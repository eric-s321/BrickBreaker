//
//  Block.h
//  p07-scagnelli
//
//  Created by Eric Scagnelli on 4/24/17.
//  Copyright © 2017 escagne1. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Block : SKSpriteNode

-(id)initWithRect:(CGRect)rect color:(UIColor *)color;
-(void)breakBlock;

@end
