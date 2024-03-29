//
//  LevelReader.m
//  Brick_Breaker
//
//  Created by Eric Scagnelli on 5/7/17.
//  Copyright © 2017 escagne1. All rights reserved.
//

#import "LevelReader.h"
#import "Block.h"
#import "Level.h"
#import "Universe.h"
#import "GameViewController.h"

#define STAR_WIDTH 38
#define STAR_HEIGHT 38
#define STAR_VALUE 500
#define BLOCK_VALUE 100

#define IPHONE_6S_MIN_X -187.5
#define IPHONE_6S_MAX_X 187.5
#define IPHONE_6S_MIN_Y -333.5
#define IPHONE_6S_MAX_Y 333.5

typedef struct{
    int x;
    int y;
    float width;
    float height;
} BlockCoord;

typedef struct{
    int x;
    int y;
} StarCoord;

@implementation LevelReader{
    NSMutableArray *blocks;
    NSMutableArray *stars;
    NSString *coordStr;
    bool readingCoord;
    bool readingBlocks;
    bool readingStars;
    NSMutableDictionary *coordDict;
}

@synthesize levels, numLevels;

-(void)startParsing{
    NSString *xmlPath = [[NSBundle mainBundle] pathForResource:@"LevelDataNew" ofType:@"xml"];
    NSData *xmlData = [NSData dataWithContentsOfFile:xmlPath];
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:xmlData];
    [xmlParser setDelegate:self];
    
    
    blocks = [[NSMutableArray alloc] init];
    stars = [[NSMutableArray alloc] init];
    coordStr = [[NSString alloc] init];
    levels = [[NSMutableArray alloc] init];
    numLevels = 0;
    
    readingCoord = NO;
    readingBlocks = NO;
    readingStars = NO;
    
    [xmlParser parse];
    
    //NSLog(@"Read in %lu levels", (unsigned long)[levels count]);
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI
                qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{
    if([elementName isEqualToString:@"block"] || [elementName isEqualToString:@"star"])
        coordDict = [[NSMutableDictionary alloc] init];
    
    if([elementName isEqualToString:@"x"] || [elementName isEqualToString:@"y"] || [elementName isEqualToString:@"width"] ||
        [elementName isEqualToString:@"height"] || [elementName isEqualToString:@"movement"])
        readingCoord = YES;
    else
        readingCoord = NO;
    
    if([elementName isEqualToString:@"blocks"])
        readingBlocks = YES;
    
    if([elementName isEqualToString:@"stars"])
        readingStars = YES;
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    if(readingCoord)
        coordStr = string;

    //NSLog(@"chars are %@", string);
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI
                                                                        qualifiedName:(NSString *)qName{
    if([elementName isEqualToString:@"level"]){
     //   NSLog(@"END OF LEVEL");
        [self createLevel]; //creates a level object and add it to levels array
        
        //clear blocks and stars arrays for next level
        blocks = [[NSMutableArray alloc] init];
        stars = [[NSMutableArray alloc] init];
        numLevels++; //We created one more level object
    }
    else if ([elementName isEqualToString:@"blocks"]){
        readingBlocks = NO;
    }
    else if ([elementName isEqualToString:@"stars"]){
        readingStars = NO;
    }
    else if ([elementName isEqualToString:@"block"] || [elementName isEqualToString:@"star"]){
        if(readingBlocks)
            [blocks addObject:coordDict];
        else if(readingStars)
            [stars addObject:coordDict];
    }
    else if ([elementName isEqualToString:@"x"] || [elementName isEqualToString:@"y"] ||
             [elementName isEqualToString:@"width"] || [elementName isEqualToString:@"height"] ||
             [elementName isEqualToString:@"movement"]){
        [coordDict setObject:coordStr forKey:elementName];
    }
    /*
    else if ([elementName isEqualToString:@"y"]){
        [coordDict setObject:coordStr forKey:elementName];
    }
    else if ([elementName isEqualToString:@"width"])
     */
}

-(void)createLevel{
    //NSLog(@"IN CREATE LEVEL");
    
    Level *level = [[Level alloc] init];
    float x = 0.0;
    float y = 0.0;
    float width = 0.0;
    float height = 0.0;
    Movement movement = NO_MOVEMENT;
    
    for(NSMutableDictionary *dict in blocks){
        for(id key in dict){
            if([key isEqualToString:@"x"])
                x = [[dict objectForKey:key] floatValue];
            else if([key isEqualToString:@"y"])
                y = [[dict objectForKey:key] floatValue];
            else if([key isEqualToString:@"width"])
                width = [[dict objectForKey:key] floatValue];
            else if([key isEqualToString:@"height"])
                height = [[dict objectForKey:key] floatValue];
            else if([key isEqualToString:@"movement"]){
                NSString *movementString = [dict objectForKey:key];
                if([movementString isEqualToString:@"SQUARE"])
                    movement = SQUARE;
                else if([movementString isEqualToString:@"LEFT_RIGHT"])
                    movement = LEFT_RIGHT;
                else if([movementString isEqualToString:@"UP_DOWN"])
                    movement = UP_DOWN;
            }
        }
        
        //Store 6s scaled coordinates in BlockCoord
        BlockCoord oldBlockCoord;
        oldBlockCoord.x = x;
        oldBlockCoord.y = y;
        oldBlockCoord.width = width;
        oldBlockCoord.height = height;
        
        //Get new coordinates/size scaled to the screen of the device
        BlockCoord newBlockCoord = [self convertCoordinates:oldBlockCoord];
        
        Block *block = [[Block alloc] initWithRect:CGRectMake(newBlockCoord.x, newBlockCoord.y,
                                newBlockCoord.width, newBlockCoord.height) color:[UIColor redColor] movement:movement];
        movement = NO_MOVEMENT;
        [level.blocks addObject:block];
    }
    
    for(NSMutableDictionary *dict in stars){
        for(id key in dict){
            if([key isEqualToString:@"x"]){
                x = [[dict objectForKey:key] floatValue];
            }
            else if([key isEqualToString:@"y"]){
                y = [[dict objectForKey:key] floatValue];
            }
        }
        
        StarCoord oldStarCoord;
        oldStarCoord.x = x;
        oldStarCoord.y = y;
        
        StarCoord newStarCoord = [self converCoordinates:oldStarCoord];
        
        Star *star = [[Star alloc] initWithImageNamed:@"star" intRect:CGRectMake(newStarCoord.x, newStarCoord.y, STAR_WIDTH, STAR_HEIGHT) withValue:STAR_VALUE];
        [level.stars addObject:star];
    }
    
    level.numStarsLeft = (int)[level.stars count];
    level.possibleScore = (int)[level.blocks count] * BLOCK_VALUE;
    [levels addObject:level];
}


-(BlockCoord)convertCoordinates:(BlockCoord) blockCoord{
    float screenWidth = [[UIScreen mainScreen] bounds].size.width;
    float screenHeight = [[UIScreen mainScreen] bounds].size.height;
    
    float maxX = screenWidth / 2;
    float maxY = screenHeight / 2;
    
    float xRatio = blockCoord.x / IPHONE_6S_MAX_X;
    float yRatio = blockCoord.y / IPHONE_6S_MAX_Y;
    float widthRatio = blockCoord.width / (IPHONE_6S_MAX_X * 2);
    float heightRatio = blockCoord.height / (IPHONE_6S_MAX_Y * 2);

    BlockCoord newBlockCoord;
    newBlockCoord.x = maxX * xRatio;
    newBlockCoord.y = maxY * yRatio;
    newBlockCoord.width = screenWidth * widthRatio;
    newBlockCoord.height = screenHeight * heightRatio;
    
    return newBlockCoord;
}

-(StarCoord)converCoordinates:(StarCoord) starCoord{
    float screenWidth = [[UIScreen mainScreen] bounds].size.width;
    float screenHeight = [[UIScreen mainScreen] bounds].size.height;

    float maxX = screenWidth / 2;
    float maxY = screenHeight / 2;
    
    float xRatio = starCoord.x / IPHONE_6S_MAX_X;
    float yRatio = starCoord.y / IPHONE_6S_MAX_Y;
    
    StarCoord newStarCoord;
    newStarCoord.x = maxX * xRatio;
    newStarCoord.y = maxY * yRatio;
    
    return newStarCoord;
}

@end
