//
//  GameLayer.m
//  TowerDefence_new
//
//  Created by mir-macmini5 on 13-3-26.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"

#import "SimpleAudioEngine.h"

#define WINSCALE ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] == YES ? [[UIScreen mainScreen] scale] : 1.0f)
//#define WINSCALE ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] == YES && [[UIScreen mainScreen] scale] == 2.0f)

#define PIXS_GRID 40

@interface GameLayer(Private)

- (id)initWithPass:(int)aPass rank:(int)aRank land:(int)aLand isTeaching:(BOOL) isTeaching;

- (void)loadMapInfo;
- (void)initLabelAtlas;
- (void)initTheGame;
- (void)initTeachMode;
- (void)addSpriteFile;
- (void)initStoneArray:(NSDictionary *)propertiesDict tilePos:(CGPoint)tilePos;

- (void)loadWaves;

- (void)removeStoneFromMap:(StoneInfo *)stoneInfo;
- (CGPoint)tilePosFormLocation:(CGPoint)aLocation;
- (CGPoint)positionFromTilePos:(CGPoint)tilePos;
- (CGPoint)formatPoint:(CGPoint)tempPoint;

- (void)checkUpgradeWithTower:(TowerSprite *)towerSprite WithPoint:(CGPoint)tempPoint;
- (Boolean)isSameWithTower:(TowerInfo *)towerInfo withTiledPoint:(CGPoint)tiledPoint;

- (CGPoint)getBarrierTargetPos:(int)barrierType withTouchPoint:(CGPoint)touchPoint;
- (float)getRadiusByStoneType:(StoneType)aType;

- (void)createATower:(CGPoint)touchPoint withNum:(int)num withGrade:(int)grade;

- (void)showTowerModel:(CGPoint)tempPoint;
- (NSMutableArray *)getTowerModelArray;
- (CGPoint)getModelStartPoint:(CGPoint)tempPoint fromTowerArray:(NSArray *)towerArray;
- (void)closeTowerModel;

- (void)showNoCreateAnimation:(CGPoint)pos;

- (void)startCountDown;
- (void)showStartCreateInfo;

- (BOOL)detectEnemyCollsion:(BulletSprite *)bulletSprite number:(int)number;
- (void)detectStoneCollsion:(BulletSprite *)bulletSprite number:(int)number;

- (void)showBulletBombAnim:(int)number withPos:(CGPoint)pos withBullet:(BulletSprite *) bulletSprite;
//- (void)updateEnemyHp:(EnemySprite *)enemySprite withAttackPower:(int)attackPower;
- (void)updateEnemyHp:(EnemySprite *)enemySprite withBulletSprite:(BulletSprite*)aBulletSprite;
- (void)updateStoneHp:(BulletSprite *)bulletSprite stoneInfo:(StoneInfo *)stoneInfo;
- (void)checkEnemyDie;

- (void)showGlodDrapAnimation:(NSMutableArray *)paramArray;
- (void)showGetAwardAnimation:(NSMutableArray *)paramArray;

- (void)gameWin;
- (void)gameOver;
- (void) callFuncShowGameWin;
- (void) callFuncShowReceived;
- (void) showFailResult;

- (void) addAndSettingSprite;
- (void) bulletBomb:(CCSprite *)aSprite;

- (void) playDefaultBGM;
- (void) playLandBGM;
- (void) createExit;

- (void) lossHpAnimat;
- (void) startFiring:(EnemySprite *) aEnemySprite;

@end

@implementation GameLayer

/*
 * 命名规则：
 * pass_关卡_难度.xml:（难度a:1、难度b:2、难度c:3）
 * tower_关卡.xml
 * 地图：map_1.tmx、layer_1,layer_2,layer_3,layer_obj
 *
 */
+ (id)scene:(int)aPass rank:(int)aRank land:(int)aLand isTeaching:(BOOL) isTeaching
{
    CCScene *scene = [CCScene node];
    
    CCLayer *gameLayer = [[[GameLayer alloc] initWithPass:aPass rank:aRank land:aLand isTeaching:isTeaching] autorelease];
    
    [scene addChild:gameLayer];
    
    return scene;
}

- (id)initWithPass:(int)aPass rank:(int)aRank land:(int)aLand isTeaching:(BOOL) isTeaching
{
    if((self = [super init])){
        
        curPass = aPass;
        curRank = aRank;
        curLand = aLand;
        isGameOver = NO;
        isGameWin = NO;
        isGamePause = NO;
        isTeachMode = isTeaching;
        
        NSUserDefaults *saveDefaults = [NSUserDefaults standardUserDefaults];
        isBGMOpen = [[saveDefaults objectForKey:@"BGMSave"] boolValue];
        isSoundOpen = [[saveDefaults objectForKey:@"SoundSave"] boolValue];
        
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        
        if (!isTeaching) {
            [self initTheGame];
            //加载本关卡地图信息
            [self loadMapInfo];
            //添加纹理图
            [self addSpriteFile];
            // 创建出口
            [self createExit];
            //初始化显示数字的label
            [self initLabelAtlas];
            //开始倒数计时
            [self startCountDown];
        } else {
            //教学模式
            //加载本关卡地图信息
            [self loadMapInfo];
            //添加纹理图
            [self addSpriteFile];
            // 创建出口
            [self createExit];
            //初始化显示数字的label
            [self initLabelAtlas];
            
            [self initTeachMode];
        }
        
        
        
    }
    return self;
}

- (void)dealloc
{
    [self unscheduleAllSelectors];
    
//    if (tempBombSprite) {
//        [tempBombSprite release];
//        tempBombSprite = nil;
//    }
    
    if (tempBulletSprite) {
        [tempBulletSprite release];
        tempBulletSprite = nil;
    }
    
    if(enemysArray){
        [enemysArray removeAllObjects];
        [enemysArray release];
        enemysArray = nil;
    }
    
    if(towersArray){
        [towersArray removeAllObjects];
        [towersArray release];
        towersArray = nil;
    }
    
    if(bulletArray){
        [bulletArray removeAllObjects];
        [bulletArray release];
        bulletArray = nil;
    }
    
    if(stoneArray){
        [stoneArray removeAllObjects];
        [stoneArray release];
        stoneArray = nil;
    }
    
    if(boutArray){
        [boutArray removeAllObjects];
        [boutArray release];
        boutArray = nil;
    }
    
    if(towerModelArray){
        [towerModelArray removeAllObjects];
        [towerModelArray release];
        towerModelArray = nil;
    }
    
    if(priceLabelArray){
        [priceLabelArray removeAllObjects];
        [priceLabelArray release];
        priceLabelArray = nil;
    }
    
//    if (bombArray) {
//        [bombArray removeAllObjects];
//        [bombArray release];
//        bombArray = nil;
//    }
    
    [super dealloc];
}


//开始倒计时
- (void)startCountDown
{
    createYesPointArray = [[NSMutableArray arrayWithCapacity:2] retain];
    createNoPointArray = [[NSMutableArray arrayWithCapacity:2] retain];
        
    CGSize size = [[CCDirector sharedDirector] winSize];
    for (int k = 1; k < size.height / PIXS_GRID; k++) {
        for (int j = 0; j < size.width / PIXS_GRID; j++) {
            CGPoint tilePos = ccp(j, k);
            
            int tiledType = 1;//1、能建；2、不能建，3、路
            
            for (int i = 1; i < 5; i++) {
                CCTMXLayer *eventLayer = [tmxTiledMap layerNamed:[NSString stringWithFormat:@"layer_%d",i]];
                if(!eventLayer){
                    break;
                }
                
                int tiledGid = [eventLayer tileGIDAt:tilePos];
                if(tiledGid == 0){
                    continue;
                }
                
                NSDictionary *propertiesDict = [tmxTiledMap propertiesForGID:tiledGid];
                
                if([propertiesDict objectForKey:@"isWater"]){
                    tiledType = 2;
                }else if([propertiesDict objectForKey:@"isBarrier"]){
                    tiledType = 2;                    
                    [self initStoneArray:propertiesDict tilePos:tilePos];
                }else if([propertiesDict objectForKey:@"isPath"]){
                    tiledType = 3;
                }
            }
            
            if(tiledType == 1){
                //能建
                [createYesPointArray addObject:[NSValue valueWithCGPoint:[self positionFromTilePos:tilePos]]];
            }else if (tiledType == 2){
                //不能建
                [createNoPointArray addObject:[NSValue valueWithCGPoint:[self positionFromTilePos:tilePos]]];
            }else if (tiledType == 3){
                //路
                
            }
            
        }
    }
    
    [self showStartCreateInfo];
}

//倒计时过程，将地图上的石头转化成soneArray
- (void)initStoneArray:(NSDictionary *)propertiesDict tilePos:(CGPoint)tilePos
{
    if(!stoneArray){
        stoneArray = [[NSMutableArray arrayWithCapacity:2] retain];
    }
    
    int stoneType = [[propertiesDict objectForKey:@"isBarrier"] intValue];
    if(stoneType == 1 || stoneType == 21 || stoneType == 31 || stoneType == 41){
        StoneInfo *stoneInfo = [StoneInfo stoneInfo:stoneType withPosition:[self positionFromTilePos:tilePos]];
        stoneInfo.delegate = self;
        stoneInfo.stoneCurHp = [[propertiesDict objectForKey:@"HP"] intValue];
        stoneInfo.stoneMaxHp = [[propertiesDict objectForKey:@"HP"] intValue];
        stoneInfo.stoneAward = [[propertiesDict objectForKey:@"coins"] intValue];
        
        [stoneArray addObject:stoneInfo];
    }
}

//倒计时时，显示可以建造炮塔的区域
- (void)showStartCreateInfo
{
    createYesSpriteArray = [[NSMutableArray arrayWithCapacity:2] retain];
    createNoSpriteArray = [[NSMutableArray arrayWithCapacity:2] retain];
    
    for (int i = 0; i < createNoPointArray.count; i++) {
        CGPoint pos = [[createNoPointArray objectAtIndex:i] CGPointValue];
        CCSprite *aSprite = [CCSprite spriteWithSpriteFrameName:@"create_no.png"];
        aSprite.position = pos;
        [spritesCtrlSheet addChild:aSprite z:4];
        
        [createNoSpriteArray addObject:aSprite];
    }
    
    for (int i = 0; i < createYesPointArray.count; i++) {
        CGPoint pos = [[createYesPointArray objectAtIndex:i] CGPointValue];
        CCSprite *aSprite = [CCSprite spriteWithSpriteFrameName:@"create_yes.png"];
        aSprite.position = pos;
        [spritesCtrlSheet addChild:aSprite z:4];
        
        [createYesSpriteArray addObject:aSprite];
    }    
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    CCSprite *sprite = [CCSprite spriteWithSpriteFrameName:@"countdown_01.png"];
    sprite.position = ccp(size.width * 0.5f, size.height * 0.5f);
    [spritesCtrlSheet addChild:sprite];
    
    NSMutableArray *frameArray = [NSMutableArray arrayWithCapacity:2];
    for (int i = 1; i <= 18; i++) {
        CCSpriteFrame *frame = [frameCache spriteFrameByName:[NSString stringWithFormat:@"countdown_%02d.png",i]];
        [frameArray addObject:frame];
    }
    
    CCAnimate *animate = [CCAnimate actionWithAnimation:[CCAnimation animationWithFrames:frameArray delay:0.2f]];
    CCCallFuncO *callFunO = [CCCallFuncO actionWithTarget:self selector:@selector(countdownFinish:) object:sprite];
    [sprite runAction:[CCSequence actions:animate,callFunO, nil]];
}

//倒计时完成，开始游戏
- (void)countdownFinish:(CCSprite *)aSprite
{
    if(aSprite){
        [aSprite removeFromParentAndCleanup:YES];
        aSprite = nil;
    }
    
    for (int i = 0; i < createNoSpriteArray.count; i++) {
        CCSprite *aSprite = [createNoSpriteArray objectAtIndex:i];
        [aSprite removeFromParentAndCleanup:YES];
    }
    
    for (int i = 0; i < createYesSpriteArray.count; i++) {
        CCSprite *aSprite = [createYesSpriteArray objectAtIndex:i];
        [aSprite removeFromParentAndCleanup:YES];
    }
    
    [createNoPointArray removeAllObjects];
    [createNoPointArray release];
    createNoPointArray = nil;
    
    [createNoSpriteArray removeAllObjects];
    [createNoSpriteArray release];
    createNoSpriteArray = nil;
    
    [createYesPointArray removeAllObjects];
    [createYesPointArray release];
    createYesPointArray = nil;
    
    [createYesSpriteArray removeAllObjects];
    [createYesSpriteArray release];
    createYesSpriteArray = nil;
    
    self.isTouchEnabled = YES;
    //加载本关卡出关信息
    [self loadWaves];
    // 开始播放音乐
    [self playLandBGM];
}

//加载出怪的信息(时间、种类等)
- (void)loadWaves
{
    enemysArray = [[NSMutableArray arrayWithCapacity:2] retain];
    towersArray = [[NSMutableArray arrayWithCapacity:2] retain];
    towerModelArray = [[NSMutableArray arrayWithCapacity:1] retain];
    
    curWave = 0;
    curEnemy = 0;
    curWaveEnemy = [boutArray objectAtIndex:curWave];
    EnemyInfo *tankInfo = [curWaveEnemy objectAtIndex:curEnemy];
    
    [self schedule:@selector(handleEnemyAppear:) interval:tankInfo.spawnTime];
    
}

- (void)handleEnemyAppear:(ccTime)delta
{
    if(curWaveEnemy && curWaveEnemy.count > 0){
        EnemyInfo *tankInfo = [curWaveEnemy objectAtIndex:curEnemy];
        EnemySprite *enemySprite = [EnemySprite enemyWithEnemyInfo:tankInfo withWayPoints:wayPointsArray];
        enemySprite.enemyInfo.enemyId = curEnemy;
        enemySprite.delegate = self;
        [enemysArray addObject:enemySprite];
        [spritesEnemySheet addChild:enemySprite];
        
        curEnemy++;
        if(curEnemy < curWaveEnemy.count){
            //出本波怪的下一个
            EnemyInfo *tankInfo = [curWaveEnemy objectAtIndex:curEnemy];
            
            [self unschedule:@selector(handleEnemyAppear:)];
            
            [self schedule:@selector(handleEnemyAppear:) interval:tankInfo.spawnTime];
        }else{
            //本波怪已全部出完，出下一波
            curWave++;
            curEnemy = 0;
            
            curWaveEnemy = nil;
        }
    }else{
        if(enemysArray.count == 0){
            if(curWave < boutArray.count){
                [waveLabel setString:[NSString stringWithFormat:@"%d/%d",curWave+1,boutArray.count]];
                curWaveEnemy = [boutArray objectAtIndex:curWave];
                
                EnemyInfo *tankInfo = [curWaveEnemy objectAtIndex:curEnemy];
                
                [self unschedule:@selector(handleEnemyAppear:)];
                
                [self schedule:@selector(handleEnemyAppear:) interval:tankInfo.spawnTime];
            }else{
//                curWave = 0;
                curEnemy = 0;
                
                if (curWaveEnemy) {
                    [curWaveEnemy removeAllObjects];
                    curWaveEnemy = nil;
                }
                
                [self unschedule:@selector(handleEnemyAppear:)];
            }
        }
    }
}

- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [self convertTouchToNodeSpace:[touches anyObject]];
    CGPoint tiledPoint = [self tilePosFormLocation:touchPoint];
    
    if (isGameOver || isGamePause) {
        return;
    }
    
    if (isTeachMode) {
        // 跳过教学
        if (CGRectContainsPoint(CGRectMake(320, 65, 105, 55), touchPoint)) {
            [[CCDirector sharedDirector] replaceScene:[GameLayer scene:curPass rank:curRank land:curLand isTeaching:NO]];
            return;
        }
        
        if (towerModelArray.count > 0){
            for (int i = 1; i < towerModelArray.count; i++) {
                TowerModelSprite *modelSprite = [towerModelArray objectAtIndex:i];
                if(CGRectContainsPoint(modelSprite.boundingBox, touchPoint)){
                    if(curGold >= modelSprite.towerPrice){
                        CCSprite *aSprite = [towerModelArray objectAtIndex:0];//建造区域
                        [self createATower:aSprite.position withNum:modelSprite.towerNumber withGrade:1];
                        teachStep += 1;
//                    }else{
//                         isTeachTowerModelShow = NO;
                    }
                }
            }
            
//            if(!isTeachTowerModelShow){
            [self closeTowerModel];
            [teachHand stopAllActions];
            if (teachStep == 1) {
                teachHand.position = ccp(260, 70);
            } else if (teachStep == 2){
                teachHand.position = ccp(300, 70);
            }
            
            CCMoveBy *move1 = [CCMoveBy actionWithDuration:0.5f position:ccp(-15, 15)];
            CCMoveBy *move2 = [CCMoveBy actionWithDuration:0.5f position:ccp(15, -15)];
            CCSequence *seq = [CCSequence actions:move1, move2, nil];
            CCRepeatForever *repeat = [CCRepeatForever actionWithAction:seq];
            [teachHand runAction:repeat];
//            }
        } else {
            if (teachStep == 0) {
                if (tiledPoint.x == 4 && tiledPoint.y == 5) {
                    //能建塔，显示模板
                    [self showTowerModel:[self formatPoint:touchPoint]];
                    [teachExplain setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"teaching_explain_2.png"]];
                    
                    [teachHand stopAllActions];
                    teachHand.position = ccp(220, 20);
                    
                    CCMoveBy *move1 = [CCMoveBy actionWithDuration:0.5f position:ccp(-15, 15)];
                    CCMoveBy *move2 = [CCMoveBy actionWithDuration:0.5f position:ccp(15, -15)];
                    CCSequence *seq = [CCSequence actions:move1, move2, nil];
                    CCRepeatForever *repeat = [CCRepeatForever actionWithAction:seq];
                    [teachHand runAction:repeat];
                    
                    isTeachTowerModelShow = YES;
                }
            } else if (teachStep == 1){
                if (tiledPoint.x == 5 && tiledPoint.y == 5) {
                    //能建塔，显示模板
                    [self showTowerModel:[self formatPoint:touchPoint]];
                    [teachExplain setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"teaching_explain_3.png"]];
                    
                    [teachHand stopAllActions];
                    teachHand.position = ccp(260, 20);
                    
                    CCMoveBy *move1 = [CCMoveBy actionWithDuration:0.5f position:ccp(-15, 15)];
                    CCMoveBy *move2 = [CCMoveBy actionWithDuration:0.5f position:ccp(15, -15)];
                    CCSequence *seq = [CCSequence actions:move1, move2, nil];
                    CCRepeatForever *repeat = [CCRepeatForever actionWithAction:seq];
                    [teachHand runAction:repeat];
                    
                    isTeachTowerModelShow = YES;
                }
            } else if (teachStep == 2){
                if (tiledPoint.x == 6 && tiledPoint.y == 5) {
                    //能建塔，显示模板
                    [self showTowerModel:[self formatPoint:touchPoint]];
                    [teachExplain setDisplayFrame:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"teaching_explain_3.png"]];
                    
                    [teachHand stopAllActions];
                    teachHand.position = ccp(300, 20);
                    
                    CCMoveBy *move1 = [CCMoveBy actionWithDuration:0.5f position:ccp(-15, 15)];
                    CCMoveBy *move2 = [CCMoveBy actionWithDuration:0.5f position:ccp(15, -15)];
                    CCSequence *seq = [CCSequence actions:move1, move2, nil];
                    CCRepeatForever *repeat = [CCRepeatForever actionWithAction:seq];
                    [teachHand runAction:repeat];
                    
                    isTeachTowerModelShow = YES;
                }
            }
        }
        
        return;
    }
    
    if(rangeSprite){
        //攻击范围显示
        [rangeSprite removeFromParentAndCleanup:YES];
        rangeSprite = nil;
    }else if (towerModelArray.count > 0){
        //模板显示
        Boolean isCloseModel = YES;
        for (int i = 1; i < towerModelArray.count; i++) {
            TowerModelSprite *modelSprite = [towerModelArray objectAtIndex:i];
            if(CGRectContainsPoint(modelSprite.boundingBox, touchPoint)){
                if(curGold >= modelSprite.towerPrice){
                    CCSprite *aSprite = [towerModelArray objectAtIndex:0];//建造区域
                    [self createATower:aSprite.position withNum:modelSprite.towerNumber withGrade:1];
                }else{
                    isCloseModel = NO;
                }
            }
        }
        if(isCloseModel){
            [self closeTowerModel];
        }
    } else {
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
            
            if([propertiesDict objectForKey:@"isWater"] || [propertiesDict objectForKey:@"isPath"] || [propertiesDict objectForKey:@"isExit"] || [propertiesDict objectForKey:@"isEntrance"]){
                //点击的是水面或路面，不能建塔
                isCreateTower = NO;
                isShowNoCreate = YES;
                break;
            }else if([propertiesDict objectForKey:@"isBarrier"]){
                if(towersArray.count == 0){
                    [self showNoCreateAnimation:[self formatPoint:touchPoint]];                    
                }else{
                    //可被打掉的障碍物，如果在已建塔的视野内，被攻击
                    int barrierType = [[propertiesDict objectForKey:@"isBarrier"] intValue];
                    CGPoint targetPointTemp = [self getBarrierTargetPos:barrierType withTouchPoint:touchPoint];
                    
                    for (int i = 0; i < towersArray.count; i++) {
                        TowerSprite *towerSprite = [towersArray objectAtIndex:i];
                        if(ccpDistance(towerSprite.position, targetPointTemp) < towerSprite.towerInfo.field + 25){
                                                        
                            //设置塔的攻击目标
                            if (CGPointEqualToPoint(towerSprite.targetPoint, CGPointZero)) {
                                towerSprite.targetPoint = targetPointTemp;
                            }else{
                                if(CGPointEqualToPoint(towerSprite.targetPoint, targetPointTemp)){
                                    //点击已在攻击的目标
                                    towerSprite.targetPoint = CGPointZero;
                                }else{
                                    //点击不同的攻击目标
                                    towerSprite.targetPoint = targetPointTemp;
                                }
                            }
                        }
                    }
                    isShowNoCreate = NO;
                }
                isCreateTower = NO;
                break;
            }else if([propertiesDict objectForKey:@"isTower"] && ![@"isTower" isEqualToString:[propertiesDict objectForKey:@"isTower"]]){
                //已经建塔
                TowerSprite *towerSprite = [propertiesDict objectForKey:@"isTower"];
                
//                if(towerSprite.towerInfo.number != 2){
                    rangeSprite = [CCSprite spriteWithSpriteFrameName:@"range.png"];
                    rangeSprite.position = towerSprite.position;
                    rangeSprite.scale = towerSprite.towerInfo.field / (rangeSprite.contentSize.width / 2);
                    [spritesCtrlSheet addChild:rangeSprite];
//                }
                
                isCreateTower = NO;
                isShowNoCreate = NO;
                break;
            }
        }
        
        // 判断是否点在怪身上
        if(enemysArray.count > 0){
            for (int i = 0; i < enemysArray.count; i++) {
                EnemySprite *enemySprite = [enemysArray objectAtIndex:i];
                
                CGRect enemyRect = CGRectMake(enemySprite.position.x - PIXS_GRID / 2, enemySprite.position.y - PIXS_GRID / 2, PIXS_GRID, PIXS_GRID);
                if(CGRectContainsPoint(enemyRect, touchPoint)){
                    isShowNoCreate = NO;
                    isCreateTower = NO;
                    for (int j = 0; j < towersArray.count; j++) {
                        TowerSprite *towerSprite = [towersArray objectAtIndex:j];
                        towerSprite.targetPoint = CGPointZero;
                    }
                    break;
                }
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

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    CGPoint touchPoint = [self convertTouchToNodeSpace:[touches anyObject]];
    
    //返回
    if(CGRectContainsPoint(CGRectMake(0, size.height-40, 40, 40), touchPoint)){
        [[CCDirector sharedDirector] replaceScene:[ChoosePassLayer scene:curPass]];
        [self playDefaultBGM];
    }
    
    // 游戏结束则只响应游戏结束面板上的事件
    if (isGameOver) {
        
        if (isGameWin) {
            // 返回首页
            if(CGRectContainsPoint(CGRectMake(120.0f, 40.0f, 100.0f, 60.0f), touchPoint)){
                [[CCDirector sharedDirector] replaceScene:[ChoosePassLayer scene:curPass]];
                
                [self playDefaultBGM];
                return;
            }
            
            // 继续游戏
            if(CGRectContainsPoint(CGRectMake(270.0f, 40.0f, 100.0f, 60.0f), touchPoint)){
                if (curPass == 20) {
                    //提示已经最后一关, 返回选关
                    [[CCDirector sharedDirector] replaceScene:[ChoosePassLayer scene:curPass]];
                    
                    [self playDefaultBGM];
                    return;
                }
                [[CCDirector sharedDirector] replaceScene:[GameLayer scene:curPass + 1 rank:curRank land:curLand isTeaching:NO]];
//                [self playLandBGM];// 播放背景音
                return;
            }
            return;
        }
        
        // 游戏失败后选择关卡
        if(CGRectContainsPoint(CGRectMake(130.0f, 40.0f, 100.0f, 60.0f), touchPoint)){
            [[CCDirector sharedDirector] replaceScene:[ChoosePassLayer scene:curPass]];
            [self playDefaultBGM];
            return;
        }
        
        // 游戏失败后重新游戏
        if(CGRectContainsPoint(CGRectMake(280.0f, 40.0f, 100.0f, 60.0f), touchPoint)){
            [[CCDirector sharedDirector] replaceScene:[GameLayer scene:curPass rank:curRank land:curLand isTeaching:NO]];
//            [self playLandBGM];
            return;
        }
        return;
    }
    
    // 游戏设置面板
    if(CGRectContainsPoint(CGRectMake(settingIcon.position.x - settingIcon.contentSize.width * 0.5f, settingIcon.position.y - settingIcon.contentSize.height * 0.5f, settingIcon.contentSize.width + 25, settingIcon.contentSize.height), touchPoint)){
        if (!isGamePause) {
            settingSprite = [CCSprite spriteWithSpriteFrameName:@"setting_panel.png"];
            settingSprite.position = ccp(size.width * 0.5f, size.height * 0.6f);
            [spritesCtrlSheet addChild:settingSprite];
            
            restartGame = [CCSprite spriteWithSpriteFrameName:@"setting_game_again.png"];
            restartGame.position = ccp(settingSprite.position.x - 20 - restartGame.contentSize.width * 0.5f, settingSprite.position.y - settingSprite.contentSize.height * 0.5f - restartGame.contentSize.height * 0.5f);
            [spritesCtrlSheet addChild:restartGame];
            
            selectMission = [CCSprite spriteWithSpriteFrameName:@"setting_choosepass.png"];
            selectMission.position = ccp(settingSprite.position.x + 20 + selectMission.contentSize.width * 0.5f, settingSprite.position.y - settingSprite.contentSize.height * 0.5f - selectMission.contentSize.height * 0.5f);
            [spritesCtrlSheet addChild:selectMission];
            
            isGamePause = YES;
            
            [self addAndSettingSprite];
            
//            //增加setting_open
//            CCSprite *soundSprite = [CCSprite spriteWithSpriteFrameName:@"setting_open.png"];
//            [settingSprite addChild:soundSprite];
//            soundSprite.position = ccp(settingSprite.contentSize.width * 0.675f, settingSprite.contentSize.height * 0.545f);
//            
//            CCSprite *BGMSprite = [CCSprite spriteWithSpriteFrameName:@"setting_close.png"];
//            [settingSprite addChild:BGMSprite];
//            BGMSprite.position = ccp(settingSprite.contentSize.width * 0.825f, settingSprite.contentSize.height * 0.295f);
            
            for (int i = 0; i < [enemysArray count]; i ++) {
                EnemySprite *tempEnemySprite = [enemysArray objectAtIndex:i];
                [tempEnemySprite stopMove];
                [tempEnemySprite stopAllActions];
            }
            
            for (int i = 0; i < [towersArray count]; i ++) {
                TowerSprite *tempTowerSprite = [towersArray objectAtIndex:i];
                [tempTowerSprite stopAllActions];
            }
            
            [self unschedule:@selector(handleEnemyAppear:)];
        }
    }
    
    if (isGamePause) {
        
        // 关闭设置面板
        if(CGRectContainsPoint(CGRectMake(settingSprite.position.x + settingSprite.contentSize.width * 0.5f - 40, settingSprite.position.y + settingSprite.contentSize.height * 0.5f - 40, 40, 40), touchPoint)){
            [spritesCtrlSheet removeChild:settingSprite cleanup:YES];
            [spritesCtrlSheet removeChild:restartGame cleanup:YES];
            [spritesCtrlSheet removeChild:selectMission cleanup:YES];
            
            isGamePause = NO;
            
            for (int i = 0; i < [enemysArray count]; i ++) {
                EnemySprite *tempEnemySprite = [enemysArray objectAtIndex:i];
                [tempEnemySprite restartMove];
                //                [tempEnemySprite stopAllActions];
            }
            
            for (int i = 0; i < [towersArray count]; i ++) {
                TowerSprite *tempTowerSprite = [towersArray objectAtIndex:i];
                //                [tempTowerSprite stopAllActions];
                [tempTowerSprite restartAllActions];
            }
            [self schedule:@selector(handleEnemyAppear:)];
            
        }
        
        // 重新游戏
        if(CGRectContainsPoint(CGRectMake(120.0f, 70.0f, 110.0f, 50.0f), touchPoint)){
            [[CCDirector sharedDirector] replaceScene:[GameLayer scene:curPass rank:curRank land:curLand isTeaching:NO]];
//            [self playLandBGM];
            return;
        }
        
        // 选择关卡
        if(CGRectContainsPoint(CGRectMake(275.0f, 80.0f, 110.0f, 50.0f), touchPoint)){
            [[CCDirector sharedDirector] replaceScene:[ChoosePassLayer scene:curPass]];
            [self playDefaultBGM];
            return;
        }
        
        CCSpriteFrame* openFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"setting_open.png"];
        CCSpriteFrame* closeFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"setting_close.png"];
        
        NSUserDefaults *saveDefaults = [NSUserDefaults standardUserDefaults];
        
        if(CGRectContainsPoint(CGRectMake(275.0f, 190.0f, 100.0f, 30.0f), touchPoint)){
            // 音效开关
            NSString *soundSave = nil;
            if (isSoundOpen) {
                isSoundOpen = NO;
                soundSave = @"NO";
                [soundSprite setDisplayFrame:closeFrame];
                soundSprite.position = ccp(settingSprite.contentSize.width * 0.825f, settingSprite.contentSize.height * 0.545f);
                
            }else{
                isSoundOpen = YES;
                soundSave = @"YES";
                [soundSprite setDisplayFrame:openFrame];
                soundSprite.position = ccp(settingSprite.contentSize.width * 0.675f, settingSprite.contentSize.height * 0.545f);
            }
            [saveDefaults setObject:soundSave forKey:@"SoundSave"];
        }
        
        if(CGRectContainsPoint(CGRectMake(275.0f, 150.0f, 100.0f, 30.0f), touchPoint)){
            // 背景音乐开关
            NSString *bgmSave = nil;
            if (isBGMOpen) {
                isBGMOpen = NO;
                bgmSave = @"NO";
                [BGMSprite setDisplayFrame:closeFrame];
                BGMSprite.position = ccp(settingSprite.contentSize.width * 0.825f, settingSprite.contentSize.height * 0.295f);
                
                [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
            }else{
                isBGMOpen = YES;
                bgmSave = @"YES";
                [BGMSprite setDisplayFrame:openFrame];
                BGMSprite.position = ccp(settingSprite.contentSize.width * 0.675f, settingSprite.contentSize.height * 0.295f);
                
                [self playLandBGM];
            }
            [saveDefaults setObject:bgmSave forKey:@"BGMSave"];
        }
        
        return;
    }
    
    if (CGRectContainsPoint(speedIcon.boundingBox, touchPoint)) {
        [[CCScheduler sharedScheduler] setTimeScale:10];
    }
    
}

- (void) addAndSettingSprite
{
    
    CCSpriteFrame* openFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"setting_open.png"];
    CCSpriteFrame* closeFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"setting_close.png"];
    
    //增加setting_open
    soundSprite = [CCSprite spriteWithSpriteFrameName:@"setting_open.png"];
    [settingSprite addChild:soundSprite];
    
    if (isSoundOpen) {
        [soundSprite setDisplayFrame:openFrame];
        soundSprite.position = ccp(settingSprite.contentSize.width * 0.675f, settingSprite.contentSize.height * 0.545f);
    } else {
        [soundSprite setDisplayFrame:closeFrame];
        soundSprite.position = ccp(settingSprite.contentSize.width * 0.825f, settingSprite.contentSize.height * 0.545f);
    }
    
    BGMSprite = [CCSprite spriteWithSpriteFrameName:@"setting_open.png"];
    [settingSprite addChild:BGMSprite];
    if (isBGMOpen) {
        [BGMSprite setDisplayFrame:openFrame];
        BGMSprite.position = ccp(settingSprite.contentSize.width * 0.675f, settingSprite.contentSize.height * 0.295f);
    } else {
        [BGMSprite setDisplayFrame:closeFrame];
        BGMSprite.position = ccp(settingSprite.contentSize.width * 0.825f, settingSprite.contentSize.height * 0.295f);
    }
    
}

- (void) createExit
{
    WayPointInfo *pointInfo = [wayPointsArray objectAtIndex:(wayPointsArray.count-1)];
    
    // 魔法阵
    CCSprite *magicCircle = [CCSprite spriteWithSpriteFrameName:@"exit_0.png"];
    magicCircle.position = pointInfo.position;
    
    NSMutableArray *exitArray = [NSMutableArray arrayWithCapacity:4];
    for (int i = 1; i <= 13; i ++) {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"exit_%d.png", i]];
        [exitArray addObject:frame];
    }
    
    CCAnimation *exitAnimation = [CCAnimation animationWithFrames:exitArray delay:0.15];
    CCAnimate *exitAnimate = [CCAnimate actionWithAnimation:exitAnimation];
    CCRepeatForever *repeat = [CCRepeatForever actionWithAction:exitAnimate];
    [magicCircle runAction:repeat];
    [self addChild:magicCircle];
    
    // 血量 心
    heartHpSprite = [CCSprite spriteWithSpriteFrameName:@"heart_hp.png"];
    heartHpSprite.position = pointInfo.position;
    
    // 血量值
    lifeLabel = [CCLabelAtlas labelWithString:@"" charMapFile:@"number_heart_hp.png" itemWidth:6 itemHeight:9 startCharMap:'0'];
    [lifeLabel setString:[NSString stringWithFormat:@"%d",curLife]];
    lifeLabel.anchorPoint = ccp(0.5f, 0.5f);
    [heartHpSprite addChild:lifeLabel];
    lifeLabel.position = ccp(heartHpSprite.contentSize.width * 0.5f + 0.8, heartHpSprite.contentSize.height * 0.5f + 7);
    [self addChild:heartHpSprite z:labelLayer];
    
    // 心 跳动
    CCMoveTo *heartMoveUp = [CCMoveTo actionWithDuration:0.975f position:ccpAdd(heartHpSprite.position, ccp(0, 3))];
    CCMoveTo *heartMoveDown = [CCMoveTo actionWithDuration:0.975f position:ccpAdd(heartHpSprite.position, ccp(0, -3))];
    CCSequence *sequence = [CCSequence actions:heartMoveUp, heartMoveDown, nil];
    CCRepeatForever *heartRepeat = [CCRepeatForever actionWithAction:sequence];
    [heartHpSprite runAction:heartRepeat];
}

- (void) lossHpAnimat
{
    lifeLabel.visible = NO;
    NSMutableArray *exitArray = [NSMutableArray arrayWithCapacity:4];
    for (int i = 0; i <= 2; i ++) {
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"loss_hp_%d.png", i]];
        [exitArray addObject:frame];
    }
    
    CCAnimation *exitAnimation = [CCAnimation animationWithFrames:exitArray delay:0.15];
    CCAnimate *exitAnimate = [CCAnimate actionWithAnimation:exitAnimation restoreOriginalFrame:YES];
    CCCallFunc *callFunc = [CCCallFunc actionWithTarget:self selector:@selector(lossHpOver)];
    CCSequence *seq = [CCSequence actions:exitAnimate, callFunc, nil];
    [heartHpSprite runAction:seq];
}

- (void) lossHpOver
{
    lifeLabel.visible = YES;
}

- (void)createATower:(CGPoint)touchPoint withNum:(int)num withGrade:(int)grade
{
    CGPoint tiledPoint = [self tilePosFormLocation:touchPoint];
    
    CCTMXLayer *eventLayer = [tmxTiledMap layerNamed:[NSString stringWithFormat:@"layer_1"]];
    int tiledGid = [eventLayer tileGIDAt:tiledPoint];
    
    //原炮塔的信息
    TowerInfo *towerInfo = [towerTypeDict objectForKey:[NSString stringWithFormat:@"%d_%d",num,grade]];
    //升级信息
    UpgradeInfo *aUpgradeInfo = [upgradeInfoDict objectForKey:[NSString stringWithFormat:@"%d",towerInfo.number]];
    towerInfo = [TowerInfo towerInfo:towerInfo withUpgradeInfo:aUpgradeInfo];
    
    if (curGold < towerInfo.price) {
        return;
    }
    
    TowerSprite *towerSprite = [TowerSprite towerSpriteWithTowerInfo:towerInfo upgradeInfo: aUpgradeInfo];
    
    [towerSprite setDelegate:self];
    
    towerSprite.position = [self formatPoint:touchPoint];
    curGold = curGold - towerSprite.towerInfo.price;
    [goldLabel setString:[NSString stringWithFormat:@"%d",curGold]];
    
    NSDictionary *propertiesDict = [tmxTiledMap propertiesForGID:tiledGid];
    [propertiesDict setValue:towerSprite forKey:@"isTower"];
    
    [towersArray addObject:towerSprite];
    [spritesTowerSheet addChild:towerSprite];
    
    
    [self schedule:@selector(doAttack:) interval:RATE_SPEED];
    [self schedule:@selector(detectCollsion:) interval:RATE_SPEED];
        
    //判断上下左右是否是同级别的tower
    [self checkUpgradeWithTower:towerSprite WithPoint:tiledPoint];
}

- (void)doAttack:(ccTime)delta
{
    // 查找视野内是否有怪，病按进入视野的顺序排列
    for (int i = 0; i < towersArray.count; i++) {
        TowerSprite *towerSprite = [towersArray objectAtIndex:i];
        for (int j = 0; j < enemysArray.count; j++) {
            EnemySprite *enemySprite = [enemysArray objectAtIndex:j];   
            if(ccpDistance(towerSprite.position, enemySprite.position) < towerSprite.towerInfo.field + PIXS_GRID/2){
                if (![towerSprite.enemyArray containsObject:enemySprite]) {
                    [towerSprite.enemyArray addObject:enemySprite];
                }
            } else {
                if ([towerSprite.enemyArray containsObject:enemySprite]) {
                    [towerSprite.enemyArray removeObject:enemySprite];
                }
            }
        }
//        CCLOG(@"-------%d----->%d",i,towerSprite.enemyArray.count);
    }
    
    // 检测攻击的
    for (int j = 0; j < towersArray.count; j++) {     
        TowerSprite *towerSprite = [towersArray objectAtIndex:j];
        if (CGPointEqualToPoint(towerSprite.targetPoint, CGPointZero)) {   
            //攻击怪物
            if (towerSprite.enemyArray.count > 0) {
                EnemySprite *enemySprite = [towerSprite.enemyArray objectAtIndex:0];
                if(ccpDistance(towerSprite.position, enemySprite.position) < towerSprite.towerInfo.field + PIXS_GRID/2){
                    // 3级冰塔会优先攻击未被减速的
                    if (towerSprite.towerInfo.number == 3 && towerSprite.towerInfo.grade == 3) {
                        if (enemySprite.isSlowDown ) {
                            break;
                        } else {
                            [towerSprite attackWithTargetPos:enemySprite.position];
                        }
                    }else {
                        [towerSprite attackWithTargetPos:enemySprite.position];
                    }
                }
            }
        }else{
            //攻击石头
            int index = 0;
            for (index = 0; index < stoneArray.count; index++) {
                StoneInfo *stoneInfo = [stoneArray objectAtIndex:index];
                if(CGPointEqualToPoint(stoneInfo.stonePos, towerSprite.targetPoint)){                    
                    if(ccpDistance(towerSprite.position, stoneInfo.stonePos) < towerSprite.towerInfo.field + [self getRadiusByStoneType:stoneInfo.stoneType]){
                        [towerSprite attackWithTargetPos:stoneInfo.stonePos];

                        break;
                    }
                }
            }
            
            if(index == stoneArray.count){
                //已经将石头打掉了，回复攻击怪物
                towerSprite.targetPoint = CGPointZero;
            }
        }        
    }
}

- (void)detectCollsion:(ccTime)delta
{
    for (int i = 0; i < bulletArray.count; i++) {
        BulletSprite *bulletSprite = [bulletArray objectAtIndex:i];
        int number = bulletSprite.bulletInfo.number;
        
        if(number == 4){
            //与怪碰撞
            BOOL isCollided = [self detectEnemyCollsion:bulletSprite number:number];
            //与石头碰撞
            if(!isCollided){                
                [self detectStoneCollsion:bulletSprite number:number];
            }
        }else{
            if (CGPointEqualToPoint(bulletSprite.targetPoint, CGPointZero)) {
                //与怪碰撞
                [self detectEnemyCollsion:bulletSprite number:number];
            } else {
                //与石头碰撞
                [self detectStoneCollsion:bulletSprite number:number];
            }
            
        }
      
    }
}

- (BOOL)detectEnemyCollsion:(BulletSprite *)bulletSprite number:(int)number
{
    for (int j = 0; j < enemysArray.count; j++) {
        EnemySprite *enemySprite = [enemysArray objectAtIndex:j];
    
        CGRect rect = CGRectMake(enemySprite.position.x - 20, enemySprite.position.y - 20, 40, 40);
        if(CGRectContainsPoint(rect , bulletSprite.position)){
            if (number == 2) {
                // 2号塔是AOE伤害
                CGPoint tempPoint = ccpAdd(enemySprite.position, ccp(0, 0));//-enemySprite.contentSize.height * 0.5f
                
                [self showBulletBombAnim:number withPos:tempPoint withBullet: bulletSprite];
                
                // 升级4技能10%概率击中后有燃烧效果
                
                if (bulletSprite.bulletInfo.isFiring) {
                    int value = arc4random() % 10;
                    if (value == 0) {
                        [self startFiring:enemySprite];
                    }
                }
                
                [bulletArray removeObject:bulletSprite];
                [bulletSprite removeFromParentAndCleanup:YES];
                
                return YES;
                
            } else if(number == 4) {
                if(!(bulletSprite.bulletInfo.firstHitEnemyIdx == enemySprite.enemyInfo.enemyId || bulletSprite.bulletInfo.secondHitEnemyIdx == enemySprite.enemyInfo.enemyId)){
                    
                    if (bulletSprite.bulletInfo.firstHitEnemyIdx != enemySprite.enemyInfo.enemyId) {
                        bulletSprite.bulletInfo.firstHitEnemyIdx = enemySprite.enemyInfo.enemyId;
                    } else {
                        bulletSprite.bulletInfo.secondHitEnemyIdx = enemySprite.enemyInfo.enemyId;
                    }
                    
                    //子弹消失
                    bulletSprite.bulletInfo.pierceEnemyNumber -= 1;
                    
                    CGPoint tempPoint = ccpAdd(enemySprite.position, ccp(0, -enemySprite.contentSize.height * 0.5f));
                    //怪减速
//                    [enemySprite doSlowDown:bulletSprite.bulletInfo.slowRate slowTime:bulletSprite.bulletInfo.slowTime];
                    if (bulletSprite.bulletInfo.pierceEnemyNumber < 0) {
                        bulletSprite.bulletInfo.attackPower = bulletSprite.bulletInfo.attackPower * 2;
                    }
                    
                    //怪减血
                    [self updateEnemyHp:enemySprite withBulletSprite:bulletSprite];
                    
                    NSLog(@"bulletSprite.bulletInfo.pierceEnemyNumber = %d", bulletSprite.bulletInfo.pierceEnemyNumber);
                    //                enemysArray
                    if (enemySprite && bulletSprite.bulletInfo.pierceEnemyNumber < 0) {
                        
                        [self showBulletBombAnim:number withPos:tempPoint withBullet: bulletSprite];
                        
                        [bulletArray removeObject:bulletSprite];
                        [bulletSprite removeFromParentAndCleanup:YES];
                    }

                }
                return YES;
            } else{
                CGPoint tempPoint = ccpAdd(enemySprite.position, ccp(0, -enemySprite.contentSize.height * 0.5f));
                //怪减速
                [enemySprite doSlowDown:bulletSprite.bulletInfo.slowRate slowTime:bulletSprite.bulletInfo.slowTime];
                
                //怪减血
                [self updateEnemyHp:enemySprite withBulletSprite:bulletSprite];
                
                //子弹消失
                
                [self showBulletBombAnim:number withPos:tempPoint withBullet: bulletSprite];
                
                [bulletArray removeObject:bulletSprite];
                [bulletSprite removeFromParentAndCleanup:YES];
                
                return YES;
            }
        }
    }
    
    return NO;
}

- (void) startFiring:(EnemySprite *) aEnemySprite
{
    if (aEnemySprite.isFiring) {
        aEnemySprite.firingDuration = 10;
        [aEnemySprite unschedule:@selector(onFiring)];
        [aEnemySprite schedule:@selector(onFiring) interval:1.0f];
    } else {
        aEnemySprite.isFiring = YES;
        ccColor3B red = ccc3(255, 0, 0);
        [aEnemySprite setColor:red];
        aEnemySprite.enemyInfo.curHp -= 10;
        aEnemySprite.firingDuration = 10;
        
        [aEnemySprite schedule:@selector(onFiring) interval:1.0f];
    }
}
//
//- (void) onFiring:(EnemySprite *) aEnemySprite
//{
//    firingDuration -= 1;
//    aEnemySprite.enemyInfo.curHp -= 10;
//    if(aEnemySprite.enemyInfo.curHp > 0){
//        aEnemySprite.bloodProgress.percentage = aEnemySprite.enemyInfo.curHp * 100 / aEnemySprite.enemyInfo.maxHp;
//    }else{
//        //更新金币数量
//        curGold = curGold + aEnemySprite.enemyInfo.award;
//        [goldLabel setString:[NSString stringWithFormat:@"%d",curGold]];
////        
////        //如果建造模板显示，检测原本不能建塔的是否能建塔
////        if (towerModelArray.count > 0){
////            for (int i = 1; i < towerModelArray.count; i++) {
////                TowerModelSprite *modelSprite = [towerModelArray objectAtIndex:i];
////                if(!modelSprite.isGoldEnough && curGold >= modelSprite.towerPrice){
////                    [modelSprite shiftSprite];
////                }
////            }
////        }
//        
//        CGPoint position = ccpAdd(aEnemySprite.position, ccp(0, 20));
//        NSMutableArray *paramArray = [NSMutableArray arrayWithCapacity:2];
//        [paramArray addObject:[NSValue valueWithCGPoint:position]];
//        [paramArray addObject:[NSString stringWithFormat:@"/%d",aEnemySprite.enemyInfo.award]];
//        
//        //显示金币掉落效果
//        [self showGlodDrapAnimation:paramArray];
//        
//        [enemysArray removeObject:aEnemySprite];
//        
//        [self checkEnemyDie];
//        
//        [aEnemySprite.bloodFrame removeFromParentAndCleanup:YES];
//        [aEnemySprite.bloodProgress removeFromParentAndCleanup:YES];
//        [aEnemySprite removeFromParentAndCleanup:YES];
//        
//        if(curWave == boutArray.count && enemysArray.count == 0){
//            if (curLife > 0) {
//                [self gameWin];
//            } else {
//                [self gameOver];
//            }
//        }
//    }
//
//    if (firingDuration == 0) {
//        [aEnemySprite setColor:ccc3(255, 255, 255)];
//    } else {
//        [self schedule:@selector(onFiring:) interval:1.0f];
//    }
//}


- (void)detectStoneCollsion:(BulletSprite *)bulletSprite number:(int)number
{
    for (int j = 0; j < stoneArray.count; j++) {
        StoneInfo *stoneInfo = [stoneArray objectAtIndex:j];
        if(CGRectContainsPoint(stoneInfo.stoneRect, bulletSprite.position)){
            stoneInfo.bloodFrame.visible = YES;
            stoneInfo.bloodProgress.visible = YES;
            
            //stone减血
            [self updateStoneHp:bulletSprite stoneInfo:stoneInfo];
            
            //子弹消失
            if (number != 5 && number != 8) {
                [self showBulletBombAnim:number withPos:bulletSprite.position withBullet: bulletSprite];
                
                [bulletArray removeObject:bulletSprite];
                [bulletSprite removeFromParentAndCleanup:YES];
            }
            return;
        }
    }
}

- (void)updateEnemyHp:(EnemySprite *)enemySprite withBulletSprite:(BulletSprite*)aBulletSprite
{
    enemySprite.enemyInfo.curHp = enemySprite.enemyInfo.curHp - aBulletSprite.bulletInfo.attackPower;
    if(enemySprite.enemyInfo.curHp > 0){
        enemySprite.bloodProgress.percentage = enemySprite.enemyInfo.curHp * 100 / enemySprite.enemyInfo.maxHp;
    }else{
        //更新金币数量
        curGold = curGold + enemySprite.enemyInfo.award;
        [goldLabel setString:[NSString stringWithFormat:@"%d",curGold]];
        
        //如果建造模板显示，检测原本不能建塔的是否能建塔
        if (towerModelArray.count > 0){
            for (int i = 1; i < towerModelArray.count; i++) {
                TowerModelSprite *modelSprite = [towerModelArray objectAtIndex:i];
                if(!modelSprite.isGoldEnough && curGold >= modelSprite.towerPrice){
                    [modelSprite shiftSprite];
                }
            }
        }

        CGPoint position = ccpAdd(enemySprite.position, ccp(0, 20));
        NSMutableArray *paramArray = [NSMutableArray arrayWithCapacity:2];
        [paramArray addObject:[NSValue valueWithCGPoint:position]];
        [paramArray addObject:[NSString stringWithFormat:@"/%d",enemySprite.enemyInfo.award]];
        
        //显示金币掉落效果
        [self showGlodDrapAnimation:paramArray];               
        
        [enemysArray removeObject:enemySprite];
        
        [self checkEnemyDie];        
        
        [enemySprite.bloodFrame removeFromParentAndCleanup:YES];
        [enemySprite.bloodProgress removeFromParentAndCleanup:YES];
        [enemySprite removeFromParentAndCleanup:YES];
        enemySprite = nil;
        
        if(curWave == boutArray.count && enemysArray.count == 0){
            if (curLife > 0) {
                [self gameWin];
            } else {
                [self gameOver];
            }
        }
    }    
}

// 移除已经死亡的敌人
- (void)checkEnemyDie
{
    for (int i = 0; i < towersArray.count; i++) {
        TowerSprite *towerSprite = [towersArray objectAtIndex:i];
        for (int j = 0; j < towerSprite.enemyArray.count; j++) {
            EnemySprite *enemySprite = [towerSprite.enemyArray objectAtIndex:j];            
            if (enemySprite.enemyInfo.curHp <= 0) {
                if ([towerSprite.enemyArray containsObject:enemySprite]){
                    if (isSoundOpen) {
                        if (enemySprite.enemyInfo.number <= 4) {
                            // 序号4以内的怪死亡则随机播放1或者2的音效
                            int value = arc4random() % 2;
                            if (value == 0) {
                                [[SimpleAudioEngine sharedEngine]playEffect:[NSString stringWithFormat:@"enemy_dead_%d_1.caf", enemySprite.enemyInfo.number]];// 播放死亡音效
                            }else{
                                [[SimpleAudioEngine sharedEngine]playEffect:[NSString stringWithFormat:@"enemy_dead_%d_2.caf", enemySprite.enemyInfo.number]];// 播放死亡音效
                            }
                        } else {
                            [[SimpleAudioEngine sharedEngine]playEffect:[NSString stringWithFormat:@"enemy_dead_%d_1.caf", enemySprite.enemyInfo.number]];// 播放死亡音效
                        }
                    }
                    
                    [towerSprite.enemyArray removeObject:enemySprite];
                }
            }
        }
    }
}

- (void)updateStoneHp:(BulletSprite *)bulletSprite stoneInfo:(StoneInfo *)stoneInfo
{
    stoneInfo.stoneCurHp = stoneInfo.stoneCurHp - bulletSprite.bulletInfo.attackPower;
    if(stoneInfo.stoneCurHp <= 0){
        curGold = curGold + stoneInfo.stoneAward;
        [goldLabel setString:[NSString stringWithFormat:@"%d",curGold]];
        
        CGPoint position = ccpAdd(stoneInfo.stonePos, ccp(0, stoneInfo.stoneRect.size.height/2));
        NSMutableArray *paramArray = [NSMutableArray arrayWithCapacity:2];
        [paramArray addObject:[NSValue valueWithCGPoint:position]];
        [paramArray addObject:[NSString stringWithFormat:@"/%d",stoneInfo.stoneAward]];
        [self showGlodDrapAnimation:paramArray];
        
        [stoneInfo.bloodFrame removeFromParentAndCleanup:YES];
        [stoneInfo.bloodProgress removeFromParentAndCleanup:YES];
        
        [self removeStoneFromMap:stoneInfo];
        [stoneArray removeObject:stoneInfo];
    }else{
        stoneInfo.bloodProgress.percentage = stoneInfo.stoneCurHp * 100 / stoneInfo.stoneMaxHp;
    }
}

/*
 * 显示掉钱的动画
 * 参数数组：0，label的位子(CGPoint)，1，label的内容(NSString *)
 */
- (void)showGlodDrapAnimation:(NSMutableArray *)paramArray
{
    CCSprite *aSprite = [CCSprite spriteWithSpriteFrameName:@"gold_drop_01.png"];
    aSprite.position = [[paramArray objectAtIndex:0] CGPointValue];
    [spritesCtrlSheet addChild:aSprite];
    
    CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    NSMutableArray *frameArray = [NSMutableArray arrayWithCapacity:2];
    
    for (int i = 0; i < 9; i++) {
        CCSpriteFrame *frame = [frameCache spriteFrameByName:[NSString stringWithFormat:@"gold_drop_%02d.png",i+1]];
        [frameArray addObject:frame];
    }
    
    CCAnimation *animation = [CCAnimation animationWithFrames:frameArray delay:0.1f];
    CCAnimate *animate = [CCAnimate actionWithAnimation:animation];
    
    [paramArray addObject:aSprite];
    CCCallFuncO *callFuno = [CCCallFuncO actionWithTarget:self selector:@selector(showGetAwardAnimation:) object:paramArray];
    
    [aSprite runAction:[CCSequence actions:animate,callFuno, nil]];
}

/*
 * 显示掉钱的数字
 * 参数数组：0，label的位子(CGPoint)，1，label的内容(NSString *),2,金币的图片
 */
- (void)showGetAwardAnimation:(NSMutableArray *)paramArray
{
    CCLabelAtlas *awardLabel = [CCLabelAtlas labelWithString:@"" charMapFile:@"number_enemy.png" itemWidth:14 itemHeight:19 startCharMap:'/'];
    awardLabel.anchorPoint = ccp(0.5f, 0.5f);
    [self addChild:awardLabel z:labelLayer];
    
    awardLabel.position = [[paramArray objectAtIndex:0] CGPointValue];
    [awardLabel setString:[paramArray objectAtIndex:1]];
    if([paramArray objectAtIndex:2]){
        CCSprite *aSprite = [paramArray objectAtIndex:2];
        [aSprite removeFromParentAndCleanup:YES];
        aSprite = nil;
    }
    
    [awardLabel runAction:[CCMoveBy actionWithDuration:2.0f position:ccp(0, 40)]];
    [awardLabel runAction:[CCSequence actions:[CCFadeOut actionWithDuration:2.1f],[CCCallFuncO actionWithTarget:self selector:@selector(removeSprite:) object:awardLabel], nil]];
}

//显示子弹爆炸的效果
- (void)showBulletBombAnim:(int)number withPos:(CGPoint)pos withBullet:(BulletSprite *) bulletSprite
{
    if(number != 1 && number != 2 && number != 3 && (number != 4)){
        // 测试用
        return;
    }
    
    CCSprite *aSprite = [CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"bullet_%d_1.png",number]];
    aSprite.anchorPoint = ccp(0.5f, 0.1f);
    aSprite.position = pos;
    [spritesBulletSheet addChild:aSprite];
    
    CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    NSMutableArray *frameArray = [NSMutableArray arrayWithCapacity:2];
    NSMutableArray *lastFrameArray = [NSMutableArray arrayWithCapacity:2];
    
    NSString *string = nil;
    int count = 0;
    
    if(number == 1){
        count = 6;
        string = @"bullet_%d_bomb_%d.png";
    }else if(number == 2){
        count = 11;
        string = @"bullet_%d_bomb_%d.png";
    }else if(number == 3){
        count = 5;
        string = @"bullet_%d_bomb_%d.png";
    }else if(number == 4){
        if (bulletSprite.bulletInfo.grade == 3) {
            count = 3;
            string = @"bullet_%d_bomb_%d_bigbang.png";
        } else {
            count = 4;
            string = @"bullet_%d_bomb_%d.png";
        }
    }
    
    for (int i = 1; i <= count; i++) {
        CCSpriteFrame *frame = [frameCache spriteFrameByName:[NSString stringWithFormat:string, number,i]];
        if (number == 2) {
            if (i <= 3) {
                [frameArray addObject:frame];
            }else{
                [lastFrameArray addObject:frame];
            }
        }else{
            [frameArray addObject:frame];
        }
    }
    
    CCAnimation *animation = [CCAnimation animationWithFrames:frameArray delay:0.1f];
    CCAnimate *animate = [CCAnimate actionWithAnimation:animation restoreOriginalFrame:NO];
    CCCallFuncO *callFunO = [CCCallFuncO actionWithTarget:self selector:@selector(removeSprite:) object:aSprite];
    
    CCSequence *sequence  = nil;
    if (number == 2) {
        tempBulletSprite = [bulletSprite retain];
        
        float scale;
        switch (bulletSprite.bulletInfo.grade) {
            case 1:
                scale = 0.3f;
                break;
                
            case 2:
                scale = 0.6f;
                break;
                
            default:
                scale = 1.0f;
                break;
                
        }
        aSprite.scale = scale;
        
        // 处理动画
        CCAnimation *animation2 = [CCAnimation animationWithFrames:lastFrameArray delay:0.1f];
        CCAnimate *animate2 = [CCAnimate actionWithAnimation:animation2];
        // 计算爆炸AOE面积与enemy的碰撞
        CCCallFuncO *callFunc = [CCCallFuncO actionWithTarget:self selector:@selector(bulletBomb:) object:aSprite];
        
        sequence = [CCSequence actions:animate,callFunc,animate2,callFunO, nil];
    }else{
        sequence = [CCSequence actions:animate,callFunO, nil];
    }
    
    [aSprite runAction:sequence];
}

- (void) bulletBomb:(CCSprite *)aSprite
{
    float boundingScale;
    switch (tempBulletSprite.bulletInfo.grade) {
        case 1:
            boundingScale = 0.3f;
            break;
            
        case 2:
            boundingScale = 0.6f;
            break;
            
        default:
            boundingScale = 1.0f;
            break;
            
    }

    CGRect bombBoundingBox = aSprite.boundingBox;
    CGRect bombRect1 = CGRectMake(bombBoundingBox.origin.x + 93 * boundingScale, bombBoundingBox.origin.y, 215 * boundingScale, 100 * boundingScale);
    CGRect bombRect2 = CGRectMake(bombBoundingBox.origin.x + 125 * boundingScale, bombBoundingBox.origin.y + 100 * boundingScale, 150 * boundingScale, 80 * boundingScale);
    
    for (int j = 0; j < enemysArray.count; j++) {
        EnemySprite *enemySprite = [enemysArray objectAtIndex:j];
        
        if (CGRectIntersectsRect(bombRect1, [enemySprite boundingBox]) || CGRectIntersectsRect(bombRect2, [enemySprite boundingBox])) {
//        if (CGRectIntersectsRect(bombBoundingBox, [enemySprite boundingBox])) {
        
            //怪减速
            [enemySprite doSlowDown:tempBulletSprite.bulletInfo.slowRate slowTime:tempBulletSprite.bulletInfo.slowTime];
            
            // 如果怪物死掉则下标往前移一位
            int curHp = enemySprite.enemyInfo.curHp - tempBulletSprite.bulletInfo.attackPower;
            if (curHp <= 0) {
                j --;
            }
            //怪减血
            [self updateEnemyHp:enemySprite withBulletSprite:tempBulletSprite];
            
        }
    }
}

//移除地图中的stone
- (void)removeStoneFromMap:(StoneInfo *)stoneInfo
{
    NSMutableArray *tiledPointArray = [NSMutableArray arrayWithCapacity:2];
    if(stoneInfo.stoneType == stoneType1){
        [tiledPointArray addObject:[NSValue valueWithCGPoint:[self tilePosFormLocation:stoneInfo.stonePos]]];
    }else if(stoneInfo.stoneType == stoneType2){
        [tiledPointArray addObject:[NSValue valueWithCGPoint:[self tilePosFormLocation:ccpAdd(stoneInfo.stonePos, ccp(-PIXS_GRID/2, 0))]]];
        [tiledPointArray addObject:[NSValue valueWithCGPoint:[self tilePosFormLocation:ccpAdd(stoneInfo.stonePos, ccp(PIXS_GRID/2, 0))]]];        
    }else if(stoneInfo.stoneType == stoneType3){
        [tiledPointArray addObject:[NSValue valueWithCGPoint:[self tilePosFormLocation:ccpAdd(stoneInfo.stonePos, ccp(0, -PIXS_GRID/2))]]];
        [tiledPointArray addObject:[NSValue valueWithCGPoint:[self tilePosFormLocation:ccpAdd(stoneInfo.stonePos, ccp(0, PIXS_GRID/2))]]];
    }else if(stoneInfo.stoneType == stoneType4){
        [tiledPointArray addObject:[NSValue valueWithCGPoint:[self tilePosFormLocation:ccpAdd(stoneInfo.stonePos, ccp(-PIXS_GRID/2, -PIXS_GRID/2))]]];
        [tiledPointArray addObject:[NSValue valueWithCGPoint:[self tilePosFormLocation:ccpAdd(stoneInfo.stonePos, ccp(-PIXS_GRID/2, PIXS_GRID/2))]]];
        [tiledPointArray addObject:[NSValue valueWithCGPoint:[self tilePosFormLocation:ccpAdd(stoneInfo.stonePos, ccp(PIXS_GRID/2, -PIXS_GRID/2))]]];
        [tiledPointArray addObject:[NSValue valueWithCGPoint:[self tilePosFormLocation:ccpAdd(stoneInfo.stonePos, ccp(PIXS_GRID/2, PIXS_GRID/2))]]];        
    }    
    
    for (int i = 2; i < 5; i++) {
        //不确定在哪层
        CCTMXLayer *eventLayer = [tmxTiledMap layerNamed:[NSString stringWithFormat:@"layer_%d",i]];
        if(!eventLayer){
            break;
        }        
        
        for (int j = 0; j < tiledPointArray.count; j++) {
            CGPoint tiledPoint = [[tiledPointArray objectAtIndex:j] CGPointValue];
            
            int tiledGid = [eventLayer tileGIDAt:tiledPoint];
            if(tiledGid == 0){
                continue;
            }
            
            NSDictionary *propertiesDict = [tmxTiledMap propertiesForGID:tiledGid];
            
            if([propertiesDict objectForKey:@"isBarrier"]){
                [eventLayer removeTileAt:tiledPoint];
            }
        }
       
    }
}

- (void)checkUpgradeWithTower:(TowerSprite *)towerSprite WithPoint:(CGPoint)tempPoint
{
    if(towerSprite.towerInfo.grade >= 3){
        //满级了，不需要判断是否升级
        return;
    }
    
    int x = tempPoint.x;
    int y = tempPoint.y;
    
    int sameCount = 1;//相邻相同种类相同级别的tower的个数
    
    NSMutableArray *sameTowerKeys = [NSMutableArray arrayWithCapacity:2];
    [sameTowerKeys addObject:[NSString stringWithFormat:@"%d*%d",x,y]];
     
    //左
    if([self isSameWithTower:towerSprite.towerInfo withTiledPoint:ccp(x-1, y)]){
        sameCount++;
        [sameTowerKeys addObject:[NSString stringWithFormat:@"%d*%d",x-1,y]];
        //左的左
        if([self isSameWithTower:towerSprite.towerInfo withTiledPoint:ccp(x-2, y)]){
            sameCount ++;
            [sameTowerKeys addObject:[NSString stringWithFormat:@"%d*%d",x-2,y]];
        }
        //左的上
        if([self isSameWithTower:towerSprite.towerInfo withTiledPoint:ccp(x-1, y+1)]){
            sameCount ++;
            [sameTowerKeys addObject:[NSString stringWithFormat:@"%d*%d",x-1,y+1]];
        }
        //左的下
        if([self isSameWithTower:towerSprite.towerInfo withTiledPoint:ccp(x-1, y-1)]){
            sameCount ++;
            [sameTowerKeys addObject:[NSString stringWithFormat:@"%d*%d",x-1,y-1]];
        }
    }
    //右
    if([self isSameWithTower:towerSprite.towerInfo withTiledPoint:ccp(x+1, y)]){
        sameCount++;
        [sameTowerKeys addObject:[NSString stringWithFormat:@"%d*%d",x+1,y]];
        
        if([self isSameWithTower:towerSprite.towerInfo withTiledPoint:ccp(x+2, y)]){
            sameCount ++;
            [sameTowerKeys addObject:[NSString stringWithFormat:@"%d*%d",x+2,y]];
        }
        
        if([self isSameWithTower:towerSprite.towerInfo withTiledPoint:ccp(x+1, y+1)]){
            sameCount ++;
            [sameTowerKeys addObject:[NSString stringWithFormat:@"%d*%d",x+1,y+1]];
        }
        
        if([self isSameWithTower:towerSprite.towerInfo withTiledPoint:ccp(x+1, y-1)]){
            sameCount ++;
            [sameTowerKeys addObject:[NSString stringWithFormat:@"%d*%d",x+1,y-1]];
        }
    }
    //上
    if([self isSameWithTower:towerSprite.towerInfo withTiledPoint:ccp(x, y+1)]){
        sameCount++;
        [sameTowerKeys addObject:[NSString stringWithFormat:@"%d*%d",x,y+1]];
        
        if([self isSameWithTower:towerSprite.towerInfo withTiledPoint:ccp(x-1, y+1)]){
            sameCount ++;
            [sameTowerKeys addObject:[NSString stringWithFormat:@"%d*%d",x-1,y+1]];
        }
        
        if([self isSameWithTower:towerSprite.towerInfo withTiledPoint:ccp(x+1, y+1)]){
            sameCount ++;
            [sameTowerKeys addObject:[NSString stringWithFormat:@"%d*%d",x+1,y+1]];
        }
        
        if([self isSameWithTower:towerSprite.towerInfo withTiledPoint:ccp(x, y+2)]){
            sameCount ++;
            [sameTowerKeys addObject:[NSString stringWithFormat:@"%d*%d",x,y+2]];
        }
    }
    //下
    if([self isSameWithTower:towerSprite.towerInfo withTiledPoint:ccp(x, y-1)]){
        sameCount++;
        [sameTowerKeys addObject:[NSString stringWithFormat:@"%d*%d",x,y-1]];
        
        if([self isSameWithTower:towerSprite.towerInfo withTiledPoint:ccp(x-1, y-1)]){
            sameCount ++;
            [sameTowerKeys addObject:[NSString stringWithFormat:@"%d*%d",x-1,y-1]];
        }
        
        if([self isSameWithTower:towerSprite.towerInfo withTiledPoint:ccp(x+1, y-1)]){
            sameCount ++;
            [sameTowerKeys addObject:[NSString stringWithFormat:@"%d*%d",x+1,y-1]];
        }
        
        if([self isSameWithTower:towerSprite.towerInfo withTiledPoint:ccp(x, y-2)]){
            sameCount ++;
            [sameTowerKeys addObject:[NSString stringWithFormat:@"%d*%d",x,y-2]];
        }
    }
    
    if(sameCount >= 3){
        //等级未满
        CGPoint towerPoint = towerSprite.position;
        int curTowerNum = towerSprite.towerInfo.number;
        int curTowerGrade = towerSprite.towerInfo.grade;
        
        CCTMXLayer *eventLayer = [tmxTiledMap layerNamed:[NSString stringWithFormat:@"layer_1"]];
        
        //移除低等级的
        for (int i = 0; i < sameTowerKeys.count; i++) {
            NSString *keyStr = [sameTowerKeys objectAtIndex:i];
            
            NSRange range = [keyStr rangeOfString:@"*"];
            int tileId = [eventLayer tileGIDAt:ccp([[keyStr substringToIndex:range.location] intValue], [[keyStr substringFromIndex:range.location + range.length] intValue])];
            
            NSDictionary *propertiesDict = [tmxTiledMap propertiesForGID:tileId];
            
            TowerSprite *tower = [propertiesDict objectForKey:@"isTower"];
            [propertiesDict setValue:@"isTower" forKey:@"isTower"];
            
            [towersArray removeObject:tower];
            [tower removeFromParentAndCleanup:YES];
        }
        
        //升级最后一个
        [self createATower:towerPoint withNum:curTowerNum withGrade:curTowerGrade + 1];
    }
    
    [sameTowerKeys removeAllObjects];
    sameTowerKeys = nil;
}

//根据触摸障碍物的点获取目标点
- (CGPoint)getBarrierTargetPos:(int)barrierType withTouchPoint:(CGPoint)touchPoint
{
    int tempX = touchPoint.x / PIXS_GRID;
    int tempY = touchPoint.y / PIXS_GRID;
    CGPoint tempPoint = ccp(tempX * PIXS_GRID, tempY * PIXS_GRID );
    
    switch (barrierType) {
        case 1:
            tempPoint = ccpAdd(tempPoint, ccp(PIXS_GRID / 2, PIXS_GRID / 2));
            break;
        case 21:
            tempPoint = ccpAdd(tempPoint, ccp(PIXS_GRID, PIXS_GRID / 2));
            break;
        case 22:
            tempPoint = ccpAdd(tempPoint, ccp(0, PIXS_GRID / 2));
            break;
        case 31:
            tempPoint = ccpAdd(tempPoint, ccp(PIXS_GRID / 2, 0));
            break;
        case 32:
            tempPoint = ccpAdd(tempPoint, ccp(PIXS_GRID / 2, PIXS_GRID));
            break;
        case 41:
            tempPoint = ccpAdd(tempPoint, ccp(PIXS_GRID, 0));
            break;
        case 42:
            tempPoint = tempPoint;
            break;
        case 43:
            tempPoint = ccpAdd(tempPoint, ccp(PIXS_GRID, PIXS_GRID));
            break;
        case 44:
            tempPoint = ccpAdd(tempPoint, ccp(0, PIXS_GRID));
            break;
            
    }
    return tempPoint;
}

- (float)getRadiusByStoneType:(StoneType)aType
{
    
    float radius = 0;
    switch (aType) {
        case stoneType1:
            radius = 15;
            break;
        case stoneType2:
            radius = 20;
            break;
        case stoneType3:
            radius = 20;            
            break;
        case stoneType4:
            radius = 30;
            break;
    }
    return radius;
}

//判断是否是是同种类同级别的tower，升级用
- (Boolean)isSameWithTower:(TowerInfo *)towerInfo withTiledPoint:(CGPoint)tiledPoint
{
    if(tiledPoint.x < 0 || tiledPoint.y < 0 || tiledPoint.x >= 12 || tiledPoint.y >= 8){
        return NO;
    }
    
    CCTMXLayer *eventLayer = [tmxTiledMap layerNamed:[NSString stringWithFormat:@"layer_1"]];
    int tiledGid = [eventLayer tileGIDAt:tiledPoint];
    
    if(tiledGid != 0){
        NSDictionary *propertiesDict = [tmxTiledMap propertiesForGID:tiledGid];
    
        if(![propertiesDict objectForKey:@"isWater"] && ![@"isTower" isEqualToString:[propertiesDict objectForKey:@"isTower"]]){
            TowerSprite *towerSprite = [propertiesDict objectForKey:@"isTower"];
            if(towerInfo.number == towerSprite.towerInfo.number && towerInfo.grade == towerSprite.towerInfo.grade){
                //同种类，同级别
                return YES;
            }
        }
    }
    
    return NO;
}

//显示某一个能建塔的模板
- (void)showTowerModel:(CGPoint)tempPoint
{
    CCSprite *aSprite = [CCSprite spriteWithSpriteFrameName:@"creating.png"];
    aSprite.position = tempPoint;
    [spritesCtrlSheet addChild:aSprite];
    [towerModelArray addObject:aSprite];
    
    int number = 0;
    NSArray *towerArray = [self getTowerModelArray];
    for (int i = 0; i < towerArray.count; i++) {
        TowerInfo *towerInfo = [towerArray objectAtIndex:i];
        if(towerInfo.number != number){
            number = towerInfo.number;            
            
            int row = i;//第几列
            int line = 0;//第几行
            if(i >= 4){
                row = i - 4;
                line = 1;
            }
            
            TowerModelSprite *modelSprite = [TowerModelSprite towerModelWithNum:towerInfo.number price:towerInfo.price curGold:curGold];
            modelSprite.position = ccpAdd([self getModelStartPoint:tempPoint fromTowerArray:towerArray], ccp(row * PIXS_GRID * 1.5 , -line * PIXS_GRID * 1.5));
            [modelSprite setDelegate:self];
            
            [spritesCtrlSheet addChild:modelSprite];
            [towerModelArray addObject:modelSprite];            
        }
    }
    
}

- (NSMutableArray *)getTowerModelArray
{
    NSArray *towerArray = [towerTypeDict allValues];
    
    NSMutableArray *modelArray = [[NSMutableArray alloc] initWithCapacity:1];
    for (int i = 0; i < towerArray.count; i++) {
        TowerInfo *towerInfo = [towerArray objectAtIndex:i];
        //升级信息
        UpgradeInfo *aUpgradeInfo = [upgradeInfoDict objectForKey:[NSString stringWithFormat:@"%d",towerInfo.number]];
        towerInfo = [TowerInfo towerInfo:towerInfo withUpgradeInfo:aUpgradeInfo];

        if(towerInfo.grade == 1){
            [modelArray addObject:towerInfo];
        }
    }
    
    return modelArray;
}

//关闭打开的建塔的模板
- (void)closeTowerModel
{
    CCSprite *aSprite = [towerModelArray objectAtIndex:0];
    [aSprite removeFromParentAndCleanup:YES];
    
    //清楚模型精灵
    for (int i = 1; i < towerModelArray.count; i++) {
        TowerModelSprite *modelInfo = [towerModelArray objectAtIndex:i];
        [modelInfo removeFromParentAndCleanup:YES];
    }
    [towerModelArray removeAllObjects];
    
    //清除模型上的价格lebal
    for (int i = 0; i < priceLabelArray.count; i++) {
        CCLabelAtlas *priceLabel = [priceLabelArray objectAtIndex:i];
        [priceLabel removeFromParentAndCleanup:YES];
    }    
    [priceLabelArray removeAllObjects];
}

//获取模板的第一个的显示的位置
- (CGPoint)getModelStartPoint:(CGPoint)tempPoint fromTowerArray:(NSArray *)towerArray
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    int startX = tempPoint.x;
    int startY = tempPoint.y;
    
    switch (towerArray.count) {
        case 1:            
            break;
        case 2:
            if(tempPoint.x + PIXS_GRID > size.width){
                startX = startX - PIXS_GRID * 1.5;
            }
            break;
        case 3:
            if (tempPoint.x - PIXS_GRID * 2 < 0) {
                startX = tempPoint.x;
            }else if(tempPoint.x + PIXS_GRID * 2 > size.width){
                startX = startX - PIXS_GRID * 3;
            }else{
                startX = startX - PIXS_GRID * 1.5;
            }
            break;
        case 4:
        case 5:
        case 6:
        case 7:
        case 8:
            if (tempPoint.x - PIXS_GRID < 0) {
                startX = tempPoint.x;
            }else if(tempPoint.x + PIXS_GRID > size.width){
                startX = startX - PIXS_GRID * 3;
            }else{
                startX = startX - PIXS_GRID * 1.5;
            }
            break;
            
    }    
    
    if(towerArray.count >= 4){
        if(tempPoint.y - PIXS_GRID * 4 < 0){
            startY = startY + PIXS_GRID * 3;
        }else{
            startY = startY - PIXS_GRID * 1.5;
        }
    }else{
        if (tempPoint.y - PIXS_GRID * 2 < 0) {
            startY = startY + PIXS_GRID * 1.5;
        }else{
            startY = startY - PIXS_GRID * 1.5;
        }
    }
  
    return ccp(startX, startY);
}

//加载地图信息
- (void)loadMapInfo
{
    tmxTiledMap = [CCTMXTiledMap tiledMapWithTMXFile:[NSString stringWithFormat:@"map_%d.tmx",curPass]];
    [self addChild:tmxTiledMap z:mapLayer];
    
    wayPointsArray = [[NSMutableArray arrayWithCapacity:2] retain];
    
    CCTMXObjectGroup *objGroup = [tmxTiledMap objectGroupNamed:@"layer_obj"];
    NSMutableArray *objArray = objGroup.objects;
        
    //点
    for (int i = 0; i < objArray.count; i++) {        
        NSDictionary *gridDict = [objArray objectAtIndex:i];
        
        WayPointInfo *pointInfo = [WayPointInfo wayPointWithPos:ccp([[gridDict valueForKey:@"x"] intValue] / WINSCALE + PIXS_GRID / 2, [[gridDict valueForKey:@"y"] intValue] / WINSCALE + PIXS_GRID / 2 + 10)];
        
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
//    CGSize size = [[CCDirector sharedDirector] winSize];
    
//    lifeLabel = [CCLabelAtlas labelWithString:@"" charMapFile:@"number_life.png" itemWidth:11 itemHeight:15 startCharMap:'0'];
//    lifeLabel.anchorPoint = ccp(0.5f, 0.5f);
//    WayPointInfo *pointInfo = [wayPointsArray objectAtIndex:(wayPointsArray.count-1)];
//    lifeLabel.position = pointInfo.position;
//    [self addChild:lifeLabel z:labelLayer];
//    [lifeLabel setString:[NSString stringWithFormat:@"%d",curLife]];
    
    goldLabel = [CCLabelAtlas labelWithString:@"" charMapFile:@"number_top_bar.png" itemWidth:15 itemHeight:19 startCharMap:'/'];
    goldLabel.anchorPoint = ccp(0, 0.5f);
    goldLabel.position = ccp(goldIcon.position.x + goldIcon.contentSize.width * 0.5f + 3, goldIcon.position.y);
    [self addChild:goldLabel z:labelLayer];
    [goldLabel setString:[NSString stringWithFormat:@"%d",curGold]];
    
    diamondLabel = [CCLabelAtlas labelWithString:@"" charMapFile:@"number_top_bar.png" itemWidth:15 itemHeight:19 startCharMap:'/'];
    diamondLabel.anchorPoint = ccp(0, 0.5f);
    diamondLabel.position = ccp(diamondIcon.position.x + diamondIcon.contentSize.width * 0.5f + 3, diamondIcon.position.y);
    [self addChild:diamondLabel z:labelLayer];
    [diamondLabel setString:[NSString stringWithFormat:@"%d", curDiamond]];
    
    waveLabel = [CCLabelAtlas labelWithString:@"" charMapFile:@"number_top_bar.png" itemWidth:15 itemHeight:19 startCharMap:'/'];
    waveLabel.anchorPoint = ccp(0, 0.5f);
    waveLabel.position = ccp(waveIcon.position.x + waveIcon.contentSize.width * 0.5f + 3, waveIcon.position.y);
    [self addChild:waveLabel z:labelLayer];
    [waveLabel setString:[NSString stringWithFormat:@"%d/%d",curWave+1,boutArray.count]];
}

- (void)initTheGame
{
    //解析enemy配置文件
    EnemyXMLParser *enemyParser = [[[EnemyXMLParser alloc] init] autorelease];
    [enemyParser parseEnemyInfo:[NSString stringWithFormat:@"pass_%d_%d",curPass,curRank]];
    
    curLife = [[enemyParser.passDict objectForKey:@"initLife"] intValue];
    curGold = [[enemyParser.passDict objectForKey:@"initGold"] intValue];
    // test
    curDiamond = 9999;
    boutArray = [[enemyParser.passDict objectForKey:@"boutArray"] retain];
    
    //解析tower的配置文件
    TowerInfoXMLParser *towerParser = [[[TowerInfoXMLParser alloc] init] autorelease];
    [towerParser parseTowerInfo:[NSString stringWithFormat:@"tower_%d",curPass]];
    towerTypeDict = [towerParser.towerDict retain];
    
    //获取升级信息
    upgradeInfoDict = [[FileUtils readUpgradeInfo] retain];
    
}

- (void) initTeachMode
{
    curLife = 9;
    curGold = 1000;
    // test
    curDiamond = 9999;
    
    //解析tower的配置文件
    TowerInfoXMLParser *towerParser = [[[TowerInfoXMLParser alloc] init] autorelease];
    [towerParser parseTowerInfo:@"tower_teach_mode"];
    towerTypeDict = [towerParser.towerDict retain];
    
    createYesPointArray = [[NSMutableArray arrayWithCapacity:2] retain];
    createNoPointArray = [[NSMutableArray arrayWithCapacity:2] retain];
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    for (int k = 1; k < size.height / PIXS_GRID; k++) {
        for (int j = 0; j < size.width / PIXS_GRID; j++) {
            CGPoint tilePos = ccp(j, k);
            
            int tiledType = 1;//1、能建；2、不能建，3、路
            
            for (int i = 1; i < 5; i++) {
                CCTMXLayer *eventLayer = [tmxTiledMap layerNamed:[NSString stringWithFormat:@"layer_%d",i]];
                if(!eventLayer){
                    break;
                }
                
                int tiledGid = [eventLayer tileGIDAt:tilePos];
                if(tiledGid == 0){
                    continue;
                }
                
                NSDictionary *propertiesDict = [tmxTiledMap propertiesForGID:tiledGid];
                
                if([propertiesDict objectForKey:@"isWater"]){
                    tiledType = 2;
                }else if([propertiesDict objectForKey:@"isBarrier"]){
                    tiledType = 2;
                    [self initStoneArray:propertiesDict tilePos:tilePos];
                }else if([propertiesDict objectForKey:@"isPath"]){
                    tiledType = 3;
                }
            }
            
            if(tiledType == 1){
                //能建
                [createYesPointArray addObject:[NSValue valueWithCGPoint:[self positionFromTilePos:tilePos]]];
            }else if (tiledType == 2){
                //不能建
                [createNoPointArray addObject:[NSValue valueWithCGPoint:[self positionFromTilePos:tilePos]]];
            }else if (tiledType == 3){
                //路
                
            }
        }
    }
    
    self.isTouchEnabled = YES;
    //加载本关卡出关信息
    [self loadWaves];
    // 开始播放音乐
    [self playLandBGM];
}

- (void)addSpriteFile
{
    CCSpriteFrameCache *framCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    
    [framCache addSpriteFramesWithFile:@"td_enemy_sprites.plist"];
    [framCache addSpriteFramesWithFile:@"td_tower_sprites.plist"];
    [framCache addSpriteFramesWithFile:@"td_bullet_sprites.plist"];
    [framCache addSpriteFramesWithFile:@"td_ctrl_sprites.plist"];
//    [framCache addSpriteFramesWithFile:@"td_frame_sprites.plist"];
    
    
    spritesEnemySheet = [CCSpriteBatchNode batchNodeWithFile:@"td_enemy_sprites.png"];
    spritesTowerSheet = [CCSpriteBatchNode batchNodeWithFile:@"td_tower_sprites.png"];
    spritesBulletSheet = [CCSpriteBatchNode batchNodeWithFile:@"td_bullet_sprites.png"];
    spritesCtrlSheet = [CCSpriteBatchNode batchNodeWithFile:@"td_ctrl_sprites.png"];
    
    [self addChild:spritesEnemySheet z:enemyLayer];
    [self addChild:spritesTowerSheet z:towerLayer];
    [self addChild:spritesBulletSheet z:bulletLayer];
    [self addChild:spritesCtrlSheet z:ctrlLayer];
    
    CGSize size = [[CCDirector sharedDirector] winSize];
    goldIcon = [CCSprite spriteWithSpriteFrameName:@"gold.png"];
    [spritesCtrlSheet addChild:goldIcon];
    goldIcon.position = ccp(PIXS_GRID / 2 + goldIcon.contentSize.width * 0.5f, size.height - PIXS_GRID / 2);
    
    diamondIcon = [CCSprite spriteWithSpriteFrameName:@"diamond.png"];
    [spritesCtrlSheet addChild:diamondIcon];
    diamondIcon.position = ccp(size.width * 0.25f + PIXS_GRID / 2, size.height - PIXS_GRID / 2);
    
    waveIcon = [CCSprite spriteWithSpriteFrameName:@"monster.png"];
    [spritesCtrlSheet addChild:waveIcon];
    waveIcon.position = ccp(size.width * 0.5f, size.height - PIXS_GRID / 2);
    
    speedIcon = [CCSprite spriteWithSpriteFrameName:@"speed.png"];
    [spritesCtrlSheet addChild:speedIcon];
    speedIcon.position = ccp(size.width * 0.75f, size.height - PIXS_GRID / 2);
    
    pauseIcon = [CCSprite spriteWithSpriteFrameName:@"pause.png"];
    [spritesCtrlSheet addChild:pauseIcon];
    pauseIcon.position = ccp(size.width - PIXS_GRID * 2.0f, size.height - PIXS_GRID / 2);
    
    settingIcon = [CCSprite spriteWithSpriteFrameName:@"setting.png"];
    [spritesCtrlSheet addChild:settingIcon];
    settingIcon.position = ccp(size.width - PIXS_GRID, size.height - PIXS_GRID / 2);
    
    // teaching mode
    if (isTeachMode) {
        teachFrame = [CCSprite spriteWithSpriteFrameName:@"teaching_frame.png"];
        [spritesCtrlSheet addChild:teachFrame];
        teachFrame.position = ccp(367, 178);
        
        teachExplain = [CCSprite spriteWithSpriteFrameName:@"teaching_explain_1.png"];
        [spritesCtrlSheet addChild:teachExplain];
        teachExplain.position = ccp(365, 210);
        
        teachHand = [CCSprite spriteWithSpriteFrameName:@"teaching_hand.png"];
        [self addChild:teachHand z:10];
        teachHand.position = ccp(220, 70);
        
        CCMoveBy *move1 = [CCMoveBy actionWithDuration:0.5f position:ccp(-15, 15)];
        CCMoveBy *move2 = [CCMoveBy actionWithDuration:0.5f position:ccp(15, -15)];
        CCSequence *seq = [CCSequence actions:move1, move2, nil];
        CCRepeatForever *repeat = [CCRepeatForever actionWithAction:seq];
        [teachHand runAction:repeat];
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

- (void)showNoCreateAnimation:(CGPoint)pos
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    if(pos.y > size.height - PIXS_GRID){
        //最上边一行不显示
        return;
    }
    
    CCSprite *aSprite = [CCSprite spriteWithSpriteFrameName:@"create_no.png"];
    aSprite.position = pos;
    [spritesCtrlSheet addChild:aSprite];
    
    CCFadeOut *fadeOut = [CCFadeOut actionWithDuration:1.0f];
    CCCallFuncO *callFun = [CCCallFuncO actionWithTarget:self selector:@selector(removeSprite:) object:aSprite];
    
    [aSprite runAction:[CCSequence actions:fadeOut,callFun, nil]];
}

- (void)removeSprite:(CCSprite *)aSprite
{
    if(aSprite){
        [aSprite removeFromParentAndCleanup:YES];
        aSprite = nil;
    }
}

- (void) gameWin
{
    if (isBGMOpen) {
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"bgm_gamewin.mp3" loop:NO];// 播放背景音
    }
    
    isGameOver = YES;
    isGameWin = YES;
    
    for (int i = 0; i < [towersArray count]; i ++) {
        TowerSprite *tempTowerSprite = [towersArray objectAtIndex:i];
        [tempTowerSprite stopAllActions];
    }
    [self unschedule:@selector(handleEnemyAppear:)];
    
    CCLayerColor *layer =[CCLayerColor layerWithColor:ccc4(0, 0, 0, 127)];
    [self addChild:layer];
    
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    
    CCSprite *winSprite2 = [CCSprite spriteWithSpriteFrameName:@"show_win_anim_1.png"];
    winSprite2.position = ccp(screenSize.width / 2, screenSize.height / 2 - 20);
    
    NSMutableArray *frameArray2 = [NSMutableArray arrayWithCapacity:2];
    for (int i = 1; i <= 5; i++) {
        CCSpriteFrame *frame = [frameCache spriteFrameByName:[NSString stringWithFormat:@"show_win_anim_%d.png", i]];
        
        [frameArray2 addObject:frame];
    }
    
    CCSpriteFrame *rewardFrame = [frameCache spriteFrameByName:[NSString stringWithFormat:@"rotation_light.png"]];
    [frameArray2 addObject:rewardFrame];
    
    CCAnimation *animation2 = [CCAnimation animationWithFrames:frameArray2 delay:0.2f];
    CCAnimate *animate2 = [CCAnimate actionWithAnimation:animation2 restoreOriginalFrame:NO];
    CCCallFunc *callFunc = [CCCallFunc actionWithTarget:self selector:@selector(callFuncShowGameWin)];
    CCRotateBy *rotationLight = [CCRotateBy actionWithDuration:10 angle:180.0f];
    CCSequence *seq = [CCSequence actions:animate2, callFunc, rotationLight, nil];
//    CCRepeatForever *repeat = [CCRepeatForever actionWithAction:seq];
    [winSprite2 runAction:seq];
    [spritesCtrlSheet addChild:winSprite2 z:4];
    
}

- (void) callFuncShowGameWin
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
        
    CCSprite *winSprite1 = [CCSprite spriteWithSpriteFrameName:@"gameover_anim_1.png"];
    winSprite1.position = ccp(screenSize.width / 2, screenSize.height / 2 - 20);
    
    CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    NSMutableArray *frameArray1 = [NSMutableArray arrayWithCapacity:2];
    for (int i = 1; i <= 6; i++) {
        CCSpriteFrame *frame = [frameCache spriteFrameByName:[NSString stringWithFormat:@"gameover_anim_%d.png", i]];
        
        [frameArray1 addObject:frame];
    }
    
    CCAnimation *animation1 = [CCAnimation animationWithFrames:frameArray1 delay:0.2f];
    CCAnimate *animate1 = [CCAnimate actionWithAnimation:animation1 restoreOriginalFrame:NO];
    CCCallFunc *callFunc = [CCCallFunc actionWithTarget:self selector:@selector(callFuncShowReceived)];
    CCSequence *seq = [CCSequence actions:animate1, callFunc, nil];
    [winSprite1 runAction:seq];
    [spritesCtrlSheet addChild:winSprite1 z:5];
}

- (void) callFuncShowReceived
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
    CCSprite *prompt = [CCSprite spriteWithSpriteFrameName:@"rank_hard.png"];
    prompt.position = ccp(screenSize.width / 2, screenSize.height / 2 + 65);
    [spritesCtrlSheet addChild:prompt z:5];
    
    CCSprite *winSpriteReceived = [CCSprite spriteWithSpriteFrameName:@"gameover_reward.png"];
    winSpriteReceived.position = ccp(screenSize.width / 2, screenSize.height / 2 - 35);
    [spritesCtrlSheet addChild:winSpriteReceived z:5];
    
    CCLabelAtlas *received = [CCLabelAtlas labelWithString:@"000.0" charMapFile:@"number_gameover_reward.png" itemWidth:17 itemHeight:22 startCharMap:'0'];
    received.anchorPoint = ccp(0, 0.5f);
    received.position = ccp(screenSize.width / 2 - 10, screenSize.height / 2 - 35);
    
    [received setString:@"300"];//[NSString stringWithFormat:@"300"]
    [self addChild:received z:5];
    
}

- (void) gameOver
{
    isGameOver = YES;
    for (int i = 0; i < [enemysArray count]; i ++) {
        EnemySprite *tempEnemySprite = [enemysArray objectAtIndex:i];
        [tempEnemySprite stopMove];
        [tempEnemySprite stopAllActions];
    }
    
    for (int i = 0; i < [towersArray count]; i ++) {
        TowerSprite *tempTowerSprite = [towersArray objectAtIndex:i];
        [tempTowerSprite stopAllActions];
    }
    [self unschedule:@selector(handleEnemyAppear:)];
    
    CCLayerColor *layer =[CCLayerColor layerWithColor:ccc4(0, 0, 0, 127)];
    [self addChild:layer];
    
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    
    CCSprite *gameOverSprite = [CCSprite spriteWithSpriteFrameName:@"gameover_fail_btn_1.png"];
    gameOverSprite.position = ccp(screenSize.width / 2, screenSize.height + gameOverSprite.contentSize.height / 2);
    
    CCSprite *prompt = [CCSprite spriteWithSpriteFrameName:@"rank_hard.png"];
    prompt.position = ccp(gameOverSprite.contentSize.width / 2, gameOverSprite.contentSize.height + 40);
    [gameOverSprite addChild:prompt];
    
    CCMoveTo *gameOverMove1 = [CCMoveTo actionWithDuration:0.3f position:CGPointMake(screenSize.width / 2, screenSize.height / 2 - 50)];
    CCMoveTo *gameOverMove2 = [CCMoveTo actionWithDuration:0.1f position:CGPointMake(screenSize.width / 2, screenSize.height / 2 - 45)];
    CCMoveTo *gameOverMove3 = [CCMoveTo actionWithDuration:0.1f position:CGPointMake(screenSize.width / 2, screenSize.height / 2 - 50)];
    CCCallFunc *callFunc = [CCCallFunc actionWithTarget:self selector:@selector(showFailResult)];
    CCSequence *gameOverSeq = [CCSequence actions:gameOverMove1, gameOverMove2, gameOverMove3, callFunc, nil];
    [gameOverSprite runAction:gameOverSeq];
    [spritesCtrlSheet addChild:gameOverSprite z:5];
    
}

- (void) playDefaultBGM
{
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    if (isSoundOpen) {
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"bgm_default.mp3" loop:YES];// 播放背景音
    }
    
}

- (void) playLandBGM
{
    [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
    if (isBGMOpen) {
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:[NSString stringWithFormat:@"bgm_land_%d.mp3", curLand] loop:YES];// 播放背景音
    }
}

- (void) showFailResult
{
    CGSize screenSize = [[CCDirector sharedDirector] winSize];
    CCSprite *result = [CCSprite spriteWithSpriteFrameName:@"fail_prompt.png"];
    result.position = ccp(screenSize.width / 2, screenSize.height / 2 - 35);
    
    CCFadeIn *fadeIn = [CCFadeIn actionWithDuration:1.0f];
    [result runAction:fadeIn];
    [spritesCtrlSheet addChild:result z:5];
    
    CCLabelAtlas *received = [CCLabelAtlas labelWithString:@"" charMapFile:@"number_fail.png" itemWidth:17 itemHeight:22 startCharMap:'/'];
    received.anchorPoint = ccp(0, 0.5f);
    received.position = ccp(screenSize.width / 2 - 12, screenSize.height / 2 - 35);
    [received runAction:fadeIn];
    
    [received setString:[NSString stringWithFormat:@"%d/%d", curWave - 1, boutArray.count]];
    [self addChild:received];
}

#pragma TowerSpriteDelegate

- (void)onTowerLaunchBullet:(id)sender withTowerNumber:(int)towerNumber
{
    if(!bulletArray){
        bulletArray = [[NSMutableArray alloc] initWithCapacity:2];
    }
    
    BulletSprite *bulletSprite = (BulletSprite *)sender;
    [bulletSprite setDelegate:self];    
    
    [spritesBulletSheet addChild:bulletSprite];
    [bulletArray addObject:sender];
    if (isSoundOpen) {
        [[SimpleAudioEngine sharedEngine]playEffect:[NSString stringWithFormat:@"tower_attack_effect_%d.caf", towerNumber]];// 播放攻击音效
    }

}

#pragma end

#pragma TowerModelDelegate

- (void)onAddPriceLabel:(CCLabelAtlas *)priceLabel
{
    if (!priceLabelArray) {
        priceLabelArray = [[NSMutableArray alloc] initWithCapacity:1];
    }
    
    [priceLabelArray addObject:priceLabel];
    [self addChild:priceLabel z:labelLayer];
}

#pragma end

#pragma BulletSpriteDelegate

- (void)onRemoveBullet:(id)sender
{
    if (bulletArray) {
        [bulletArray removeObject:sender];
    }
}

#pragma end


#pragma EnemySpriteDelegate

- (void)onRemoveEnemy:(id)sender
{
    EnemySprite *enemySprite = (EnemySprite *)sender;

    [enemysArray removeObject:sender];
    enemySprite.enemyInfo.curHp = 0;
    [self checkEnemyDie];
    [enemySprite.bloodFrame removeFromParentAndCleanup:YES];
    [enemySprite.bloodProgress removeFromParentAndCleanup:YES];
    
    curLife = curLife - 1;
    [self lossHpAnimat];
    [lifeLabel setString:[NSString stringWithFormat:@"%d",curLife]];
    
    
    if (curLife == 0) {
        [self gameOver];
    }
}

- (void)onAddEnemyBloodBg:(id)sender
{
    [self addChild:sender z:progressLayer];
}

- (void)onAddEnemyBloodProgress:(id)sender
{
    [self addChild:sender z:progressLayer];
}

- (void) onEnemyDead:(EnemySprite *)sender
{
//    //更新金币数量
//    curGold = curGold + sender.enemyInfo.award;
//    [goldLabel setString:[NSString stringWithFormat:@"%d",curGold]];
//    
//    //如果建造模板显示，检测原本不能建塔的是否能建塔
//    if (towerModelArray.count > 0){
//        for (int i = 1; i < towerModelArray.count; i++) {
//            TowerModelSprite *modelSprite = [towerModelArray objectAtIndex:i];
//            if(!modelSprite.isGoldEnough && curGold >= modelSprite.towerPrice){
//                [modelSprite shiftSprite];
//            }
//        }
//    }
//    
//    CGPoint position = ccpAdd(sender.position, ccp(0, 20));
//    NSMutableArray *paramArray = [NSMutableArray arrayWithCapacity:2];
//    [paramArray addObject:[NSValue valueWithCGPoint:position]];
//    [paramArray addObject:[NSString stringWithFormat:@"/%d",sender.enemyInfo.award]];
//    
//    //显示金币掉落效果
//    [self showGlodDrapAnimation:paramArray];
//    
//    [enemysArray removeObject:sender];
//    
//    [self checkEnemyDie];
//    
//    [sender.bloodFrame removeFromParentAndCleanup:YES];
//    [sender.bloodProgress removeFromParentAndCleanup:YES];
//    [sender removeFromParentAndCleanup:YES];
//    
//    if(curWave == boutArray.count && enemysArray.count == 0){
//        if (curLife > 0) {
//            [self gameWin];
//        } else {
//            [self gameOver];
//        }
//    }
}

#pragma end


#pragma StoneDelegate

- (void)onAddStoneBloodBg:(CCSprite *)aSprite
{
    [self addChild:aSprite z:progressLayer];
    aSprite.visible = NO;
}

- (void)onAddStoneBloodProgress:(CCProgressTimer *)aProgress
{    
    [self addChild:aProgress z:progressLayer];
    aProgress.visible = NO;
}

#pragma end
@end
