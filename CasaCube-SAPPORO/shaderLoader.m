//
//  shaderLoader.m
//  Science-gene
//
//  Created by wtnbks on 2017/05/09.
//  Copyright © 2017年 wtnbks. All rights reserved.
//

#import "shaderLoader.h"

@implementation shaderLoader

- (id)init
{
    self = [super init];
    NSLog(@"shaderLoader init");
    return self;
}


- (BOOL)loadShaderSourceAndCompileShader:(NSString*)name type:(NSString*)type to:(GLuint*)shObj
{
    const GLchar* CODE_STR;
    GLint logLength;
    NSString* PATH_STR;
    
    // search file
    PATH_STR = [[NSBundle mainBundle] pathForResource:name ofType:type];
    if( PATH_STR == nil )
    {
        NSLog(@"shader file cand be found.. return.");
        return NO;
    }
    
    // get source code
    CODE_STR = (GLchar*)[[NSString stringWithContentsOfFile:PATH_STR
                                                   encoding:NSUTF8StringEncoding
                                                      error:nil] UTF8String];
    
    
    // check file type
    if( [type isEqualToString:@"vsh"] )
    {
        *shObj = glCreateShader( GL_VERTEX_SHADER );
    }
    else if( [type isEqualToString:@"gsh"] )
    {
        // no definition in GLES 3.0
        //*shObj = glCreateShader( GL_GEOMETRY_SHADER );
    }
    else if( [type isEqualToString:@"fsh"])
    {
        *shObj = glCreateShader( GL_FRAGMENT_SHADER );
    }
    else
    {
        NSLog(@"file type should be 'vsh', 'gsh', 'fsh'... return");
        return NO;
    }
    
    
    // supply code & compile shader
    glShaderSource( *shObj, 1, &CODE_STR, NULL );
    glCompileShader( *shObj );
    
    
    glGetShaderiv( *shObj, GL_INFO_LOG_LENGTH, &logLength );
    if( logLength > 1 )
    {
        GLchar* log = (GLchar*)malloc(logLength);
        glGetShaderInfoLog(*shObj, logLength, &logLength, log );
        NSLog(@"%@.%@ compile error :\n%s", name, type, log );
        free(log);
        
        return NO;
    }
    
    NSLog(@"%@.%@ compile success", name, type);
    
    return YES;
}


- (BOOL)createProgram_AttachShader_Link:(GLuint*)prg VS:(GLuint*)vObj GS:(GLuint*)gObj FS:(GLuint*)fObj
{
    // createProgram
        *prg = glCreateProgram();

    
    // attach shader
    glAttachShader( *prg, *vObj );
    glAttachShader( *prg, *fObj );
    
    // link program
    glLinkProgram( *prg );
    
    // check link status
    GLint status;
    glGetProgramiv( *prg, GL_LINK_STATUS, &status );
    
    
    if( status == GL_TRUE )
    {
        NSLog(@"program link success!");
    }
    else
    {
        NSLog(@"program link ERROR..... return");
        return NO;
    }
    
    return YES;
}
@end
