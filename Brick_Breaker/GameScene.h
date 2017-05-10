//
//  GameScene.h
//  p07-scagnelli
//
//  Created by Eric Scagnelli on 4/19/17.
//  Copyright © 2017 escagne1. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "PopUpView.h"

@class Level;
@class Universe;

@protocol GameDelegate
-(void) levelScoreChanged:(int)difference;
-(void) totalScoreChanged:(int)difference;
-(void) setUpLevel:(int)startingScore;
-(void) showLostLevelScreen;
-(int) getLevelScore;
-(int) getTotalScore;
-(void)presentNoMoreLevelsController;
@end

@interface GameScene : SKScene <SKPhysicsContactDelegate, PopupDelegate>{
    Level *currentLevel;
    SKLabelNode *tapScreenLabel;
    Universe *universe;
    CGPoint PADDLE_START_POSITION;
    CGPoint BALL_START_POSITION;
    bool tutorialMode;
    NSMutableArray *popupViews;
    int popupIndex;
}

@property (strong, nonatomic) id<GameDelegate> gameDelegate;
@property (nonatomic) int currentRoundPoints;

-(void)didMoveToView:(SKView *)view;
-(void)didBeginContact:(SKPhysicsContact *)contact;
-(void)clearBlocksAndStars;
-(void)boundVelocity;
-(void)levelSetup:(int)startingScore;
-(void)passedLevel;
-(void)nextLevel;
-(void)setCurrentLevel:(Level *)level;

@end
