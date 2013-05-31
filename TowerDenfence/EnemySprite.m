//
//  Enemy.m
//  TowerDenfence
//
//  Created by mir-macmini5 on 13-4-16.
//
//

#import "EnemySprite.h"
#import "GameLayer.h"
#import "SimpleAudioEngine.h"

@interface EnemySprite(Private)

- (void) setCurSpeed;

- (void) updateself:(CGPoint)curPoint withTarget:(CGPoint)targetPoint;
- (void) removeTankSprite;
- (int) getEnemyDirection:(CGPoint)tempPoint;
- (void) portalAnimateOver;
- (void) onFiring;

@end

@implementation EnemySprite

@synthesize bloodProgress;
@synthesize bloodFrame;
@synthesize delegate;
@synthesize enemyInfo;
@synthesize listenTowerArray;
@synthesize isFiring;
@synthesize firingDuration;
@synthesize isSlowDown;

+ (id)enemyWithEnemyInfo:(EnemyInfo *)info withWayPoints:(NSMutableArray *)pointArray
{
    return [[[self alloc] initWithEnemyInfo:info withWayPoints:pointArray] autorelease];
}

- (id)initWithEnemyInfo:(EnemyInfo *)info withWayPoints:(NSMutableArray *)pointArray
{
    if((self = [super init])){
        wayPiontArray = pointArray;
        listenTowerArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        curPos = [wayPiontArray objectAtIndex:0];
        targetPos = curPos.nextPoint;
        
        isStopMove = NO;
        isShowPortal = NO;
        
        enemyInfo  = [info retain];
        
        
        
//        CGPoint tempPoint = ccpSub(targetPos.position, curPos.position);
//        [super initWithSpriteFrameName:[NSString stringWithFormat:@"enemy_%d_%d3.png",enemyInfo.number,[self getEnemyDirection:tempPoint]]];
        [super initWithSpriteFrameName:[NSString stringWithFormat:@"portal_1.png"]];
        
        [[SimpleAudioEngine sharedEngine] preloadEffect:[NSString stringWithFormat:@"enemy_dead_%d_1.caf", enemyInfo.number]];// 预先加载音效
        if (enemyInfo.number <= 4) {
            [[SimpleAudioEngine sharedEngine] preloadEffect:[NSString stringWithFormat:@"enemy_dead_%d_2.caf", enemyInfo.number]];
        }

        frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];

        [self updateself:curPos.position withTarget:targetPos.position];
        
//        [self schedule:@selector(updatePosition:) interval:RATE_SPEED];
    }
    return self;
}

- (void)dealloc
{
    [self unscheduleAllSelectors];
        
//    if(bloodFrame){
//        [bloodFrame removeFromParentAndCleanup:YES];
//        bloodFrame = nil;
//    }
//    
//    if(bloodProgress){
//        [bloodProgress removeFromParentAndCleanup:YES];
//        bloodProgress = nil;
//    }
    
    if(enemyInfo){
        [enemyInfo release];
        enemyInfo = nil;
    }
    
    if(listenTowerArray){
        [listenTowerArray removeAllObjects];
        [listenTowerArray release];
        listenTowerArray = nil;
    }
    
    [super dealloc];
}

- (void)setDelegate:(id<EnemySpriteDelegate>)aDelegate
{
    delegate = aDelegate;
    // 血量条背景
    bloodFrame = [[CCSprite spriteWithFile:@"blood_frame.png"] retain];
//    bloodFrame.position = ccpAdd(self.position, ccp(0, self.contentSize.height/2));
    // 血量条的大小根据图像的实际高度计算
    bloodFrame.position = ccpAdd(self.position, ccp(0, 25));
    
    if (delegate && [delegate respondsToSelector:@selector(onAddEnemyBloodBg:)]) {
        [delegate onAddEnemyBloodBg:bloodFrame];
    }
    
    // 血条
    bloodProgress = [[CCProgressTimer progressWithFile:@"blood.png"] retain];
    bloodProgress.type = kCCProgressTimerTypeHorizontalBarLR;
    bloodProgress.percentage = 100;
    bloodProgress.position = bloodFrame.position;
    
    if (delegate && [delegate respondsToSelector:@selector(onAddEnemyBloodProgress:)]) {
        [delegate onAddEnemyBloodProgress:bloodProgress];
    }
    
}

- (void) stopMove
{
    isStopMove = YES;
}

- (void) restartMove
{
    isStopMove = NO;
}

- (void)doSlowDown:(float)aRate slowTime:(float)aTime
{
    if(aRate > 0){
        slowRate = aRate;
        slowTime = aTime;
        
        isSlowDown =  YES;
        indexSlowTime = 0;
    }
}


- (void)updatePosition:(ccTime)dt
{
    if (isStopMove) {
        return;
    }
    
    [self setCurSpeed];

    if(self.position.x == targetPos.position.x && self.position.y == targetPos.position.y){
        if(targetPos.nextPoint){
            targetPos = targetPos.nextPoint;
            [self updateself:self.position withTarget:targetPos.position];
        }else{
            [self removeTankSprite];
        }
    }
    
    CGPoint normalized = ccpNormalize(ccp(targetPos.position.x - self.position.x,targetPos.position.y - self.position.y));
    
    CGPoint deltaPoint = ccpSub(targetPos.position, self.position);
    
    //每次更新x,y方向的偏移量
    float deltaX = normalized.x * enemyInfo.curSpeed * RATE_SPEED;
    float deltaY = normalized.y * enemyInfo.curSpeed * RATE_SPEED;
    
    CGPoint newPos = self.position;
    
    if((deltaPoint.x > 0 && deltaPoint.x < deltaX && deltaPoint.y == 0) || (deltaPoint.x == 0 && deltaPoint.y > 0 && deltaPoint.y < deltaY)){
        //此次更新的偏移量小于正常值
        newPos = ccp(self.position.x + deltaPoint.x, self.position.y + deltaPoint.y);
    }else{
        //正常更新
        newPos = ccp(self.position.x + deltaX, self.position.y + deltaY);
    }
    
    self.position = newPos;
//    bloodFrame.position = ccpAdd(self.position, ccp(0, self.contentSize.height/2));
    bloodFrame.position = ccpAdd(self.position, ccp(0, 25));
    bloodProgress.position = bloodFrame.position;
}

- (void)setCurSpeed
{
    if(isSlowDown){
        indexSlowTime ++;
        if (indexSlowTime >= slowTime * 60) {
            indexSlowTime = 0;
            isSlowDown = NO;
        }
        
        int tempSpeed = enemyInfo.curSpeed * (1 - slowRate);
        if(enemyInfo.curSpeed == enemyInfo.maxSpeed && tempSpeed < enemyInfo.curSpeed){
            //减速
            enemyInfo.curSpeed = enemyInfo.curSpeed * (1 - slowRate);
            //反应UI
            slowSprite = [CCSprite spriteWithSpriteFrameName:@"enemy_slow.png"];
            slowSprite.position = ccp(self.contentSize.width * 0.5f, self.contentSize.height * 0.25f);
            [self addChild:slowSprite];
        }
    }else{
        //回复速度
        enemyInfo.curSpeed = enemyInfo.maxSpeed;
        [slowSprite removeFromParentAndCleanup:YES];
        slowSprite = nil;
    }
}

- (void)updateself:(CGPoint)curPoint withTarget:(CGPoint)targetPoint
{
    subPoint = ccpSub(targetPoint, curPoint);
    
    self.position = curPoint;
    
    //test
    int index = 0;
    int maxAnimation = 3;
    if (enemyInfo.number == 6 || enemyInfo.number == 8 || enemyInfo.number == 9 || enemyInfo.number == 12 || enemyInfo.number == 13) {
        maxAnimation = 1;
    }
//    if(enemyInfo.number == 1 || enemyInfo.number == 2){
//        index = 0;
//    }
    
    if (!isShowPortal) {
        NSMutableArray *portalArray = [NSMutableArray arrayWithCapacity:2];
        
        for (int i = 1; i <= 4; i++) {
            CCSpriteFrame *frame = [frameCache spriteFrameByName:[NSString stringWithFormat:@"portal_%d.png", i]];
            [portalArray addObject:frame];
        }
        
        CCAnimation *portalAnimation = [CCAnimation animationWithFrames:portalArray delay:0.1f];
        CCAnimate *portalAnimate = [CCAnimate actionWithAnimation:portalAnimation];
        CCCallFunc *callFunc = [CCCallFuncN actionWithTarget:self selector:@selector(portalAnimateOver)];
        CCSequence *seq = [CCSequence actions:portalAnimate, callFunc, nil];
        [self runAction:seq];
        isShowPortal = YES;
        return;
    }
    
    NSMutableArray *frameArray = [NSMutableArray arrayWithCapacity:2];
    for (int i = index; i <= maxAnimation; i++) {
        CCSpriteFrame *frame = [frameCache spriteFrameByName:[NSString stringWithFormat:@"enemy_%d_%d%d.png",enemyInfo.number,[self getEnemyDirection:subPoint],i]];
        
        [frameArray addObject:frame];
    }
    
    CCAnimation *animation = [CCAnimation animationWithFrames:frameArray delay:0.2f];
    CCAnimate *animate = [CCAnimate actionWithAnimation:animation];
    CCRepeatForever *repeatAction = [CCRepeatForever actionWithAction: animate];
    
    [self runAction:repeatAction];
    
}

//- (void) startFiring
//{
//    if (isFiring) {
//        firingDuration = 10;
//        [self unschedule:@selector(onFiring)];
//        [self schedule:@selector(onFiring) interval:1.0f];
//    } else {
//        isFiring = YES;
//        ccColor3B red = ccc3(255, 0, 0);
//        [self setColor:red];
//        enemyInfo.curHp -= 10;
//        firingDuration = 10;
//        
//        [self schedule:@selector(onFiring) interval:1.0f];
//    }
//}

- (void) onFiring
{
    firingDuration -= 1;
    enemyInfo.curHp -= 10;
    self.enemyInfo.curHp = self.enemyInfo.curHp - 10;
    if(self.enemyInfo.curHp > 0){
        self.bloodProgress.percentage = self.enemyInfo.curHp * 100 / self.enemyInfo.maxHp;
    } else {
        // enemy dead
        return;
    }
    
    if (firingDuration <= 0) {
        [self setColor:ccc3(255, 255, 255)];
    } else {
        
        [self schedule:@selector(onFiring) interval:1.0f];
    }
//    else{
//        //更新金币数量
//        curGold = curGold + enemySprite.enemyInfo.award;
//        [goldLabel setString:[NSString stringWithFormat:@"%d",curGold]];
//        
//        //如果建造模板显示，检测原本不能建塔的是否能建塔
//        if (towerModelArray.count > 0){
//            for (int i = 1; i < towerModelArray.count; i++) {
//                TowerModelSprite *modelSprite = [towerModelArray objectAtIndex:i];
//                if(!modelSprite.isGoldEnough && curGold >= modelSprite.towerPrice){
//                    [modelSprite shiftSprite];
//                }
//            }
//        }
//        
//        CGPoint position = ccpAdd(enemySprite.position, ccp(0, 20));
//        NSMutableArray *paramArray = [NSMutableArray arrayWithCapacity:2];
//        [paramArray addObject:[NSValue valueWithCGPoint:position]];
//        [paramArray addObject:[NSString stringWithFormat:@"/%d",enemySprite.enemyInfo.award]];
//        
//        //显示金币掉落效果
//        [self showGlodDrapAnimation:paramArray];
//        
//        [enemysArray removeObject:enemySprite];
//        
//        [self checkEnemyDie];
//        
//        [enemySprite.bloodFrame removeFromParentAndCleanup:YES];
//        [enemySprite.bloodProgress removeFromParentAndCleanup:YES];
//        [enemySprite removeFromParentAndCleanup:YES];
//        
//        if(curWave == boutArray.count && enemysArray.count == 0){
//            if (curLife > 0) {
//                [self gameWin];
//            } else {
//                [self gameOver];
//            }
//        }
//    }
    
    
}

- (void) portalAnimateOver
{
    [self updateself:curPos.position withTarget:targetPos.position];
    [self schedule:@selector(updatePosition:) interval:RATE_SPEED];
    
    
}

- (void) startAnimation
{
    
}

- (void) stopAnimation
{
    
}

- (void)removeTankSprite
{
    if(delegate && [delegate respondsToSelector:@selector(onRemoveEnemy:)]){
        
        [delegate onRemoveEnemy:self];
    }
    
    [[CCScheduler sharedScheduler] unscheduleSelector:@selector(updatePosition:) forTarget:self];
    
    if(bloodFrame){
        [bloodFrame removeFromParentAndCleanup:YES];
        bloodFrame = nil;
    }
    
    if(bloodProgress){
        [bloodProgress removeFromParentAndCleanup:YES];
        bloodProgress = nil;
    }
}

//获取敌人当前运行的方向(0:向左，1:向下，2:向右，3:向上)
- (int)getEnemyDirection:(CGPoint)tempPoint
{
    if(tempPoint.x < 0 && tempPoint.y == 0){
        return 0;
    }else if(tempPoint.x > 0 && tempPoint.y == 0){
        return 2;
    }else if(tempPoint.x == 0 && tempPoint.y < 0){
        return 1;
    }else if(tempPoint.x == 0 && tempPoint.y > 0){
        return 3;
    }else {
        return 1;
    }
}

@end
