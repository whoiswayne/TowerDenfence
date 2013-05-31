//
//  StoneInfo.m
//  TowerDenfence
//
//  Created by mir-macmini5 on 13-4-24.
//
//

#import "StoneInfo.h"

@interface StoneInfo(Private)

- (id)initStoneInfo:(int)aType withPosition:(CGPoint)aPos;

@end

@implementation StoneInfo

@synthesize stoneType;
@synthesize stonePos;
@synthesize stoneRect;
@synthesize stoneAward;
@synthesize stoneCurHp;
@synthesize stoneMaxHp;
@synthesize bloodFrame;
@synthesize bloodProgress;

@synthesize delegate;

+ (id)stoneInfo:(int)aType withPosition:(CGPoint)aPos
{
    return [[[self alloc] initStoneInfo:aType withPosition:aPos] autorelease];
}

- (id)initStoneInfo:(int)aType withPosition:(CGPoint)aPos
{
    self = [super init];
    if (self) {
        switch (aType) {
            case 1:
                stoneType = stoneType1;
                stonePos = aPos;
                break;
            case 21:
                stonePos = ccpAdd(aPos, ccp(20, 0));
                stoneType = stoneType2;
                break;
            case 22:
                stoneType = stoneType2;
                break;
            case 31:
                stonePos = ccpAdd(aPos, ccp(0, -20));
                stoneType = stoneType3;
                break;
            case 32:
                stoneType = stoneType3;
                break;
            case 41:
                stonePos = ccpAdd(aPos, ccp(20, -20));
                stoneType = stoneType4;
                break;
            case 42:
            case 43:
            case 44:
                stoneType = stoneType4;
                break;                
        }
        
        switch (stoneType) {
            case stoneType1:
                stoneRect = CGRectMake(stonePos.x - 15, stonePos.y - 15, 30, 30);
                break;
            case stoneType2:
                stoneRect = CGRectMake(stonePos.x - 30, stonePos.y - 15, 60, 30);
                break;
            case stoneType3:
                stoneRect = CGRectMake(stonePos.x - 15, stonePos.y - 30, 30, 60);
                break;
            case stoneType4:
                stoneRect = CGRectMake(stonePos.x - 30, stonePos.y - 30, 60, 60);
                break;
        }
    }
    return self;
}

- (void)setDelegate:(id<StoneDelegate>)aDelegate
{
    delegate = aDelegate;
    // 血量条背景
    bloodFrame = [[CCSprite spriteWithFile:@"blood_frame.png"] retain];
    bloodFrame.position = ccpAdd(stonePos, ccp(0, stoneRect.size.height/2));
    
    if (delegate && [delegate respondsToSelector:@selector(onAddStoneBloodBg:)]) {
        [delegate onAddStoneBloodBg:bloodFrame];
    }
    
    // 血条
    bloodProgress = [[CCProgressTimer progressWithFile:@"blood.png"] retain];
    bloodProgress.type = kCCProgressTimerTypeHorizontalBarLR;
    bloodProgress.percentage = 100;
    bloodProgress.position = bloodFrame.position;
    
    if (delegate && [delegate respondsToSelector:@selector(onAddStoneBloodProgress:)]) {
        [delegate onAddStoneBloodProgress:bloodProgress];
    }
}

@end
