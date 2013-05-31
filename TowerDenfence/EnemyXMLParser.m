//
//  XMLParseManager.m
//  TowerDefense
//
//  Created by mir-macmini5 on 13-3-21.
//
//

#import "EnemyXMLParser.h"

#define DEST_PATH [NSHomeDirectory() stringByAppendingFormat:@"/Documents"]

@implementation EnemyXMLParser

@synthesize passDict;

- (id)init
{
    if((self = [super init])){
        appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)parseEnemyInfo:(NSString *)fileName
{    
    NSString *filePath = [DEST_PATH stringByAppendingFormat:@"/%@.xml",fileName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"xml"];
    }
    
    NSFileHandle *file = [NSFileHandle fileHandleForReadingAtPath:filePath];
    NSData *data = [file readDataToEndOfFile];
    [file closeFile];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    [parser parse];    
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{    
    if ([elementName isEqualToString:@"pass"]){
        passDict = [NSMutableDictionary dictionaryWithCapacity:2];
        curBoutArray = [NSMutableArray arrayWithCapacity:2];
    }else if ([elementName isEqualToString:@"bout"]) {
        curEnemyArray = [NSMutableArray arrayWithCapacity:2];
    }else if ([elementName isEqualToString:@"enemy"]) {
        curEneny = [[EnemyInfo alloc] init];
        
        curEneny.number = [[attributeDict objectForKey:@"number"] intValue];
        curEneny.curHp = [[attributeDict objectForKey:@"blood"] intValue];
        curEneny.maxHp = [[attributeDict objectForKey:@"blood"] intValue];
        curEneny.curSpeed = [[attributeDict objectForKey:@"speed"] intValue];
        curEneny.maxSpeed = [[attributeDict objectForKey:@"speed"] intValue];
        curEneny.award = [[attributeDict objectForKey:@"award"] intValue];
        curEneny.spawnTime = [[attributeDict objectForKey:@"spawnTime"] floatValue];
        
        [curEnemyArray addObject:curEneny];        
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    curElementValue = [NSString stringWithString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"initLife"]){
        [passDict setObject:curElementValue forKey:@"initLife"];
    }else if([elementName isEqualToString:@"initGold"]){
        [passDict setObject:curElementValue forKey:@"initGold"];
    }else if([elementName isEqualToString:@"bout"]){
        [curBoutArray addObject:curEnemyArray];
    }else if([elementName isEqualToString:@"pass"]){
        [passDict setObject:curBoutArray forKey:@"boutArray"];        
    }
}

@end
