//
//  BlurredView.h
//  p07-scagnelli
//
//  Created by Eric Scagnelli on 4/29/17.
//  Copyright © 2017 escagne1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BlurredView : UIVisualEffectView{
    UILabel *levelCompleteLabel;
    UILabel *levelPointsLabel;
    UILabel *totalPointsLabel;
    UILabel *levelScoreLabel;
    UILabel *totalScoreLabel;
    int levelScoreInt;
    int finalLevelScore;
    int totalScoreInt;
    int finalTotalScoreInt;
    int totalScoreDifference;
    
    NSTimeInterval timeInterval;
    
    NSTimer *timer;
}

//-(id)initWithFrame:(CGRect)frame;
-(id)initWithFrame:(CGRect)frame levelScore:(int)levelScore totalScore:(int)totalScore;
-(void)incrementLevelScore;
-(void)incrementTotalScore;
-(void)presentGameScene;
    
@end
