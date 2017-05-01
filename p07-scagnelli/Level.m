//
//  Level.m
//  p07-scagnelli
//
//  Created by Eric Scagnelli on 4/27/17.
//  Copyright © 2017 escagne1. All rights reserved.
//

#import "Level.h"
#import "Block.h"
#import "Universe.h"

#define BLOCK_VALUE 100

@implementation Level
@synthesize levelBegan, stars, blocks, starsCopy;

+(Level *)level1{
    Level *level1 = [[Level alloc] init];
    [level1 createBlocks];
    level1.numStarsLeft = (int)[level1.stars count];
    level1.possibleScore = (int)[level1.blocks count] * BLOCK_VALUE;
    
    return level1;
}

+(Level *)level2{
    return NULL;

}

-(id)init{
    self = [super init];
    if(self){
        levelBegan = NO;
        blocks = [[NSMutableArray alloc] init];
        stars = [[NSMutableArray alloc] init];
        starsCopy = [[NSMutableArray alloc] init];
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
                                                 color:[UIColor redColor]];
            lefty += 100;
            [blocks addObject:block];
        }
        else{
            Block *block = [[Block alloc] initWithRect:CGRectMake(rightx, righty, BLOCK_WIDTH, BLOCK_HEIGHT)
                                                 color:[UIColor redColor]];
            righty += 100;
            [blocks addObject:block];
        }
    }
    
    Star *star = [[Star alloc] initWithImageNamed:@"star" intRect:CGRectMake(0, 350, 75, 75) withValue:500];
    Star *star1 = [[Star alloc] initWithImageNamed:@"star" intRect:CGRectMake(100, -350, 75, 75) withValue:500];
    
    [stars addObject:star];
    [stars addObject:star1];
    
}

@end
