//
//  BlurredView.m
//  p07-scagnelli
//
//  Created by Eric Scagnelli on 4/29/17.
//  Copyright © 2017 escagne1. All rights reserved.
//

#import "BlurredView.h"
#import "Universe.h"

#define LABEL_PADDING 25

@implementation BlurredView

-(id)initWithFrame:(CGRect)frame levelScore:(int)levelScore totalScore:(int)totalScore{
    NSLog(@"In blurred view constructor");
    self = [super initWithFrame:frame];
    
    NSString *FONT = @"Lunchtime Doubly So";
    
    if(self){
        levelScoreInt = 0;
        finalLevelScore = levelScore;
        totalScoreInt = totalScore;
        finalTotalScoreInt = totalScoreInt + finalLevelScore;
        totalScoreDifference = finalTotalScoreInt - totalScoreInt;
        timeInterval = .005;
        
        //Update total score in GameViewController
        //(Do this here incase to ensure it is before user hits continue
        [[Universe sharedInstance] incrementTotalScore:totalScoreDifference];
        
        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        self.effect = blurEffect;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        float xCenter = self.frame.size.width / 2;
//        float yCenter = self.frame.size.height / 2;
        
        float bigLabelHeight = 150;
        float bigLabelWidth = 200;
        float smallLabelHeight = 75;
        float smallLabelWidth = 125;
        
        float yCoord = 50;
        
        
        levelCompleteLabel = [[UILabel alloc] initWithFrame:
                                    CGRectMake(xCenter - bigLabelWidth/2, yCoord, bigLabelWidth, bigLabelHeight)];
//        levelCompleteLabel.backgroundColor = [UIColor redColor];
        levelCompleteLabel.text = @"Level Complete!";
        levelCompleteLabel.font = [UIFont fontWithName:FONT size:35];
        levelCompleteLabel.textColor = [UIColor whiteColor];
        levelCompleteLabel.numberOfLines = 2;
        [levelCompleteLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:levelCompleteLabel];
        
        yCoord += bigLabelHeight + 50;
        
        levelPointsLabel = [[UILabel alloc] initWithFrame:
                                     CGRectMake((xCenter / 2) - smallLabelWidth/2 + LABEL_PADDING , yCoord, smallLabelWidth, smallLabelHeight)];
//        levelPointsLabel.backgroundColor = [UIColor blueColor];
        levelPointsLabel.text = @"Level Score: ";
        levelPointsLabel.font = [UIFont fontWithName:FONT size:22];
        levelPointsLabel.textColor = [UIColor whiteColor];
        levelPointsLabel.numberOfLines = 2;
        [levelPointsLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:levelPointsLabel];
        
        levelScoreLabel = [[UILabel alloc] initWithFrame:
                                     CGRectMake(xCenter * 1.5 - smallLabelWidth/2 - LABEL_PADDING, yCoord, smallLabelWidth, smallLabelHeight)];
//        levelScoreLabel.backgroundColor = [UIColor blueColor];
        levelScoreLabel.text = [NSString stringWithFormat:@"%d", levelScoreInt];
        levelScoreLabel.font = [UIFont fontWithName:FONT size:22];
        levelScoreLabel.textColor = [UIColor whiteColor];
        levelScoreLabel.numberOfLines = 2;
        [levelScoreLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:levelScoreLabel];
        
        
        yCoord += smallLabelHeight + 10;
        
        totalPointsLabel = [[UILabel alloc] initWithFrame:
                                     CGRectMake(xCenter/2 - smallLabelWidth/2 + LABEL_PADDING, yCoord, smallLabelWidth, smallLabelHeight)];
//        totalPointsLabel.backgroundColor = [UIColor blueColor];
        totalPointsLabel.text = @"Total Score: ";
        totalPointsLabel.font = [UIFont fontWithName:FONT size:22];
        totalPointsLabel.textColor = [UIColor whiteColor];
        totalPointsLabel.numberOfLines = 2;
        [totalPointsLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:totalPointsLabel];
        
        totalScoreLabel = [[UILabel alloc] initWithFrame:
                                     CGRectMake(xCenter * 1.5 - smallLabelWidth/2 - LABEL_PADDING , yCoord, smallLabelWidth, smallLabelHeight)];
//        totalScoreLabel.backgroundColor = [UIColor blueColor];
        totalScoreLabel.text = [NSString stringWithFormat:@"%d", totalScoreInt];
        totalScoreLabel.font = [UIFont fontWithName:FONT size:22];
        totalScoreLabel.textColor = [UIColor whiteColor];
        totalScoreLabel.numberOfLines = 2;
        [totalScoreLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:totalScoreLabel];
        
        yCoord += smallLabelHeight + 100;
        
        float btnWidth = 200;
        float btnHeight = 50;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(xCenter - btnWidth/2, yCoord, btnWidth, btnHeight)];
        [btn setTitle:@"Continue" forState:UIControlStateNormal];
        [btn setBackgroundColor:[UIColor colorWithRed:0 green:128/255.0 blue:64/255.0 alpha:1]];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont fontWithName:FONT size:24]];
        [btn addTarget:self action:@selector(presentGameScene) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(incrementLevelScore) userInfo:nil repeats:YES];
    }
    
    return self;
}

-(void)incrementLevelScore{
    if(finalLevelScore == 0)
        [timer invalidate];
    else{
        levelScoreInt++;
        if(levelScoreInt == finalLevelScore){
            [timer invalidate];
            timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(incrementTotalScore) userInfo:nil repeats:YES];
        }
        levelScoreLabel.text = [NSString stringWithFormat:@"%d", levelScoreInt];
    }
}

-(void)incrementTotalScore{
    totalScoreInt++;
    if(totalScoreInt == finalTotalScoreInt)
        [timer invalidate];
    totalScoreLabel.text = [NSString stringWithFormat:@"%d", totalScoreInt];
}

-(void)presentGameScene{
    [[Universe sharedInstance] clearLevel];
    [[Universe sharedInstance] nextLevel];
    
    [[Universe sharedInstance] setLevel];
    [[Universe sharedInstance] startLevel];
/*
    if(nextLevel){
        [[Universe sharedInstance] setLevel];
        [[Universe sharedInstance] startLevel];
    }
*/
    
    [self removeFromSuperview];
}


@end
