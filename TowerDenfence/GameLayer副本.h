//
//  GameLayer.h
//  TowerDenfence
//
//  Created by mir-macmini5 on 13-4-16.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
//#import "Bullet.h"
//#import "Tower.h"
#import "EnemySprite.h"
#import "EnemyXMLParser.h"
//#import "TowerInfoXMLParser.h"

#import "TowerModelInfo.h"

@interface GameLayer : CCLayer<EnemyDelegate>
{
    CCTMXTiledMap *tmxTiledMap;
    
    CCSprite *rangeSprite;
    
    CCSpriteBatchNode *spritesEnemySheet;
    CCSpriteBatchNode *spritesTowerSheet;
    CCSpriteBatchNode *spritesCtrlSheet;
    
    NSMutableArray *wayPointsArray;
    NSMutableDictionary *towerTypeDict;
    
    NSMutableArray *enemysArray;//现有的enemy
    NSMutableArray *towersArray;//现有的tower
    NSMutableArray *bulletArray;//现有的bullet
    
    NSMutableArray *towerModelArray;
    
    CCLabelAtlas *lifeLabel;
    int curLife;
    
    CCLabelAtlas *goldLabel;
    int curGold;
    
    CCLabelAtlas *waveLabel;
    int curWave;
    
    CCLabelAtlas *priceLabel;
    
    NSMutableArray *boutArray;//每波怪的数组，每个元素都是enemy的数组
}

//@property (nonatomic,retain) CCTMXTiledMap *tmxTiledMap;
//@property (nonatomic,retain) CCSpriteBatchNode *spritesEnemySheet;
//@property (nonatomic,retain) CCSpriteBatchNode *spritesTowerSheet;
//@property (nonatomic,retain) CCSpriteBatchNode *spritesCtrlSheet;
//@property (nonatomic,readonly) NSMutableArray *wayPointsArray;
//@property (nonatomic,readonly) NSMutableDictionary *towerTypeDict;
//@property (nonatomic,retain) NSMutableArray *enemysArray;
//@property (nonatomic,retain) NSMutableArray *towersArray;
//
//@property (nonatomic,retain) CCLabelAtlas *lifeLabel;
//@property (nonatomic,retain) CCLabelAtlas *goldLabel;
//@property (nonatomic,assign) int curLife;
//@property (nonatomic,assign) int curGold;
//
//@property (nonatomic,assign) Boolean isPause;

+ (id)scene;


@end
