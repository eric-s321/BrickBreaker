//
//  BlurredView.m
//  p07-scagnelli
//
//  Created by Eric Scagnelli on 4/29/17.
//  Copyright © 2017 escagne1. All rights reserved.
//

#import "BlurredView.h"
#import "Universe.h"

@implementation BlurredView

-(id)initWithFrame:(CGRect)frame{
    NSLog(@"In blurred view constructor");
    self = [super initWithFrame:frame];
    
    if(self){
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        self.effect = blurEffect;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(200, 200, 150, 100)];
        label.text = @"Testing Testing 1 2 3...";
        label.textColor = [UIColor whiteColor];
        [self addSubview:label];
        
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(50, 400, 150, 100)];
        [btn setTitle:@"Continue" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(presentGameScene) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    
    return self;
}

-(void)presentGameScene{
    [[Universe sharedInstance] clearLevel];
    [[Universe sharedInstance] nextLevel];
    [[Universe sharedInstance] setLevel];
    [[Universe sharedInstance] startLevel];
    
    [self removeFromSuperview];
}


@end
