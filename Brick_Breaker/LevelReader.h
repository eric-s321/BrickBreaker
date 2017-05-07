//
//  LevelReader.h
//  Brick_Breaker
//
//  Created by Eric Scagnelli on 5/7/17.
//  Copyright © 2017 escagne1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LevelReader : NSObject<NSXMLParserDelegate>

-(void)startParsing;
    
@end
