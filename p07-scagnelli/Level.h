//
//  Level.h
//  p07-scagnelli
//
//  Created by Eric Scagnelli on 4/27/17.
//  Copyright © 2017 escagne1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Universe.h"
#import "Star.h"


@interface Level : NSObject<StarDelegate>{
    Universe *universe;
}

@property (strong, nonatomic) NSMutableArray *blocks;
@property (strong, nonatomic) NSMutableArray *stars;
@property (nonatomic) BOOL levelBegan;

-(void)createBlocks;

@end
