//
//  TowerSprite.h
//  TowerDefence
//
//  Created by mir-macmini5 on 13-3-28.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "TowerInfo.h"
#import "UpgradeInfo.h"
@protocol TowerSpriteDelegate <NSObject>

- (void)onTowerLaunchBullet:(id)sender withTowerNumber:(int)towerNumber;

@end


@interface TowerSprite : CCSprite 
{
    TowerInfo *towerInfo;
    UpgradeInfo *upgradeInfo;
    CGPoint targetPoint;
    
    CGPoint bulletTargetPoint; // 子弹最大射程目标点
    
    NSTimeInterval prepareTime;
    
    id<TowerSpriteDelegate> delegate;
    
    NSMutableArray *enemyArray;// 在视野内的敌人
}

@property (nonatomic,assign) id<TowerSpriteDelegate> delegate;
@property (nonatomic,retain) TowerInfo *towerInfo;
@property (nonatomic,assign) CGPoint targetPoint;
@property (nonatomic,assign) NSMutableArray *enemyArray;;

+ (TowerSprite *)towerSpriteWithTowerInfo:(TowerInfo *)aTowerInfo upgradeInfo:(UpgradeInfo *) aUpgradeInfo;

- (void)attackWithTargetPos:(CGPoint)tempPos;

- (void) restartAllActions;

@end
