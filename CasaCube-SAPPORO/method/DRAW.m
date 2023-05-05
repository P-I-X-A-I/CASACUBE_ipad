#import "mainController.h"

@implementation mainController ( DRAW )

- (void)drawGL:(CADisplayLink *)dispLink
{
    // ANOTHER PROCESS
    
    
    // timer call to gles view
    [gles_view_obj drawTimerFromMainController];
    
    
    // send udp
    //[UDP_obj sendData:@"/nandemo"];
    
    
    // get similarity ************************************
    float SIM[NUM_MODELS];
    int MODEL_INDEX = gles_view_obj.CURRENT_MODEL_INDEX;
    bool isModelOn = gles_view_obj.isSomothingOn;
    
    [gles_view_obj get_similarity:SIM];
    
    
    if( MODEL_INDEX < NUM_MODELS )
    {
        TEXTURE_TITLE_INDEX = MODEL_INDEX;
    }
    
    
    //printf("[%d - %d] : ", MODEL_INDEX, isModelOn);
    
    // check for animation in trigger *****************************
    for( int i = 0 ; i < NUM_MODELS ; i++ )
    {
        if( isInAnimation_1 == false )
        {
            if( SIM[i] > 60.0 )
            {
                [self animation_start_trigger_1];
                isInAnimation_1 = true;
                
                [UDP_obj sendIndex:MODEL_INDEX];
            }
        }
        //printf(" %1.3f :", SIM[i] );
    }
    //printf("\n");
    
    
    // check for animation end trigger ***************************
    bool isAnimationEnd = true;
    if( isModelOn == false )
    {
        for( int i = 0 ; i < NUM_MODELS ; i++ )
        {
            if( SIM[i] > 3.0 )
            {
                isAnimationEnd = false;
            }
        }
        
        if( isInAnimation_1 == true && isAnimationEnd == true )
        {
            isInAnimation_1 = false;
            [self animation_end_trigger_1];
            
            [UDP_obj sendIndex:99];
        }
    }
   
    
    // check particle flag *********************
    if( isModelOn == true )
    {
        if( isFirstParticle == true )
        {
            // particle
            [self start_particle];
            isFirstParticle = false;
        }
        PARTICLE_COUNTER = 0;
    }
    else
    {
        PARTICLE_COUNTER += 1;
        if( PARTICLE_COUNTER > 30 )
        {
            PARTICLE_COUNTER = 30;
            isFirstParticle = true;
        }
    }
    
    // get prev_fan coef
    if( MODEL_INDEX < NUM_MODELS )
    {
        prev_radius = SIM[MODEL_INDEX]*0.001;
    }
    else
    {
        prev_radius *= 0.9;
    }
    
    
    
    
    
    
    // for instructon
    if( isModelOn == false )
    {
        INSTRUCTION_COUNTER++;
        
        if(INSTRUCTION_COUNTER < 60 * 15 )
        {
            // alpha
            act_board_alpha[0] = 0.0;
            act_board_alpha[1] = 0.0;
            act_board_alpha[2] = 0.0;
            act_board_alpha[3] = 0.0;
            
            // position
            act_board_center[0][0] = 0.8;   act_board_center[0][1] = -0.05;
            act_board_center[1][0] = 0.8;   act_board_center[1][1] = -0.3;
            act_board_center[2][0] = 0.8;   act_board_center[2][1] = -0.3;
            act_board_center[3][0] = 1.0;   act_board_center[3][1] = 0.3;
            
            //size
            board_size[0] = 0.1;
        }
        else if( INSTRUCTION_COUNTER >= 60*15 && INSTRUCTION_COUNTER < 60*19 )
        {
            // alpha
            act_board_alpha[0] += ( 0.5 - act_board_alpha[0] ) * 0.02; // point
            act_board_alpha[1] += ( 1.0 - act_board_alpha[1] ) * 0.02; // text 1
            act_board_alpha[3] += ( 1.0 - act_board_alpha[3] ) * 0.05; // hand
            
            // position
            act_board_center[3][1] += ( 0.05 - act_board_center[3][1] )*0.025;
            
            // size
            board_size[0] += ( 0.12 - board_size[0] ) * 0.01;
        }
        else if( INSTRUCTION_COUNTER >= 60*19 && INSTRUCTION_COUNTER < 60*25 )
        {
            // alpha
            act_board_alpha[0] += ( 0.3 - act_board_alpha[0])*0.1;
            act_board_alpha[1] = 0.0;
            act_board_alpha[2] += ( 1.0 - act_board_alpha[2] )*0.1;
            
            // position
            act_board_center[3][0] += ( -0.7 - act_board_center[3][0] )*0.008;
            act_board_center[0][0] = act_board_center[3][0] - 0.2;
            act_board_center[2][0] = act_board_center[3][0] - 0.2;
            
            act_board_center[3][1] += ( 0.03 - act_board_center[3][1] )*0.1;
            
            // size
            board_size[0] += ( 0.17 - board_size[0] ) * 0.1;
        }
        else if( INSTRUCTION_COUNTER >= 25 && INSTRUCTION_COUNTER < 60*29 )
        {
            act_board_alpha[0] += ( 0.0 - act_board_alpha[0] )*0.1;
            act_board_alpha[1] += ( 0.0 - act_board_alpha[1] )*0.1;
            act_board_alpha[2] += ( 0.0 - act_board_alpha[2] )*0.1;
            act_board_alpha[3] += ( 0.0 - act_board_alpha[3] )*0.1;
        }
        else if( INSTRUCTION_COUNTER >= 60*29 )
        {
            INSTRUCTION_COUNTER = 890;
        }
    }
    else // if model on
    {
        INSTRUCTION_COUNTER = 0;
        
        // alpha
        act_board_alpha[0] = 0.0;
        act_board_alpha[1] = 0.0;
        act_board_alpha[2] = 0.0;
        act_board_alpha[3] = 0.0;
        
        // position
        act_board_center[0][0] = 0.8;   act_board_center[0][1] = -0.05;
        act_board_center[1][0] = 0.8;   act_board_center[1][1] = -0.3;
        act_board_center[2][0] = 0.8;   act_board_center[2][1] = -0.3;
        act_board_center[3][0] = 1.0;   act_board_center[3][1] = 0.3;
        
        //size
        board_size[0] = 0.1;
    }
    
    
    
    
    
    
    // OPENGL DRAWING *********************************
    
    // set blend mode
    glBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );
    glEnable( GL_DEPTH_TEST );
    
    float aspect_ratio = VIEW_WIDTH / VIEW_HEIGHT;
    
    //NSLog(@"drawGL");
    
    // set view port
    glViewport(0, 0, (GLsizei)VIEW_WIDTH, (GLsizei)VIEW_HEIGHT);
    
    //bind frame buffer
    glBindFramebuffer( GL_FRAMEBUFFER, FBO_default );
    
    
    // clear buffer
    float BGColor = 1.0;
    glClearColor(BGColor, BGColor, BGColor, 1.0 );
    glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
    
    // setup matrix
    [matrix_obj initMatrix];
    [matrix_obj lookAt_Ex:0.0 Ey:0.0 Ez:1.0
                       Vx:0.0 Vy:0.0 Vz:0.0
                       Hx:0.0 Hy:1.0 Hz:0.0];
    
    [matrix_obj orthogonal_left:-aspect_ratio right:aspect_ratio
                         bottom:-1.0 top:1.0
                           near:-0.9 far:5.0];
//    [matrix_obj perspective_fovy:90.0 aspect:aspect_ratio near:0.01 far:5.0];
    
    // choose shader
    glUseProgram( PLANE_PRG_OBJ );
    
    // set uniform
    glUniformMatrix4fv( UNF_PLANE_mvpMatrix,
                       1,
                       GL_FALSE,
                       [matrix_obj getMatrix]);
    
    
    
    // set buffer data
    // TOUCH POINT *******************************
    /*
    glBindVertexArray( VAO_default );
    
    GLfloat tempV[4][4];
    GLfloat tempC[4][4];
    

    for( int i = 0 ; i < 3 ; i++ )
    {
        float GL_X, GL_Y;
        CGPoint tempPoint = [gles_view_obj get_position:i];
        
        GL_X = ((tempPoint.x/ VIEW_WIDTH) - 0.5) * 2.0 * aspect_ratio;
        GL_Y = ((tempPoint.y / VIEW_HEIGHT) - 0.5) * -2.0;

        tempV[0][0] = GL_X - 0.1;
        tempV[0][1] = GL_Y + 0.1;
        tempV[0][2] = 0.0;
        tempV[0][3] = 1.0;
        
        tempV[1][0] = GL_X - 0.1;
        tempV[1][1] = GL_Y - 0.1;
        tempV[1][2] = 0.0;
        tempV[1][3] = 1.0;
        
        tempV[2][0] = GL_X + 0.1;
        tempV[2][1] = GL_Y + 0.1;
        tempV[2][2] = 0.0;
        tempV[2][3] = 1.0;
        
        tempV[3][0] = GL_X + 0.1;
        tempV[3][1] = GL_Y - 0.1;
        tempV[3][2] = 0.0;
        tempV[3][3] = 1.0;
        
        for( int j = 0 ; j < 4 ; j++ )
        {
            tempC[j][0] = random()%100 * 0.01;
            tempC[j][1] = random()%100 * 0.01;
            tempC[j][2] = random()%100 * 0.01;
            tempC[j][3] = 1.0;
        }
    
    
    glBindBuffer( GL_ARRAY_BUFFER, VBO_default[0] );
    glBufferData( GL_ARRAY_BUFFER, sizeof(GLfloat)*4*4, tempV, GL_DYNAMIC_DRAW);
    glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, 0, 0);
    
    glBindBuffer( GL_ARRAY_BUFFER, VBO_default[1] );
    glBufferData( GL_ARRAY_BUFFER, sizeof(GLfloat)*4*4, tempC, GL_DYNAMIC_DRAW);
    glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, 0, 0);
    
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
    
    }// i
    */
    // TOUCH POINT *******************************
     
    
    

    
    
    
    
    
    
    // drwa fan ***********************************
    // get center
    CGPoint pt1, pt2, pt3;
    pt1 = [gles_view_obj get_position:0];
    pt2 = [gles_view_obj get_position:1];
    pt3 = [gles_view_obj get_position:2];
    
    float CENTER[2];
    float CONVERT[3][2];
    CONVERT[0][0] = ((pt1.x / VIEW_WIDTH) - 0.5)*2.0*aspect_ratio;
    CONVERT[1][0] = ((pt2.x / VIEW_WIDTH) - 0.5)*2.0*aspect_ratio;
    CONVERT[2][0] = ((pt3.x / VIEW_WIDTH) - 0.5)*2.0*aspect_ratio;
    
    CONVERT[0][1] = ((pt1.y / VIEW_HEIGHT) - 0.5) * -2.0;
    CONVERT[1][1] = ((pt2.y / VIEW_HEIGHT) - 0.5) * -2.0;
    CONVERT[2][1] = ((pt3.y / VIEW_HEIGHT) - 0.5) * -2.0;
    
    CENTER[0] = (CONVERT[0][0] + CONVERT[1][0] + CONVERT[2][0]) / 3.0;
    CENTER[1] = (CONVERT[0][1] + CONVERT[1][1] + CONVERT[2][1]) / 3.0;
    
    act_fan_center[0] += ( CENTER[0] - act_fan_center[0] )*0.4;
    act_fan_center[1] += ( CENTER[1] - act_fan_center[1] )*0.4;
    
    float RADIUS = 2.0;
    
    
    // fan center
    fan_v[0][0] = act_fan_center[0];
    fan_v[0][1] = act_fan_center[1];
    
    // fan alpha
    fan_c[0][3] = 1.0;
    
    float FINAL_COEF = act_radius_coef + prev_radius;
    for( int i = 1 ; i < 182 ; i++ )
    {
        // to radian
        float radian = (float)(i-1) * 0.0174532925 * 2.0;
        float tempRadian[3];
        float waveCoef[3];
        tempRadian[0] = wave_radian[0] + radian*2.0;
        tempRadian[1] = wave_radian[1] + radian*3.0;
        tempRadian[2] = wave_radian[2] + radian*5.0;
        waveCoef[0] = sinf(tempRadian[0])*0.3333;
        waveCoef[1] = sinf(tempRadian[1])*0.3333;
        waveCoef[2] = sinf(tempRadian[2])*0.3333;
        
        float COEF = 1.0 + (waveCoef[0]+waveCoef[1]+waveCoef[2])*0.075;
        
        
        fan_v[i][0] = fan_v[0][0] + (cosf( radian ) * COEF * RADIUS) * (FINAL_COEF);
        fan_v[i][1] = fan_v[0][1] + (sinf( radian ) * COEF * RADIUS) * (FINAL_COEF);
        
        fan_c[i][3] = 1.0;
    }
    
    glBindBuffer( GL_ARRAY_BUFFER, VBO_default[0]);
    glBufferData( GL_ARRAY_BUFFER, sizeof(float)*182*4, fan_v, GL_DYNAMIC_DRAW );
    glVertexAttribPointer( 0, 4, GL_FLOAT, GL_FALSE, 0, 0 );
    
    glBindBuffer( GL_ARRAY_BUFFER, VBO_default[1] );
    glBufferData( GL_ARRAY_BUFFER, sizeof(float)*182*4, fan_c, GL_DYNAMIC_DRAW );
    glVertexAttribPointer( 1, 4, GL_FLOAT, GL_FALSE, 0, 0 );
    
    glDrawArrays( GL_TRIANGLE_FAN, 0, 182 );
    
    // calculation for fan
    for( int i = 0 ; i < 3 ; i++ )
    {
        wave_radian[i] += wave_radian_add[i];
        
        if( wave_radian[i] > (2.0 * M_PI) )
        {
            wave_radian[i] -= 2.0*M_PI;
        }
        else if( wave_radian[i] < (-2.0*M_PI) )
        {
            wave_radian[i] += 2.0*M_PI;
        }
    }
    
    
    
    
    
    

    
    
    
    
    
    
    
    // draw texture plane ****************************************
    glUseProgram( TEXTURE_PRG_OBJ );
    glUniformMatrix4fv( UNF_TEXTURE_mvpMatrix, 1, GL_FALSE, [matrix_obj getMatrix]);
    
    
    // casa logo

    glUniform1i( UNF_TEXTURE_imageTexture, 0);
    glUniform1f( UNF_TEXTURE_texAlpha, 0.5 );
    
    GLfloat logo_v[16];
    GLfloat logo_t[16];
    
    [self set_Billboard:logo_v
                    tex:logo_t
                   size:0.25
                  ratio:2.0
                  index:8
               center_x:-0.8
               center_y:0.85];
    
    
    glBindBuffer( GL_ARRAY_BUFFER, VBO_default[0] );
    glBufferData( GL_ARRAY_BUFFER, sizeof(GLfloat)*4*4, logo_v, GL_DYNAMIC_DRAW );
    glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, 0, 0 );
    
    glBindBuffer( GL_ARRAY_BUFFER, VBO_default[1] );
    glBufferData( GL_ARRAY_BUFFER, sizeof(GLfloat)*4*4, logo_t, GL_DYNAMIC_DRAW );
    glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, 0, 0 );
    
    glDrawArrays( GL_TRIANGLE_STRIP, 0, 4);

    
    
    
    
    // NAME *****
    
    // change blend mode
    glDisable(GL_DEPTH_TEST);
    glBlendFunc( GL_ONE, GL_ONE_MINUS_SRC_ALPHA );

    
    glUniform1i( UNF_TEXTURE_imageTexture, 1);
    glUniform1f( UNF_TEXTURE_texAlpha, act_texTitle_alpha);
    
    
    // set billboard
    GLfloat vert[16]; // 4 * 4
    GLfloat tex[16];// 4 * 4
    

    
    [self set_Billboard:vert tex:tex size:0.175 ratio:3.0 index:TEXTURE_TITLE_INDEX center_x:act_name_center[0] center_y:act_name_center[1]];
    

    // set buffer
    glBindBuffer( GL_ARRAY_BUFFER, VBO_default[0] );
    glBufferData( GL_ARRAY_BUFFER, sizeof(GLfloat)*4*4, vert, GL_DYNAMIC_DRAW);
    glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, 0, 0 );
    
    glBindBuffer( GL_ARRAY_BUFFER, VBO_default[1] );
    glBufferData( GL_ARRAY_BUFFER, sizeof(GLfloat)*4*4, tex, GL_DYNAMIC_DRAW );
    glVertexAttribPointer( 1, 4, GL_FLOAT, GL_FALSE, 0, 0 );
    
    glDrawArrays( GL_TRIANGLE_STRIP, 0, 4 );
    
    
    
    
    
    // draw instruction
    glBlendFunc( GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA );
    glUniform1i( UNF_TEXTURE_imageTexture, 2);
    
    GLfloat board_v[4][16];
    GLfloat board_t[4][16];
    
    for( int i = 0 ; i < 4 ; i++ )
    {
        glUniform1f( UNF_TEXTURE_texAlpha, act_board_alpha[i]);
        
        [self set_Billboard:&board_v[i][0]
                        tex:&board_t[i][0]
                       size:board_size[i]
                      ratio:board_ratio[i]
                      index:board_index[i]
                   center_x:act_board_center[i][0]
                   center_y:act_board_center[i][1]];
        
        glBindBuffer( GL_ARRAY_BUFFER, VBO_default[0] );
        glBufferData( GL_ARRAY_BUFFER, sizeof(GLfloat)*4*4, &board_v[i][0], GL_DYNAMIC_DRAW );
        glVertexAttribPointer(0, 4, GL_FLOAT, GL_FALSE, 0, 0 );
        
        glBindBuffer( GL_ARRAY_BUFFER, VBO_default[1] );
        glBufferData( GL_ARRAY_BUFFER, sizeof(GLfloat)*4*4, &board_t[i][0], GL_DYNAMIC_DRAW );
        glVertexAttribPointer(1, 4, GL_FLOAT, GL_FALSE, 0, 0 );
        
        glDrawArrays( GL_TRIANGLE_STRIP, 0, 4);
    }
    
    
    
    
    
    
    
    
    // draw particle *********************************************************
    
    glUseProgram( POINT_PRG_OBJ );
    glUniformMatrix4fv(UNF_POINT_mvpMatrix, 1, GL_FALSE, [matrix_obj getMatrix]);
    glUniform1i(UNF_POINT_texImage, 0 );
    
    glBindBuffer( GL_ARRAY_BUFFER, VBO_default[0]);
    glBufferData( GL_ARRAY_BUFFER, sizeof(GLfloat)*NUM_PARTICLE*4, part_v, GL_DYNAMIC_DRAW );
    glVertexAttribPointer( 0, 4, GL_FLOAT, GL_FALSE, 0, 0 );
    
    glBindBuffer( GL_ARRAY_BUFFER, VBO_default[1] );
    glBufferData( GL_ARRAY_BUFFER, sizeof(GLfloat)*NUM_PARTICLE*2, part_s, GL_DYNAMIC_DRAW );
    glVertexAttribPointer(1, 2, GL_FLOAT, GL_FALSE, 0, 0 );
    
    glDrawArrays( GL_POINTS, 0, NUM_PARTICLE );
    
    
    
    // calculate particle
    for( int i = 0 ; i < NUM_PARTICLE ; i++ )
    {
        float vecX, vecY;
        float cenX, cenY;
        part_s[i][1] += (0.0 - part_s[i][1])*0.02;
        
        // vec to another particle point
        if( i == 0 )
        {
            vecX = part_v[NUM_PARTICLE-1][0] - part_v[i][0];
            vecY = part_v[NUM_PARTICLE-1][1] - part_v[i][1];
        }
        else
        {
            vecX = part_v[i-1][0] - part_v[i][0];
            vecY = part_v[i-1][1] - part_v[i][1];
        }
        
        // vec to center
        cenX = CENTER[0] - part_v[i][0];
        cenY = CENTER[1] - part_v[i][1];
        
        // normalize vec
        float distance = sqrtf( vecX*vecX + vecY*vecY );
        
        if( distance > 1.0 )
        {
            //vecX *= (1.0 / distance);
            //vecY *= (1.0 / distance);
        }
        else if( distance == 0.0 )
        {
            vecX = 0.0;
            vecY = 0.0;
        }
        else
        {
            //vecX *= (-1.0 / distance);
            //vecY *= (-1.0 / distance);
            vecX *= -1.0;
            vecY *= -1.0;
        }
        
        
        
        distance = sqrtf( cenX*cenX + cenY*cenY );
        
        if( distance == 0.0 )
        {
            cenX = 0.0;
            cenY = 0.0;
        }
        else if( distance < 1.0 && distance > 0.0 )
        {
            //cenX /= distance;
            //cenY /= distance;
            cenX *= -1.0;
            cenY *= -1.0;
        }
        else
        {
            cenX /= distance;
            cenY /= distance;
            cenX *= (distance - 1.0);
            cenY *= (distance - 1.0);
        }
        
        
        
        
        part_vel[i][0] = part_vel[i][0]*0.75 + vecX*0.002 + cenX*0.002;
        part_vel[i][1] = part_vel[i][1]*0.75+ vecY*0.002 + cenY*0.002;
        
        part_v[i][0] += part_vel[i][0];
        part_v[i][1] += part_vel[i][1];
    }
    
    
    
    
    
    
    //******************************************************
    // bind renderbuffer and present
    glBindRenderbuffer(GL_RENDERBUFFER, RBO_default_color);
    [glContext_obj presentRenderbuffer:GL_RENDERBUFFER];
    //******************************************************

    
    
    
    // calculation
    act_radius_coef += (dist_radius_coef - act_radius_coef)*animeCoef_1;
    
    
    // name
    if( CENTER[0] < 0.0 )
    {
        dist_name_center[0] = (CENTER[0] + aspect_ratio)/2.0;
        dist_name_center[1] = CENTER[1];
    }
    else
    {
        dist_name_center[0] = ( CENTER[0] - aspect_ratio ) / 2.0;
        dist_name_center[1] = CENTER[1];
    }
    act_name_center[0] += ( dist_name_center[0] - act_name_center[0] )*0.01;
    act_name_center[1] += ( dist_name_center[1] - act_name_center[1] )*0.01;
    act_texTitle_alpha += ( dist_texTitle_alpha - act_texTitle_alpha )*0.02;

    
}



- (void)animation_start_trigger_1
{
    NSLog(@"animation start trigger 1");
    dist_radius_coef = 0.9;
    animeCoef_1 = 0.015;
    
    dist_texTitle_alpha = 1.0;
    
    act_name_center[0] = 2.5;
    act_name_center[1] = 0.0;
}

- (void)animation_end_trigger_1
{
    NSLog(@"animation end trigger 1");
    dist_radius_coef = 0.0;
    animeCoef_1 = 0.05;
    
    dist_texTitle_alpha = 0.0;
}




- (void)set_Billboard:(GLfloat*)vPtr tex:(GLfloat*)texPtr size:(float)sz ratio:(float)r index:(int)idx center_x:(float)cx center_y:(float)cy
{
    float* vTemp = vPtr;
    float* tTemp = texPtr;
    
    float CENTER[2];
    float y_size = sz;
    float x_size = y_size * r;

    CENTER[0] = cx;
    CENTER[1] = cy;
    
    *vTemp = CENTER[0] - x_size;  vTemp++;
    *vTemp = CENTER[1] + y_size;  vTemp++;
    *vTemp = 0.0;   vTemp++;
    *vTemp = 1.0;   vTemp++;
    
    *vTemp = CENTER[0] - x_size;  vTemp++;
    *vTemp = CENTER[1] - y_size;  vTemp++;
    *vTemp = 0.0;   vTemp++;
    *vTemp = 1.0;   vTemp++;
    
    *vTemp = CENTER[0] + x_size;  vTemp++;
    *vTemp = CENTER[1] + y_size;  vTemp++;
    *vTemp = 0.0;   vTemp++;
    *vTemp = 1.0;   vTemp++;
    
    *vTemp = CENTER[0] + x_size;  vTemp++;
    *vTemp = CENTER[1] - y_size;  vTemp++;
    *vTemp = 0.0;   vTemp++;
    *vTemp = 1.0;   vTemp++;
    
    
    *tTemp = tex_coord_list[idx][0][0];   tTemp++;
    *tTemp = tex_coord_list[idx][0][1];   tTemp++;
    *tTemp = 0.0;   tTemp++;
    *tTemp = 0.0;   tTemp++;
    
    *tTemp = tex_coord_list[idx][1][0];   tTemp++;
    *tTemp = tex_coord_list[idx][1][1];   tTemp++;
    *tTemp = 0.0;   tTemp++;
    *tTemp = 0.0;   tTemp++;
    
    *tTemp = tex_coord_list[idx][2][0];   tTemp++;
    *tTemp = tex_coord_list[idx][2][1];   tTemp++;
    *tTemp = 0.0;   tTemp++;
    *tTemp = 0.0;   tTemp++;
    
    *tTemp = tex_coord_list[idx][3][0];   tTemp++;
    *tTemp = tex_coord_list[idx][3][1];   tTemp++;
    *tTemp = 0.0;   tTemp++;
    *tTemp = 0.0;   tTemp++;
    
}



- (void)start_particle
{
    NSLog(@"start particle");
    
    CGPoint pt1, pt2, pt3;
    pt1 = [gles_view_obj get_position:0];
    pt2 = [gles_view_obj get_position:1];
    pt3 = [gles_view_obj get_position:2];
    
    float CENTER_X, CENTER_Y;
    float aspect = VIEW_WIDTH / VIEW_HEIGHT;
    //CENTER_X = (pt1.x + pt2.x + pt3.x) / 3.0;
    //CENTER_Y = (pt1.y + pt2.y + pt3.y) / 3.0;
    CENTER_X = pt1.x;
    CENTER_Y = pt1.y;
    CENTER_X = ((CENTER_X / VIEW_WIDTH) - 0.5) * 2.0 * aspect;
    CENTER_Y = ((CENTER_Y / VIEW_HEIGHT) - 0.5) * -2.0;
    
    // median of CENTER_X and pt1
    
    NSLog(@"CENTER %f %f %f", CENTER_X, CENTER_Y, aspect);
    
    for( int i = 0 ; i < NUM_PARTICLE ; i++ )
    {
        float radius = (float)(random()%100)*0.0015;
        float degree = (float)(random()%360)*0.0174532925;
        float rand_x = sinf(degree)*radius;
        float rand_y = cosf(degree)*radius;
        part_v[i][0] = CENTER_X + rand_x;
        part_v[i][1] = CENTER_Y + rand_y;
        
        part_s[i][1] = (random()%30)*0.01 + 0.7;
        
        part_vel[i][0] = rand_x*1.5;
        part_vel[i][1] = rand_y*1.5;
    }
}

@end
