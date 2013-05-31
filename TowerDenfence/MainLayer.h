//
//  MainLayer.h
//  TowerDenfence
//
//  Created by seven on 13-5-14.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "ChooseSceneLayer.h"

@interface MainLayer : CCLayer {
    BOOL isChinese; // 是则中文, 不是则英文
    
    CGSize screenSize; // 屏幕尺寸
    
    CCSprite *mainBg; // 背景
    CCSprite *mainLogo; // logo
    CCSprite *mainRankingList; // 排行榜
    CCSprite *mainStart; // 开始按钮
    CCSprite *mainSetting; // setting
    CCSprite *mainHelp; // help
    
    
}

+ (id) scene;

@end
