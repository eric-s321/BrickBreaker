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


@implementation Universe
@synthesize levels, NUM_LEVELS, BALL_CATEGORY, BOTTOM_CATEGORY, BLOCK_CATEGORY, PADDLE_CATEGORY,
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
    NSLog(@"SETTING GAME VIEW CONTROLLER");
    gameViewController = gameViewControllerIn;
}

-(void)setLevel{
    [gameViewController setGameSceneLevel:levels[levelIndex]];
}

-(void)nextLevel{
    if(levelIndex + 1 < NUM_LEVELS)
        levelIndex++;
    else
        [_gameDelegate presentNoMoreLevelsController];
/*
    if(levelIndex + 1 < NUM_LEVELS){
        levelIndex++;
        return YES;
    }
    else{//ran out of levels
        NSLog(@"RAN OUT OF LEVELS");
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UIViewController *noMoreLevelsController = [storyBoard instantiateViewControllerWithIdentifier:@"NoMoreLevelsController"];
        UIViewController *initialController = [storyBoard instantiateInitialViewController];
        [initialController presentViewController:noMoreLevelsController animated:YES completion:nil];
        return NO;
    }
*/
}

-(void)startLevel{
    [gameViewController nextLevel];
}
-(void)clearLevel{
    [gameViewController clearLevel];
}

-(Level *)getCurrentLevel{
    return levels[levelIndex];
}

-(void)incrementTotalScore:(int)score{
    [gameViewController totalScoreChanged:score];
}

-(void)setLevelIndex:(int)newIndex{
    levelIndex = newIndex;
}

/*
-(IBAction)newGame:(UIStoryboardSegue *)segue{
    levelIndex = 0;
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    GameViewController *newGameController = [storyBoard instantiateViewControllerWithIdentifier:@"GameViewController"];
    [self setGameViewController:newGameController];
    [self setLevel];
    
    UIViewController *initialController = [storyBoard instantiateInitialViewController];
    [initialController presentViewController:newGameController animated:YES completion:nil];
}
*/

-(BOOL)gameViewControllerIsNull{
    if(gameViewController)
        return NO;
    return YES;
}

-(GameViewController *)getGameViewController{
    return gameViewController;
}
    
@end
