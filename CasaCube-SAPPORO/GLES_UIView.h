//
//  GLES_UIView.h
//  casa_cube
//
//  Created by annolab on 2018/10/05.
//  Copyright © 2018年 annolab. All rights reserved.
//

#import <UIKit/UIKit.h>

#define NUM_MODELS 6

@interface GLES_UIView : UIView
{
    NSMutableArray* TOUCH_RECORD_ARRAY;
    int RECORD_COUNTER;
    
    
    // touch location
    float T_XY[3][2];
    double ORDERED_LENGTH[3];
    double ORDERED_ANGLE[3];
    int ORDERED_INDEX[3];
    
    
    double SIM_LEN[NUM_MODELS][3];
    double SIM_ANG[NUM_MODELS][3];
    double SIMILARITY[NUM_MODELS];
    
    double SIMILARITY_SUM[NUM_MODELS];
}

@property ( readonly ) bool isSomothingOn;
@property ( readonly ) int CURRENT_MODEL_INDEX;

- (void)delayedAFN;

- (void)set_touch_array:(NSArray*)tcArray;
- (void)set_touch_position:(NSArray*)tcArray;
- (void)reorder_length;
- (void)reorder_angle;
- (void)check_similarity;

- (CGPoint)get_position:(int)index;
- (void)get_similarity:(float*)sim_ptr;

- (void)drawTimerFromMainController;
@end
