//
//  EnemyInfo.m
//  TowerDenfence
//
//  Created by mir-macmini5 on 13-4-16.
//
//

#import "EnemyInfo.h"

@implementation EnemyInfo

@synthesize number;
@synthesize maxHp;
@synthesize curHp;
@synthesize curSpeed;
@synthesize maxSpeed;
@synthesize award;
@synthesize spawnTime;
@synthesize enemyId;

+ (id)tankInfoWithTankInfo:(EnemyInfo *)info
{
    return [[[self alloc] initWithTankInfo:info] autorelease];
}

- (id)initWithTankInfo:(EnemyInfo *)info
{
    if((self = [super init])){
        number = info.number;
        maxHp = info.maxHp;
        curHp = info.curHp;
        curSpeed = info.curSpeed;
        maxSpeed = info.maxSpeed;
        award = info.award;
        spawnTime = info.spawnTime;
    }
    return self;
}
@end
