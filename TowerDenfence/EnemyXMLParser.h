//
//  XMLParseManager.h
//  TowerDefense
//
//  Created by mir-macmini5 on 13-3-21.
//
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "EnemyInfo.h"

@interface EnemyXMLParser :  NSObject <NSXMLParserDelegate>
{
    NSString *curElementValue;
    AppDelegate *appDelegate;
    
    NSMutableDictionary *passDict;
    NSMutableArray *curBoutArray;
    NSMutableArray *curEnemyArray;
    EnemyInfo *curEneny;
}

@property (nonatomic,retain) NSMutableDictionary *passDict;

//+ (id)sharedXMLParseManager;

- (void)parseEnemyInfo:(NSString *)fileName;

@end
