//
//  FileUtils.h
//  TowerDenfence
//
//  Created by mir-macmini5 on 13-4-22.
//
//

#import <Foundation/Foundation.h>
#import "UpgradeInfo.h"

@interface FileUtils : NSObject

+ (NSMutableDictionary *)readUpgradeInfo;
+ (void)writeUpgradeInfo:(NSArray *)infoArray;

@end
