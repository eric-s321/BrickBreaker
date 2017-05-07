//
//  LevelReader.m
//  Brick_Breaker
//
//  Created by Eric Scagnelli on 5/7/17.
//  Copyright © 2017 escagne1. All rights reserved.
//

#import "LevelReader.h"

@implementation LevelReader


-(void)startParsing{
    NSString *xmlPath = [[NSBundle mainBundle] pathForResource:@"LevelData" ofType:@"xml"];
    NSData *xmlData = [NSData dataWithContentsOfFile:xmlPath];
    NSXMLParser *xmlParser = [[NSXMLParser alloc] initWithData:xmlData];
    [xmlParser setDelegate:self];
    [xmlParser parse];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI
                qualifiedName:(NSString *)qName attributes:(NSDictionary<NSString *,NSString *> *)attributeDict{

}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{

}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI
                                                                        qualifiedName:(NSString *)qName{
    

}

@end
