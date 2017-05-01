//
//  Universe.h
//  p07-scagnelli
//
//  Created by Eric Scagnelli on 4/28/17.
//  Copyright © 2017 escagne1. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GameViewController;
@class Level;

@interface Universe : NSObject{
    GameViewController *gameViewController;
    NSMutableArray *levels;
    int levelIndex;
}

@property (nonatomic) UInt32 BALL_CATEGORY;
@property (nonatomic) UInt32 BOTTOM_CATEGORY;
@property (nonatomic) UInt32 BLOCK_CATEGORY;
@property (nonatomic) UInt32 PADDLE_CATEGORY;
@property (nonatomic) UInt32 BORDER_CATEGORY;
@property (nonatomic) UInt32 STAR_CATEGORY;
@property (nonatomic) UInt32 STAR_COLLISION;
@property (nonatomic) UInt32 NON_STAR_COLLISION;

+(Universe *)sharedInstance;

-(void)setGameViewController:(GameViewController *)gameViewControllerIn;
-(void)loadLevels;
-(void)setLevel;
-(void)nextLevel;
-(void)startLevel;
-(void)clearLevel;
-(Level *)getCurrentLevel;

@end
