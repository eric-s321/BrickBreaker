//
//  MainMenuViewController.m
//  Brick_Breaker
//
//  Created by Eric Scagnelli on 5/8/17.
//  Copyright © 2017 escagne1. All rights reserved.
//

#import "MainMenuViewController.h"
#import "Universe.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _resumeBtn.layer.cornerRadius = 8;
    _newgameBtn.layer.cornerRadius = 8;
    
    if([[Universe sharedInstance] gameViewControllerIsNull])
        [self disableBtn:_resumeBtn];
    else
        [self enableBtn:_resumeBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)disableBtn:(UIButton *) btn{
    btn.enabled = NO;
    btn.alpha = .5;
}

-(void)enableBtn:(UIButton *) btn{
    btn.enabled = YES;
    btn.alpha = 1;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
