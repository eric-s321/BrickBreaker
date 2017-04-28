//
//  Star.h
//  p07-scagnelli
//
//  Created by Eric Scagnelli on 4/28/17.
//  Copyright © 2017 escagne1. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Universe.h"

@interface Star : SKSpriteNode{
    Universe *universe;
}

@property(nonatomic) int value;

-(id)initWithImageNamed:(NSString *)name intRect:(CGRect)rect withValue:(int)value;
-(void)removeStar;

@end
