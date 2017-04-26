//
//  GameScene.h
//  p07-scagnelli
//
//  Created by Eric Scagnelli on 4/19/17.
//  Copyright © 2017 escagne1. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameScene : SKScene <SKPhysicsContactDelegate>

-(void)didMoveToView:(SKView *)view;
-(void)didBeginContact:(SKPhysicsContact *)contact;
-(void)boundVelocity;


@end
