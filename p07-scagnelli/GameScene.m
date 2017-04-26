//
//  GameScene.m
//  p07-scagnelli
//
//  Created by Eric Scagnelli on 4/19/17.
//  Copyright © 2017 escagne1. All rights reserved.
//

#import "GameScene.h"
#import "Block.h"

@implementation GameScene {
//    SKShapeNode *_spinnyNode;
//    SKLabelNode *_label;
    SKSpriteNode *paddle;
    SKShapeNode *ball;
    CGVector ballImpulse;
    
    UInt32 BALL_CATEGORY;
    UInt32 BOTTOM_CATEGORY;
    UInt32 BLOCK_CATEGORY;
    UInt32 PADDLE_CATEGORY;
    UInt32 BORDER_CATEGORY;
    
    bool fixedIt;
    
}

- (void)didMoveToView:(SKView *)view {
    // Setup your scene here
    
    fixedIt = NO;
    
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.friction = 0;
    
    paddle = (SKSpriteNode *)[self childNodeWithName:@"paddle"];
    float yCoord = (self.view.frame.size.height - paddle.frame.size.height) * -1;
    
    paddle.position = CGPointMake(0, yCoord);
    paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:paddle.frame.size];
    paddle.physicsBody.dynamic = NO;
    
    ball = [SKShapeNode shapeNodeWithCircleOfRadius:20];
    ball.strokeColor = [UIColor greenColor];
    ball.fillColor = [UIColor greenColor];
    ball.position = CGPointMake(0, self.frame.size.height/8);
    
    
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:20];
    ball.physicsBody.friction = 0;
    ball.physicsBody.restitution = 1;
    ball.physicsBody.linearDamping = 0;
    ball.physicsBody.allowsRotation = NO;
    ball.physicsBody.dynamic = YES;
    
    [self addChild:ball];
    
    
    //Remove all gravity
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsWorld.contactDelegate = self;
    ballImpulse = CGVectorMake(15, -30);  //Set impulse for the ball
    [ball.physicsBody applyImpulse:ballImpulse];  //Needs to get called AFTER ball is added to scene
    
    //Set up constant category names
    BALL_CATEGORY = 0x1 << 0;
    BOTTOM_CATEGORY = 0x1 << 1;
    BLOCK_CATEGORY = 0X1 << 2;
    PADDLE_CATEGORY = 0x1 << 3;
    BORDER_CATEGORY = 0x1 << 4;
    
    
    //Set up physics body for bottom of screen
    SKNode *bottom = [[SKNode alloc] init];
    CGRect bottomRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 1);
    bottom.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:bottomRect];
    [self addChild:bottom];
    
    //Set up category bit masks
    bottom.physicsBody.categoryBitMask = BOTTOM_CATEGORY;
    ball.physicsBody.categoryBitMask = BALL_CATEGORY;
    paddle.physicsBody.categoryBitMask = PADDLE_CATEGORY;
    self.physicsBody.categoryBitMask = BORDER_CATEGORY;
    
    //Notify contact delegate when ball touches bottom of screen
    ball.physicsBody.contactTestBitMask = BOTTOM_CATEGORY | BLOCK_CATEGORY | PADDLE_CATEGORY;
    

////////////////////BLOCK SETUP/////////////////////////////////////////////////////////////////
    int BLOCK_WIDTH = 150;
    int BLOCK_HEIGHT = 30;
    float leftx = ((self.view.frame.size.width / 4.0) * -1) - BLOCK_WIDTH / 2;
    float lefty = 100.0;
    float rightx = (self.view.frame.size.width / 4.0) + BLOCK_WIDTH / 2;
    float righty = 100.0;
    
    for (int i = 0; i < 8; i++){
        if (i < 4){
            Block *block = [[Block alloc] initWithRect:CGRectMake(leftx, lefty, BLOCK_WIDTH, BLOCK_HEIGHT)
                                                 color:[UIColor blueColor]];
            block.physicsBody.categoryBitMask = BLOCK_CATEGORY;
            
            lefty += 100;
            [self addChild:block];
        }
        else{
            Block *block = [[Block alloc] initWithRect:CGRectMake(rightx, righty, BLOCK_WIDTH, BLOCK_HEIGHT)
                                                 color:[UIColor blueColor]];
            block.physicsBody.categoryBitMask = BLOCK_CATEGORY;
            
            righty += 100;
            [self addChild:block];
        }
    }
}


//Called when contact with an object and anything in it's contactTestBitMask is detected
-(void)didBeginContact:(SKPhysicsContact *)contact{
    SKPhysicsBody *firstBody;
    SKPhysicsBody *secondBody;
    
    //Ensure body with the lower category bitmask is stored in firstBody
    if(contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else{
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if(firstBody.categoryBitMask == BALL_CATEGORY && secondBody.categoryBitMask == BOTTOM_CATEGORY){
        NSLog(@"Ball hit the bottom");
    }
    
    if(firstBody.categoryBitMask == BALL_CATEGORY && secondBody.categoryBitMask == BLOCK_CATEGORY){
        NSLog(@"Ball hit block!");
        Block *block = (Block *)[secondBody node];
        [block breakBlock];
    }
    
    if(firstBody.categoryBitMask == BALL_CATEGORY && secondBody.categoryBitMask == PADDLE_CATEGORY){
        NSLog(@"Ball hit paddle");
        
        float contactPointX = contact.contactPoint.x;//x coord of collision point
        float paddlePosX = paddle.position.x; //x coord of the center of the paddle
        
        float distanceFromCenter;
        float VELOCITY_CONSTANT = 2;
        if(contactPointX < paddlePosX){ //Ball hit left side of paddle
            NSLog(@"LEFT");
            distanceFromCenter = paddlePosX - contactPointX;
            NSLog(@"%f", distanceFromCenter);
            //Move ball to left
            ball.physicsBody.velocity = CGVectorMake(distanceFromCenter * VELOCITY_CONSTANT * -1, ball.physicsBody.velocity.dy);
        }
        else{
            NSLog(@"RIGHT");
            distanceFromCenter = contactPointX - paddlePosX;
            NSLog(@"%f", distanceFromCenter);
            //Move ball to right
            ball.physicsBody.velocity = CGVectorMake(distanceFromCenter * VELOCITY_CONSTANT, ball.physicsBody.velocity.dy);
        }
        [self boundVelocity];
    }
}

- (void)boundVelocity{
    NSLog(@"BEFORE\nBall velocity dx = %f dy = %f", ball.physicsBody.velocity.dx, ball.physicsBody.velocity.dy);
    if(ball.physicsBody.velocity.dx > 500){
        ball.physicsBody.velocity = CGVectorMake(500, ball.physicsBody.velocity.dy);
    }
    if(ball.physicsBody.velocity.dx < -500){
        ball.physicsBody.velocity = CGVectorMake(500, ball.physicsBody.velocity.dy);
    }
    if(ball.physicsBody.velocity.dy < 550){
        ball.physicsBody.velocity = CGVectorMake(ball.physicsBody.velocity.dx, 550);
    }
    NSLog(@"AFTER\nBall velocity dx = %f dy = %f", ball.physicsBody.velocity.dx, ball.physicsBody.velocity.dy);
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


//Called before each frame is rendered
-(void)update:(CFTimeInterval)currentTime {
    /*
     * Prevent ball from getting stuck
     */
    if(ball.physicsBody.velocity.dx == 0){
        if(ball.position.x < 0){
            NSLog(@"x is 0 on left");
            [ball.physicsBody applyImpulse:CGVectorMake(5, 0)];
        }
        else{
            NSLog(@"x is 0 on right");
            [ball.physicsBody applyImpulse:CGVectorMake(-5, 0)];
        }
        fixedIt = YES;
    }
    
    if(ball.physicsBody.velocity.dy == 0){
        if(ball.position.y < 0){ //Ball against the bottom of screen
            NSLog(@"y is 0 on bottom");
            [ball.physicsBody applyImpulse:CGVectorMake(0, 5)]; //Push ball up
        }
        else{ //Ball is against top of screen
            NSLog(@"y is 0 on top");
            [ball.physicsBody applyImpulse:CGVectorMake(0, -5)]; //Push ball down
        }
        fixedIt = YES;
    }
}


@end
