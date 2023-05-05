#import "mainController.h"

@implementation mainController ( OPENGL_SETUP )

- (void)setup_openGLES
{
    NSLog(@"setup OpenGLES");
    
    // create context **************************
    glContext_obj = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    [EAGLContext setCurrentContext:glContext_obj];
    
    // check version **************************
    const GLubyte* version = glGetString( GL_VERSION );
    const GLubyte* vendor = glGetString( GL_VENDOR );
    const GLubyte* renderer = glGetString( GL_RENDERER );
    const GLubyte* shader = glGetString( GL_SHADING_LANGUAGE_VERSION );
    NSLog(@"version : %s", version );
    NSLog(@"vendor : %s", vendor);
    NSLog(@"renderer : %s", renderer );
    NSLog(@"shader : %s", shader );
    
    
    // set opengl status **************************
    glEnable( GL_BLEND );
    glBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );

    // cullface
    glDisable( GL_CULL_FACE );
    
    // depth test
    glDisable( GL_DEPTH_TEST );
    //glEnable( GL_DEPTH_TEST );
    //glDepthFunc( GL_LESS );
    
    
    // point smooth

    
    // check error  **************************
    GLenum error = glGetError();
    NSLog(@"GLES setup status : error %x", error );
    
    
    // set layer property
    CAEAGLLayer* eaglLayer = (CAEAGLLayer*)gles_view_obj.layer;
    eaglLayer.opaque = TRUE;
    eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:FALSE], kEAGLDrawablePropertyRetainedBacking,
                                    kEAGLColorFormatRGBA8,
                                    kEAGLDrawablePropertyColorFormat,
                                    nil];
}



- (void)setup_FBO
{
    NSLog(@"setup FBO");
    
    // gen FBO
    glGenFramebuffers(1, &FBO_default);
    
    // bind FBO
    glBindFramebuffer( GL_FRAMEBUFFER, FBO_default );
    
    
    
    // gen RBO color
    glGenRenderbuffers(1, &RBO_default_color);
    
    // bind RBO
    glBindRenderbuffer(GL_RENDERBUFFER, RBO_default_color );
    
    // assign RBO memory to gles view
    [glContext_obj renderbufferStorage:GL_RENDERBUFFER
                          fromDrawable:(CAEAGLLayer*)gles_view_obj.layer];
    
    // set RBO to FBO's color attachment point
    glFramebufferRenderbuffer( GL_FRAMEBUFFER,
                              GL_COLOR_ATTACHMENT0,
                              GL_RENDERBUFFER,
                              RBO_default_color);
    
    
    // get RBO color's width & height
    GLint tempWidth, tempHeight;
    glGetRenderbufferParameteriv(GL_RENDERBUFFER,
                                 GL_RENDERBUFFER_WIDTH,
                                 &tempWidth);
    
    glGetRenderbufferParameteriv(GL_RENDERBUFFER,
                                 GL_RENDERBUFFER_HEIGHT,
                                 &tempHeight);
    
    NSLog(@"Renderbuffer WH %d %d", tempWidth, tempHeight);
    VIEW_WIDTH = (float)tempWidth;
    VIEW_HEIGHT = (float)tempHeight;
    
    
    // gen RBO for depth
    glGenRenderbuffers( 1, &RBO_default_depth );
    glBindRenderbuffer( GL_RENDERBUFFER, RBO_default_depth );
    glRenderbufferStorage( GL_RENDERBUFFER, GL_DEPTH_COMPONENT16, tempWidth, tempHeight);
    glFramebufferRenderbuffer( GL_FRAMEBUFFER, GL_DEPTH_ATTACHMENT, GL_RENDERBUFFER, RBO_default_depth );
    
    
    
    // check status (8cd5)********************
    NSLog(@"FBO status %x", glCheckFramebufferStatus( GL_FRAMEBUFFER ));
    
    
    // test clear ***************
    // RBO color should be bind before present renderbuffer
    glClearColor(1.0, 0.0, 0.0, 1.0 );
    glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
    
    glBindRenderbuffer( GL_RENDERBUFFER, RBO_default_color );
    
    [glContext_obj presentRenderbuffer:GL_RENDERBUFFER];
    
}




- (void)setup_Texture
{
    NSLog(@"setup Texture");
    
    // generate sampler
    glGenSamplers( 3, Sampler_name );
    
    // setup sampler object
    glSamplerParameteri( Sampler_name[0], GL_TEXTURE_WRAP_S, GL_REPEAT );
    glSamplerParameteri( Sampler_name[0], GL_TEXTURE_WRAP_T, GL_REPEAT );
    glSamplerParameteri( Sampler_name[0], GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    glSamplerParameteri( Sampler_name[0], GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    
    glSamplerParameteri( Sampler_name[1], GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE );
    glSamplerParameteri( Sampler_name[1], GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE );
    glSamplerParameteri( Sampler_name[1], GL_TEXTURE_MIN_FILTER, GL_NEAREST );
    glSamplerParameteri( Sampler_name[1], GL_TEXTURE_MAG_FILTER, GL_NEAREST );
    
    glSamplerParameteri( Sampler_name[2], GL_TEXTURE_WRAP_S, GL_MIRRORED_REPEAT );
    glSamplerParameteri( Sampler_name[2], GL_TEXTURE_WRAP_T, GL_MIRRORED_REPEAT );
    glSamplerParameteri( Sampler_name[2], GL_TEXTURE_MIN_FILTER, GL_NEAREST );
    glSamplerParameteri( Sampler_name[2], GL_TEXTURE_MAG_FILTER, GL_NEAREST );
    
    
    // bind sampler to all texture unit
    GLint NUM_TEX;
    glGetIntegerv( GL_MAX_TEXTURE_IMAGE_UNITS, &NUM_TEX );
    
    for( int i = 0 ; i < NUM_TEX ; i++ )
    {
        glBindSampler( i, Sampler_name[0] );
    }
    
    
    
    // generate texture name
    glGenTextures( 3, TEX_name );
    
    
    // get png data
    unsigned char* texPtr = nil;
    long tex_Width, tex_Height;
    [self getTextureImagePointer:@"casa-modify"
                       toPointer:&texPtr
                           width:&tex_Width
                          height:&tex_Height];
    
    glBindTexture( GL_TEXTURE_2D, TEX_name[0] );
    glTexImage2D(GL_TEXTURE_2D,
                 0,
                 GL_RGBA8,
                 (int)tex_Width,
                 (int)tex_Height,
                 0,
                 GL_RGBA,
                 GL_UNSIGNED_BYTE,
                 (GLubyte*)texPtr);
    
    
    free( texPtr );
    
    [self getTextureImagePointer:@"casa_name"
                       toPointer:&texPtr
                           width:&tex_Width
                          height:&tex_Height];
    
    glBindTexture( GL_TEXTURE_2D, TEX_name[1] );
    glTexImage2D( GL_TEXTURE_2D,
                 0,
                 GL_RGBA8,
                 (int)tex_Width,
                 (int)tex_Height,
                 0,
                 GL_RGBA,
                 GL_UNSIGNED_BYTE,
                 (GLubyte*)texPtr);
    
    free( texPtr );
    
    
    [self getTextureImagePointer:@"casa-texture-2"
                       toPointer:&texPtr
                           width:&tex_Width
                          height:&tex_Height];
    
    glBindTexture( GL_TEXTURE_2D, TEX_name[2] );
    glTexImage2D(GL_TEXTURE_2D,
                 0,
                 GL_RGBA8,
                 (int)tex_Width,
                 (int)tex_Height,
                 0,
                 GL_RGBA,
                 GL_UNSIGNED_BYTE,
                 (GLubyte*)texPtr);
    
    free( texPtr );
    
    
    
    // bind Texture unit & Texture object
    glActiveTexture( GL_TEXTURE0 );
    glBindTexture( GL_TEXTURE_2D, TEX_name[0] );
    
    glActiveTexture( GL_TEXTURE1 );
    glBindTexture( GL_TEXTURE_2D, TEX_name[1] );
    
    glActiveTexture( GL_TEXTURE2 );
    glBindTexture( GL_TEXTURE_2D, TEX_name[2] );
}



- (void)getTextureImagePointer:(NSString*)fileName toPointer:(unsigned char**)tex_Ptr width:(long*)width_Ptr height:(long*)height_Ptr
{
    NSInteger tex_width, tex_height;
    CGContextRef tex_Context;
    
    
    // get CGImage data of texture
    CGImageRef tex_Image_Ref = [UIImage imageNamed:fileName].CGImage;
    
    // get width, height
    tex_width = CGImageGetWidth( tex_Image_Ref );
    tex_height = CGImageGetHeight( tex_Image_Ref );
    NSLog(@"texture : %@ W:%ld H:%ld", fileName, tex_width, tex_height);
    
    // set width height to pointer
    *width_Ptr = tex_width;
    *height_Ptr = tex_height;
    
    
    
    // malloc tex_Ptr
    *tex_Ptr = (unsigned char*)malloc(  tex_width * tex_height * 4 );
    
    // draw texture image to context
    tex_Context = CGBitmapContextCreate( *tex_Ptr,
                                        tex_width,
                                        tex_height,
                                        8,
                                        tex_width*4,
                                        CGImageGetColorSpace(tex_Image_Ref),
                                        kCGImageAlphaPremultipliedLast
                                        );
    
    CGContextDrawImage( tex_Context,
                       CGRectMake(0.0, 0.0, tex_width, tex_height),
                       tex_Image_Ref
                       );
    
    CGContextRelease( tex_Context );
    
}






- (void)setup_Shader
{
    NSLog(@"setup shader");
    
    [shaderLoader_obj loadShaderSourceAndCompileShader:@"PLANE" type:@"vsh" to:&PLANE_VS_OBJ];
    [shaderLoader_obj loadShaderSourceAndCompileShader:@"PLANE" type:@"fsh" to:&PLANE_FS_OBJ];
    
    [shaderLoader_obj createProgram_AttachShader_Link:&PLANE_PRG_OBJ
                                                   VS:&PLANE_VS_OBJ
                                                   GS:nil
                                                   FS:&PLANE_FS_OBJ];
    
    // get uniform location
    UNF_PLANE_mvpMatrix = glGetUniformLocation( PLANE_PRG_OBJ, "mvpMatrix");
    NSLog(@"UNF_PLANE_mvpMatrix %d", UNF_PLANE_mvpMatrix);
    
    
    
    
    [shaderLoader_obj loadShaderSourceAndCompileShader:@"TEXTURE"
                                                  type:@"vsh"
                                                    to:&TEXTURE_VS_OBJ];
    [shaderLoader_obj loadShaderSourceAndCompileShader:@"TEXTURE"
                                                  type:@"fsh"
                                                    to:&TEXTURE_FS_OBJ];
    [shaderLoader_obj createProgram_AttachShader_Link:&TEXTURE_PRG_OBJ
                                                   VS:&TEXTURE_VS_OBJ
                                                   GS:nil
                                                   FS:&TEXTURE_FS_OBJ];
    
    UNF_TEXTURE_mvpMatrix = glGetUniformLocation( TEXTURE_PRG_OBJ, "mvpMatrix");
    UNF_TEXTURE_imageTexture = glGetUniformLocation( TEXTURE_PRG_OBJ, "imageTexture");
    UNF_TEXTURE_texAlpha = glGetUniformLocation( TEXTURE_PRG_OBJ, "texAlpha");
    NSLog(@"UNF_TEXTURE_mvpMatrix %d", UNF_TEXTURE_mvpMatrix );
    NSLog(@"UNF_TEXTURE_imageTexture %d", UNF_TEXTURE_imageTexture );
    NSLog(@"UNF_TEXTURE_texAlpha %d", UNF_TEXTURE_texAlpha );
    
    
    /// Point shader
    [shaderLoader_obj loadShaderSourceAndCompileShader:@"POINT" type:@"vsh" to:&POINT_VS_OBJ];
    [shaderLoader_obj loadShaderSourceAndCompileShader:@"POINT" type:@"fsh" to:&POINT_FS_OBJ];
    [shaderLoader_obj createProgram_AttachShader_Link:&POINT_PRG_OBJ VS:&POINT_VS_OBJ GS:nil FS:&POINT_FS_OBJ];
    
    UNF_POINT_mvpMatrix = glGetUniformLocation( POINT_PRG_OBJ, "mvpMatrix" );
    UNF_POINT_texImage = glGetUniformLocation( POINT_PRG_OBJ, "texImage");
    NSLog(@"UNF_POINT_mvpMatrix %d", UNF_POINT_mvpMatrix );
    NSLog(@"UNF_POINT_texImage %d", UNF_POINT_texImage );
    
}



- (void)setup_VAO
{
    NSLog(@"setup VAO");
    // gen VAO & VBO
    glGenVertexArrays(1, &VAO_default);
    glGenBuffers(2, VBO_default);
    
    // bind VAO
    glBindVertexArray( VAO_default );
    glEnableVertexAttribArray(0);
    glEnableVertexAttribArray(1);
}

@end
