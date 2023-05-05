//
//  mainController.m
//  CasaCube-SAPPORO
//
//  Created by annolab on 2018/10/13.
//  Copyright © 2018年 annolab. All rights reserved.
//

#import "mainController.h"

@implementation mainController

- (id)init
{
    self = [super init];
    NSLog(@"mainController init");
    
    
    // init objects
    matrix_obj = [[matrixClass alloc] init];
    shaderLoader_obj = [[shaderLoader alloc] init];
    
    
    for( int i = 0 ; i < 182 ; i++ )
    {
        fan_v[i][0] = 0.0;
        fan_v[i][1] = 0.0;
        fan_v[i][2] = 0.01;
        fan_v[i][3] = 1.0;
        fan_c[i][0] = 0.5;
        fan_c[i][1] = 0.5;
        fan_c[i][2] = 0.5;
        fan_c[i][3] = 1.0;
    }
    
    act_fan_center[0] = 0.0;
    act_fan_center[1] = 0.0;
    
    
    srandom( (unsigned int)time(NULL) );

    wave_radian[0] = (random()%628)*0.01;
    wave_radian_add[0] = 0.005 + (random()%100)*0.0005;
 
    wave_radian[1] = (random()%628)*0.01;
    wave_radian_add[1] = -0.01 - (random()%100)*0.0006;
    
    wave_radian[2] = (random()%628)*0.01;
    wave_radian_add[2] = 0.015 + (random()%100)*0.0007;
    
    
    
    // animation
    isInAnimation_1 = false;
    
    act_radius_coef = 0.0;
    dist_radius_coef = 0.0;
    act_animation_radius = 0.0;
    dist_animation_radius = 0.0;
    
    prev_radius = 0.0;
    
    act_texTitle_alpha = 0.0;
    dist_texTitle_alpha = 0.0;
    
    animeCoef_1 = 0.01;
    
    
    isFirstParticle = true;
    PARTICLE_COUNTER = 0;
    
    
    // texture coord list
    // casa amare
    tex_coord_list[0][0][0] = 0.0;  tex_coord_list[0][0][1] = 0.1666666 * 0.0; // pt1
    tex_coord_list[0][1][0] = 0.0;  tex_coord_list[0][1][1] = 0.1666666 * 1.0; // pt2
    tex_coord_list[0][2][0] = 0.5;  tex_coord_list[0][2][1] = 0.1666666 * 0.0; // pt3
    tex_coord_list[0][3][0] = 0.5;  tex_coord_list[0][3][1] = 0.1666666 * 1.0; // pt4

    // casa basso
    tex_coord_list[1][0][0] = 0.0;  tex_coord_list[1][0][1] = 0.1666666 * 1.0; // pt1
    tex_coord_list[1][1][0] = 0.0;  tex_coord_list[1][1][1] = 0.1666666 * 2.0; // pt2
    tex_coord_list[1][2][0] = 0.5;  tex_coord_list[1][2][1] = 0.1666666 * 1.0; // pt3
    tex_coord_list[1][3][0] = 0.5;  tex_coord_list[1][3][1] = 0.1666666 * 2.0; // pt4
    
    // casa carina
    tex_coord_list[2][0][0] = 0.0;  tex_coord_list[2][0][1] = 0.1666666 * 2.0; // pt1
    tex_coord_list[2][1][0] = 0.0;  tex_coord_list[2][1][1] = 0.1666666 * 3.0; // pt2
    tex_coord_list[2][2][0] = 0.5;  tex_coord_list[2][2][1] = 0.1666666 * 2.0; // pt3
    tex_coord_list[2][3][0] = 0.5;  tex_coord_list[2][3][1] = 0.1666666 * 3.0; // pt4
    
    // casa cube
    tex_coord_list[3][0][0] = 0.0;  tex_coord_list[3][0][1] = 0.1666666 * 3.0; // pt1
    tex_coord_list[3][1][0] = 0.0;  tex_coord_list[3][1][1] = 0.1666666 * 4.0; // pt2
    tex_coord_list[3][2][0] = 0.5;  tex_coord_list[3][2][1] = 0.1666666 * 3.0; // pt3
    tex_coord_list[3][3][0] = 0.5;  tex_coord_list[3][3][1] = 0.1666666 * 4.0; // pt4
    
    // casa piatto
    tex_coord_list[4][0][0] = 0.0;  tex_coord_list[4][0][1] = 0.1666666 * 4.0; // pt1
    tex_coord_list[4][1][0] = 0.0;  tex_coord_list[4][1][1] = 0.1666666 * 5.0; // pt2
    tex_coord_list[4][2][0] = 0.5;  tex_coord_list[4][2][1] = 0.1666666 * 4.0; // pt3
    tex_coord_list[4][3][0] = 0.5;  tex_coord_list[4][3][1] = 0.1666666 * 5.0; // pt4
    
    // casa skip
    tex_coord_list[5][0][0] = 0.0;  tex_coord_list[5][0][1] = 0.1666666 * 5.0; // pt1
    tex_coord_list[5][1][0] = 0.0;  tex_coord_list[5][1][1] = 0.1666666 * 6.0; // pt2
    tex_coord_list[5][2][0] = 0.5;  tex_coord_list[5][2][1] = 0.1666666 * 5.0; // pt3
    tex_coord_list[5][3][0] = 0.5;  tex_coord_list[5][3][1] = 0.1666666 * 6.0; // pt4
    
    // whole texture
    tex_coord_list[6][0][0] = 0.0;  tex_coord_list[6][0][1] = 0.0; // pt1
    tex_coord_list[6][1][0] = 0.0;  tex_coord_list[6][1][1] = 1.0; // pt2
    tex_coord_list[6][2][0] = 1.0;  tex_coord_list[6][2][1] = 0.0; // pt3
    tex_coord_list[6][3][0] = 1.0;  tex_coord_list[6][3][1] = 1.0; // pt4
    
    // dummy texture code
    tex_coord_list[7][0][0] = 0.0;  tex_coord_list[7][0][1] = 0.0; // pt1
    tex_coord_list[7][1][0] = 0.0;  tex_coord_list[7][1][1] = 0.0; // pt2
    tex_coord_list[7][2][0] = 0.0;  tex_coord_list[7][2][1] = 0.0; // pt3
    tex_coord_list[7][3][0] = 0.0;  tex_coord_list[7][3][1] = 0.0; // pt4
    
    
    // logo
    tex_coord_list[8][0][0] = 0.0;  tex_coord_list[8][0][1] = 0.0;
    tex_coord_list[8][1][0] = 0.0;  tex_coord_list[8][1][1] = 0.5;
    tex_coord_list[8][2][0] = 1.0;  tex_coord_list[8][2][1] = 0.0;
    tex_coord_list[8][3][0] = 1.0;  tex_coord_list[8][3][1] = 0.5;

    
    // for instruction
    // hand
    tex_coord_list[10][0][0] = 0.0; tex_coord_list[10][0][1] = 0.1666666 * 0.0;
    tex_coord_list[10][1][0] = 0.0; tex_coord_list[10][1][1] = 0.1666666 * 2.0;
    tex_coord_list[10][2][0] = 0.5; tex_coord_list[10][2][1] = 0.1666666 * 0.0;
    tex_coord_list[10][3][0] = 0.5; tex_coord_list[10][3][1] = 0.1666666 * 2.0;

    // text 1
    tex_coord_list[11][0][0] = 0.0; tex_coord_list[11][0][1] = 0.1666666 * 2.0;
    tex_coord_list[11][1][0] = 0.0; tex_coord_list[11][1][1] = 0.1666666 * 3.0;
    tex_coord_list[11][2][0] = 0.5; tex_coord_list[11][2][1] = 0.1666666 * 2.0;
    tex_coord_list[11][3][0] = 0.5; tex_coord_list[11][3][1] = 0.1666666 * 3.0;
    
    // circle
    tex_coord_list[12][0][0] = 0.0; tex_coord_list[12][0][1] = 0.1666666 * 3.0;
    tex_coord_list[12][1][0] = 0.0; tex_coord_list[12][1][1] = 0.1666666 * 5.0;
    tex_coord_list[12][2][0] = 0.5; tex_coord_list[12][2][1] = 0.1666666 * 3.0;
    tex_coord_list[12][3][0] = 0.5; tex_coord_list[12][3][1] = 0.1666666 * 5.0;
    
    // text
    tex_coord_list[13][0][0] = 0.0; tex_coord_list[13][0][1] = 0.1666666 * 5.0;
    tex_coord_list[13][1][0] = 0.0; tex_coord_list[13][1][1] = 0.1666666 * 6.0;
    tex_coord_list[13][2][0] = 0.5; tex_coord_list[13][2][1] = 0.1666666 * 5.0;
    tex_coord_list[13][3][0] = 0.5; tex_coord_list[13][3][1] = 0.1666666 * 6.0;
    
    TEXTURE_TITLE_INDEX = 0;
    
    dist_name_center[0] = 2.5;
    dist_name_center[1] = 0.0;
    act_name_center[0] = 2.5;
    act_name_center[1] = 0.0;
    
    
    for( int i = 0 ; i < NUM_PARTICLE ; i++ )
    {
        part_v[i][0] = 0.0;
        part_v[i][1] = 0.0;
        part_v[i][2] = 0.05;
        part_v[i][3] = 1.0;
        
        part_s[i][0] = (float)(random()%8 + 5); // point size
        part_s[i][1] = 0.0; //alpha;
        
        part_vel[i][0] = 0.0;
        part_vel[i][1] = 0.0;
    }
    
    
    // instruction board
    INSTRUCTION_COUNTER = 600;
    
    act_board_alpha[0] = 1.0; // circle
    act_board_alpha[1] = 1.0; // text 1
    act_board_alpha[2] = 1.0; // text 2
    act_board_alpha[3] = 1.0; // hand

    board_size[0] = 0.1;
    board_size[1] = 0.15;
    board_size[2] = 0.15;
    board_size[3] = 0.25;

    board_ratio[0] = 1.5;
    board_ratio[1] = 3.0;
    board_ratio[2] = 3.0;
    board_ratio[3] = 1.5;

    board_index[0] = 12;
    board_index[1] = 11;
    board_index[2] = 13;
    board_index[3] = 10;
    
    act_board_center[0][0] = 0.8;   act_board_center[0][1] = -0.05;
    act_board_center[1][0] = 0.8;   act_board_center[1][1] = -0.25;
    act_board_center[2][0] = 0.8;   act_board_center[2][1] = -0.25;
    act_board_center[3][0] = 1.0;   act_board_center[3][1] = 0.05;

    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    NSLog(@"mainController AFN");
    
    [NSTimer scheduledTimerWithTimeInterval:1.0
                                     target:self
                                   selector:@selector(delayedAFN:)
                                   userInfo:nil
                                    repeats:NO];
}


- (void)delayedAFN:(NSTimer *)timer
{
    NSLog(@"delayed AFN");
    
    // create gles view
    gles_view_obj = [[GLES_UIView alloc] initWithFrame:main_view_obj.frame];
    [main_view_obj addSubview:gles_view_obj];
    
    // enable multi touch
    [gles_view_obj setMultipleTouchEnabled:YES];
    
    // delayed AFN of gles view
    [gles_view_obj delayedAFN];
    
    NSLog(@"%@", main_view_obj);
    NSLog(@"%@", gles_view_obj);
    
    
    // setup openGLES ****************
    [self setup_openGLES];
    
    // setup FBO
    [self setup_FBO];
    
    // setup Texture
    [self setup_Texture];
    
    // setup shader
    [self setup_Shader];
    
    // setup VAO & VBO
    [self setup_VAO];
    
    
    
    // UDP
    UDP_obj = [[UDP_network alloc] init];
    [UDP_obj createReceiveSocket:9001];
    [UDP_obj createSendSocket:"111.111.111.111" port:9000];

    
    
    // draw loop
    disp_link = [CADisplayLink displayLinkWithTarget:self
                                            selector:@selector(drawGL:)];
    
    [disp_link addToRunLoop:[NSRunLoop currentRunLoop]
                    forMode:NSDefaultRunLoopMode];
    [disp_link setPaused:NO];
}
@end
