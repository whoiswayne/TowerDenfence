//
//  GameOverSprite.m
//  TowerDenfence
//
//  Created by mir on 13-4-28.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "GameOverSprite.h"

@interface GameOverSprite (PrivateMethod)

- (void)gameAnimationWithResult: (BOOL) result;

@end

@implementation GameOverSprite
// todo
- (id) initWithGameResult:(BOOL) result
{
    if ((self = [super init])) {
        [self gameAnimationWithResult: result];
    }
    
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (void)gameAnimationWithResult: (BOOL) result
{
    if (result) {
        NSMutableArray *frameArray = [NSMutableArray arrayWithCapacity:2];
        for (int i = 1; i <= 5; i++) {
            CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
            CCSpriteFrame *frame = [frameCache spriteFrameByName:[NSString stringWithFormat:@"gameover_anim_%d.png", i]];
            
            [frameArray addObject:frame];
        }
        
        CCAnimation *animation = [CCAnimation animationWithFrames:frameArray delay:0.2f];
        CCAnimate *animate = [CCAnimate actionWithAnimation:animation];
        CCRepeatForever *repeatAction = [CCRepeatForever actionWithAction: animate];
        
        [self runAction:repeatAction];
    }else{
        
    }
    
}
@end
