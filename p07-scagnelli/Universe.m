//
//  Universe.m
//  p07-scagnelli
//
//  Created by Eric Scagnelli on 4/28/17.
//  Copyright © 2017 escagne1. All rights reserved.
//

#import "Universe.h"
#import "GameViewController.h"
#import "Level.h"

#define NUM_LEVELS 1

@implementation Universe
@synthesize BALL_CATEGORY, BOTTOM_CATEGORY, BLOCK_CATEGORY, PADDLE_CATEGORY,
    BORDER_CATEGORY, STAR_CATEGORY, STAR_COLLISION, NON_STAR_COLLISION;

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
        STAR_CATEGORY = 0x1 << 5;
        levelIndex = 0;
        levels = [[NSMutableArray alloc] init];
        
        singleton = self;
    }
    
    return self;
}

+(Universe *)sharedInstance{
    
    if(singleton)
        return singleton;
    
    return [[Universe alloc]init];
}

-(void)setGameViewController:(GameViewController *)gameViewControllerIn{
    gameViewController = gameViewControllerIn;
}

-(void)loadLevels{
    [levels addObject:[Level level1]];
}

-(void)setLevel{
    [gameViewController setGameSceneLevel:levels[levelIndex]];
}

-(void)nextLevel{
    levelIndex++;
}

-(Level *)getCurrentLevel{
/*
    NSLog(@"GET CURRENT LEVEL");
    Level *originalLevel = levels[levelIndex];
    Level *copyLevel = [levels[levelIndex] copy];
    NSLog(@"Original level %@", levels[levelIndex]);
    NSLog(@"Copy level %@", copyLevel);
    NSLog(@"Copy level stars %@", copyLevel.stars);
    NSLog(@"Original level stars %@", originalLevel.stars);
*/
    return levels[levelIndex];
}

@end
