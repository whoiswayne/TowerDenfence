//
//  HelloWorldLayer.m
//  TestGameChoose
//
//  Created by mir on 13-4-16.
//  Copyright __MyCompanyName__ 2013年. All rights reserved.
//

#import "ChoosePassLayer.h"
#import "GameLayer.h"
#import "ChooseSceneLayer.h"

@interface ChoosePassLayer (Private)

-(id) initWithPass:(int)curLand;

- (void) addSprites;
- (UIImage *) renderUIImageFromSprite :(CCSprite *)sprite;
- (int) getPicArrayIndex: (int) i;

@end

@implementation ChoosePassLayer

+(CCScene *) scene:(int)aLand
{
	CCScene *scene = [CCScene node];
	ChoosePassLayer *layer = [[ChoosePassLayer alloc] initWithPass:aLand];
	[scene addChild: layer];
	return scene;
}

-(id) initWithPass:(int)aPass
{
	if( (self=[super init])) {
        curLand = aPass;
        
        screenSize = [[CCDirector sharedDirector] winSize];
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"td_upgrade_sprites.plist"];
        
        [self addSprites];
        
        NSMutableArray *picArray = [NSMutableArray arrayWithCapacity:2];
        
        for (int i = 1; i <= 20; i++) {
            NSString *imagePath = [NSString stringWithFormat:@"map_model_%d.png", i];
            [picArray addObject:[UIImage imageNamed:imagePath]];
        }
        

        scrollView = [LeftAndRightSlideView slideViewWithFrame:CGRectMake(0, 41, 480, 155) pictures:picArray pass:curLand];
        scrollView.delegate = self;
        scrollView.playBtnDelegate = self;
        scrollView.scrollViewDelegate = self;
        [[[CCDirector sharedDirector] openGLView] addSubview:scrollView];
        
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
    bg = [CCSprite spriteWithSpriteFrameName:@"select_mission_bg.png"];
    bg.position = ccp(screenSize.width * 0.5f, screenSize.height * 0.5f);
    [self addChild:bg z:-1];
    
    back = [CCSprite spriteWithSpriteFrameName:@"bt_back_n.png"];
    back.position = ccp(3 + back.contentSize.width * 0.5f, screenSize.height - 3 - back.contentSize.height * 0.5f);
    [self addChild:back z:0];
    
    option = [CCSprite spriteWithSpriteFrameName:@"bt_option_n.png"];
    option.position = ccp(screenSize.width - 5 - option.contentSize.width * 0.5f, screenSize.height - 3 - option.contentSize.height * 0.5f);
    [self addChild:option z:0];
    
    help = [CCSprite spriteWithSpriteFrameName:@"bt_help_n.png"];
    help.position = ccp(screenSize.width - 5 - option.contentSize.width - 5 - help.contentSize.width * 0.5f, screenSize.height - 3 - help.contentSize.height * 0.5f);
    [self addChild:help z:0];
    
    select_mission = [CCSprite spriteWithSpriteFrameName:@"select_mission.png"];
    select_mission.position = ccp(screenSize.width * 0.5f, screenSize.height - 10 - select_mission.contentSize.height * 0.5f);
    [self addChild:select_mission z:0];
    
    mission_label = [CCSprite spriteWithSpriteFrameName:@"mission_number.png"];
    mission_label.position = ccp(screenSize.width * 0.35f, select_mission.position.y - 25 - mission_label.contentSize.height * 0.5f);
    [self addChild:mission_label z:0];
    
    mission_number = [CCLabelAtlas labelWithString:@"" charMapFile:@"number_mission.png" itemWidth:13 itemHeight:19 startCharMap:'0'];
    mission_number.anchorPoint = ccp(0.5f, 0.5f);
    mission_number.position = ccp(mission_label.position.x - mission_number.contentSize.width * 0.5f, mission_label.position.y - 2);
    [self addChild:mission_number z:0];
    [mission_number setString:[NSString stringWithFormat:@"%d",curLand]];
    
    wind = [CCSprite spriteWithSpriteFrameName:@"lvlup_wind.png"];
    wind.position = ccp(screenSize.width - 10 - wind.contentSize.width * 0.5f, 15 + wind.contentSize.height * 0.5f);
    [self addChild:wind z:0];
    
    lv_up = [CCSprite spriteWithSpriteFrameName:@"level_up.png"];
    lv_up.anchorPoint = CGPointMake(0.5f, 0);
//    lv_up.anchorPoint = ccp(lv_up.contentSize.width * 0.5f, lv_up.contentSize.height * 0.5f);
    lv_up.position = ccp(wind.position.x, wind.position.y - lv_up.contentSize.height * 0.2f);
    [self addChild:lv_up z:0];
    
    CCRotateBy *rotateRight = [CCRotateBy actionWithDuration:0.3 angle:20];
    CCRotateBy *rotateLeft = [CCRotateBy actionWithDuration:0.3 angle:-20];
    CCSequence * seq = [CCSequence actions:rotateRight, rotateLeft, rotateLeft, rotateRight, nil];
    CCRepeatForever *repeat = [CCRepeatForever actionWithAction:seq];
    [lv_up runAction:repeat];
    
    cover_wind = [CCSprite spriteWithSpriteFrameName:@"lvlup_wind_cover.png"];
    cover_wind.position = ccp(lv_up.position.x, lv_up.position.y + lv_up.contentSize.height * 0.2f);
    [self addChild:cover_wind z:0];
    
    rank1 = [CCSprite spriteWithSpriteFrameName:@"rank_hard.png"];
    rank1.position = ccp(screenSize.width * 0.5 + rank1.contentSize.width + 20, 30 + rank1.contentSize.height * 0.5f);
    [self addChild:rank1 z:0];
    
    rank2 = [CCSprite spriteWithSpriteFrameName:@"rank_normal.png"];
    rank2.position = ccp(screenSize.width * 0.5, 30 + rank2.contentSize.height * 0.5f);
    [self addChild:rank2 z:0];
    
    rank3 = [CCSprite spriteWithSpriteFrameName:@"rank_easy.png"];
    rank3.position = ccp(screenSize.width * 0.5 - rank3.contentSize.width - 20, 30 + rank3.contentSize.height * 0.5f);
    [self addChild:rank3 z:0];
//    
//    reward1 = [CCSprite spriteWithSpriteFrameName:@"reward_300.png"];
//    reward1.position = ccp(rank1.position.x, rank1.contentSize.height + reward1.contentSize.height * 0.5f + 5);
//    [self addChild:reward1 z:0 tag:8];
//    
//    reward2 = [CCSprite spriteWithSpriteFrameName:@"reward_200.png"];
//    reward2.position = ccp(rank2.position.x, rank2.contentSize.height + reward2.contentSize.height * 0.5f + 5);
//    [self addChild:reward2 z:0 tag:9];
//    
//    reward3 = [CCSprite spriteWithSpriteFrameName:@"reward_100.png"];
//    reward3.position = ccp(rank3.position.x, rank3.contentSize.height + reward3.contentSize.height * 0.5f + 5);
//    [self addChild:reward3 z:0 tag:10];
//    
    
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [self convertTouchToNodeSpace:[touches anyObject]];
    if (CGRectContainsPoint([rank1 boundingBox], touchPoint)) {
        CCSpriteFrame* frame1 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"rank_hard_focus.png"];
        [rank1 setDisplayFrame:frame1];
        
        CCSpriteFrame* frame2 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"rank_normal.png"];
        [rank2 setDisplayFrame:frame2];
        
        CCSpriteFrame* frame3 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"rank_easy.png"];
        [rank3 setDisplayFrame:frame3];
                
        [scrollView showPlayBtn];
        
        curRank = 1;
    }else if (CGRectContainsPoint([rank2 boundingBox], touchPoint)) {
        CCSpriteFrame* frame1 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"rank_hard.png"];
        [rank1 setDisplayFrame:frame1];
        
        CCSpriteFrame* frame2 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"rank_normal_focus.png"];
        [rank2 setDisplayFrame:frame2];
        
        CCSpriteFrame* frame3 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"rank_easy.png"];
        [rank3 setDisplayFrame:frame3];
        
        [scrollView showPlayBtn];
       
        curRank = 2;
    }else if (CGRectContainsPoint([rank3 boundingBox], touchPoint)) {
        CCSpriteFrame* frame1 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"rank_hard.png"];
        [rank1 setDisplayFrame:frame1];
        
        CCSpriteFrame* frame2 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"rank_normal.png"];
        [rank2 setDisplayFrame:frame2];
        
        CCSpriteFrame* frame3 = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"rank_easy_focus.png"];
        [rank3 setDisplayFrame:frame3];
        
        [scrollView showPlayBtn];
        
        curRank = 3;
    }else if(CGRectContainsPoint(lv_up.boundingBox, touchPoint)){
        [scrollView removeFromSuperview];
        [[CCDirector sharedDirector] replaceScene:[TowerUpgradeLayer scene:curLand]];
    }else if(CGRectContainsPoint([back boundingBox], touchPoint)){
        [scrollView removeFromSuperview];
        [[CCDirector sharedDirector] replaceScene:[ChooseSceneLayer scene:1]];
    }else if(CGRectContainsPoint(help.boundingBox, touchPoint)){
        // 进入教学模式
        [scrollView removeFromSuperview];
        [[CCDirector sharedDirector] replaceScene:[GameLayer scene:1 rank:1 land:1 isTeaching:YES]];
    }
}

- (UIImage *) renderUIImageFromSprite :(CCSprite *)sprite 
{
    int tx = sprite.contentSize.width;
    int ty = sprite.contentSize.height;
    
    CCRenderTexture *renderer	= [CCRenderTexture renderTextureWithWidth:tx height:ty];
    
    sprite.anchorPoint	= CGPointZero;
    
    [renderer begin];
    [sprite visit];
    [renderer end];
    
    return [renderer getUIImageFromBuffer];
}

- (void)onClickPlayBtn:(int)curPage
{
    [scrollView removeFromSuperview];
    [[CCDirector sharedDirector] replaceScene:[GameLayer scene:curPage rank:curRank land:curLand isTeaching:NO]];
}

- (void) onScrolling:(int)curPage
{
    NSLog(@"curLand = %d, curPage = %d", curLand, curPage);
    [mission_number setString:[NSString stringWithFormat:@"%d",curPage]];
}

@end
