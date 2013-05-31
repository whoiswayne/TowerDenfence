//
//  FileUtils.m
//  TowerDenfence
//
//  Created by mir-macmini5 on 13-4-22.
//
//

#import "FileUtils.h"

#define UPGRADEINO_FILENAME @"upgradeInfo.txt"

#define DEST_PATH [NSHomeDirectory() stringByAppendingFormat:@"/Documents"]


@implementation FileUtils


//读取升级信息
+ (NSMutableDictionary *)readUpgradeInfo
{
    NSMutableDictionary *infoDict = [NSMutableDictionary dictionaryWithCapacity:2];
    
    NSString *filePath = [DEST_PATH stringByAppendingFormat:@"/%@",UPGRADEINO_FILENAME];
    NSString *infoStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    NSLog(@"%@ ************* %@", filePath, infoStr);
    
    if(!infoStr){
        //第一次运行程序，升级数据都为0
        for (int i = 1; i <= 4; i ++) {
            NSString *indexString = [NSString stringWithFormat:@"%d", i];
            if (![infoDict objectForKey:indexString]) {
                UpgradeInfo *tempUpgradeInfo = [[UpgradeInfo alloc] init];
                tempUpgradeInfo.towerNum = i;
                tempUpgradeInfo.upgrade1_1 = 0;
                tempUpgradeInfo.upgrade2_1 = 0;
                tempUpgradeInfo.upgrade2_2 = 0;
                tempUpgradeInfo.upgrade3_1 = 0;
                tempUpgradeInfo.upgrade4_1 = 0;
                [infoDict setValue:tempUpgradeInfo forKey:indexString];
                [tempUpgradeInfo release];
            }
        }
        return infoDict;
    }
    
    NSArray *upgradeStrArrray = [infoStr componentsSeparatedByString:@"|"];
    for (int i = 0; i < upgradeStrArrray.count; i++) {
        NSString *itemStr = [upgradeStrArrray objectAtIndex:i];
        NSArray *itemInfoArray = [itemStr componentsSeparatedByString:@" "];
        
        UpgradeInfo *upgradeInfo = [[[UpgradeInfo alloc] init] autorelease];
        
        upgradeInfo.towerNum = [[itemInfoArray objectAtIndex:0] intValue];
        upgradeInfo.upgrade1_1 = [[itemInfoArray objectAtIndex:1] intValue];
        upgradeInfo.upgrade2_1 = [[itemInfoArray objectAtIndex:2] intValue];
        upgradeInfo.upgrade2_2 = [[itemInfoArray objectAtIndex:3] intValue];
        upgradeInfo.upgrade3_1 = [[itemInfoArray objectAtIndex:4] intValue];
        upgradeInfo.upgrade4_1 = [[itemInfoArray objectAtIndex:5] intValue];
        
        [infoDict setValue:upgradeInfo forKey:[NSString stringWithFormat:@"%d",upgradeInfo.towerNum]];
    }
    
    
    
    return infoDict;
}

//将当前的升级树信息保存到文件
+ (void)writeUpgradeInfo:(NSArray *)infoArray
{
    NSMutableString *infoStr = [[NSMutableString alloc] init];
    
    for (int i = 0; i < infoArray.count; i++) {
        UpgradeInfo *upgradeInfo = [infoArray objectAtIndex:i];
        
        [infoStr appendFormat:@"%d %d %d %d %d %d", upgradeInfo.towerNum, upgradeInfo.upgrade1_1, upgradeInfo.upgrade2_1, upgradeInfo.upgrade2_2, upgradeInfo.upgrade3_1, upgradeInfo.upgrade4_1];
        
        if(i != infoArray.count - 1){
            [infoStr appendFormat:@"|"];
        }
    }
    
    NSString *filePath = [DEST_PATH stringByAppendingFormat:@"/%@",UPGRADEINO_FILENAME];    
    [infoStr writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];    
}

@end
