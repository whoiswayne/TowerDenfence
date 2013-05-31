//
//  BulletInfo.h
//  TowerDenfence
//
//  Created by mir-macmini5 on 13-4-16.
//
//

#import <Foundation/Foundation.h>
#import "TowerInfo.h"
#import "EnemySprite.h"

@interface BulletInfo : NSObject
{
    CGPoint targetPoint; // 目标点    
    int attackPower; // 攻击力    
    int number; // 子弹编号
    int grade;// 子弹的级别，主要用于不同级别的子弹图片
    int gunshot;//塔的射程
    int pierceEnemyNumber; // 穿透攻击个数 默认1
    
    float critRate;//暴击率
    float slowRate;//减速率
    float slowTime;//减速时间
    
    int multiAttack; // 多重攻击
    BOOL isFiring; // 是否有灼烧伤害
    BOOL isAttactUnslowedEnemy; // 是否会攻击已减速的敌人
    
    BOOL isExplosion; // 是否可以爆炸
    
    int firstHitEnemyIdx; // 打中的第一个敌人索引
    int secondHidEnemyIdx; // 第二个
}

@property (nonatomic,assign) CGPoint targetPoint;
@property (nonatomic,assign) int number;
@property (nonatomic,assign) int grade;
@property (nonatomic,assign) int attackPower;
@property (nonatomic,assign) int gunshot;
@property (nonatomic,assign) int pierceEnemyNumber;

@property (nonatomic,assign) float critRate;
@property (nonatomic,assign) float slowRate;
@property (nonatomic,assign) float slowTime;

@property (nonatomic,assign) int multiAttack; // 多重攻击
@property (nonatomic,assign) BOOL isFiring; // 是否有灼烧伤害
@property (nonatomic,assign) BOOL isAttactUnslowedEnemy; // 是否会攻击已减速的敌人

@property (nonatomic,assign) BOOL isExplosion; // 是否可以爆炸
@property (nonatomic,assign) int firstHitEnemyIdx;
@property (nonatomic,assign) int secondHitEnemyIdx;

+ (id)bulletInfoWithTowerInfo:(TowerInfo *)towerInfo targetpos:(CGPoint)aTargetPos;


@end
