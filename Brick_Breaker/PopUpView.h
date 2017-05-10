//
//  PopUpView.h
//  Brick_Breaker
//
//  Created by Eric Scagnelli on 5/9/17.
//  Copyright © 2017 escagne1. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef enum{
    ARROW_BOTTOM_LEFT,
    ARROW_BOTTOM_CENTER,
    ARROW_BOTTOM_RIGHT,
    ARROW_NO_POSITION
} ArrowPosition;

@protocol PopupDelegate
-(void)displayTapLabel;
-(void)displayNextPopup;
@end

@interface PopUpView : UIView

@property (strong, nonatomic) id<PopupDelegate> popupDelegate;
@property (nonatomic) bool onView;

-(id)initWithFrame:(CGRect)frame message:(NSString *)msg withArrow:(BOOL)arrow arrowPosition:(ArrowPosition)pos fontSize:(int)size;

@end
