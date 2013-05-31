//
//  ChooseSceneLayer.m
//  TowerDenfence
//
//  Created by seven on 13-5-8.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "ChooseSceneLayer.h"
#import "ChoosePassLayer.h"
//#import "SimpleAudioEngine.h"
#import "MainLayer.h"

#define GRASSLAND_INDEX 1
#define DESERT_INDEX 2
#define VOLCANO_INDEX 3
#define ICELAND_INDEX 4

@interface ChooseSceneLayer (Private)

- (id) initWithNothing;
- (void) addSprites;

@end

@implementation ChooseSceneLayer

+ (id)scene: (int) sceneIndex
{
    CCScene *scene = [CCScene node];
    
    CCLayer *mainLayer = [[[ChooseSceneLayer alloc] initWithNothing] autorelease];
    [scene addChild:mainLayer];
    
    return scene;
}

- (id) initWithNothing
{
    if ((self = [super init])) {
//        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"bgm_default.mp3" loop:YES];// 播放背景音
        [self addSprites];
        self.isTouchEnabled = YES;
    }
    return self;
}

- (void) dealloc
{
    [super dealloc];
}

- (void) addSprites
{
    CCSpriteFrameCache *frameCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    [frameCache addSpriteFramesWithFile:@"td_frame_sprites.plist"];
    screenSize = [[CCDirector sharedDirector] winSize];
    
    bgSprite = [CCSprite spriteWithSpriteFrameName:@"scene_bg.png"];
    bgSprite.position = CGPointMake(screenSize.width * 0.5f, screenSize.height * 0.5f);
    [self addChild:bgSprite z:0];
    
    grassLandFocus = [CCSprite spriteWithSpriteFrameName:@"grassland_focus.png"];
    grassLandFocus.position = ccp(102.0f, 148.0f);
    [self addChild:grassLandFocus z:1];
    grassLandFocus.visible = NO;
    
    desertLocked = [CCSprite spriteWithSpriteFrameName:@"desert_locked.png"];
    desertLocked.position = ccp(233.0f, 93.0f);
    [self addChild:desertLocked z:0];
    
    desertFocus = [CCSprite spriteWithSpriteFrameName:@"desert_focus.png"];
    desertFocus.position = ccp(desertLocked.position.x - 2, desertLocked.position.y);
    [self addChild:desertFocus z:1];
    desertFocus.visible = NO;
    
    volcanoLocked = [CCSprite spriteWithSpriteFrameName:@"volcano_locked.png"];
    volcanoLocked.position = ccp(372.0f, 143.0f);
    [self addChild:volcanoLocked z:0];
    
    volcanoFocus = [CCSprite spriteWithSpriteFrameName:@"volcano_focus.png"];
    volcanoFocus.position = ccp(volcanoLocked.position.x - 4, volcanoLocked.position.y);
    [self addChild:volcanoFocus z:1];
    volcanoFocus.visible = NO;
    
    icelandLocked = [CCSprite spriteWithSpriteFrameName:@"iceland_locked.png"];
    icelandLocked.position = ccp(231.0f, 227.0f);
    [self addChild:icelandLocked z:0];
    
    icelandFocus = [CCSprite spriteWithSpriteFrameName:@"iceland_focus.png"];
    icelandFocus.position = ccp(icelandLocked.position.x - 4, icelandLocked.position.y);
    [self addChild:icelandFocus z:1];
    icelandFocus.visible = NO;
    
    back = [CCSprite spriteWithSpriteFrameName:@"bt_back_n.png"];
    back.position = ccp(3 + back.contentSize.width * 0.5f, screenSize.height - 3 - back.contentSize.height * 0.5f);
    [self addChild:back z:2];
    
    option = [CCSprite spriteWithSpriteFrameName:@"bt_option_n.png"];
    option.position = ccp(screenSize.width - 5 - option.contentSize.width * 0.5f, screenSize.height - 3 - option.contentSize.height * 0.5f);
    [self addChild:option z:2];
    
    help = [CCSprite spriteWithSpriteFrameName:@"bt_help_n.png"];
    help.position = ccp(screenSize.width - 5 - option.contentSize.width - 5 - help.contentSize.width * 0.5f, screenSize.height - 3 - help.contentSize.height * 0.5f);
    [self addChild:help z:2];
    
    select_mission = [CCSprite spriteWithSpriteFrameName:@"select_mission.png"];
    select_mission.position = ccp(screenSize.width * 0.5f, screenSize.height - 10 - select_mission.contentSize.height * 0.5f);
    [self addChild:select_mission z:2];
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [self convertTouchToNodeSpace:[touches anyObject]];
    NSLog(@"touchPoint.x = %f, y = %f", touchPoint.x, touchPoint.y);
    if (CGRectContainsPoint(CGRectMake(0, 40, 140.0f, 200.0f), touchPoint) || CGRectContainsPoint(CGRectMake(140, 122, 26, 100), touchPoint)) {
        grassLandFocus.visible = YES;
        desertFocus.visible = NO;
        volcanoFocus.visible = NO;
        icelandFocus.visible = NO;
    }else if(CGRectContainsPoint(CGRectMake(142, 0, 190.0f, 122.0f), touchPoint) || CGRectContainsPoint(CGRectMake(183, 122, 141, 26), touchPoint)){
        grassLandFocus.visible = NO;
        desertFocus.visible = YES;
        volcanoFocus.visible = NO;
        icelandFocus.visible = NO;
    }else if(CGRectContainsPoint(CGRectMake(332, 33, 141, 210), touchPoint) || CGRectContainsPoint(CGRectMake(300, 155, 23, 70), touchPoint)){
        grassLandFocus.visible = NO;
        desertFocus.visible = NO;
        volcanoFocus.visible = YES;
        icelandFocus.visible = NO;
    }else if(CGRectContainsPoint(CGRectMake(125, 239, 220, 80), touchPoint) || CGRectContainsPoint(CGRectMake(197, 160, 115, 80), touchPoint)){
        grassLandFocus.visible = NO;
        desertFocus.visible = NO;
        volcanoFocus.visible = NO;
        icelandFocus.visible = YES;
    }else{
        grassLandFocus.visible = NO;
        desertFocus.visible = NO;
        volcanoFocus.visible = NO;
        icelandFocus.visible = NO;
    }
}

- (void) ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [self convertTouchToNodeSpace:[touches anyObject]];
    
    if (CGRectContainsPoint(CGRectMake(0, 40, 140.0f, 200.0f), touchPoint) || CGRectContainsPoint(CGRectMake(140, 122, 26, 100), touchPoint)) {
        grassLandFocus.visible = YES;
        desertFocus.visible = NO;
        volcanoFocus.visible = NO;
        icelandFocus.visible = NO;
    }else if(CGRectContainsPoint(CGRectMake(142, 0, 190.0f, 122.0f), touchPoint) || CGRectContainsPoint(CGRectMake(183, 122, 141, 26), touchPoint)){
        grassLandFocus.visible = NO;
        desertFocus.visible = YES;
        volcanoFocus.visible = NO;
        icelandFocus.visible = NO;
    }else if(CGRectContainsPoint(CGRectMake(332, 33, 141, 210), touchPoint) || CGRectContainsPoint(CGRectMake(300, 155, 23, 70), touchPoint)){
        grassLandFocus.visible = NO;
        desertFocus.visible = NO;
        volcanoFocus.visible = YES;
        icelandFocus.visible = NO;
    }else if(CGRectContainsPoint(CGRectMake(125, 239, 220, 80), touchPoint) || CGRectContainsPoint(CGRectMake(197, 160, 115, 80), touchPoint)){
        grassLandFocus.visible = NO;
        desertFocus.visible = NO;
        volcanoFocus.visible = NO;
        icelandFocus.visible = YES;
    }else{
        grassLandFocus.visible = NO;
        desertFocus.visible = NO;
        volcanoFocus.visible = NO;
        icelandFocus.visible = NO;
    }
    
    // 退出
    if (CGRectContainsPoint([back boundingBox], touchPoint)) {
        [self dealloc];
    }
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [self convertTouchToNodeSpace:[touches anyObject]];
    
    if (CGRectContainsPoint(CGRectMake(0, 40, 140.0f, 200.0f), touchPoint) || CGRectContainsPoint(CGRectMake(140, 122, 26, 100), touchPoint)) {
        [[CCDirector sharedDirector] replaceScene:[ChoosePassLayer scene:GRASSLAND_INDEX]];
    }else if(CGRectContainsPoint(CGRectMake(142, 0, 190.0f, 122.0f), touchPoint) || CGRectContainsPoint(CGRectMake(183, 122, 141, 26), touchPoint)){
        [[CCDirector sharedDirector] replaceScene:[ChoosePassLayer scene:DESERT_INDEX]];
    }else if(CGRectContainsPoint(CGRectMake(332, 33, 141, 210), touchPoint) || CGRectContainsPoint(CGRectMake(300, 155, 23, 70), touchPoint)){
        [[CCDirector sharedDirector] replaceScene:[ChoosePassLayer scene:VOLCANO_INDEX]];
    }else if(CGRectContainsPoint(CGRectMake(125, 239, 220, 80), touchPoint) || CGRectContainsPoint(CGRectMake(197, 160, 115, 80), touchPoint)){
        [[CCDirector sharedDirector] replaceScene:[ChoosePassLayer scene:ICELAND_INDEX]];
    }else if(CGRectContainsPoint(back.boundingBox, touchPoint)){
        [[CCDirector sharedDirector] replaceScene:[MainLayer scene]];
    }
    
    grassLandFocus.visible = NO;
    desertFocus.visible = NO;
    volcanoFocus.visible = NO;
    icelandFocus.visible = NO;
}

@end
