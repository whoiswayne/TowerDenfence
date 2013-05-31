//
//  MainLayer.m
//  TowerDenfence
//
//  Created by seven on 13-5-14.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "MainLayer.h"
#import "SimpleAudioEngine.h"

@interface MainLayer (Private)

- (id) initWithNothing;
- (void) addSprites;

@end

@implementation MainLayer

+ (id) scene
{
    CCScene *scene = [CCScene node];
    CCLayer *layer = [[[MainLayer alloc] initWithNothing] autorelease];
    [scene addChild:layer];
    return scene;
}

- (id) initWithNothing
{
    if ((self = [super init])) {
        NSUserDefaults *saveDefaults = [NSUserDefaults standardUserDefaults];
        BOOL isBGMOpen = [[saveDefaults objectForKey:@"BGMSave"] boolValue];
        if (isBGMOpen) {
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"bgm_default.mp3" loop:YES];// 播放背景音
        }
        
        isChinese = YES;
        self.isTouchEnabled = YES;
        [self addSprites];
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (void) addSprites
{
    screenSize = [[CCDirector sharedDirector]winSize];
    
    CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    [frameCache addSpriteFramesWithFile:@"td_frame_sprites.plist"];
    
    mainBg = [CCSprite spriteWithSpriteFrameName:@"main_page.png"];
    mainBg.position = CGPointMake(screenSize.width * 0.5f, screenSize.height * 0.5f);
    [self addChild:mainBg z:0];
    
    mainRankingList = [CCSprite spriteWithSpriteFrameName:@"main_ranking_list.png"];
    mainRankingList.position = ccp(444, 288);
    [self addChild:mainRankingList z:1];
    
    mainSetting = [CCSprite spriteWithSpriteFrameName:@"main_setting.png"];
    mainSetting.position = ccp(390, 34);
    [self addChild:mainSetting z:1];
    
    mainHelp = [CCSprite spriteWithSpriteFrameName:@"main_help.png"];
    mainHelp.position = ccp(444, 34);
    [self addChild:mainHelp z:1];
    
    if (isChinese) {
        mainLogo = [CCSprite spriteWithSpriteFrameName:@"main_logo_ch.png"];
        mainStart = [CCSprite spriteWithSpriteFrameName:@"main_start_ch.png"];
    } else {
        mainLogo = [CCSprite spriteWithSpriteFrameName:@"main_logo_en.png"];
        mainStart = [CCSprite spriteWithSpriteFrameName:@"main_start_en.png"];
    }
    
    mainLogo.position = ccp(138, 274);
    [self addChild:mainLogo z:1];
    
    mainStart.position = ccp(245, 55);
    [self addChild:mainStart z:1];
    
    
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [self convertTouchToNodeSpace:[touches anyObject]];
    if (CGRectContainsPoint(mainStart.boundingBox, touchPoint)) {
        CCScene *scene = [ChooseSceneLayer scene:1];
//        CCTransitionSlideInB *transitionScene = [CCTransitionSlideInB transitionWithDuration:3 scene:scene];
        [[CCDirector sharedDirector]replaceScene:scene];
        
        //scene 切换动画
        //CCTransitionTurnOffTiles *transitionScene = [CCTransitionTurnOffTiles transitionWithDuration:3 scene:scene];
        //近远－远近－－－－－
        //CCTransitionShrinkGrow *transitionScene = [CCTransitionShrinkGrow transitionWithDuration:3 scene:scene];
        //另一个layout左侧进入（视觉感觉是屏幕右移）
        //CCTransitionSlideInL *transitionScene = [CCTransitionSlideInL transitionWithDuration:3 scene:scene];
        //另一个layout右侧进入（视觉感觉是屏幕左移）
        //CCTransitionSlideInR *transitionScene = [CCTransitionSlideInR transitionWithDuration:3 scene:scene];
        //另一个layout上侧进入（视觉感觉是屏幕下移）
        //CCTransitionSlideInT *transitionScene = [CCTransitionSlideInT transitionWithDuration:3 scene:scene];
        //另一个layout下侧进入（视觉感觉是屏幕上移）
        //CCTransitionSlideInB *transitionScene = [CCTransitionSlideInB transitionWithDuration:3 scene:scene];
        //当前屏幕被分为3列，两则下移，中间上移
        //CCTransitionSplitCols *transitionScene = [CCTransitionSplitCols transitionWithDuration:3 scene:scene];
        //当前屏幕被分为3列，两则左移，中间右移
        //CCTransitionSplitRows *transitionScene = [CCTransitionSplitRows transitionWithDuration:3 scene:scene];
        //扇形转换－－－－－
        //CCTransitionRadialCW *transitionScene = [CCTransitionRadialCW transitionWithDuration:3 scene:scene];
        //平面旋转－－－－－
        //CCTransitionRotoZoom *transitionScene = [CCTransitionRotoZoom transitionWithDuration:3 scene:scene];
        //近－远－跳动－－－－－－
        //CCTransitionJumpZoom *transitionScene = [CCTransitionJumpZoom transitionWithDuration:3 scene:scene];
        //立体反转（X轴）－－(还有种从近到远，从远到近的感觉)－－－－－－－－
        //CCTransitionZoomFlipX *transitionScene = [CCTransitionZoomFlipX transitionWithDuration:3 scene:scene];
        //立体反转（Y轴）－(还有种从近到远，从远到近的感觉)－－－－－－－
        //CCTransitionZoomFlipY *transitionScene = [CCTransitionZoomFlipY transitionWithDuration:3 scene:scene];
        //立体反转（X,Y轴）－－－(还有种从近到远，从远到近的感觉)－－－－－
        //CCTransitionZoomFlipAngular *transitionScene = [CCTransitionZoomFlipAngular transitionWithDuration:3 scene:scene];
        //另外一个layout左侧进入覆盖当前layout
        //CCTransitionMoveInL *transitionScene = [CCTransitionMoveInL transitionWithDuration:3 scene:scene];
        //另外一个layout右侧进入覆盖当前layout
        //CCTransitionMoveInR *transitionScene = [CCTransitionMoveInR transitionWithDuration:3 scene:scene];
        //另外一个layout上侧进入覆盖当前layout
        //CCTransitionMoveInT *transitionScene = [CCTransitionMoveInT transitionWithDuration:3 scene:scene];
        //另外一个layout下侧进入覆盖当前layout
        //CCTransitionMoveInB *transitionScene = [CCTransitionMoveInB transitionWithDuration:3 scene:scene];
        //立体反转（X轴）－－2D平面反转，没有远近感
        //CCTransitionFlipX *transitionScene = [CCTransitionFlipX transitionWithDuration:3 scene:scene];
        //立体反转（Y轴）－－2D平面反转，没有远近感
        //CCTransitionFlipY *transitionScene = [CCTransitionFlipY transitionWithDuration:3 scene:scene];
        //立体反转（X,Y轴）－－2D平面反转，没有远近感
        //CCTransitionFlipAngular *transitionScene = [CCTransitionFlipAngular transitionWithDuration:3 scene:scene];
        //实体－透明－实体(默认无颜色，可以附带颜色)
        //CCTransitionFade* transitionScene = [CCTransitionFade transitionWithDuration:3 scene:scene withColor:ccWHITE];
        //另外一个直接渐变覆盖当前layout
        //CCTransitionCrossFade *transitionScene = [CCTransitionCrossFade transitionWithDuration:3 scene:scene];
        //移动（方格状）部落格，从左下往右上
        //CCTransitionFadeTR *transitionScene = [CCTransitionFadeTR transitionWithDuration:3 scene:scene];
        //移动（方格状）部落格，从右上往左下
        //CCTransitionFadeBL *transitionScene = [CCTransitionFadeBL transitionWithDuration:3 scene:scene];
        //移动（长矩形，宽度是屏幕宽）部落格，从下往上
        //CCTransitionFadeUp *transitionScene = [CCTransitionFadeUp transitionWithDuration:3 scene:scene];
        //移动（长矩形，宽度是屏幕宽）部落格，从上往下
        //CCTransitionFadeDown *transitionScene = [CCTransitionFadeDown transitionWithDuration:3 scene:scene];
    }
}

@end
