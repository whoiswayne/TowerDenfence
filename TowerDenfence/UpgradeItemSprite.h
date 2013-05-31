//
//  UpgradeItemSprite.h
//  TowerDenfence
//
//  Created by mir-macmini5 on 13-4-19.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

typedef enum{
    upgrade1_1_idx,//    addAttackPower,//增加攻击力
    upgrade2_1_idx,//    addAttackSpeed,//增加攻击速度
    upgrade2_2_idx,//    addGunshot,//增加射程
    upgrade3_1_idx,//    addAward,//增加奖励
    upgrade4_1_idx,//    decTowerPrice,//建造价格
}UpgradeItems;

@protocol UpgradeItemDelegate <NSObject>

- (void)onAddNumberLabel:(id)numberLabel;

@end

@interface UpgradeItemSprite : CCSprite
{
    UpgradeItems upgradeItem;
    int requiredGold;
    int curGrade;
    int maxGrade;
    
    id<UpgradeItemDelegate> delegate;
    CCLabelAtlas *numberLabel;
}

@property (nonatomic,assign) UpgradeItems upgradeItem;
@property (nonatomic,assign) int requiredGold;
@property (nonatomic,assign) int curGrade;
@property (nonatomic,assign) id<UpgradeItemDelegate> delegate;

+ (id)upgradeItem:(UpgradeItems)aItem curGrade:(int)aCurGrade maxGrade:(int)aMaxGrade towerIndex:(int) towerIndex canUpgrade:(BOOL)canUpgrade;
- (void)upgrade:(UpgradeItems)aItem grade:(int)aGrade towerIndex:(int) towerIndex;
- (int) maxGrade;

@end
