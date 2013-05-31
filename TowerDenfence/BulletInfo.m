//
//  BulletInfo.m
//  TowerDenfence
//
//  Created by mir-macmini5 on 13-4-16.
//
//

#import "BulletInfo.h"

@interface BulletInfo(Private)

- (id)initWithTowerInfo:(TowerInfo *)towerInfo targetpos:(CGPoint)aTargetPos;

@end

@implementation BulletInfo

@synthesize targetPoint;
@synthesize number;
@synthesize grade;
@synthesize attackPower;
@synthesize gunshot;
@synthesize pierceEnemyNumber;

@synthesize firstHitEnemyIdx;
@synthesize secondHitEnemyIdx;

@synthesize critRate;
@synthesize slowRate;
@synthesize slowTime;

@synthesize multiAttack; // 多重攻击
@synthesize isFiring; // 是否有灼烧伤害
@synthesize isAttactUnslowedEnemy; // 是否会攻击已减速的敌人

@synthesize isExplosion; // 是否可以爆炸

+ (id)bulletInfoWithTowerInfo:(TowerInfo *)towerInfo targetpos:(CGPoint)aTargetPos
{
    return [[[self alloc] initWithTowerInfo:towerInfo targetpos:aTargetPos] autorelease];
}

- (id)initWithTowerInfo:(TowerInfo *)towerInfo targetpos:(CGPoint)aTargetPos
{
    self = [super init];
    if (self) {
        targetPoint = aTargetPos;
        
        number = towerInfo.number;
        grade = towerInfo.grade;
        attackPower = towerInfo.attackPower;
        gunshot = towerInfo.gunshot;
        pierceEnemyNumber = towerInfo.pierceEnemyNumber;
        
        critRate = towerInfo.critRate;
        slowRate = towerInfo.slowRate;
        slowTime = towerInfo.slowTime;
        
        multiAttack = towerInfo.multiAttack; // 多重攻击
        isFiring = towerInfo.isFiring; // 是否有灼烧伤害
        isAttactUnslowedEnemy = towerInfo.isAttactUnslowedEnemy; // 是否会攻击已减速的敌人
        
        isExplosion = towerInfo.isExplosion; // 是否可以爆炸
        
        firstHitEnemyIdx = -1;
        secondHitEnemyIdx = -1;
    }
    return self;
}


@end
