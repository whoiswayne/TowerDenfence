//
//  self.m
//  TowerDefence
//
//  Created by mir-macmini5 on 13-3-28.
//
//

#import "TowerSprite.h"
#import "BulletSprite.h"

#import "SimpleAudioEngine.h"


/*
 * tower命名规则：tower_类别_级别_方向(_att).png
 * 模板：tower_类别_model.png
 */
@interface TowerSprite(Private)

- (id)initWithTowerInfo:(TowerInfo *)aTowerInfo upgradeInfo:(UpgradeInfo *) aUpgradeInfo;

- (void)rotateTower:(CGPoint)targetPos;

- (void)showAttackAnim:(CGPoint)targetPos;

- (int)getAngle:(CGPoint)targetPos;

- (CGPoint)getBulletOriginalPos:(CGPoint)targetPos;

- (void)createABullet:(CGPoint)tempPos;

- (CGPoint) getMultiBullet:(int)aAngle;

// 塔发射子弹
- (void)towerLanuchBullet;


@end

@implementation TowerSprite

@synthesize delegate;
//@synthesize isExistsAttackTarget;
@synthesize towerInfo;
@synthesize targetPoint;
@synthesize enemyArray;

+ (TowerSprite *)towerSpriteWithTowerInfo:(TowerInfo *)aTowerInfo upgradeInfo:(UpgradeInfo *) aUpgradeInfo
{
    return [[[self alloc] initWithTowerInfo:aTowerInfo upgradeInfo: aUpgradeInfo] autorelease];
}

- (id)initWithTowerInfo:(TowerInfo *)aTowerInfo upgradeInfo:(UpgradeInfo *) aUpgradeInfo
{
    self = [super init];
    if (self) {
        towerInfo = [aTowerInfo retain];
        upgradeInfo = [aUpgradeInfo retain];
        
        bulletTargetPoint = CGPointZero;        
        targetPoint = CGPointZero;
        enemyArray = [[NSMutableArray alloc] initWithCapacity:2];
        
        NSString *frameName = nil;
        
//        if (towerInfo.number == 1 || towerInfo.number == 2 || towerInfo.number == 3 || towerInfo.number == 4) {
        frameName = [NSString stringWithFormat:@"tower_%d_%d_0.png",towerInfo.number,towerInfo.grade];
//        }
        
//        if(towerInfo.number == 5 || towerInfo.number == 9){
//            //无旋转效果
//            frameName = [NSString stringWithFormat:@"tower_%d.png",towerInfo.number];
//        }else{
//            //有旋转效果
//            if(towerInfo.number == 1 || towerInfo.number == 3 || towerInfo.number == 4){
//                frameName = [NSString stringWithFormat:@"tower_%d_%d_0.png",towerInfo.number,towerInfo.grade];
//            }else{
//                frameName = [NSString stringWithFormat:@"tower_%d_001.png",towerInfo.number];
//            }
//        }
        
        [super initWithSpriteFrameName:frameName];
        
        [[SimpleAudioEngine sharedEngine] preloadEffect:[NSString stringWithFormat:@"tower_attack_effect_%d.caf", towerInfo.number]];// 预先加载音效
        
        [self schedule:@selector(checkExistsTarget) interval:RATE_SPEED];
    }
    return self;
}

- (void)dealloc
{
    [self unscheduleAllSelectors];
        
    if(towerInfo){
        [towerInfo release];
        towerInfo = nil;
    }
    
    if(upgradeInfo){
        [upgradeInfo release];
        upgradeInfo = nil;
    }
    
    if(enemyArray){
        [enemyArray removeAllObjects];
        [enemyArray release];
        enemyArray = nil;
    }
    
    [super dealloc];
}

- (void) stopAllActions
{
    [super stopAllActions];
    [self unscheduleAllSelectors];
}

- (void) restartAllActions
{
    
    [self schedule:@selector(checkExistsTarget) interval:RATE_SPEED];
}

- (void)checkExistsTarget
{    
    if (enemyArray.count <= 0 && CGPointEqualToPoint(targetPoint, CGPointZero)) {
        return;
    }
    
    [self towerLanuchBullet];
}

// 根据怪物的坐标计算子弹能够飞往最大射程的坐标
- (void)attackWithTargetPos:(CGPoint)tempPos
{
    // tempPos是怪物的坐标
    // 怪物和塔的距离
    double tempLength =  sqrt(pow((tempPos.x - self.position.x), 2) + pow((tempPos.y - self.position.y), 2));
    // 最大射程距离
    float maxLength = towerInfo.gunshot;
    float x = ((tempPos.x - self.position.x) * maxLength + self.position.x * tempLength) / tempLength;
    float y = ((tempPos.y - self.position.y) * maxLength + self.position.y * tempLength) / tempLength;
    bulletTargetPoint = ccp(x, y);
}

- (void)towerLanuchBullet
{
    if ([[NSDate date] timeIntervalSince1970] - prepareTime <= 1.0f / towerInfo.attackSpeed) {
        return;
    }
    
    prepareTime = [[NSDate date] timeIntervalSince1970];    
    CGPoint tempPos = bulletTargetPoint;
    
    //旋转
    [self rotateTower:tempPos];

    //显示塔的攻击效果
    [self showAttackAnim:tempPos];
    
    if(towerInfo.number == 4){
        float gunshot = towerInfo.gunshot;
        [self createABullet:ccpAdd(self.position, ccp(-gunshot, gunshot))];
        [self createABullet:ccpAdd(self.position, ccp(-gunshot, 0))];
        [self createABullet:ccpAdd(self.position, ccp(-gunshot, -gunshot))];
        [self createABullet:ccpAdd(self.position, ccp(0, gunshot))];
        [self createABullet:ccpAdd(self.position, ccp(0, -gunshot))];
        [self createABullet:ccpAdd(self.position, ccp(gunshot, gunshot))];
        [self createABullet:ccpAdd(self.position, ccp(gunshot, 0))];
        [self createABullet:ccpAdd(self.position, ccp(gunshot, -gunshot))];
    }else if(towerInfo.number == 1 && upgradeInfo.upgrade3_1 == 1 && towerInfo.grade == 3){
        // 3级章鱼塔升级4技能之后有散射攻击
        CGPoint rightPoint = [self getMultiBullet:30];
        CGPoint leftPoint = [self getMultiBullet:-30];
        
        [self createABullet:tempPos];
        [self createABullet:rightPoint];
        [self createABullet:leftPoint];
    }else{
        [self createABullet:tempPos];
    }
}

- (CGPoint) getMultiBullet:(int)aAngle
{
    // 怪物与水平方向的夹角 弧度
    float a;
    if (bulletTargetPoint.x <= self.position.x) {
        a = M_PI - asin((bulletTargetPoint.y - self.position.y) / towerInfo.gunshot);
    } else {
        a = 2 * M_PI + asin((bulletTargetPoint.y - self.position.y) / towerInfo.gunshot);
        if (a >= 2 * M_PI) {
            a -= 2 * M_PI;
        }
    }
    
    float rightAngle = a + aAngle * M_PI / 180;// 右侧散弹的角度(弧度)
    if (rightAngle >= 2 * M_PI) {
        rightAngle -= 2 * M_PI;
    }
    
    float y;
    y = self.position.y + sin(rightAngle) * towerInfo.gunshot;
    
    float x;
    x = self.position.x + cos(rightAngle) * towerInfo.gunshot;
    
    return ccp(x, y);
}

- (void)createABullet:(CGPoint)tempPos
{
    BulletInfo *bulletInfo = [BulletInfo bulletInfoWithTowerInfo:towerInfo targetpos:tempPos];
    BulletSprite *bulletSprite = [BulletSprite bulletSpriteWithBulletInfo:bulletInfo originalPos:[self getBulletOriginalPos:tempPos]];
    bulletSprite.targetPoint = targetPoint;
    
    if (delegate && [delegate respondsToSelector:@selector(onTowerLaunchBullet:withTowerNumber:)]) {
        [delegate onTowerLaunchBullet:bulletSprite withTowerNumber:towerInfo.number];
//        [[SimpleAudioEngine sharedEngine]playEffect:[NSString stringWithFormat:@"tower_attack_effect_%d.caf", towerInfo.number]];// 播放攻击音效
    }
}

//微调子弹的开始位置
- (CGPoint)getBulletOriginalPos:(CGPoint)targetPos
{
    CGPoint normalized = ccpNormalize(ccpSub(targetPos, self.position));
    
    int angle = [self getAngle:targetPos];
    int aAngle = angle < 0 ? -angle : angle;
    
    CGPoint tempPoint = self.position;
    if(aAngle > 9){
        tempPoint = ccpAdd(tempPoint, ccpMult(normalized, 20));
    }else if(aAngle > 5){
        if(angle < 0){
            tempPoint = ccpAdd(tempPoint, ccp(20, 0));
        }else{
            tempPoint = ccpAdd(tempPoint, ccp(-20, 0));
        }
    }else if(aAngle == 5){
        if(angle < 0){
            tempPoint = ccpAdd(tempPoint, ccp(16, -1));
        }else{
            tempPoint = ccpAdd(tempPoint, ccp(-16, -1));
        }
    }else if(aAngle == 4){
        if(angle < 0){
            tempPoint = ccpAdd(tempPoint, ccp(12, -2));
        }else{
            tempPoint = ccpAdd(tempPoint, ccp(-12, -2));
        }
    }else if(aAngle == 3){
        if(angle < 0){
            tempPoint = ccpAdd(tempPoint, ccp(8, -3));
        }else{
            tempPoint = ccpAdd(tempPoint, ccp(-20, -3));
        }
    }else if(aAngle == 2){
        if(angle < 0){
            tempPoint = ccpAdd(tempPoint, ccp(4, -2));
        }else{
            tempPoint = ccpAdd(tempPoint, ccp(-4, -2));
        }   
    }else{
        tempPoint = ccpSub(tempPoint, ccp(0, 5));
    }
    
    return tempPoint;
}

- (void)rotateTower:(CGPoint)targetPos
{
    if(towerInfo.number == 4){
        //无旋转效果
        return;
    }
    
    CGPoint tempPos = self.position;
    
    int angle = [self getAngle:targetPos];
    int aAngle = angle < 0 ? -angle : angle;
    NSString *frameName = nil;
    if(towerInfo.number == 1 || towerInfo.number == 2 || towerInfo.number == 3){
//        self = [[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"tower_%d_%d_%d.png", towerInfo.number, towerInfo.grade, aAngle]] retain];
        frameName = [NSString stringWithFormat:@"tower_%d_%d_%d.png", towerInfo.number, towerInfo.grade, aAngle];
    }else{
//        self = [[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"tower_%d_%03d.png",towerInfo.number,aAngle]] retain];
         frameName = [NSString stringWithFormat:@"tower_%d_%03d.png", towerInfo.number, aAngle];
    }
    
    if(angle > 0){
        //水平翻转
        self.flipX = YES;
    } else {
        self.flipX = NO;
    }
    
    self.position = tempPos;
    
    CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
    [self setDisplayFrame:frame];
}

- (void)removeSprite:(CCNode *)aNode
{
    if(aNode){
        [aNode removeFromParentAndCleanup:YES];
        aNode = nil;
    }
}

// 显示塔攻击的效果
- (void)showAttackAnim:(CGPoint)targetPos
{
    if(towerInfo.number != 1 && towerInfo.number != 2 && towerInfo.number != 3 && towerInfo.number != 4){
        return;
    }
        
    CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    NSMutableArray *frameArray = [NSMutableArray arrayWithCapacity:1];
    
    CCAnimation *animation = nil;
    if(towerInfo.number == 4){
        for (int i = 1; i < 4; i++) {
            CCSpriteFrame *frame = [frameCache spriteFrameByName:[NSString stringWithFormat:@"tower_%d_%d_%d.png",towerInfo.number,towerInfo.grade,i]];
            [frameArray addObject:frame];            
        }
        animation = [CCAnimation animationWithFrames:frameArray delay:0.05f];
    }else{
        int angle = [self getAngle:targetPos];
        int aAngle = angle > 0 ? angle : -angle;
        CCSpriteFrame *frame = [frameCache spriteFrameByName:[NSString stringWithFormat:@"tower_%d_%d_%d_att.png", towerInfo.number, towerInfo.grade, aAngle]];
        
        [frameArray addObject:frame];
        
        animation = [CCAnimation animationWithFrames:frameArray delay:0.3f];
    }
    
    CCAnimate *animate = [CCAnimate actionWithAnimation:animation];
    [self runAction:animate];
}

- (int)getAngle:(CGPoint)targetPos
{
    CGPoint normalized = ccpNormalize(ccpSub(targetPos, self.position));
    int angle = 0;
    int degree = (CC_RADIANS_TO_DEGREES(atan2(normalized.y, -normalized.x)) + 90) / 10;
    
    if(degree > 18){
        degree = degree - 36;
    }
    if(degree < 0){
        angle = degree - 1;
    }else{
        angle = degree;
    }
    return angle;
}

@end
