//
//  GameScene.m
//  p07-scagnelli
//
//  Created by Eric Scagnelli on 4/19/17.
//  Copyright © 2017 escagne1. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene {
//    SKShapeNode *_spinnyNode;
//    SKLabelNode *_label;
    SKSpriteNode *paddle;
    SKShapeNode *ball;
}

- (void)didMoveToView:(SKView *)view {
    // Setup your scene here
    
    
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    
    paddle = (SKSpriteNode *)[self childNodeWithName:@"paddle"];
    float yCoord = (self.view.frame.size.height - paddle.frame.size.height) * -1;
    
    paddle.position = CGPointMake(0, yCoord);
    paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:paddle.frame.size];
    paddle.physicsBody.dynamic = NO;
    
    ball = [SKShapeNode shapeNodeWithCircleOfRadius:20];
    ball.strokeColor = [UIColor greenColor];
    ball.fillColor = [UIColor greenColor];
    ball.position = CGPointMake(0, self.frame.size.height/4);
    
    
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:20];
    ball.physicsBody.friction = 0;
    ball.physicsBody.restitution = 1;
    ball.physicsBody.linearDamping = 0;
    ball.physicsBody.allowsRotation = NO;
    ball.physicsBody.dynamic = YES;
    
    [self addChild:ball];
    
    [ball.physicsBody applyImpulse:CGVectorMake(2, -2)];  //Needs to get called AFTER ball is added to scene
    
    
    
    
}


- (void)touchDownAtPoint:(CGPoint)pos {
    
}

- (void)touchMovedToPoint:(CGPoint)pos fromPoint:(CGPoint)oldPos {
    float newX = paddle.position.x + (pos.x - oldPos.x);
    
    float leftBorder = (self.frame.size.width / 2) * -1 + paddle.size.width/2;
    float rightBorder = self.frame.size.width / 2 - paddle.size.width/2;
    
    if(newX < leftBorder)
        newX = leftBorder;
    if(newX > rightBorder)
        newX = rightBorder;
    
    paddle.position = CGPointMake(newX, paddle.position.y);
}

- (void)touchUpAtPoint:(CGPoint)pos {
   
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // Run 'Pulse' action from 'Actions.sks'
/*
    [_label runAction:[SKAction actionNamed:@"Pulse"] withKey:@"fadeInOut"];
    
    for (UITouch *t in touches) {[self touchDownAtPoint:[t locationInNode:self]];}
*/
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *t in touches)
    {
        CGPoint oldLocation = [t previousLocationInNode:self];
        [self touchMovedToPoint:[t locationInNode:self] fromPoint:oldLocation];
    }
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches){
        [self touchUpAtPoint:[t locationInNode:self]];
    }
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *t in touches) {[self touchUpAtPoint:[t locationInNode:self]];}
}


-(void)update:(CFTimeInterval)currentTime {
    // Called before each frame is rendered
}

@end
