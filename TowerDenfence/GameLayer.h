//
//  GameLayer.h
//  TowerDefence_new
//
//  Created by mir-macmini5 on 13-3-26.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "TowerSprite.h"
#import "BulletSprite.h"
#import "EnemySprite.h"
#import "WayPointInfo.h"
#import "TowerModelSprite.h"
#import "EnemyXMLParser.h"
#import "TowerInfoXMLParser.h"
#import "FileUtils.h"
#import "ChoosePassLayer.h"
#import "StoneInfo.h"
#import "GameOverSprite.h"

typedef enum {
    mapLayer,//地图层
    towerLayer,//炮塔
    enemyLayer,//敌人
    progressLayer,//血条
    bulletLayer,//子弹
    ctrlLayer,//控制界面
    labelLayer,//lebal
    gameoverLayer,//游戏结束界面
}GameSpriteLayer;

@interface GameLayer : CCLayer <TowerSpriteDelegate,TowerModelDelegate,BulletSpriteDelegate,EnemySpriteDelegate,StoneDelegate>
{
    CCTMXTiledMap *tmxTiledMap;
    
    CCSprite *rangeSprite;
    
    //topBarIcons
    CCSprite *goldIcon;
    CCSprite *diamondIcon;
    CCSprite *waveIcon;
    CCSprite *speedIcon;
    CCSprite *pauseIcon;
    CCSprite *settingIcon;
    
    CCSprite *heartHpSprite;// 血量(心)
    
    NSMutableArray *curWaveEnemy;
    int curEnemy;//某一波的第几个怪
    
    //倒计时时候
    NSMutableArray *createYesPointArray;
    NSMutableArray *createNoPointArray;
    
    NSMutableArray *createYesSpriteArray;
    NSMutableArray *createNoSpriteArray;
    
    CCSpriteBatchNode *spritesEnemySheet;
    CCSpriteBatchNode *spritesTowerSheet;
    CCSpriteBatchNode *spritesBulletSheet;
    CCSpriteBatchNode *spritesCtrlSheet;
    
    NSMutableArray *wayPointsArray;
    NSMutableDictionary *towerTypeDict;
    
    NSMutableArray *enemysArray;//现有的enemy
    NSMutableArray *towersArray;//现有的tower
    NSMutableArray *bulletArray;//现有的bullet
    NSMutableArray *stoneArray;//现有的stone
    
    NSMutableArray *towerModelArray;
    NSMutableArray *priceLabelArray;
    
    CCLabelAtlas *lifeLabel;
    int curLife;
    
    CCLabelAtlas *goldLabel;
    int curGold;
    
    CCLabelAtlas *diamondLabel;
    int curDiamond;
    
    CCLabelAtlas *waveLabel;
    int curWave;
    
    NSMutableArray *boutArray;//每波怪的数组，每个元素都是enemy的数组
    
    NSMutableDictionary *upgradeInfoDict;//升级树中的升级效果
    
    int curPass;//当前游戏是那一关
    int curRank;//当前关卡的难度
    int curLand; // 当前大陆
    
    BOOL isGameOver;// 是否游戏结束
    BOOL isGameWin; // 
    
    CCSprite *settingSprite; // 设置的Sprite
    CCSprite *restartGame; // 重新游戏
    CCSprite *selectMission; // 选择关卡
    
    CCSprite *soundSprite; //音效开关
    CCSprite *BGMSprite; // 背景音乐开关
    
    BOOL isGamePause; // 游戏是否暂停
    
    BOOL isSoundOpen; // 是否开启音效
    BOOL isBGMOpen; // 是否开启背景音乐
    
//    CCSprite *tempBombSprite;
    CGRect bombSpriteRect;
    BulletSprite *tempBulletSprite;
    NSMutableArray *bombArray;
    
    int firingDuration; // 燃烧持续时间
    BOOL isTeachMode; // 是否为教学模式
    CCSprite *teachFrame; // 教学框
    CCSprite *teachExplain; // 教学内容
    CCSprite *teachHand; // 教学手势
    
    int teachStep; // 教学步骤
    BOOL isTeachTowerModelShow; // 教学建塔是否显示
    
}

+ (id)scene:(int)curPage rank:(int)aRank land:(int)aLand isTeaching:(BOOL) isTeaching;

@end
