//
//  GameScene.m
//  p07-scagnelli
//
//  Created by Eric Scagnelli on 4/19/17.
//  Copyright © 2017 escagne1. All rights reserved.
//

#import "GameScene.h"
#import "Block.h"
#import "Star.h"
#import "BlurredView.h"
#import "Level.h"
#import "Universe.h"

@implementation GameScene {
    SKSpriteNode *paddle;
    SKShapeNode *ball;
    CGVector ballImpulse;
}
@synthesize currentRoundPoints;

- (void)didMoveToView:(SKView *)view {
    // Setup your scene here
    
    universe = [Universe sharedInstance];
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
    self.physicsBody.friction = 0;
    
    //Remove all gravity
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsWorld.contactDelegate = self;
    
    paddle = (SKSpriteNode *)[self childNodeWithName:@"paddle"];
    float yCoord = (self.view.frame.size.height - paddle.frame.size.height*2.5) * -1;
    PADDLE_START_POSITION = CGPointMake(0, yCoord);
    paddle.position = PADDLE_START_POSITION;
    paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:paddle.frame.size];
    paddle.physicsBody.dynamic = NO;
    
    ball = [SKShapeNode shapeNodeWithCircleOfRadius:20];
    ball.strokeColor = [UIColor greenColor];
    ball.fillColor = [UIColor greenColor];
    BALL_START_POSITION = CGPointMake(0, self.frame.size.height/8);
    ball.position = BALL_START_POSITION;
    
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:20];
    ball.physicsBody.friction = 0;
    ball.physicsBody.restitution = 1;
    ball.physicsBody.linearDamping = 0;
    ball.physicsBody.allowsRotation = NO;
    ball.physicsBody.dynamic = NO;  //Start ball stationary
    ball.physicsBody.velocity = CGVectorMake(0, 0);
    
    [self addChild:ball];
    
    //Set up physics body for bottom of screen
    SKNode *bottom = [[SKNode alloc] init];
    CGRect bottomRect = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 1);
    bottom.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:bottomRect];
    [self addChild:bottom];
    
    
    //Set up category bit masks
    bottom.physicsBody.categoryBitMask = universe.BOTTOM_CATEGORY;
    ball.physicsBody.categoryBitMask = universe.BALL_CATEGORY;
    paddle.physicsBody.categoryBitMask = universe.PADDLE_CATEGORY;
    self.physicsBody.categoryBitMask = universe.BORDER_CATEGORY;
    
    //Notify contact delegate when ball touches other objects
    ball.physicsBody.contactTestBitMask = universe.BOTTOM_CATEGORY | universe.BLOCK_CATEGORY |
                    universe.PADDLE_CATEGORY | universe.STAR_CATEGORY;
    ball.physicsBody.collisionBitMask = universe.BORDER_CATEGORY | universe.PADDLE_CATEGORY |
                    universe.BLOCK_CATEGORY ;
    
    currentRoundPoints = 0;
}

-(void)levelSetup:(int)startingScore{
    [_gameDelegate setUpLevel:startingScore];
    
    //Add blocks and stars
    for (Block *block in currentLevel.blocks){
        [self addChild:block];
    }
    for (SKSpriteNode *star in currentLevel.stars){
        [self addChild:star];
    }
    
    tapScreenLabel = [[SKLabelNode alloc] initWithFontNamed:@"Avenir"];
    tapScreenLabel.fontSize = 30;
    tapScreenLabel.text = [NSString stringWithFormat:@"Tap Screen to Start"];
    [_gameDelegate setUpLevel:currentLevel.possibleScore];
    
    [self addChild:tapScreenLabel];
    currentRoundPoints = 0;
}

-(void)clearBlocksAndStars{
    
    for (Block *block in currentLevel.blocks){
        [block removeFromParent];
    }
    for (SKSpriteNode *star in currentLevel.stars){
        [star removeFromParent];
    }
    
    paddle.position = PADDLE_START_POSITION;
    ball.position = BALL_START_POSITION;
    ball.physicsBody.dynamic = NO;  //Start ball stationary
    ball.physicsBody.velocity = CGVectorMake(0, 0);
    self.paused = NO;
    
    currentLevel.numStarsLeft = (int)[currentLevel.stars count];
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
    
    if(firstBody.categoryBitMask == universe.BALL_CATEGORY){
        if(secondBody.categoryBitMask == universe.BOTTOM_CATEGORY){
            //NSLog(@"Ball hit the bottom");
            self.paused = YES;
            [_gameDelegate showLostLevelScreen];
        }
        
        if(secondBody.categoryBitMask == universe.BLOCK_CATEGORY){
            //NSLog(@"Ball hit block!");
            Block *block = (Block *)[secondBody node];
            [block breakBlock];
            [_gameDelegate levelScoreChanged:100];
        }
        
        if(secondBody.categoryBitMask == universe.PADDLE_CATEGORY){
            //NSLog(@"Ball hit paddle");
            if(!currentLevel.levelBegan) //First time ball hit paddle in this level
                currentLevel.levelBegan = YES;
            
            float contactPointX = contact.contactPoint.x;//x coord of collision point
            float paddlePosX = paddle.position.x; //x coord of the center of the paddle
            
            float distanceFromCenter;
            float VELOCITY_CONSTANT = 2;
            if(contactPointX < paddlePosX){ //Ball hit left side of paddle
                distanceFromCenter = paddlePosX - contactPointX;
                //Move ball to left
                ball.physicsBody.velocity = CGVectorMake(distanceFromCenter * VELOCITY_CONSTANT * -1, ball.physicsBody.velocity.dy);
            }
            else{
                distanceFromCenter = contactPointX - paddlePosX;
                //Move ball to right
                ball.physicsBody.velocity = CGVectorMake(distanceFromCenter * VELOCITY_CONSTANT, ball.physicsBody.velocity.dy);
            }
            [self boundVelocity];
        }
        if(secondBody.categoryBitMask == universe.STAR_CATEGORY){
            NSLog(@"Ball hit star");
            Star *star = (Star *)secondBody.node;
            [_gameDelegate totalScoreChanged:star.value];
            currentRoundPoints += star.value;
            [star removeStar];
            currentLevel.numStarsLeft--;
            
            if(currentLevel.numStarsLeft == 0){
                NSLog(@"Last star was removed!");
                self.paused = YES;
                [self passedLevel];
            }
        }
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

- (void)passedLevel{
    NSLog(@"Beginning of passed level");
    
    int levelScore = [_gameDelegate getLevelScore];
    int totalScore = [_gameDelegate getTotalScore];
    
    //Blur the background
    if(!UIAccessibilityIsReduceTransparencyEnabled()) {
        NSLog(@"IN IF");
        self.view.backgroundColor = [UIColor clearColor];
        BlurredView *blurredView = [[BlurredView alloc]
                initWithFrame:self.view.frame levelScore:levelScore totalScore:totalScore];
        [self.view addSubview:blurredView];
    }
    else{
        NSLog(@"IN ELSE");
        self.view.backgroundColor = [UIColor blackColor];
        UIView *regView = [[UIView alloc] initWithFrame:self.view.frame];
        [self.view addSubview:regView];
    }
}

-(void)nextLevel{

}

-(void)setCurrentLevel:(Level *)level{
    currentLevel = level;
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

- (void)touchUpAtPoint:(CGPoint)pos{
    if(!currentLevel.levelBegan && !ball.physicsBody.dynamic){
        ball.physicsBody.dynamic = YES; //Allow ball to move
        ballImpulse = CGVectorMake(0, -30);  //Set impulse for the ball
        [ball.physicsBody applyImpulse:ballImpulse];
        [tapScreenLabel removeFromParent];
    }
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
    if(currentLevel.levelBegan){
        if(ball.physicsBody.velocity.dx == 0){
            if(ball.position.x < 0){
                NSLog(@"x is 0 on left");
                [ball.physicsBody applyImpulse:CGVectorMake(5, 0)];
            }
            else{
                NSLog(@"x is 0 on right");
                [ball.physicsBody applyImpulse:CGVectorMake(-5, 0)];
            }
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
        }
    }
}

@end
