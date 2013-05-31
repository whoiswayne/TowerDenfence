//
//  ParseXMLTowerInfo.h
//  TowerDefence
//
//  Created by mir-macmini5 on 13-4-12.
//
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "TowerInfo.h"

@interface TowerInfoXMLParser : NSObject <NSXMLParserDelegate>
{
    NSString *curElementValue;
    AppDelegate *appDelegate;
    
    NSMutableDictionary *towerDict;
}

@property (nonatomic,retain) NSMutableDictionary *towerDict;

- (void)parseTowerInfo:(NSString *)fileName;

@end
