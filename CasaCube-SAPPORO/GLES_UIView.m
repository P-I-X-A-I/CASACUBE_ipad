//
//  GLES_UIView.m
//  casa_cube
//
//  Created by annolab on 2018/10/05.
//  Copyright © 2018年 annolab. All rights reserved.
//

#import "GLES_UIView.h"

@implementation GLES_UIView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+(Class)layerClass
{
    return [CAEAGLLayer class];
}


- (void)delayedAFN
{
    // init
    TOUCH_RECORD_ARRAY = [[NSMutableArray alloc] init];
    RECORD_COUNTER = 0;
    
    T_XY[0][0] = -1000.0;
    T_XY[0][1] = -1000.0;
    T_XY[1][0] = -1001.0;
    T_XY[1][1] = -1001.0;
    T_XY[2][0] = -1002.0;
    T_XY[2][1] = -1002.0;

    // set 3 string to array
    for( int i = 0 ; i < 3 ; i++ )
    {
        NSString* tempString = [[NSString alloc] initWithFormat:@"%d", 0];
        [TOUCH_RECORD_ARRAY addObject:tempString];
    }
    
    
    
    // set similarity value
    // casa amare ( 0 )
    SIM_LEN[0][0] = 238.0;  SIM_LEN[0][1] = 238.0;  SIM_LEN[0][2] = 80.0;
    SIM_ANG[0][0] = 81.0;   SIM_ANG[0][1] = 79.0;   SIM_ANG[0][2] = 20.5;
    
    // casa basso ( 1 )
    SIM_LEN[1][0] = 272.0;  SIM_LEN[1][1] = 266.0;  SIM_LEN[1][2] = 148.5;
    SIM_ANG[1][0] = 74.5;   SIM_ANG[1][1] = 72.0;   SIM_ANG[1][2] = 31.5;
    
    // casa carina ( 2 )
    SIM_LEN[2][0] = 122.0;  SIM_LEN[2][1] = 120.0;  SIM_LEN[2][2] = 92.0;
    SIM_ANG[2][0] = 68.0;   SIM_ANG[2][1] = 65.0;   SIM_ANG[2][2] = 45.0;
    
    // casa cube ( 3 )
    SIM_LEN[3][0] = 192.0;  SIM_LEN[3][1] = 142.0;  SIM_LEN[3][2] = 130.0;
    SIM_ANG[3][0] = 90.0;   SIM_ANG[3][1] = 48.0;   SIM_ANG[3][2] = 41.0;
    
    // casa piatto ( 4 )
    SIM_LEN[4][0] = 258.0;  SIM_LEN[4][1] = 186.0;  SIM_LEN[4][2] = 184.0;
    SIM_ANG[4][0] = 89.5;   SIM_ANG[4][1] = 45.0;   SIM_ANG[4][2] = 45.0;
    
    // casa skip ( 5 )
    SIM_LEN[5][0] = 159.0;  SIM_LEN[5][1] = 159.0;  SIM_LEN[5][2] = 120.0;
    SIM_ANG[5][0] = 70.0;   SIM_ANG[5][1] = 66.0;   SIM_ANG[5][2] = 43.0;
    
    for( int i = 0 ; i < NUM_MODELS ; i++ )
    {
        SIMILARITY_SUM[i] = 0.0;
    }
    
    _isSomothingOn = false;
    _CURRENT_MODEL_INDEX = 100;
    
}



- (void)set_touch_array:(NSArray*)tcArray
{
    int debug[3] = {0};
    
    for( int i = 0 ; i < [tcArray count] ; i++ )
    {
        UITouch* tempTouch = [tcArray objectAtIndex:i];
        NSString* tempString = [NSString stringWithFormat:@"%p", tempTouch];
        BOOL isExist = false;
        
        // check if touch is already exist
        if( [[TOUCH_RECORD_ARRAY objectAtIndex:0] isEqualToString:tempString] ){ isExist = true; debug[0] = 1;}
        if( [[TOUCH_RECORD_ARRAY objectAtIndex:1] isEqualToString:tempString] ){ isExist = true; debug[1] = 1;}
        if( [[TOUCH_RECORD_ARRAY objectAtIndex:2] isEqualToString:tempString] ){ isExist = true; debug[2] = 1;}


        
        if( !isExist )
        {
            // set to slot
            NSString* allocedString = [[NSString alloc] initWithString:tempString];
            
            [TOUCH_RECORD_ARRAY removeObjectAtIndex:RECORD_COUNTER];
            [TOUCH_RECORD_ARRAY insertObject:allocedString atIndex:RECORD_COUNTER];
            RECORD_COUNTER++;
            
            if( RECORD_COUNTER > 2 )
            {
                RECORD_COUNTER = 0;
            }
        }// if !isExist
    } // for
    
    
    // debug print
//    for( int i = 0 ; i < [TOUCH_RECORD_ARRAY count] ; i++ )
//    {
//        NSLog(@"%@ :: %d", [TOUCH_RECORD_ARRAY objectAtIndex:i], debug[i]);
//    }
//
//    NSLog(@"***********");
}




- (void)set_touch_position:(NSArray*)tcArray
{
    float inValue[3][2];
    int inNum = 0;
    
    for( int i = 0 ; i < [tcArray count] ; i++ )
    {
        UITouch* tempTouch = [tcArray objectAtIndex:i];
        NSString* pointerString = [NSString stringWithFormat:@"%p", tempTouch];
        
        
        // overwrite touch position to closest point
        
        //T_XY[i][0] = [tempTouch locationInView:self].x;
        //T_XY[i][1] = [tempTouch locationInView:self].y;
        inValue[i][0] = [tempTouch locationInView:self].x;
        inValue[i][1] = [tempTouch locationInView:self].y;
        inNum++;
        
        
        if( i == 2 )
        {
            break;
        }
        
        
        // set position if these come from same touch objects
        for( int j = 0 ; j < [TOUCH_RECORD_ARRAY count] ; j++ )
        {
            if( [[TOUCH_RECORD_ARRAY objectAtIndex:j] isEqualToString:pointerString ])
            {
                //T_XY[j][0] = [tempTouch locationInView:self].x;
                //T_XY[j][1] = [tempTouch locationInView:self].y;
            }
        } // for j
        
        
    } // for i
    
    
    // write inValue to closest position
    float distance[3][3];
    float tempSlot[3][2];
    
    for( int i = 0 ; i < inNum ; i++ )
    {
        // check length
        // to T_XY 0
        float A = T_XY[0][0] - inValue[i][0];
        float B = T_XY[0][1] - inValue[i][1];
        distance[i][0] = sqrtf( A*A + B*B );
        
        // to T_XY 1
        A = T_XY[1][0] - inValue[i][0];
        B = T_XY[1][1] - inValue[i][1];
        distance[i][1] = sqrtf( A*A + B*B );
        
        // to _XY 2
        A = T_XY[2][0] - inValue[i][0];
        B = T_XY[2][1] - inValue[i][1];
        distance[i][2] = sqrtf( A*A + B*B );
    }
    
    
    // set inValue to closest T_XY
    bool isSomeValueOutOfRange = false;
    bool isTempSlotStored[3] = {false};
    for( int i = 0 ; i < inNum ; i++ )
    {
        float closest = 20.0;
        int IDX = 123456789;
        for( int j = 0 ; j < 3 ; j++ )
        {
            if( distance[i][j] < closest )
            {
                closest = distance[i][j];
                IDX = j;
            }
        }// j
        
        if( IDX != 123456789 )
        {
            tempSlot[IDX][0] = inValue[i][0];
            tempSlot[IDX][1] = inValue[i][1];
            isTempSlotStored[IDX] = true;
        }
        else if( IDX == 123456789 )
        {
            isSomeValueOutOfRange = true;
        }
    }// i
    
    
    // there are some "not close" point
    if( isSomeValueOutOfRange )
    {
        for( int i = 0 ; i < inNum ; i++)
        {
            T_XY[i][0] = inValue[i][0];
            T_XY[i][1] = inValue[i][1];
        }
    }
    else // all touch point stored into closest position
    {
        for( int i = 0 ; i < 3 ; i++ )
        {
            if( isTempSlotStored[i] )
            {
                T_XY[i][0] = tempSlot[i][0];
                T_XY[i][1] = tempSlot[i][1];
            }
        }//for i
    }
    
}// end





- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // get touch array
    NSArray* tempArray = [touches allObjects];
    
    // check slot
    [self set_touch_array:tempArray];
    
    // set touch position
    [self set_touch_position:tempArray];
    
    // order
    [self reorder_length];
    [self reorder_angle];
    
    // check similarity
    [self check_similarity];
    
    
    _isSomothingOn = true;
}






- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // get touch array
    NSArray* tempArray = [touches allObjects];
    
    // check slot
    [self set_touch_array:tempArray];
    
    // set touch position
    [self set_touch_position:tempArray];
    
    // order
    [self reorder_length];
    [self reorder_angle];
    
    // check similarity
    [self check_similarity];
    
    
    _isSomothingOn = true;
}






- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // get touch array
    NSArray* tempArray = [touches allObjects];
    
    // check slot
    [self set_touch_array:tempArray];
    
    // set touch position
    [self set_touch_position:tempArray];
    
    // order
    [self reorder_length];
    [self reorder_angle];
    
    // check similarity
    [self check_similarity];
    
    NSLog(@"TOUCH END!!!!!!!!!!!!");
    
    
    _isSomothingOn = false;
}





- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // get touch array
    NSArray* tempArray = [touches allObjects];
    
    // check slot
    [self set_touch_array:tempArray];
    
    // set touch position
    [self set_touch_position:tempArray];
    
    [self reorder_length];
    [self reorder_angle];
}





- (void)reorder_length
{
//    NSLog(@"a : %f %f", T_XY[0][0], T_XY[0][1] );
//    NSLog(@"b : %f %f", T_XY[1][0], T_XY[1][1] );
//    NSLog(@"c : %f %f", T_XY[2][0], T_XY[2][1] );
//    NSLog(@"**********");
//
    double LENGTH[3];
    double vecX;
    double vecY;
    
    // length of pt 0 -> pt 1
    vecX = T_XY[1][0] - T_XY[0][0];
    vecY = T_XY[1][1] - T_XY[0][1];
    LENGTH[0] = sqrt( vecX*vecX + vecY*vecY );
    
    // length of pt 1 -> pt 2
    vecX = T_XY[2][0] - T_XY[1][0];
    vecY = T_XY[2][1] - T_XY[1][1];
    LENGTH[1] = sqrt( vecX*vecX + vecY*vecY );
    
    // length of pt 2 -> pt 0
    vecX = T_XY[0][0] - T_XY[2][0];
    vecY = T_XY[0][1] - T_XY[2][1];
    LENGTH[2] = sqrt( vecX*vecX + vecY*vecY );
    
    // check order
    [self compair_three_number:LENGTH
                    orderedNum:ORDERED_LENGTH
                  orderedIndex:ORDERED_INDEX];
    
    //NSLog(@"L : %f %f %f", ORDERED_LENGTH[0], ORDERED_LENGTH[1], ORDERED_LENGTH[2] );
    //NSLog(@"IDX : %d %d %d", ORDERED_INDEX[0], ORDERED_INDEX[1], ORDERED_INDEX[2]);
}






- (void)reorder_angle
{
    double vecA[3][2];
    double vecB[3][2];
    double ANGLE[3];
    double LENGTH;
    // 0 - 1 & 0 - 2
    vecA[0][0] = T_XY[1][0] - T_XY[0][0];
    vecA[0][1] = T_XY[1][1] - T_XY[0][1];
    vecB[0][0] = T_XY[2][0] - T_XY[0][0];
    vecB[0][1] = T_XY[2][1] - T_XY[0][1];
    
    // 1 - 0 & 1 - 2
    vecA[1][0] = T_XY[0][0] - T_XY[1][0];
    vecA[1][1] = T_XY[0][1] - T_XY[1][1];
    vecB[1][0] = T_XY[2][0] - T_XY[1][0];
    vecB[1][1] = T_XY[2][1] - T_XY[1][1];
    
    // 2 - 0 & 2 - 1
    vecA[2][0] = T_XY[0][0] - T_XY[2][0];
    vecA[2][1] = T_XY[0][1] - T_XY[2][1];
    vecB[2][0] = T_XY[1][0] - T_XY[2][0];
    vecB[2][1] = T_XY[1][1] - T_XY[2][1];

    // normalize vec
    for( int i = 0 ; i < 3 ; i++ )
    {
        LENGTH = sqrt( vecA[i][0]*vecA[i][0] + vecA[i][1]*vecA[i][1] );
        if( LENGTH > 1.0 )
        {
            vecA[i][0] /= LENGTH;
            vecA[i][1] /= LENGTH;
        }
        else
        {
            vecA[i][0] = 0.0;
            vecA[i][1] = 0.0;
        }
        
        LENGTH = sqrt( vecB[i][0]*vecB[i][0] + vecB[i][1]*vecB[i][1] );
        if( LENGTH > 1.0 )
        {
            vecB[i][0] /= LENGTH;
            vecB[i][1] /= LENGTH;
        }
        else
        {
            vecB[i][0] = 0.0;
            vecB[i][1] = 0.0;
        }
    }

    
    // dot product
    for( int i = 0 ; i < 3 ; i++ )
    {
        ANGLE[i] = vecA[i][0]*vecB[i][0] + vecA[i][1]*vecB[i][1];
    }
    
    
    // convert to degree
    ANGLE[0] = acos(ANGLE[0]) * 57.295779578552299;
    ANGLE[1] = acos(ANGLE[1]) * 57.295779578552299;
    ANGLE[2] = acos(ANGLE[2]) * 57.295779578552299;

    // order angle
    [self compair_three_number:ANGLE
                    orderedNum:ORDERED_ANGLE
                  orderedIndex:nil];
    
    //NSLog(@"ANGLE : %f : %f : %f", ORDERED_ANGLE[0], ORDERED_ANGLE[1], ORDERED_ANGLE[2] );
}






- (void)compair_three_number:(double*)threeNum
                  orderedNum:(double*)ordered_L
                orderedIndex:(int*)ordered_IDX
{
    // get num
    double* tempPtr = threeNum;
    double LEN[3];
    double o_len[3];
    int o_index[3];
    LEN[0] = *tempPtr; tempPtr++;
    LEN[1] = *tempPtr; tempPtr++;
    LEN[2] = *tempPtr;
    
    // check order
    if( LEN[0] > LEN[1] )
    {
        if( LEN[0] > LEN[2] )
        {
            if(LEN[1] > LEN[2])
            {
                o_len[0] = LEN[0];
                o_len[1] = LEN[1];
                o_len[2] = LEN[2];
                o_index[0] = 0;
                o_index[1] = 1;
                o_index[2] = 2;
            }
            else
            {
                o_len[0] = LEN[0];
                o_len[1] = LEN[2];
                o_len[2] = LEN[1];
                o_index[0] = 0;
                o_index[1] = 2;
                o_index[2] = 1;
            }
        }
        else
        {
            o_len[0] = LEN[2];
            o_len[1] = LEN[0];
            o_len[2] = LEN[1];
            o_index[0] = 2;
            o_index[1] = 0;
            o_index[2] = 1;
        }
    }// if 0 > 1
    else
    {
        if(LEN[1] > LEN[2])
        {
            if(LEN[2] > LEN[0])
            {
                o_len[0] = LEN[1];
                o_len[1] = LEN[2];
                o_len[2] = LEN[0];
                o_index[0] = 1;
                o_index[1] = 2;
                o_index[2] = 0;
            }
            else
            {
                o_len[0] = LEN[1];
                o_len[1] = LEN[0];
                o_len[2] = LEN[2];
                o_index[0] = 1;
                o_index[1] = 0;
                o_index[2] = 2;
            }
        }
        else
        {
            o_len[0] = LEN[2];
            o_len[1] = LEN[1];
            o_len[2] = LEN[0];
            o_index[0] = 2;
            o_index[1] = 1;
            o_index[2] = 0;
        }
    }
    
    
    // set number
    double* Lptr = ordered_L;
    int* IDXptr;
    
    *Lptr = o_len[0];   Lptr++;
    *Lptr = o_len[1];   Lptr++;
    *Lptr = o_len[2];
    
    if( ordered_IDX != nil )
    {
        IDXptr = ordered_IDX;
        *IDXptr = o_index[0];   IDXptr++;
        *IDXptr = o_index[1];   IDXptr++;
        *IDXptr = o_index[2];
    }
}





- (void)check_similarity
{
    //printf("SIM : ");
    for( int MODEL = 0 ; MODEL < NUM_MODELS ; MODEL++ )
    {
        double diff_L[3];
        double diff_A[3];
        double ratio_L[3];
        double ratio_A[3];
        
        SIMILARITY[MODEL] = 0.0;
        
        for( int j = 0 ; j < 3 ; j++ )
        {
            diff_L[j] = fabs( ORDERED_LENGTH[j] - SIM_LEN[MODEL][j] );
            diff_A[j] = fabs( ORDERED_ANGLE[j] - SIM_ANG[MODEL][j] );
            
            ratio_L[j] = diff_L[j] / SIM_LEN[MODEL][j];
            ratio_A[j] = diff_A[j] / SIM_ANG[MODEL][j];
            
            // if it's under 10%
            
            // else
            
            
            ratio_L[j] = sqrt( ratio_L[j] );
            ratio_A[j] = sqrt( ratio_A[j] );
            
            SIMILARITY[MODEL] += ratio_L[j];
            SIMILARITY[MODEL] += ratio_A[j]*0.5;
        }
        //printf("%1.2f : ", SIMILARITY[MODEL] );
    }
    //printf("\n");

}





- (CGPoint)get_position:(int)index
{
    return CGPointMake( (CGFloat)T_XY[index][0], (CGFloat)T_XY[index][1]);
}



- (void)drawTimerFromMainController
{
    // find smallest similarity
    if( _isSomothingOn )
    {
        double smallValue = 1.0;
        int small_index = 100;
        
        
        for( int i = 0 ; i < NUM_MODELS ; i++ )
        {
            if( SIMILARITY[i] < smallValue )
            {
                smallValue = SIMILARITY[i];
                small_index = i;
            }
        }// for NUM_MODELS
        
        
        // add similarity
        SIMILARITY_SUM[small_index] += 1.5;
        
        if(SIMILARITY_SUM[small_index] > 100.0 )
        {
            SIMILARITY_SUM[small_index] = 100.0;
        }
        
        
        // set current model index
        _CURRENT_MODEL_INDEX = small_index;
        
    }// is something on
    else // no object on ipad
    {
        _CURRENT_MODEL_INDEX = 100;
    }
    
    
    
    // reduce similarity
    for( int i = 0 ; i < NUM_MODELS ; i++ )
    {
        SIMILARITY_SUM[i] *= 0.988;
    }
}




- (void)get_similarity:(float *)sim_ptr
{
    float* restore = sim_ptr;
    
    for( int i = 0 ; i < NUM_MODELS ; i++ )
    {
        *sim_ptr = SIMILARITY_SUM[i];
        sim_ptr++;
    }
    
    sim_ptr = restore;
}


@end
