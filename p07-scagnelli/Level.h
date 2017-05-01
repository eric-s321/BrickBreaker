//
//  Level.h
//  p07-scagnelli
//
//  Created by Eric Scagnelli on 4/27/17.
//  Copyright © 2017 escagne1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Star.h"

@class Universe;

@interface Level : NSObject{
    Universe *universe;
}

@property (strong, nonatomic) NSMutableArray *blocks;
@property (strong, nonatomic) NSMutableArray *stars;
@property (strong, nonatomic) NSMutableArray *starsCopy;
@property (nonatomic) BOOL levelBegan;
@property (nonatomic) int numStarsLeft;
@property (nonatomic) int possibleScore;

+(Level *)level1;
+(Level *)level2;

-(void)createBlocks;

@end
