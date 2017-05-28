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
#import "PopUpView.h"

#define SCORE_LABEL_HEIGHT 25

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
    
    self.view.multipleTouchEnabled = YES;
    
    //Remove all gravity
    self.physicsWorld.gravity = CGVectorMake(0, 0);
    self.physicsWorld.contactDelegate = self;
    
    paddle = (SKSpriteNode *)[self childNodeWithName:@"paddle"];
    float yCoord = (self.view.frame.size.height/2 - paddle.frame.size.height*2) * -1;
    PADDLE_START_POSITION = CGPointMake(0, yCoord);
    paddle.position = PADDLE_START_POSITION;
    PADDLE_SIZE = CGSizeMake(self.size.width / 3, 20);
    paddle.size = PADDLE_SIZE;
    paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:paddle.frame.size];
    paddle.physicsBody.dynamic = NO;
    
    ball = [SKShapeNode shapeNodeWithCircleOfRadius:10];
    ball.strokeColor = [UIColor greenColor];
    ball.fillColor = [UIColor greenColor];
    BALL_START_POSITION = CGPointMake(0, self.size.height/8);
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
    
    
    //Set up two finger swipe gestures
    UISwipeGestureRecognizer *twoFingerLeft = [[UISwipeGestureRecognizer alloc]
                                        initWithTarget:self action:@selector(handleSwipes:)];
    UISwipeGestureRecognizer *twoFingerRight = [[UISwipeGestureRecognizer alloc]
                                        initWithTarget:self action:@selector(handleSwipes:)];
    UISwipeGestureRecognizer *twoFingerDown = [[UISwipeGestureRecognizer alloc]
                                        initWithTarget:self action:@selector(handleSwipes:)];
    UISwipeGestureRecognizer *twoFingerUp = [[UISwipeGestureRecognizer alloc]
                                        initWithTarget:self action:@selector(handleSwipes:)];
    
    //Set directions for swipe gestures
    [twoFingerLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [twoFingerRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [twoFingerUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [twoFingerDown setDirection:UISwipeGestureRecognizerDirectionDown];
    
    //Make two fingers required
    [twoFingerLeft setNumberOfTouchesRequired:2];
    [twoFingerRight setNumberOfTouchesRequired:2];
    [twoFingerUp setNumberOfTouchesRequired:2];
    [twoFingerDown setNumberOfTouchesRequired:2];
    
    [[self view] addGestureRecognizer:twoFingerLeft];
    [[self view] addGestureRecognizer:twoFingerRight];
    [[self view] addGestureRecognizer:twoFingerUp];
    [[self view] addGestureRecognizer:twoFingerDown];
    
    
    ////////----------------TUTORIAL CODE-----------------------////////////////
    if(![[Universe sharedInstance] tutorialShown1]){
        tutorialMode = NO;
        popupViews = [[NSMutableArray alloc] init];
        popupIndex = -1;
        
        int viewHeight = 125;
        int viewWidth = 175;
        
        PopUpView *view;
        if([[Universe sharedInstance] getLevelIndex] == 0){
            tutorialMode = YES;
            
            CGRect frame = CGRectMake(CGRectGetMidX(self.view.frame) - viewWidth/2, CGRectGetMidY(self.view.frame) - viewHeight/2, viewWidth, viewHeight);
            view = [[PopUpView alloc] initWithFrame:frame message:@"Collect all the stars while avoiding the blocks!" withArrow:NO arrowPosition:ARROW_NO_POSITION fontSize:20];
            [view setPopupDelegate:self];
            [popupViews addObject:view];
            
            frame = CGRectMake(frame.origin.x, self.view.frame.size.height - viewHeight - SCORE_LABEL_HEIGHT, frame.size.width, frame.size.height);
            view = [[PopUpView alloc] initWithFrame:frame message:@"Lose 100 of these points for each block you destory" withArrow:YES arrowPosition:ARROW_BOTTOM_CENTER fontSize:18];
            [view setPopupDelegate:self];
            [popupViews addObject:view];
            
            frame = CGRectMake(self.view.frame.size.width - frame.size.width, frame.origin.y-100, frame.size.width, frame.size.height + 100);
            view = [[PopUpView alloc] initWithFrame:frame message:@"Total score. Gain 500 points for every star you collect and 100 for any block left intact" withArrow:YES arrowPosition:ARROW_BOTTOM_RIGHT fontSize:18];
            [view setPopupDelegate:self];
            [popupViews addObject:view];
            
            [[Universe sharedInstance] setTutorialShown1:YES];
        }
        
        
        //If there are popups to be shown show the first one
        if([popupViews count] > 0)
            [self displayNextPopup];
    }
}

-(bool)allPopupViewsGone{
    for(PopUpView *view in popupViews){
        if(view.onView)
            return NO;
    }
    
    return YES;
}

-(void)displayTapLabel{
    if([self allPopupViewsGone]){
        tapScreenLabel = [[SKLabelNode alloc] initWithFontNamed:@"Lunchtime Doubly So"];
        tapScreenLabel.fontSize = 20;
        tapScreenLabel.text = [NSString stringWithFormat:@"Tap Screen to Start"];
        [self addChild:tapScreenLabel];
        tutorialMode = NO;
    }
}

-(void)displayNextPopup{
    popupIndex++;
    
    //Still popups left
    if(popupIndex < [popupViews count])
        [self.view addSubview:popupViews[popupIndex]];
}

-(void)handleSwipes:(UISwipeGestureRecognizer *)recognizer {
    int swipePower = 10;
    switch ([recognizer direction]) {
        case UISwipeGestureRecognizerDirectionLeft:
            [ball.physicsBody applyImpulse:CGVectorMake(-swipePower, 0)];
            break;
        case UISwipeGestureRecognizerDirectionRight:
            [ball.physicsBody applyImpulse:CGVectorMake(swipePower, 0)];
            break;
        case UISwipeGestureRecognizerDirectionUp:
            [ball.physicsBody applyImpulse:CGVectorMake(0, swipePower)];
            break;
        case UISwipeGestureRecognizerDirectionDown:
            [ball.physicsBody applyImpulse:CGVectorMake(0, -swipePower)];
            break;
        default:
            break;
    }
    
    [self boundVelocity];
}

-(void)levelSetup:(int)startingScore{
    NSLog(@"IN game scene level setup");
    //[_gameDelegate setUpLevel:startingScore];
    
    if(![[Universe sharedInstance] tutorialShown2] &&[[Universe sharedInstance] getLevelIndex] == 1){
        tutorialMode = YES;
        int viewHeight = 125;
        int viewWidth = 175;
        
        CGRect frame = CGRectMake(CGRectGetMidX(self.view.frame) - viewWidth/2, CGRectGetMidY(self.view.frame) - viewHeight/2, viewWidth, viewHeight);
        PopUpView *view = [[PopUpView alloc] initWithFrame:frame message:@"Hit further from the center of the paddle to move the ball in that direction" withArrow:NO arrowPosition:ARROW_NO_POSITION fontSize:18];
        [view setPopupDelegate:self];
        [popupViews addObject:view];
        
        view = [[PopUpView alloc] initWithFrame:frame message:@"Swipe two fingers up, down, left, or right to move the ball" withArrow:NO arrowPosition:ARROW_NO_POSITION fontSize:18];
        [view setPopupDelegate:self];
        [popupViews addObject:view];
        [[Universe sharedInstance] setTutorialShown2:YES];
        
        popupIndex--; //On the first tutorial we skipped the first of these 2 popups
        if([popupViews count] > 0)
            [self displayNextPopup];
    }
    //Add blocks and stars
    for (Block *block in currentLevel.blocks){
        NSLog(@"Adding block");
        [self addChild:block];
        
        //Start moving blocks with movement
        if(block.movement != NO_MOVEMENT)
            [block move];
    }
    for (SKSpriteNode *star in currentLevel.stars){
        NSLog(@"Adding star");
        [self addChild:star];
    }
    
    if(!tutorialMode){
        tapScreenLabel = [[SKLabelNode alloc] initWithFontNamed:@"Lunchtime Doubly So"];
        tapScreenLabel.fontSize = 20;
        tapScreenLabel.text = [NSString stringWithFormat:@"Tap Screen to Start"];
        [self addChild:tapScreenLabel];
    }
    
    [_gameDelegate setUpLevel:currentLevel.possibleScore];
    currentRoundPoints = 0;
}

-(void)clearBlocksAndStars{
    
    for (Block *block in currentLevel.blocks){
        [block removeFromParent];
    }
    for (SKSpriteNode *star in currentLevel.stars){
        [star removeFromParent];
    }
    
    //If tap screen label is leftover because user started a new game get rid of it
    if([self intersectsNode:tapScreenLabel]){
        [tapScreenLabel removeFromParent];
    }
    
    for(id child in self.children){
        if([child isMemberOfClass:[SKLabelNode class]]) //get rid of left over point labels
            [child removeFromParent];
    }
    
    [ball removeAllActions];
    
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
    int X_MAX = 350;
    int X_MIN = -X_MAX;
    int Y_MAX = 400;
    int Y_MIN = -Y_MAX;
    
    if(ball.physicsBody.velocity.dx > X_MAX){
        ball.physicsBody.velocity = CGVectorMake(X_MAX, ball.physicsBody.velocity.dy);
    }
    else if(ball.physicsBody.velocity.dx < X_MIN){
        ball.physicsBody.velocity = CGVectorMake(X_MIN, ball.physicsBody.velocity.dy);
    }
    
    if(ball.physicsBody.velocity.dy > Y_MAX)
        ball.physicsBody.velocity = CGVectorMake(ball.physicsBody.velocity.dx, Y_MAX);
    if(ball.physicsBody.velocity.dy < Y_MIN){
        ball.physicsBody.velocity = CGVectorMake(ball.physicsBody.velocity.dx, Y_MIN);
    }
    NSLog(@"AFTER\nBall velocity dx = %f dy = %f", ball.physicsBody.velocity.dx, ball.physicsBody.velocity.dy);
}

- (void)passedLevel{
    int levelScore = [_gameDelegate getLevelScore];
    int totalScore = [_gameDelegate getTotalScore];
    
    //Blur the background
    if(!UIAccessibilityIsReduceTransparencyEnabled()) {
        self.view.backgroundColor = [UIColor clearColor];
        BlurredView *blurredView = [[BlurredView alloc]
                initWithFrame:self.view.frame levelScore:levelScore totalScore:totalScore];
        [self.view addSubview:blurredView];
    }
    else{
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
    NSLog(@"x: %f\ty: %f", pos.x, pos.y);
    if(!tutorialMode && !currentLevel.levelBegan && !ball.physicsBody.dynamic){
        ball.physicsBody.dynamic = YES; //Allow ball to move
        ballImpulse = CGVectorMake(0, -15);  //Set impulse for the ball
        [ball.physicsBody applyImpulse:ballImpulse];
        [tapScreenLabel removeFromParent];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    for (UITouch *t in touches)
    {
        //Single finger touch - move paddle
        if([[event touchesForView:self.view] count] == 1){
            CGPoint oldLocation = [t previousLocationInNode:self];
            [self touchMovedToPoint:[t locationInNode:self] fromPoint:oldLocation];
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    float avgX = 0;
    float avgY = 0;
    
    for (UITouch *t in touches){
        CGPoint loc = [t locationInNode:self];
        
        //Single finer touch - move paddle
        if([[event touchesForView:self.view] count] == 1){
            [self touchUpAtPoint:[t locationInNode:self]];
        }
        
        //Two finger touch
        else if([[event touchesForView:self.view] count] == 2){
            avgX += loc.x;
            avgY += loc.y;
        }
    }
    
    avgX /= 2.0;
    avgY /= 2.0;
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
        /*
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
        */
        
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
