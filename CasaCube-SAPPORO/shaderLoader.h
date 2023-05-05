//
//  shaderLoader.h
//  Science-gene
//
//  Created by wtnbks on 2017/05/09.
//  Copyright © 2017年 wtnbks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>

@interface shaderLoader : NSObject
{

}

- (BOOL)loadShaderSourceAndCompileShader:(NSString*)name type:(NSString*)type to:(GLuint*)shObj;
- (BOOL)createProgram_AttachShader_Link:(GLuint*)prg VS:(GLuint*)vObj GS:(GLuint*)gObj FS:(GLuint*)fObj;
@end
