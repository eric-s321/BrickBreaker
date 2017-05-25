//
//  Block.m
//  p07-scagnelli
//
//  Created by Eric Scagnelli on 4/24/17.
//  Copyright © 2017 escagne1. All rights reserved.
//

#import "Block.h"
#import "Universe.h"

@implementation Block

-(id)initWithRect:(CGRect)rect color:(UIColor *)color movement:(Movement)movement{
    self = [super init];
    
    if(self){
        self.color = color;
        self.position = rect.origin;
        self.size = rect.size;
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
        self.physicsBody.dynamic = NO;
        universe = [Universe sharedInstance];
        self.physicsBody.categoryBitMask = universe.BLOCK_CATEGORY;
        self.movement = movement;
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
    
    
    SKLabelNode *pointsLabel = [[SKLabelNode alloc] initWithFontNamed:@"Lunchtime Doubly So"];
    pointsLabel.fontSize = 15;
    pointsLabel.text = [NSString stringWithFormat:@"-%d", 100];
    pointsLabel.position = CGPointMake(self.position.x, self.position.y + self.size.height/2);
    
    [gameScene addChild:pointsLabel];
    
    [brokenBlock runAction:[SKAction sequence:@[wait,remove]]];
    [self removeFromParent];
    [pointsLabel runAction:[SKAction sequence:@[[SKAction fadeOutWithDuration:1],remove]]];
}

-(void)move{
    if (self.movement == SQUARE){
        float squareSide = self.scene.size.width / 6;
        float time = 2.0;
        SKAction *halfLeft = [SKAction moveByX:-(squareSide/2) y:0 duration:time/2];
        SKAction *down = [SKAction moveByX:0 y:-squareSide duration:time];
        SKAction *right = [SKAction moveByX:squareSide y:0 duration:time];
        SKAction *up = [SKAction moveByX:0 y:squareSide duration:time];
        SKAction *square = [SKAction sequence:@[halfLeft,down,right,up, halfLeft]];
        
        [self runAction:[SKAction repeatActionForever:square]];
    }
}

@end
