//
//  GameViewController.h
//  p07-scagnelli
//
//  Created by Eric Scagnelli on 4/19/17.
//  Copyright © 2017 escagne1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import <GameplayKit/GameplayKit.h>
#import "GameScene.h"

@interface GameViewController : UIViewController{
    GameScene *scene;
}

-(IBAction)pauseGame:(id)sender;
-(IBAction)resumeGame:(UIStoryboardSegue *)segue;

@end
