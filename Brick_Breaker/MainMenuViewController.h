//
//  MainMenuViewController.h
//  Brick_Breaker
//
//  Created by Eric Scagnelli on 5/8/17.
//  Copyright © 2017 escagne1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainMenuViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *resumeBtn;
@property (strong, nonatomic) IBOutlet UIButton *newgameBtn;

-(IBAction)newGame;

@end
