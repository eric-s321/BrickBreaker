//
//  Universe.m
//  p07-scagnelli
//
//  Created by Eric Scagnelli on 4/28/17.
//  Copyright © 2017 escagne1. All rights reserved.
//

#import "Universe.h"

@implementation Universe
@synthesize BALL_CATEGORY, BOTTOM_CATEGORY, BLOCK_CATEGORY, PADDLE_CATEGORY, BORDER_CATEGORY;

static Universe *singleton = nil;

-(id)init{
    
    if(singleton)
        return singleton;
    
    self = [super init];
    
    if(self){
        BALL_CATEGORY = 0x1 << 0;
        BOTTOM_CATEGORY = 0x1 << 1;
        BLOCK_CATEGORY = 0X1 << 2;
        PADDLE_CATEGORY = 0x1 << 3;
        BORDER_CATEGORY = 0x1 << 4;
        singleton = self;
    }
    
    return self;
}

+(Universe *)sharedInstance{
    
    if(singleton)
        return singleton;
    
    return [[Universe alloc]init];
}

@end
