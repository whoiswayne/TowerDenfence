//
//  UpgradeInfo.h
//  TowerDenfence
//
//  Created by mir-macmini5 on 13-4-22.
//
//

#import <Foundation/Foundation.h>

@interface UpgradeInfo : NSObject
{
    int towerNum;
    int upgrade1_1;
    int upgrade2_1;
    int upgrade2_2;
    int upgrade3_1;
    int upgrade4_1;
}

@property (nonatomic,assign) int towerNum;
@property (nonatomic,assign) int upgrade1_1;
@property (nonatomic,assign) int upgrade2_1;
@property (nonatomic,assign) int upgrade2_2;
@property (nonatomic,assign) int upgrade3_1;
@property (nonatomic,assign) int upgrade4_1;

@end
