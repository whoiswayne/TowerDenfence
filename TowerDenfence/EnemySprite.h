//
//  Enemy.h
//  TowerDenfence
//
//  Created by mir-macmini5 on 13-4-16.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "EnemyInfo.h"
#import "WayPointInfo.h"

@protocol EnemySpriteDelegate <NSObject>

- (void)onAddEnemyBloodBg:(id)sender;
- (void)onAddEnemyBloodProgress:(id)sender;
- (void)onRemoveEnemy:(id)sender;
//- (void) onEnemyDead:(id)sender;

@end



@interface EnemySprite : CCSprite
{
    CCSprite *bloodFrame;
    CCProgressTimer *bloodProgress;
    
    EnemyInfo *enemyInfo;

    
    NSMutableArray *wayPiontArray;
    WayPointInfo *curPos;
    WayPointInfo *targetPos;
    
    id<EnemySpriteDelegate> delegate;
    
    CCSprite *slowSprite;    
    
    NSMutableArray *listenTowerArray;
    
    float slowRate;
    float slowTime;
    BOOL isSlowDown;
    int indexSlowTime;
    BOOL isStopMove;
    
    CCSpriteFrameCache *frameCache;
    
    CGPoint subPoint;
    
    BOOL isShowPortal; //是否显示传送门动画
    BOOL isStartAnimate; // 是否已经开始动画
    
    int firingDuration;
}

@property (nonatomic,retain) CCProgressTimer *bloodProgress;
@property (nonatomic,retain) CCSprite *bloodFrame;
@property (nonatomic,retain) EnemyInfo *enemyInfo;


@property (nonatomic,assign) NSMutableArray *listenTowerArray;

@property (nonatomic,retain) id<EnemySpriteDelegate> delegate;
@property (nonatomic, assign) BOOL isFiring;
@property (nonatomic, assign) int firingDuration;
@property (nonatomic, assign) BOOL isSlowDown;


+ (id)enemyWithEnemyInfo:(EnemyInfo *)info withWayPoints:(NSMutableArray *)pointArray;
- (id)initWithEnemyInfo:(EnemyInfo *)info withWayPoints:(NSMutableArray *)pointArray;

- (void)updateself:(CGPoint)curPoint withTarget:(CGPoint)targetPoint;

- (void)doSlowDown:(float)slowRate slowTime:(float)aTime;

- (void) stopMove;
- (void) restartMove;
//- (void) startFiring;

@end
