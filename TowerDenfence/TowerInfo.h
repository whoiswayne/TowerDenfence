//
//  TowerInfo.h
//  TowerDefence_new
//
//  Created by mir-macmini5 on 13-3-26.
//
//

#import <Foundation/Foundation.h>
#import "UpgradeInfo.h"

@interface TowerInfo : NSObject
{
    int number;//编号
    int grade;//炮塔的等级
    int attackPower;//攻击力
    float attackSpeed;//攻击速度
    int field;//塔的视野
    int gunshot;//塔的射程
    int price;//购买价格
    
    float critRate;//暴击率
    float slowRate;//减速率
    float slowTime;//减速时间
    int multiAttack; // 多重攻击
    
    BOOL isFiring; // 是否有灼烧伤害
    BOOL isAttactUnslowedEnemy; // 是否会攻击已减速的敌人
    int pierceEnemyNumber; // 可以穿透几个敌人
    
    BOOL isExplosion; // 是否可以爆炸
    
//    Boolean isHaveMaxGradeTech;//3级时，攻击怪物是否有大招
}

@property (nonatomic, assign) int number;
@property (nonatomic, assign) int grade;
@property (nonatomic, assign) int attackPower;
@property (nonatomic, assign) float attackSpeed;
@property (nonatomic, assign) int field;
@property (nonatomic, assign) int gunshot;
@property (nonatomic, assign) int price;

@property (nonatomic, assign) float critRate;
@property (nonatomic, assign) float slowRate;
@property (nonatomic, assign) float slowTime;
@property (nonatomic, assign) int multiAttack;
@property (nonatomic, assign) BOOL isFiring;
@property (nonatomic, assign) BOOL isAttactUnslowedEnemy;
@property (nonatomic, assign) int pierceEnemyNumber;
@property (nonatomic, assign) BOOL isExplosion;

+ (id)towerInfo:(TowerInfo *)aTowerInfo withUpgradeInfo:(UpgradeInfo *)aUpgradeInfo;

@end
