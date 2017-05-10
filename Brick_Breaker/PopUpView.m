//
//  PopUpView.m
//  Brick_Breaker
//
//  Created by Eric Scagnelli on 5/9/17.
//  Copyright © 2017 escagne1. All rights reserved.
//

#import "PopUpView.h"

@implementation PopUpView


-(id)initWithFrame:(CGRect)frame message:(NSString *)msg withArrow:(BOOL)arrow arrowPosition:(ArrowPosition)pos fontSize:(int)size{
    self = [super initWithFrame:frame];
    
    if(self){
        int viewWidth = frame.size.width;
        int viewHeight = frame.size.height;
        int arrowHeight = 30;
        int arrowWidth = 30;
        int btnWidth;
        int btnHeight;
        btnHeight = btnWidth = 20;
        
        
        
        UILabel *label;
        if(arrow){
            label = [[UILabel alloc] initWithFrame:CGRectMake(0, btnHeight, viewWidth, viewHeight - btnHeight - arrowHeight)];
        }
        else{
            label = [[UILabel alloc] initWithFrame:CGRectMake(0, btnHeight, viewWidth, viewHeight - btnHeight)];
        }
        
        label.font = [UIFont fontWithName:@"Lunchtime Doubly So" size:size];
        label.numberOfLines = 10;
        label.text = msg;
        [label setTextAlignment:NSTextAlignmentCenter];
        
        UIButton *exitBtn = [[UIButton alloc] initWithFrame:CGRectMake(viewWidth - btnWidth, 0, btnWidth, btnHeight)];
        [exitBtn setTitle:@"X" forState:UIControlStateNormal];
        [exitBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [exitBtn addTarget:self action:@selector(dismissView) forControlEvents:UIControlEventTouchUpInside];
        
        if(arrow){
            UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"downArrow.png"]];
            if(pos == ARROW_BOTTOM_CENTER)
                arrowView.frame = CGRectMake(viewWidth/2 - arrowWidth/2, viewHeight - arrowHeight, arrowWidth, arrowHeight);
            else if(pos == ARROW_BOTTOM_RIGHT)
                arrowView.frame = CGRectMake(viewWidth - arrowWidth, viewHeight - arrowHeight, arrowWidth, arrowHeight);
            else if(pos == ARROW_BOTTOM_LEFT)
                arrowView.frame = CGRectMake(arrowWidth, viewHeight - arrowHeight, arrowWidth, arrowHeight);
            
            [self addSubview:arrowView];
        }
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        self.alpha = .7;
        
        _onView = YES;
        
        [self addSubview:label];
        [self addSubview:exitBtn];
    }
    
    return self;
}

-(void)dismissView{
    _onView = NO;
    [self removeFromSuperview];
    [_popupDelegate displayNextPopup];
    [_popupDelegate displayTapLabel];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
