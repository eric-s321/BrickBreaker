//
//  Universe.h
//  p07-scagnelli
//
//  Created by Eric Scagnelli on 4/28/17.
//  Copyright © 2017 escagne1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Universe : NSObject

@property (nonatomic) UInt32 BALL_CATEGORY;
@property (nonatomic) UInt32 BOTTOM_CATEGORY;
@property (nonatomic) UInt32 BLOCK_CATEGORY;
@property (nonatomic) UInt32 PADDLE_CATEGORY;
@property (nonatomic) UInt32 BORDER_CATEGORY;

+(Universe *)sharedInstance;

@end
