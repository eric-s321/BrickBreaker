//
//  Star.m
//  p07-scagnelli
//
//  Created by Eric Scagnelli on 4/28/17.
//  Copyright © 2017 escagne1. All rights reserved.
//

#import "Star.h"
#import "Universe.h"

@implementation Star

-(id)initWithImageNamed:(NSString *)name intRect:(CGRect)rect withValue:(int)value{
    self = [super initWithImageNamed:name];
    
    if(self){
        self.position = rect.origin;
        self.size = rect.size;
        universe = [Universe sharedInstance];
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
        self.physicsBody.dynamic = NO;
        self.physicsBody.categoryBitMask = universe.STAR_CATEGORY;
        self.value = value;
    }
    
    return self;
}

-(void)removeStar{
    NSLog(@"REMOVE STAR CALLED");
    SKLabelNode *pointsLabel = [[SKLabelNode alloc] initWithFontNamed:@"Lunchtime Doubly So"];
    pointsLabel.fontSize = 15;
    pointsLabel.text = [NSString stringWithFormat:@"+%d", self.value];
    pointsLabel.position = CGPointMake(self.position.x, self.position.y + self.size.height/2);
    
    [self.scene addChild:pointsLabel];
    
    [self removeFromParent];
    [pointsLabel runAction:[SKAction sequence:@[[SKAction fadeOutWithDuration:1],[SKAction removeFromParent]]]];
}


@end
