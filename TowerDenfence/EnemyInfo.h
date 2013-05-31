//
//  EnemyInfo.h
//  TowerDenfence
//
//  Created by mir-macmini5 on 13-4-16.
//
//

#import <Foundation/Foundation.h>

@interface EnemyInfo : NSObject
{
    int number;//编号
    int maxHp;//最大血量
    int curHp;//当前血量
    int maxSpeed;//最大速度
    int curSpeed;//当前速度
    int award;//奖励
    float spawnTime;//出现时间
    int enemyId;
}

@property (nonatomic,assign) int number;
@property (nonatomic,assign) int maxHp;
@property (nonatomic,assign) int curHp;
@property (nonatomic,assign) int maxSpeed;
@property (nonatomic,assign) int curSpeed;
@property (nonatomic,assign) int award;
@property (nonatomic,assign) float spawnTime;
@property (nonatomic,assign) int enemyId;

+ (id)tankInfoWithTankInfo:(EnemyInfo *)info;
- (id)initWithTankInfo:(EnemyInfo *)info;

@end
