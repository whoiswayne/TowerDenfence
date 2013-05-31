//
//  TowerInfo.m
//  TowerDefence_new
//
//  Created by mir-macmini5 on 13-3-26.
//
//

#import "TowerInfo.h"

@interface TowerInfo(Private)

- (id)initTowerInfo:(TowerInfo *)aTowerInfo withUpgradeInfo:(UpgradeInfo *)aUpgradeInfo;

@end

@implementation TowerInfo

@synthesize number;
@synthesize grade;
@synthesize attackPower;
@synthesize attackSpeed;
@synthesize field;
@synthesize gunshot;
@synthesize price;

@synthesize critRate;
@synthesize slowRate;
@synthesize slowTime;

@synthesize multiAttack;
@synthesize isFiring;
@synthesize isAttactUnslowedEnemy;
@synthesize pierceEnemyNumber;
@synthesize isExplosion;

+ (id)towerInfo:(TowerInfo *)aTowerInfo withUpgradeInfo:(UpgradeInfo *)aUpgradeInfo
{
    return [[[self alloc] initTowerInfo:aTowerInfo withUpgradeInfo:aUpgradeInfo] autorelease];
}

- (id)initTowerInfo:(TowerInfo *)aTowerInfo withUpgradeInfo:(UpgradeInfo *)aUpgradeInfo
{
    self = [super init];
    if (self) {
        number = aTowerInfo.number;
        grade = aTowerInfo.grade;
        
        switch (number) {
            case 1:
                // 每级提升10%攻速
                attackSpeed = aTowerInfo.attackSpeed * (1 + 0.1 * aUpgradeInfo.upgrade1_1);
                // 每级提升5%暴击
                critRate = aTowerInfo.critRate * (1 + 0.05 * aUpgradeInfo.upgrade2_1);
                // 每级减少5造价
                price = aTowerInfo.price - 5 * aUpgradeInfo.upgrade2_2;
                // 多重攻击
                multiAttack = 3 * aUpgradeInfo.upgrade3_1;
                
                //以上为升级相关, 以下为不升级项目
                attackPower = aTowerInfo.attackPower;
                field = aTowerInfo.field;
                gunshot = aTowerInfo.gunshot;
                
                slowRate = aTowerInfo.slowRate;
                slowTime = aTowerInfo.slowTime;
                
                isFiring = aTowerInfo.isFiring;
                isAttactUnslowedEnemy = aTowerInfo.isAttactUnslowedEnemy;
                pierceEnemyNumber = aTowerInfo.pierceEnemyNumber;
                
                isExplosion = aTowerInfo.isExplosion;
                break;
                
            case 2:
                // 每级提升10%攻击力
                attackPower = aTowerInfo.attackPower * (1 + 0.1 * aUpgradeInfo.upgrade1_1);
                //每级增加10个像素的视野和射程
                field = aTowerInfo.field + 10 * aUpgradeInfo.upgrade2_1;
                gunshot = aTowerInfo.gunshot + 10 * aUpgradeInfo.upgrade2_1;
                // 每级提升10%攻速
                attackSpeed = aTowerInfo.attackSpeed * (1 + 0.1 * aUpgradeInfo.upgrade2_2);
                // 是否有灼烧伤害
                isFiring = (1 == aUpgradeInfo.upgrade3_1);
                
                //以上为升级相关, 以下为不升级项目
                price = aTowerInfo.price;
                
                critRate = aTowerInfo.critRate;
                slowRate = aTowerInfo.slowRate;
                slowTime = aTowerInfo.slowTime;
                multiAttack = aTowerInfo.multiAttack;
                
                isAttactUnslowedEnemy = aTowerInfo.isAttactUnslowedEnemy;
                pierceEnemyNumber = aTowerInfo.pierceEnemyNumber;
                
                isExplosion = aTowerInfo.isExplosion;
                break;
                
            case 3:
                // 每级提升10%攻速
                attackSpeed = aTowerInfo.attackSpeed * (1 + 0.1 * aUpgradeInfo.upgrade1_1);
                // 每级提升0.5秒减速时间
                slowTime = aTowerInfo.slowTime + 0.5 * aUpgradeInfo.upgrade2_1;
                // 每级提升10%攻击力
                attackPower = aTowerInfo.attackPower + 10 * aUpgradeInfo.upgrade2_2;
                // 升级则不会优先攻击已经减速的怪物
                isAttactUnslowedEnemy = (1 == aUpgradeInfo.upgrade3_1);
                
                //以上为升级相关, 以下为不升级项目
                field = aTowerInfo.field;
                gunshot = aTowerInfo.gunshot;
                price = aTowerInfo.price;
                
                critRate = aTowerInfo.critRate;
                slowRate = aTowerInfo.slowRate;
                multiAttack = aTowerInfo.multiAttack;
                
                isFiring = aTowerInfo.isFiring;
                pierceEnemyNumber = aTowerInfo.pierceEnemyNumber;
                
                isExplosion = aTowerInfo.isExplosion;
                break;
                
            case 4:
                //每级增加10个像素的视野和射程
                field = aTowerInfo.field + 10 * aUpgradeInfo.upgrade1_1;
                gunshot = aTowerInfo.gunshot + 10 * aUpgradeInfo.upgrade1_1;
                // 每级提升10%攻速
                attackSpeed = aTowerInfo.attackSpeed * (1 + 0.1 * aUpgradeInfo.upgrade2_1);
                // 可穿透敌人数
                pierceEnemyNumber = aTowerInfo.pierceEnemyNumber + aUpgradeInfo.upgrade2_2;
                // 最后爆炸
                isExplosion = (1 == aUpgradeInfo.upgrade3_1);
                
                //以上为升级相关, 以下为不升级项目
                attackPower = aTowerInfo.attackPower;
                price = aTowerInfo.price;
                
                critRate = aTowerInfo.critRate;
                slowRate = aTowerInfo.slowRate;
                slowTime = aTowerInfo.slowTime;
                multiAttack = aTowerInfo.multiAttack;
                
                isFiring = aTowerInfo.isFiring;
                isAttactUnslowedEnemy = aTowerInfo.isAttactUnslowedEnemy;
                break;
        }
    }
    return self;
}

@end
