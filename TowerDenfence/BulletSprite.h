//
//  BulletSprite.h
//  TowerDefence
//
//  Created by mir-macmini5 on 13-4-2.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "BulletInfo.h"

//@class TowerSprite;

@protocol BulletSpriteDelegate <NSObject>

- (void)onRemoveBullet:(id)sender;

@end

@interface BulletSprite : CCSprite
{
    CGPoint originalPosition;
    CGPoint targetPosition;
    CGPoint normalized;
    int number;
    
    CCSprite *shadowSprite;        
    BulletInfo *bulletInfo;    
    
    CGPoint targetPoint;
    
    id<BulletSpriteDelegate> delegate;
}

@property (nonatomic,retain) CCSprite *shadowSprite;
@property (nonatomic,retain) BulletInfo *bulletInfo;
@property (nonatomic,assign) CGPoint targetPoint;

@property (nonatomic,retain) id<BulletSpriteDelegate> delegate;

+ (BulletSprite *)bulletSpriteWithBulletInfo:(BulletInfo *)aBulletInfo originalPos:(CGPoint)aOriginalPos;

@end
