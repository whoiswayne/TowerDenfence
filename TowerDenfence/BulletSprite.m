//
//  BulletSprite.m
//  TowerDefence
//
//  Created by mir-macmini5 on 13-4-2.
//
//

#import "BulletSprite.h"

#define SPEED_BULLET 10//子弹数度

@interface BulletSprite(Private)

- (id)initBulletInfo:(BulletInfo *)aBulletInfo originalPos:(CGPoint)aOriginalPos;

- (CCAction *)getAnimation;
- (CCAction *)getAction;
- (Boolean)isOverGunshot:(CCSprite *)aSprite;
- (Boolean)isOverScreen:(CCSprite *)aSprite;

@end

@implementation BulletSprite

@synthesize shadowSprite;
@synthesize bulletInfo;
@synthesize targetPoint;

@synthesize delegate;

+ (BulletSprite *)bulletSpriteWithBulletInfo:(BulletInfo *)aBulletInfo originalPos:(CGPoint)aOriginalPos
{
    return [[[self alloc] initBulletInfo:aBulletInfo originalPos:aOriginalPos] autorelease];
}


- (id)initBulletInfo:(BulletInfo *)aBulletInfo originalPos:(CGPoint)aOriginalPos
{
    self = [super init];
    if (self) {
        bulletInfo  = [aBulletInfo retain];
        
        originalPosition = aOriginalPos;
        targetPosition = bulletInfo.targetPoint;
        bulletInfo  = [aBulletInfo retain];
        number = bulletInfo.number;
        
        normalized = ccpNormalize(ccpSub(targetPosition, originalPosition));
        
        // 初始化精灵帧图片
        NSString *frameName = nil;
        if (number != 4) {
            // 子弹不区分级别
            frameName = [NSString stringWithFormat:@"bullet_%d_1.png",number];
        } else {
            // 子弹区分级别
            frameName = [NSString stringWithFormat:@"bullet_%d_%d.png",number,bulletInfo.grade];
        }
        [super initWithSpriteFrameName:frameName];
        
        // 初始化位置
        [super setPosition:originalPosition];
        
        self.rotation = CC_RADIANS_TO_DEGREES(atan2(normalized.y, -normalized.x)) + 90;
        
        if (number == 6 || number == 7) {
            self.anchorPoint = ccp(0.5f, 1.0f);
        }
        
        if (number == 6 || number == 7 || number == 9) {            
            [self runAction:[self getAction]];
        }else{
            [self schedule:@selector(updateBulletPos:) interval:RATE_SPEED];
        }   
        
        
        //        NSString *frameName = nil;
        //
        //        if ((number >= 3 && number <= 5) || (number == 8)) { //
        //            frameName = [NSString stringWithFormat:@"bullet_%d.png",number];
        //        } else {
        //            frameName = [NSString stringWithFormat:@"bullet_%d_1.png",number];
        //        }
        //        [super initWithSpriteFrameName:frameName];
        
//        if(number == 9){
////            self = [[CCSprite spriteWithSpriteFrameName:@"bullet_9_1.png"] retain];
////            self.position = originalPosition;
//            [self runAction:[self getAction]];
//        }else if(number == 7){
////            self = [[CCSprite spriteWithSpriteFrameName:@"bullet_7_1.png"] retain];
////            self.position = originalPosition;
//            self.rotation = CC_RADIANS_TO_DEGREES(atan2(normalized.y, -normalized.x)) + 90;
//            self.anchorPoint = ccp(0.5f, 1.0f);
//            [self runAction:[self getAction]];
//        }else if(number == 6){
////            self = [[CCSprite spriteWithSpriteFrameName:@"bullet_6_1.png"] retain];
////            self.position = originalPosition;
//            self.scaleY = ccpDistance(originalPosition, targetPos) / self.contentSize.height;
//            self.rotation = CC_RADIANS_TO_DEGREES(atan2(normalized.y, -normalized.x)) + 90;
//            self.anchorPoint = ccp(0.5f, 1.0f);
//            
//            [self runAction:[self getAction]];
//        }else if(number == 4){
//            leftSprite = [[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"bullet_%d.png",number]] retain];
//            leftSprite.rotation = 90;
//            leftSprite.position = originalPosition;
//            
//            rightSprite = [[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"bullet_%d.png",number]] retain];
//            rightSprite.rotation = -90;
//            rightSprite.position = originalPosition;
//            
//            topSprite = [[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"bullet_%d.png",number]] retain];
//            topSprite.rotation = 180;
//            topSprite.position = originalPosition;
//            
//            bottomSprite = [[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"bullet_%d.png",number]] retain];
//            bottomSprite.rotation = 0;
//            bottomSprite.position = originalPosition;
//            
//            [[CCScheduler sharedScheduler] scheduleSelector:@selector(updateBulletPos:) forTarget:self interval:1.0f/60 paused:NO];
//        }else{
//            
//            NSString *frameName = nil;
//            if (number == 1 || number == 2) {
//                //1,2
//                frameName = [NSString stringWithFormat:@"bullet_%d_1.png",number];
//            }else{
//                //3,5,8
//                frameName = [NSString stringWithFormat:@"bullet_%d.png",number];
//            }
//            self = [[CCSprite spriteWithSpriteFrameName:frameName] retain];
//            self.position = originalPosition;
//            self.rotation = CC_RADIANS_TO_DEGREES(atan2(normalized.y, -normalized.x)) + 90;
//            
//            if(number == 2){
//                [self runAction:[self getAnimation]];
//            }else if(number == 5){
//                shadowSprite = [[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"bullet_%d_shadow.png",number]] retain];
//                shadowSprite.position = ccp(self.position.x + 5 * normalized.x, self.position.y + 5 * normalized.y);
//            }
//            
//            [[CCScheduler sharedScheduler] scheduleSelector:@selector(updateBulletPos:) forTarget:self interval:1.0f/60 paused:NO];
//        }
//
        
    }
    return self;
}


//+ (id)bulletWithTower:(TowerSprite *)tower withTarget:(CGPoint)targetPos
//{
//    return [[self alloc] initWithTower:tower withTarget:targetPos];
//}
//
//- (id)initWithTower:(TowerSprite *)tower withTarget:(CGPoint)targetPos
//{
//    if((self = [super init])){
//        originalPosition = tower.towerSprite.position;
//        targetPosition = targetPos;
//        number = tower.towerInfo.number;
//        gunshot = tower.towerInfo.gunshot;        
//        
//        normalized = ccpNormalize(ccpSub(targetPosition, originalPosition));
//        
//        if(number == 9){
//            self = [[CCSprite spriteWithSpriteFrameName:@"bullet_9_1.png"] retain];
//            bulletSprite.position = originalPosition;
//            [bulletSprite runAction:[self getAction]];
//        }else if(number == 7){
//            bulletSprite = [[CCSprite spriteWithSpriteFrameName:@"bullet_7_1.png"] retain];
//            bulletSprite.position = originalPosition;
//            bulletSprite.rotation = CC_RADIANS_TO_DEGREES(atan2(normalized.y, -normalized.x)) + 90;
//            bulletSprite.anchorPoint = ccp(0.5f, 1.0f);
//            [bulletSprite runAction:[self getAction]];
//        }else if(number == 6){            
//            bulletSprite = [[CCSprite spriteWithSpriteFrameName:@"bullet_6_1.png"] retain];
//            bulletSprite.position = originalPosition;
//            bulletSprite.scaleY = ccpDistance(originalPosition, targetPos) / bulletSprite.contentSize.height;
//            bulletSprite.rotation = CC_RADIANS_TO_DEGREES(atan2(normalized.y, -normalized.x)) + 90;
//            bulletSprite.anchorPoint = ccp(0.5f, 1.0f);
//            
//            [bulletSprite runAction:[self getAction]];
//        }else if(number == 4){
//            leftSprite = [[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"bullet_%d.png",number]] retain];
//            leftSprite.rotation = 90;
//            leftSprite.position = originalPosition;
//            
//            rightSprite = [[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"bullet_%d.png",number]] retain];
//            rightSprite.rotation = -90;
//            rightSprite.position = originalPosition;
//            
//            topSprite = [[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"bullet_%d.png",number]] retain];
//            topSprite.rotation = 180;
//            topSprite.position = originalPosition;
//            
//            bottomSprite = [[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"bullet_%d.png",number]] retain];
//            bottomSprite.rotation = 0;
//            bottomSprite.position = originalPosition;
//            
//            [[CCScheduler sharedScheduler] scheduleSelector:@selector(updateBulletPos:) forTarget:self interval:1.0f/60 paused:NO];
//        }else{
//            
//            NSString *frameName = nil;
//            if (number == 1 || number == 2) {
//                //1,2
//                frameName = [NSString stringWithFormat:@"bullet_%d_1.png",number];
//            }else{
//                //3,5,8
//                frameName = [NSString stringWithFormat:@"bullet_%d.png",number];
//            }           
//            bulletSprite = [[CCSprite spriteWithSpriteFrameName:frameName] retain];            
//            bulletSprite.position = originalPosition;            
//            bulletSprite.rotation = CC_RADIANS_TO_DEGREES(atan2(normalized.y, -normalized.x)) + 90;
//            
//            if(number == 2){
//                [bulletSprite runAction:[self getAnimation]];
//            }else if(number == 5){
//                shadowSprite = [[CCSprite spriteWithSpriteFrameName:[NSString stringWithFormat:@"bullet_%d_shadow.png",number]] retain];
//                shadowSprite.position = ccp(bulletSprite.position.x + 5 * normalized.x, bulletSprite.position.y + 5 * normalized.y);
//            }
//            
//            [[CCScheduler sharedScheduler] scheduleSelector:@selector(updateBulletPos:) forTarget:self interval:1.0f/60 paused:NO];
//        }
//    }
//    return self;
//}

- (void)dealloc
{
    [self unscheduleAllSelectors];
    
    if (bulletInfo) {
        [bulletInfo release];
        bulletInfo = nil;
    }
    
//    if (bulletFromTowerSprite) {
//        [bulletFromTowerSprite release];
//        bulletFromTowerSprite = nil;
//    }
    
    [super dealloc];
}

- (void)updateBulletPos:(ccTime)dt
{         
    self.position = ccp(self.position.x + SPEED_BULLET * normalized.x, self.position.y + SPEED_BULLET * normalized.y);
    if(shadowSprite){
        shadowSprite.position = ccp(shadowSprite.position.x + SPEED_BULLET * normalized.x, shadowSprite.position.y + SPEED_BULLET * normalized.y);
    }
    
    if([self isOverGunshot:self] || [self isOverScreen:self]){
        [self unscheduleAllSelectors];
        [self removeFromParentAndCleanup:YES];
        if(shadowSprite){
            [shadowSprite removeFromParentAndCleanup:YES];
        }
        
        if(delegate && [delegate respondsToSelector:@selector(onRemoveBullet:)]){
            [delegate onRemoveBullet:self];
        }
    }
}

- (Boolean)isOverGunshot:(CCSprite *)aSprite
{
    if(ccpDistance(originalPosition, aSprite.position) >= bulletInfo.gunshot){
        return YES;
    }else{
        return NO;
    }
}

- (Boolean)isOverScreen:(CCSprite *)aSprite
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    if(aSprite.position.x > size.width + aSprite.contentSize.width / 2 || aSprite.position.x < - aSprite.contentSize.width / 2 || aSprite.position.y > size.height + aSprite.contentSize.height / 2 || aSprite.position.y < - aSprite.contentSize.height / 2){
        return YES;
    }else{
        return NO;
    }
}

- (CCAction *)getAnimation
{
    //伴随动画
    CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    NSMutableArray *frameArray = [NSMutableArray arrayWithCapacity:2];
    
    for (int i = 1; i <= 5; i++) {
        CCSpriteFrame *frame = [frameCache spriteFrameByName:[NSString stringWithFormat:@"bullet_%d_%d.png",number,i]];
        [frameArray addObject:frame];
    }
    CCAnimation *animation = [CCAnimation animationWithFrames:frameArray delay:0.2f];
    CCAnimate *animate = [CCAnimate actionWithAnimation:animation];

    return [CCRepeatForever actionWithAction: animate];
}

- (CCAction *)getAction
{
    //动画序列
    CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    NSMutableArray *frameArray = [NSMutableArray arrayWithCapacity:2];
    
    int count = 0;
    if(number == 7){
        count = 5;
    }else if(number == 6){
        count = 4;
    }else if(number == 9){
        count = 9;
    }

    for (int i = 1; i <= count; i++) {
        CCSpriteFrame *frame = [frameCache spriteFrameByName:[NSString stringWithFormat:@"bullet_%d_%d.png",number,i]];
        [frameArray addObject:frame];
    }
    CCAnimation *animation = [CCAnimation animationWithFrames:frameArray delay:0.15f];
    CCAnimate *animate = [CCAnimate actionWithAnimation:animation];
    
    CCCallFuncO *callFunO = [CCCallFuncO actionWithTarget:self selector:@selector(removeSprite:) object:self];
    
    CCSequence *sequence = [CCSequence actions:animate,callFunO, nil];
    
    return sequence;
}

- (void)removeSprite:(CCSprite *)aSprite
{
    if(aSprite){
        [aSprite removeFromParentAndCleanup:YES];
        aSprite = nil;
    }
}

@end
