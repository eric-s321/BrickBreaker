//
//  Level.m
//  p07-scagnelli
//
//  Created by Eric Scagnelli on 4/27/17.
//  Copyright © 2017 escagne1. All rights reserved.
//

#import "Level.h"
#import "Block.h"

@implementation Level


-(id)init{
    self = [super init];
    if(self){
        _levelBegan = NO;
        _blocks = [[NSMutableArray alloc] init];
        universe = [Universe sharedInstance];
    }
    return self;
}

-(void)createBlocks{
    
    int BLOCK_WIDTH = 150;
    int BLOCK_HEIGHT = 30;
    float leftx = ((375 / 4.0) * -1) - BLOCK_WIDTH / 2;
    float lefty = 100.0;
    float rightx = (375 / 4.0) + BLOCK_WIDTH / 2;
    float righty = 100.0;
    
    for (int i = 0; i < 8; i++){
        if (i < 4){
            Block *block = [[Block alloc] initWithRect:CGRectMake(leftx, lefty, BLOCK_WIDTH, BLOCK_HEIGHT)
                                                 color:[UIColor blueColor]];
            block.physicsBody.categoryBitMask = universe.BLOCK_CATEGORY;
            
            lefty += 100;
            [_blocks addObject:block];
        }
        else{
            Block *block = [[Block alloc] initWithRect:CGRectMake(rightx, righty, BLOCK_WIDTH, BLOCK_HEIGHT)
                                                 color:[UIColor blueColor]];
            block.physicsBody.categoryBitMask = universe.BLOCK_CATEGORY;
            
            righty += 100;
            [_blocks addObject:block];
        }
    }
}


@end
