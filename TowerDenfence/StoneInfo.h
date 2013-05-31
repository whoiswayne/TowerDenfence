//
//  StoneInfo.h
//  TowerDenfence
//
//  Created by mir-macmini5 on 13-4-24.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@protocol StoneDelegate <NSObject>

- (void)onAddStoneBloodBg:(CCSprite *)aSprite;
- (void)onAddStoneBloodProgress:(CCProgressTimer *)aProgress;

@end

typedef enum{
    stoneType1,//占一格
    stoneType2,//占左右两格
    stoneType3,//占上下两格
    stoneType4,//占四格
}StoneType;

@interface StoneInfo : NSObject
{
    StoneType stoneType;
    CGPoint stonePos;
    CGRect stoneRect;
    
    int stoneMaxHp;
    int stoneCurHp;
    int stoneAward;
    
    CCSprite *bloodFrame;
    CCProgressTimer *bloodProgress;
    
    id<StoneDelegate> delegate;
}

@property (nonatomic,assign) StoneType stoneType;
@property (nonatomic,assign) CGPoint stonePos;
@property (nonatomic,assign) CGRect stoneRect;
@property (nonatomic,assign) int stoneCurHp;
@property (nonatomic,assign) int stoneMaxHp;
@property (nonatomic,assign) int stoneAward;

@property (nonatomic,retain) CCSprite *bloodFrame;
@property (nonatomic,retain) CCProgressTimer *bloodProgress;

@property (nonatomic,assign) id<StoneDelegate> delegate;

+ (id)stoneInfo:(int)aType withPosition:(CGPoint)aPos;

@end
