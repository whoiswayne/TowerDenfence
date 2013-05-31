//
//  HelloWorldLayer.h
//  TestGameChoose
//
//  Created by mir on 13-4-16.
//  Copyright __MyCompanyName__ 2013年. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "AppDelegate.h"
#import "LeftAndRightSlideView.h"
#import "TowerUpgradeLayer.h"
#import "GameLayer.h"

@interface ChoosePassLayer : CCLayer<PlayBtnDelegate, ScrollViewDelegate>
{
    CGSize screenSize;
    
    CCSprite *bg;
    CCSprite *back;
    CCSprite *option;
    CCSprite *help;
    CCSprite *select_mission;
    CCSprite *mission_label;
    CCLabelAtlas *mission_number;
    CCSprite *lv_up;
    CCSprite *wind;
    CCSprite *cover_wind;
    CCSprite *rank1;
    CCSprite *rank2;
    CCSprite *rank3;
//    CCSprite *reward1;
//    CCSprite *reward2;
//    CCSprite *reward3;
    
    LeftAndRightSlideView *scrollView;
    
    int curRank;//a、b、c
    int curLand;
}

+(CCScene *) scene:(int)aPass;

@end
