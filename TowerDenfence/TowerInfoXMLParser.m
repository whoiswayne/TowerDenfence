//
//  ParseXMLTowerInfo.m
//  TowerDefence
//
//  Created by mir-macmini5 on 13-4-12.
//
//

#import "TowerInfoXMLParser.h"

#define DEST_PATH [NSHomeDirectory() stringByAppendingFormat:@"/Documents"]

@implementation TowerInfoXMLParser

@synthesize towerDict;

- (id)init
{
    if((self = [super init])){
        appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)dealloc
{
    if(towerDict){
        [towerDict release];
        towerDict = nil;
    }
    
    [super dealloc];
}

- (void)parseTowerInfo:(NSString *)fileName
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
    if ([elementName isEqualToString:@"towers"]){
        towerDict = [[NSMutableDictionary dictionaryWithCapacity:2] retain];
    }else if ([elementName isEqualToString:@"tower"]) {
        TowerInfo *curTower = [[TowerInfo alloc] init];
        
        //number="3" grade="1" attackPower="0" attackSpeed="1" field="192" gunshot="192" price="120" critRate="0" slowRate="25" slowTime="2" multiAttack="1" isFiring="NO" isAttactUnslowedEnemy="NO" pierceEnemyNumber="0" isExplosion="NO"
        
        curTower.number = [[attributeDict objectForKey:@"number"] intValue];
        curTower.grade = [[attributeDict objectForKey:@"grade"] intValue];
        curTower.attackPower = [[attributeDict objectForKey:@"attackPower"] intValue];
        curTower.attackSpeed = [[attributeDict objectForKey:@"attackSpeed"] floatValue];
        curTower.field = [[attributeDict objectForKey:@"field"] intValue];
        curTower.gunshot = [[attributeDict objectForKey:@"gunshot"] intValue];
        curTower.price = [[attributeDict objectForKey:@"price"] intValue];
        
        curTower.critRate = [[attributeDict objectForKey:@"critRate"] floatValue];
        curTower.slowRate = [[attributeDict objectForKey:@"slowRate"] floatValue];
        curTower.slowTime = [[attributeDict objectForKey:@"slowTime"] floatValue];
        curTower.multiAttack = [[attributeDict objectForKey:@"multiAttack"] intValue];
        
        curTower.isFiring = [[attributeDict objectForKey:@"isFiring"] boolValue];
        curTower.isAttactUnslowedEnemy = [[attributeDict objectForKey:@"isAttactUnslowedEnemy"] boolValue];
        curTower.pierceEnemyNumber = [[attributeDict objectForKey:@"pierceEnemyNumber"] intValue];
        curTower.isExplosion = [[attributeDict objectForKey:@"isExplosion"] boolValue];
        
        [towerDict setObject:curTower forKey:[NSString stringWithFormat:@"%d_%d",curTower.number,curTower.grade]];
    }
}

@end
