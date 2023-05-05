//
//  mainController.h
//  CasaCube-SAPPORO
//
//  Created by annolab on 2018/10/13.
//  Copyright © 2018年 annolab. All rights reserved.
//

#import <UIKit/UIKit.h>

// openGL
#import <OpenGLES/ES3/gl.h>
#import <OpenGLES/ES3/glext.h>

// my class
#import "GLES_UIView.h"
#import "matrixClass.h"
#import "shaderLoader.h"
#import "UDP_network.h"

#define NUM_PARTICLE 300

@interface mainController : UIRotationGestureRecognizer
{
    IBOutlet UIView* main_view_obj;
    GLES_UIView* gles_view_obj;
    
    matrixClass* matrix_obj;
    shaderLoader* shaderLoader_obj;
    
    CADisplayLink* disp_link;
    
    // opengl
    EAGLContext* glContext_obj;
    
    // FBO
    GLuint FBO_default;
    GLuint RBO_default_color;
    GLuint RBO_default_depth;
    
    // texture
    GLuint Sampler_name[3];
    GLuint TEX_name[3];
    
    // shader
    GLuint PLANE_VS_OBJ;
    GLuint PLANE_FS_OBJ;
    GLuint PLANE_PRG_OBJ;
    GLint UNF_PLANE_mvpMatrix;
    
    GLuint TEXTURE_VS_OBJ;
    GLuint TEXTURE_FS_OBJ;
    GLuint TEXTURE_PRG_OBJ;
    GLint UNF_TEXTURE_mvpMatrix;
    GLint UNF_TEXTURE_imageTexture;
    GLint UNF_TEXTURE_texAlpha;
    
    GLuint POINT_VS_OBJ;
    GLuint POINT_FS_OBJ;
    GLuint POINT_PRG_OBJ;
    GLuint UNF_POINT_mvpMatrix;
    GLuint UNF_POINT_texImage;
    
    // VAO VBO
    GLuint VAO_default;
    GLuint VBO_default[2];
    
    
    // variables
    float VIEW_WIDTH;
    float VIEW_HEIGHT;
    
    
    // for drawing
    GLfloat fan_v[182][4];
    GLfloat fan_c[182][4];
    float act_fan_center[2];
    float wave_radian[3];
    float wave_radian_add[3];
    
    
    
    // UDP
    UDP_network* UDP_obj;
    
    // for animation
    // fan
    float dist_radius_coef;
    float act_radius_coef;
    float dist_animation_radius;
    float act_animation_radius;
    float prev_radius;
    
    // particle
    bool isFirstParticle;
    int PARTICLE_COUNTER;
    GLfloat part_v[NUM_PARTICLE][4];
    GLfloat part_s[NUM_PARTICLE][2];
    float part_vel[NUM_PARTICLE][2];
    
    // name
    float act_texTitle_alpha;
    float dist_texTitle_alpha;
    int TEXTURE_TITLE_INDEX;
    float act_name_center[2];
    float dist_name_center[2];
    
    // animation flag
    bool isInAnimation_1;
    
    // coef
    float animeCoef_1;
    
    
    
    // instruction
    int INSTRUCTION_COUNTER;
    float act_board_alpha[4];
    float board_size[4];
    float board_ratio[4];
    int board_index[4];
    float act_board_center[4][2];
    
    
    // texcoord table
    float tex_coord_list[30][4][2];

}


- (void)delayedAFN:(NSTimer*)timer;
@end


@interface mainController ( OPENGL_SETUP )
- (void)setup_openGLES;
- (void)setup_FBO;
- (void)setup_Texture;
- (void)setup_Shader;
- (void)setup_VAO;
@end

@interface mainController ( DRAW )
- (void)animation_start_trigger_1;
- (void)animation_end_trigger_1;
- (void)drawGL:(CADisplayLink*)dispLink;
@end
