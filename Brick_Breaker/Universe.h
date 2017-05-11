//
//  Universe.h
//  p07-scagnelli
//
//  Created by Eric Scagnelli on 4/28/17.
//  Copyright © 2017 escagne1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GameScene.h"

@class GameViewController;
@class Level;


@interface Universe : NSObject{
    GameViewController *gameViewController;
    int levelIndex;
    bool tutorialShown;
}

@property (strong, nonatomic) id<GameDelegate> gameDelegate;
@property (nonatomic) BOOL tutorialShown;
@property (strong, nonatomic) NSArray *levels;
@property (nonatomic) int NUM_LEVELS;
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
-(void)setLevel;
-(void)nextLevel;
-(void)startLevel;
-(void)clearLevel;
-(Level *)getCurrentLevel;
-(void)incrementTotalScore:(int)score;
-(void)setLevelIndex:(int)newIndex;
-(BOOL)gameViewControllerIsNull;
-(GameViewController *)getGameViewController;
-(int)getLevelIndex;
-(void)load;
-(void)save;

@end
