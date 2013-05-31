//
//  TowerUpgradeLayer.h
//  TowerDenfence
//
//  Created by mir-macmini5 on 13-4-19.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ChoosePassLayer.h"
#import "UpgradeItemSprite.h"
#import "UpAndDownSlideView.h"
#import "UpgradeInfo.h"
#import "FileUtils.h"

@interface TowerUpgradeLayer : CCLayer<UpgradeItemDelegate,SlideViewDelegate>
{
//    CCSpriteBatchNode *spritesUpgradeSheet;
    
    UpAndDownSlideView *scrollView;//上下滑动的View
    
    UpgradeItemSprite *itemSprite1; // 技能图标 按位置排序
    UpgradeItemSprite *itemSprite2; 
    UpgradeItemSprite *itemSprite3;    
    UpgradeItemSprite *itemSprite4;
    UpgradeItemSprite *itemSprite5;
    UpgradeItemSprite *curFoucsUpgradeItem;

    CCSprite *upgradeSkillTreeLine1; // 技能图标连接线
    CCSprite *upgradeSkillTreeLine2;
    CCSprite *upgradeSkillTreeLine3;
    
    CCSprite *back;
    CCSprite *buyNow; // 现在购买sprite
    CCSprite *forFree; // 免费获取sprite
    CCSprite *upgradeBtn;
    CCSprite *skillExplain;// 技能提示
    CCSprite *skillFocusFrame; // 技能选中框
    
    
//    CCLabelTTF *promptLabel;//显示提示信息的label
    CCLabelAtlas *curGoldLabel;//显示当前玩家的金币数
    CCLabelAtlas *upgradeGoldLabel;//显示升级需要的金币数
    
    int curFoucsPos;
    
    NSMutableDictionary *upgradeInfoDict;
    UpgradeInfo *curUpgradeInfo;
    CCLabelAtlas *numberLabel;
    
    int curPass;
//    int curTowerIndex;
}

+ (id)scene:(int)aPass;

@end
