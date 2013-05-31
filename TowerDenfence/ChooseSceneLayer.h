//
//  ChooseSceneLayer.h
//  TowerDenfence
//
//  Created by seven on 13-5-8.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ChooseSceneLayer : CCLayer {
    int currScene; //当前场景index
    CGSize screenSize;
    
    CCSprite *bgSprite;// 背景图片
    CCSprite *back;
    CCSprite *option;
    CCSprite *help;
    CCSprite *select_mission;
    
    CCSprite *grassLandFocus; //草地选中
    CCSprite *desertLocked; // 沙漠锁定
    CCSprite *desertFocus;  //沙漠选中
    CCSprite *volcanoLocked;
    CCSprite *volcanoFocus;
    CCSprite *icelandLocked;
    CCSprite *icelandFocus;
    
}

+ (id)scene: (int) landIndex;
@end
