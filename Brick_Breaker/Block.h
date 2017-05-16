//
//  Block.h
//  p07-scagnelli
//
//  Created by Eric Scagnelli on 4/24/17.
//  Copyright © 2017 escagne1. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef enum{
    NO_MOVEMENT,
    SQUARE,
    LEFT_RIGHT,
    UP_DOWN
}Movement;

@class Universe;

@interface Block : SKSpriteNode{
    Universe *universe;
}

@property (nonatomic) Movement movement;

-(id)initWithRect:(CGRect)rect color:(UIColor *)color movement:(Movement)movement;
-(void)breakBlock;
-(void)move;

@end
