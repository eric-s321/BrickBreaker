//
//  Block.m
//  p07-scagnelli
//
//  Created by Eric Scagnelli on 4/24/17.
//  Copyright © 2017 escagne1. All rights reserved.
//

#import "Block.h"

@implementation Block

-(id)initWithRect:(CGRect)rect color:(UIColor *)color{
    self = [super init];
    
    if(self){
        self.color = color;
        self.position = rect.origin;
        self.size = rect.size;
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
        self.physicsBody.dynamic = NO;
        universe = [Universe sharedInstance];
        self.physicsBody.categoryBitMask = universe.BLOCK_CATEGORY;
    }
    
    return self;
}


-(void)breakBlock{
    SKScene *gameScene = self.scene;
    
    SKEmitterNode *brokenBlock = [SKEmitterNode nodeWithFileNamed:@"BrokenBlock"];
    brokenBlock.position = self.position;
    brokenBlock.zPosition = 3;
    
    [gameScene addChild:brokenBlock];
    
    SKAction *wait = [SKAction waitForDuration:1.0];
    SKAction *remove = [SKAction removeFromParent];
    
    [brokenBlock runAction:[SKAction sequence:@[wait,remove]]];
    [self removeFromParent];
}

@end
