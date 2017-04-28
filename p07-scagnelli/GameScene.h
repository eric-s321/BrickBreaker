//
//  GameScene.h
//  p07-scagnelli
//
//  Created by Eric Scagnelli on 4/19/17.
//  Copyright © 2017 escagne1. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Level.h"

@protocol GameDelegate
-(void) levelScoreChanged:(int)difference;
-(void) totalScoreChanged:(int)difference;
-(void) setUpLevel:(int)startingScore;
@end

@interface GameScene : SKScene <SKPhysicsContactDelegate>{
    Level *currentLevel;
    SKLabelNode *tapScreenLabel;
}

@property (strong, nonatomic) id<GameDelegate> gameDelegate;

-(void)didMoveToView:(SKView *)view;
-(void)didBeginContact:(SKPhysicsContact *)contact;
-(void)boundVelocity;
-(void)levelSetup:(int)startingScore;

@end
