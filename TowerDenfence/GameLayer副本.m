//
//  GameLayer.m
//  TowerDenfence
//
//  Created by mir-macmini5 on 13-4-16.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"

#define WINSCALE ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] == YES ? [[UIScreen mainScreen] scale] : 1.0f)

#define PIXS_GRID 40

@interface GameLayer(Private)

- (void)loadMapInfo;
- (void)initLabelAtlas;
- (void)initTheGame;

- (void)initEnemyType;
- (void)initTowerType;
- (void)addSpriteFile;

- (void)loadWaves;

- (CGPoint)tilePosFormLocation:(CGPoint)aLocation;
- (CGPoint)positionFromTilePos:(CGPoint)tilePos;

- (CGPoint)formatPoint:(CGPoint)tempPoint;

//- (void)checkUpgradeWithTower:(TowerSprite *)towerSprite WithPoint:(CGPoint)tempPoint;
//- (Boolean)isSameWithTower:(TowerInfo *)towerInfo withTiledPoint:(CGPoint)tiledPoint;

- (CGPoint)getBarrierTargetPos:(int)barrierType withTouchPoint:(CGPoint)touchPoint;

- (void)createATower:(CGPoint)touchPoint withNum:(int)num withGrade:(int)grade;

- (void)showTowerModel:(CGPoint)tempPoint;
- (CGPoint)getStartPoint:(CGPoint)tempPoint;
- (void)closeTowerModel;

- (void)showNoCreateAnimation:(CGPoint)pos;

- (void)startPlay;
- (void)showStartCreateInfo;

@end

@implementation GameLayer

NSMutableArray *curWaveEnemy;
int curEnemy;//某一波的第几个怪

+ (id)scene
{
    CCScene *scene = [CCScene node];
    
    CCLayer *gameLayer = [GameLayer node];
    
    [scene addChild:gameLayer];
    
    return scene;
}

- (id)init
{
    if((self = [super init])){
        
        [self initTheGame];
        //加载本关卡地图信息
        [self loadMapInfo];
        //初始化显示数字的label
        [self initLabelAtlas];
        //添加纹理图
        [self addSpriteFile];
        
        self.isTouchEnabled = YES;
        //加载本关卡出关信息
        [self loadWaves];
        
    }
    return self;
}

- (void)loadWaves
{   
    enemysArray = [[NSMutableArray arrayWithCapacity:2] retain];
    towersArray = [[NSMutableArray arrayWithCapacity:2] retain];
    towerModelArray = [[NSMutableArray arrayWithCapacity:1] retain];
    
    curWaveEnemy = [boutArray objectAtIndex:curWave];
    EnemyInfo *enemyInfo = [curWaveEnemy objectAtIndex:curEnemy];
    
    [self schedule:@selector(handleTankAppear:) interval:enemyInfo.spawnTime];
    
}

- (void)handleTankAppear:(ccTime)delta
{
    if(curWaveEnemy && curWaveEnemy.count > 0){
        EnemyInfo *enemyInfo = [curWaveEnemy objectAtIndex:curEnemy];
        EnemySprite *enemy = [EnemySprite enemyWithEnemyInfo:enemyInfo withWayPoints:wayPointsArray];
        [enemy setDelegate:self];
        [enemysArray addObject:enemy];
        [spritesEnemySheet addChild:enemy];
        
        curEnemy++;
        if(curEnemy < curWaveEnemy.count){
            //出本波怪的下一个
            EnemyInfo *enemyInfo = [curWaveEnemy objectAtIndex:curEnemy];
            [self schedule:@selector(handleTankAppear:) interval:enemyInfo.spawnTime];
        }else{
            //本波怪已全部出完，出下一波
            curWave++;
            curEnemy = 0;
            
            //            [curWaveEnemy removeAllObjects];
            curWaveEnemy = nil;
        }
    }else{
        if(enemysArray.count == 0){
            if(curWave < boutArray.count){
                [waveLabel setString:[NSString stringWithFormat:@"%d/%d",curWave+1,boutArray.count]];
                curWaveEnemy = [boutArray objectAtIndex:curWave];
                
                EnemyInfo *enemyInfo = [curWaveEnemy objectAtIndex:curEnemy];
                [self schedule:@selector(handleTankAppear:) interval:enemyInfo.spawnTime];
            }else{
                curWave = 0;
                curEnemy = 0;
                
                if (curWaveEnemy) {
                    [curWaveEnemy removeAllObjects];
                    curWaveEnemy = nil;
                }
                
                [self unschedule:@selector(handleTankAppear:)];
            }
        }
    }
}

- (void)initTheGame
{
    //解析enemy配置文件
    EnemyXMLParser *enemyParser = [[EnemyXMLParser alloc] init];
    [enemyParser parseEnemyInfo:@"pass_01"];
    
    curLife = [[enemyParser.passDict objectForKey:@"initLife"] intValue];
    curGold = [[enemyParser.passDict objectForKey:@"initGold"] intValue];
    boutArray = [[enemyParser.passDict objectForKey:@"boutArray"] retain];
    
//    //解析tower的配置文件
//    TowerInfoXMLParser *towerParser = [[TowerInfoXMLParser alloc] init];
//    [towerParser parseTowerInfo:@"tower_01"];
//    towerTypeDict = towerParser.towerDict;
}

//加载地图信息
- (void)loadMapInfo
{
    tmxTiledMap = [CCTMXTiledMap tiledMapWithTMXFile:@"map_1.tmx"];
    [self addChild:tmxTiledMap z:-1];
    
    wayPointsArray = [[NSMutableArray arrayWithCapacity:2] retain];
    
    CCTMXObjectGroup *objGroup = [tmxTiledMap objectGroupNamed:@"layer_obj"];
    NSMutableArray *objArray = objGroup.objects;
    
    //点
    for (int i = 0; i < objArray.count; i++) {
        NSDictionary *gridDict = [objArray objectAtIndex:i];
        WayPointInfo *pointInfo = [WayPointInfo wayPointWithPos:ccp([[gridDict valueForKey:@"x"] intValue] / WINSCALE + PIXS_GRID / 2, [[gridDict valueForKey:@"y"] intValue] / WINSCALE + PIXS_GRID / 2)];
        
        [wayPointsArray addObject:pointInfo];
    }
    
    //指针
    for (int i = 0; i < wayPointsArray.count - 1; i++) {
        WayPointInfo *pointInfo = [wayPointsArray objectAtIndex:i];
        pointInfo.nextPoint = [wayPointsArray objectAtIndex:(i + 1)];
    }
}

- (void)initLabelAtlas
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    
    lifeLabel = [CCLabelAtlas labelWithString:@"" charMapFile:@"number_life.png" itemWidth:11 itemHeight:15 startCharMap:'0'];
    lifeLabel.anchorPoint = ccp(0.5f, 0.5f);
    WayPointInfo *pointInfo = [wayPointsArray objectAtIndex:(wayPointsArray.count-1)];
    lifeLabel.position = pointInfo.position;
    [self addChild:lifeLabel z:4];
    [lifeLabel setString:[NSString stringWithFormat:@"%d",curLife]];
    
    goldLabel = [CCLabelAtlas labelWithString:@"" charMapFile:@"number_gold.png" itemWidth:14 itemHeight:19 startCharMap:'/'];
    goldLabel.anchorPoint = ccp(0, 0.5f);
    goldLabel.position = ccp(PIXS_GRID * 1.5f, size.height - PIXS_GRID/2);
    [self addChild:goldLabel z:4];
    [goldLabel setString:[NSString stringWithFormat:@"%d",curGold]];
    
    waveLabel = [CCLabelAtlas labelWithString:@"" charMapFile:@"number_gold.png" itemWidth:14 itemHeight:19 startCharMap:'/'];
    waveLabel.anchorPoint = ccp(0, 0.5f);
    waveLabel.position = ccp(size.width * 0.5f - PIXS_GRID, size.height - PIXS_GRID/2);
    [self addChild:waveLabel z:4];
    [waveLabel setString:[NSString stringWithFormat:@"%d/%d",curWave+1,boutArray.count]];
    
    priceLabel = [CCLabelAtlas labelWithString:@"" charMapFile:@"number_price.png" itemWidth:10 itemHeight:11 startCharMap:'0'];
    priceLabel.anchorPoint = ccp(0.5f, 0.5f);
    [self addChild:priceLabel z:4];
}

- (void)addSpriteFile
{
    CCSpriteFrameCache *framCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    
    [framCache addSpriteFramesWithFile:@"td_enemy_sprites.plist"];
    [framCache addSpriteFramesWithFile:@"td_tower_sprites.plist"];
    [framCache addSpriteFramesWithFile:@"td_ctrl_sprites.plist"];
    
    spritesEnemySheet = [CCSpriteBatchNode batchNodeWithFile:@"td_enemy_sprites.png"];
    spritesTowerSheet = [CCSpriteBatchNode batchNodeWithFile:@"td_tower_sprites.png"];
    spritesCtrlSheet = [CCSpriteBatchNode batchNodeWithFile:@"td_ctrl_sprites.png"];
    
    [self addChild:spritesEnemySheet z:1];
    [self addChild:spritesTowerSheet z:2];
    [self addChild:spritesCtrlSheet z:3];
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    CCSprite *ctrlSprite = [CCSprite spriteWithSpriteFrameName:@"interface_ctrl.png"];
    [spritesCtrlSheet addChild:ctrlSprite];
    ctrlSprite.position = ccp(size.width/2, size.height - PIXS_GRID / 2);
    
    CCSprite *pauseSprite = [CCSprite spriteWithSpriteFrameName:@"btn_continue.png"];
    [spritesCtrlSheet addChild:pauseSprite];
    pauseSprite.position = ccp(size.width - PIXS_GRID * 2.0f, size.height - 18);
}



- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [self convertTouchToNodeSpace:[touches anyObject]];
    CGPoint tiledPoint = [self tilePosFormLocation:touchPoint];
    
    if(rangeSprite){
        //攻击范围显示
        [rangeSprite removeFromParentAndCleanup:YES];
        rangeSprite = nil;
    }else if (towerModelArray.count > 0){
        //模板显示
        for (int i = 1; i < towerModelArray.count; i++) {
            TowerModelInfo *modelInfo = [towerModelArray objectAtIndex:i];
            if(CGRectContainsPoint(modelInfo.modelSprite.boundingBox, touchPoint)){
                CCSprite *aSprite = [towerModelArray objectAtIndex:0];
                [self createATower:aSprite.position withNum:modelInfo.towerNumber withGrade:1];
            }
        }
        
        [self closeTowerModel];
    }else{
        
        Boolean isCreateTower = YES;
        Boolean isShowNoCreate = NO;
        CCTMXLayer *eventLayer = nil;
        
        //从最下层开始，逐层判断
        for (int i = 1; i < 5; i++) {
            eventLayer = [tmxTiledMap layerNamed:[NSString stringWithFormat:@"layer_%d",i]];
            if(!eventLayer){
                break;
            }
            
            int tiledGid = [eventLayer tileGIDAt:tiledPoint];
            if(tiledGid == 0){
                continue;
            }
            
            NSDictionary *propertiesDict = [tmxTiledMap propertiesForGID:tiledGid];
            
            if([propertiesDict objectForKey:@"isWater"] || [propertiesDict objectForKey:@"isPath"]){
                //点击的是水面或路面，不能建塔
                isCreateTower = NO;
                isShowNoCreate = YES;
                break;
            }else if([propertiesDict objectForKey:@"isBarrier"]){
//                if(towersArray.count == 0){
//                    [self showNoCreateAnimation:[self formatPoint:touchPoint]];
//                }else{
//                    //可被打掉的障碍物，如果在已建塔的视野内，被攻击
//                    int barrierType = [[propertiesDict objectForKey:@"isBarrier"] intValue];
//                    CGPoint targetPoint = [self getBarrierTargetPos:barrierType withTouchPoint:touchPoint];
//                    
//                    for (int i = 0; i < towersArray.count; i++) {
//                        TowerSprite *towerSprite = [towersArray objectAtIndex:i];
//                        if(ccpDistance(towerSprite.towerSprite.position, targetPoint) < towerSprite.towerInfo.field){
//                            //设置塔的攻击目标
//                            if (CGPointEqualToPoint(towerSprite.targetPoint, CGPointZero)) {
//                                towerSprite.targetPoint = targetPoint;
//                            }else{
//                                if(CGPointEqualToPoint(towerSprite.targetPoint, targetPoint)){
//                                    //点击已在攻击的目标
//                                    towerSprite.targetPoint = CGPointZero;
//                                }else{
//                                    //点击不同的攻击目标
//                                    towerSprite.targetPoint = targetPoint;
//                                }
//                            }
//                        }
//                    }
//                    isShowNoCreate = NO;
//                }
//                isCreateTower = NO;
//                break;
//            }else if([propertiesDict objectForKey:@"isTower"] && ![@"isTower" isEqualToString:[propertiesDict objectForKey:@"isTower"]]){
//                //已经建塔
//                TowerSprite *towerSprite = [propertiesDict objectForKey:@"isTower"];
//                
//                if(towerSprite.towerInfo.number != 2){
//                    rangeSprite = [CCSprite spriteWithSpriteFrameName:@"range.png"];
//                    rangeSprite.position = towerSprite.towerSprite.position;
//                    rangeSprite.scale = towerSprite.towerInfo.field / (rangeSprite.contentSize.width / 2);
//                    [spritesCtrlSheet addChild:rangeSprite];
//                }
//                
//                isCreateTower = NO;
//                isShowNoCreate = NO;
//                break;
            }
        }
        
        if(isCreateTower){
            //能建塔，显示模板
            [self showTowerModel:[self formatPoint:touchPoint]];
        }else{
            //不能建塔，相应提示
            if(isShowNoCreate){
                [self showNoCreateAnimation:[self formatPoint:touchPoint]];
            }
        }
    }
}


//地图上的坐标转换成瓷砖的坐标
- (CGPoint)tilePosFormLocation:(CGPoint)aLocation
{
    // 触摸的屏幕坐标必须减去瓷砖地图的坐标一瓷砖地图位置已经不在（0，0）点上了
    CGPoint pos = ccpSub(aLocation, tmxTiledMap.position);
    
    // 将得到坐标值转换成整数
    pos.x = (int)(pos.x / (tmxTiledMap.tileSize.width / WINSCALE));
    
    pos.y = (int)((tmxTiledMap.mapSize.height * tmxTiledMap.tileSize.height / WINSCALE - pos.y) / (tmxTiledMap.tileSize.height / WINSCALE));
    
    CCLOG(@"touch at (%.0f, %.0f) is at tileCoord (%i, %i)", aLocation.x, aLocation.y,
          (int)pos.x, (int)pos.y);
    
    NSAssert(pos.x >= 0 && pos.y >= 0 && pos.x < tmxTiledMap.mapSize.width && pos.y < tmxTiledMap.mapSize.height,
             @"%@: coordinates (%i, %i) out of bounds!", NSStringFromSelector(_cmd), (int)pos.x, (int)pos.y);
    
    return pos;
}

//瓷砖的坐标转换成地图坐标
- (CGPoint)positionFromTilePos:(CGPoint)tilePos
{
    float tempX = tmxTiledMap.tileSize.width / WINSCALE * (tilePos.x + 0.5);
    float tempY = tmxTiledMap.tileSize.height / WINSCALE * (tmxTiledMap.mapSize.height - (tilePos.y + 0.5));
    
    return ccpAdd(tmxTiledMap.position, ccp(tempX, tempY));
}

//将点格式化
- (CGPoint)formatPoint:(CGPoint)tempPoint
{
    int tempX = tempPoint.x / PIXS_GRID;
    int tempY = tempPoint.y / PIXS_GRID;
    
    return ccp(tempX * PIXS_GRID + PIXS_GRID / 2, tempY * PIXS_GRID + PIXS_GRID / 2);
}


//enemydelegate
- (void)onLoadEnemy:(id)sender
{
    EnemySprite *enemy = sender;
//    [spritesEnemySheet addChild:enemy.enemySprite];
    [spritesEnemySheet addChild:enemy.bloodFrame];
    [self addChild:enemy.bloodProgress z:4];
    
    [enemysArray addObject:enemy];
}

- (void)onShiftEnemySprite:(id)sender
{
//    EnemySprite *enemy = sender;
//    [spritesEnemySheet addChild:enemy.enemySprite];
}

- (void)onRemoveEnemy:(id)sender
{
    [enemysArray removeObject:sender];
}

- (void)onAddEnemyBloodBg:(id)sender
{
    [spritesEnemySheet addChild:sender z:10];
}

- (void)onAddEnemyBlood:(id)sender
{
    
}

@end
