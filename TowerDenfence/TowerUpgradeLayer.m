//
//  TowerUpgradeLayer.m
//  TowerDenfence
//
//  Created by mir-macmini5 on 13-4-19.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "TowerUpgradeLayer.h"

@interface TowerUpgradeLayer(Private)

- (id)initWithPass:(int)aPass;

- (void)addSprites;
- (void)refreshUISprite;
- (void)addSlideView;

- (void)addLineSprite1;
- (void)addLineSprite2;
- (void)addLineSprite3;
- (void)addLineSprite4;

- (void) backClick;
- (void) skill1Click;
- (void) skill2Click;
- (void) skill3Click;
- (void) skill4Click;
- (void) skill5Click;
- (void) upgradeBtnClick;

- (int) getMaxGradeByTower: (int) aTower skillIndex: (int) aSkill;

@end

@implementation TowerUpgradeLayer

+ (id)scene:(int)aPass
{
    CCScene *scene = [CCScene node];
    
    CCLayer *gameLayer = [[[self alloc] initWithPass:aPass] autorelease];
    
    [scene addChild:gameLayer];
    
    return scene;
}

- (id)initWithPass:(int)aPass
{
    self = [super init];
    if (self) {
        curPass = aPass;
        curFoucsPos = 1;
        
        upgradeInfoDict = [[FileUtils readUpgradeInfo] retain];
//        NSLog(@"init upgradeInfoDict %@   count %d",upgradeInfoDict,[upgradeInfoDict count]);
        
        if(upgradeInfoDict && upgradeInfoDict.count > 0){
            curUpgradeInfo = [[upgradeInfoDict objectForKey:@"1"] retain];
        }else{
            curUpgradeInfo = [[UpgradeInfo alloc] init];
            curUpgradeInfo.towerNum = 1;
        }
        
//        NSLog(@"curUpgradeInfo %@",curUpgradeInfo);
        
//        NSLog(@"curUpgradeInfo.towerNum = %d,  %d, %d, %d, %d, %d", curUpgradeInfo.towerNum, curUpgradeInfo.upgrade1_1, curUpgradeInfo.upgrade2_1, curUpgradeInfo.upgrade2_2, curUpgradeInfo.upgrade3_1, curUpgradeInfo.upgrade4_1);
        self.isTouchEnabled = YES;
        
        [self addSprites];
        [self refreshUISprite];
        [self addSlideView];
        
    }
    return self;
}

- (void)dealloc
{
    if(curUpgradeInfo){
        
        [curUpgradeInfo release];
        curUpgradeInfo = nil;
    }

    
    if (upgradeInfoDict) {
        [upgradeInfoDict removeAllObjects];
        [upgradeInfoDict release];
        upgradeInfoDict = nil;
    }
    
    [super dealloc];
}

- (void) ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint touchPoint = [self convertTouchToNodeSpace:[touches anyObject]];
    
    if(CGRectContainsPoint(back.boundingBox, touchPoint)){
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"upgrade_back_selected.png"];
        [back setDisplayFrame:frame];
        
    }
}

- (void) ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    CGSize size = [[CCDirector sharedDirector] winSize];
    
    CGPoint touchPoint = [self convertTouchToNodeSpace:[touches anyObject]];
    
    if(CGRectContainsPoint(CGRectMake(back.boundingBox.origin.x - 10, back.boundingBox.origin.y - 10, back.boundingBox.size.width + 20, back.boundingBox.size.height + 20), touchPoint)){
        [self backClick];
        
    }else{
        CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"upgrade_back.png"];
        [back setDisplayFrame:frame];
    }
        
    if(CGRectContainsPoint(itemSprite1.boundingBox, touchPoint)){
        [self skill1Click];
        
    }else if(CGRectContainsPoint(itemSprite2.boundingBox, touchPoint)){
        [self skill2Click];
        
    }else if(CGRectContainsPoint(itemSprite3.boundingBox, touchPoint)){
        [self skill3Click];
        
    }else if(CGRectContainsPoint(itemSprite4.boundingBox, touchPoint)){
        [self skill4Click];
        
        
    }else if(CGRectContainsPoint(itemSprite5.boundingBox, touchPoint)){
        [self skill5Click];
        
    }else if(CGRectContainsPoint(upgradeBtn.boundingBox, touchPoint)){
        [self upgradeBtnClick];
    }
}

- (void) backClick
{
    if(curUpgradeInfo){
        [upgradeInfoDict setValue:curUpgradeInfo forKey:[NSString stringWithFormat:@"%d",curUpgradeInfo.towerNum]];
        [curUpgradeInfo release];
        curUpgradeInfo = nil;
    }
    
    if(upgradeInfoDict){
        [FileUtils writeUpgradeInfo:[upgradeInfoDict allValues]];
        [upgradeInfoDict removeAllObjects];
        [upgradeInfoDict release];
        upgradeInfoDict = nil;
    }
    
    if (scrollView) {
        [scrollView removeFromSuperview];
        scrollView = nil;
    }
    
    [[CCDirector sharedDirector] replaceScene:[ChoosePassLayer scene:curPass]];
}

- (void) skill1Click
{
    curFoucsUpgradeItem = itemSprite1;
    
    skillFocusFrame.position = ccp(155, 167);
    skillFocusFrame.visible = YES;
    skillExplain.visible = YES;
    
    CCSpriteFrame *frame = nil;
    switch (curFoucsPos) {
        case 1:
            frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"upgrade_att_speed_add10_explain.png"];
            break;
            
        case 2:
            frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"upgrade_att_power_add10_explain.png"];
            break;
            
        case 3:
            frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"upgrade_att_speed_add10_explain.png"];
            break;
            
        case 4:
            frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"upgrade_att_range_add10_explain.png"];
            break;
    }
    [skillExplain setDisplayFrame:frame];
}

- (void) skill2Click
{
    curFoucsUpgradeItem = itemSprite2;
    
    skillFocusFrame.position = ccp(238, 212);
    skillFocusFrame.visible = YES;
    skillExplain.visible = YES;
    
    CCSpriteFrame *frame = nil;
    switch (curFoucsPos) {
        case 1:
            frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"upgrade_att_cri_add5_explain.png"];
            break;
            
        case 2:
            frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"upgrade_att_range_add10_explain.png"];
            break;
            
        case 3:
            frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"upgrade_prolong_slow_time_explain.png"];
            break;
            
        case 4:
            frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"upgrade_att_speed_add10_explain.png"];
            break;
    }
    [skillExplain setDisplayFrame:frame];
}

- (void) skill3Click;
{
    curFoucsUpgradeItem = itemSprite3;
    
    skillFocusFrame.position = ccp(238, 119);
    skillFocusFrame.visible = YES;
    skillExplain.visible = YES;
    
    CCSpriteFrame *frame = nil;
    switch (curFoucsPos) {
        case 1:
            frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"upgrade_reduce_5coin_explain.png"];
            break;
            
        case 2:
            frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"upgrade_att_speed_add10_explain.png"];
            break;
            
        case 3:
            frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"upgrade_att_power_add10_explain.png"];
            break;
            
        case 4:
            frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"upgrade_multi_attack_explain.png"];
            if (curFoucsUpgradeItem.curGrade == 1) {
                frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"upgrade_ strike_2_explain.png"];
            } else if(curFoucsUpgradeItem.curGrade == 2){
                frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"upgrade_ strike_3_explain.png"];
            }
            break;
    }
    [skillExplain setDisplayFrame:frame];
}

- (void) skill4Click
{
    curFoucsUpgradeItem = itemSprite4;
    
    skillFocusFrame.position = ccp(330, 167);
    skillFocusFrame.visible = YES;
    skillExplain.visible = YES;
    
    CCSpriteFrame *frame = nil;
    switch (curFoucsPos) {
        case 1:
            frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"upgrade_multi_attack_explain.png"];
            break;
            
        case 2:
            frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"upgrade_attack_unslowed_explain.png"];
            break;
            
        case 3:
            frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"upgrade_attack_unslowed_explain.png"];
            break;
            
        case 4:
            frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"upgrade_explosion_explain.png"];
            break;
    }
    [skillExplain setDisplayFrame:frame];
}

- (void) skill5Click
{
    curFoucsUpgradeItem = itemSprite5;
    
    skillFocusFrame.position = ccp(420, 167);
    skillFocusFrame.visible = YES;
    skillExplain.visible = YES;
    
    CCSpriteFrame *frame = nil;
    switch (curFoucsPos) {
        case 1:
            //                frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"upgrade_attack_unslowed_explain.png"];
            break;
            
        case 2:
            frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"upgrade_premiums_50pct_explain.png"];
            break;
            
        case 3:
            //                frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"upgrade_attack_unslowed_explain.png"];
            break;
            
        case 4:
            //                frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"upgrade_explosion_explain.png"];
            break;
    }
    [skillExplain setDisplayFrame:frame];
}

- (void) upgradeBtnClick
{
    if(curFoucsUpgradeItem == itemSprite1){
        // 技能1的当前等级小于最大值才能升级
        if(curUpgradeInfo.upgrade1_1 < itemSprite1.maxGrade){
            [itemSprite1 upgrade:itemSprite1.upgradeItem grade:itemSprite1.curGrade + 1 towerIndex:curFoucsPos];
            curUpgradeInfo.upgrade1_1 = curUpgradeInfo.upgrade1_1 + 1;
        }
        
        if(itemSprite1.curGrade == itemSprite1.maxGrade){
            // 升级线1, 技能2和3变亮
            CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"upgrade_skill_tree_line_1_1.png"];
            [upgradeSkillTreeLine1 setDisplayFrame:frame];
            [self refreshUISprite];
        }
        
        // 技能2 3升级要求技能1满级
    }
    
    if (curFoucsUpgradeItem == itemSprite2 && curUpgradeInfo.upgrade1_1 == itemSprite1.maxGrade){
        if(curUpgradeInfo.upgrade2_1 < itemSprite2.maxGrade){
            [itemSprite2 upgrade:itemSprite2.upgradeItem grade:itemSprite2.curGrade + 1 towerIndex:curFoucsPos];
            curUpgradeInfo.upgrade2_1 = curUpgradeInfo.upgrade2_1 + 1;
        }
        
        if(itemSprite2.curGrade == itemSprite2.maxGrade && itemSprite3.curGrade == itemSprite3.maxGrade){
            CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"upgrade_skill_tree_line_2_1.png"];
            [upgradeSkillTreeLine2 setDisplayFrame:frame];
            [self refreshUISprite];
        }
    }
    
    if (curFoucsUpgradeItem == itemSprite3){
        CCSpriteFrame *frame = nil;
        if (curFoucsPos == 4 && curFoucsUpgradeItem.curGrade == 0) {
            frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"upgrade_ strike_2_explain.png"];
            [skillExplain setDisplayFrame:frame];
        } else if(curFoucsPos == 4 && curFoucsUpgradeItem.curGrade == 1){
            frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"upgrade_ strike_3_explain.png"];
            [skillExplain setDisplayFrame:frame];
        }
        
        if (curUpgradeInfo.upgrade1_1 == itemSprite1.maxGrade) {
            if(curUpgradeInfo.upgrade2_2 < itemSprite3.maxGrade){
                [itemSprite3 upgrade:itemSprite3.upgradeItem grade:itemSprite3.curGrade + 1 towerIndex:curFoucsPos];
                curUpgradeInfo.upgrade2_2 = curUpgradeInfo.upgrade2_2 + 1;
            }
            
            if(itemSprite2.curGrade == itemSprite2.maxGrade && itemSprite3.curGrade == itemSprite3.maxGrade){
                CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"upgrade_skill_tree_line_2_1.png"];
                [upgradeSkillTreeLine2 setDisplayFrame:frame];
                [self refreshUISprite];
            }
        }
        // 技能4升级要求技能2 3满级
    }
    
    if (curFoucsUpgradeItem == itemSprite4 && curUpgradeInfo.upgrade2_1 == itemSprite2.maxGrade && curUpgradeInfo.upgrade2_2 == itemSprite3.maxGrade){
        
        if(curUpgradeInfo.upgrade3_1 < itemSprite4.maxGrade){
            [itemSprite4 upgrade:itemSprite3.upgradeItem grade:itemSprite4.curGrade + 1 towerIndex:curFoucsPos];
            curUpgradeInfo.upgrade3_1 = curUpgradeInfo.upgrade3_1 + 1;
        }
        
        // 塔2才能升级5技能, 升级线3才会变亮
        if(itemSprite4.curGrade == itemSprite4.maxGrade || curFoucsPos == 2){
            CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:@"upgrade_skill_tree_line_3_1.png"];
            [upgradeSkillTreeLine3 setDisplayFrame:frame];
            [self refreshUISprite];
        }
    }
    
    if (curFoucsUpgradeItem == itemSprite5 && curUpgradeInfo.upgrade4_1 == itemSprite4.maxGrade){
        
        if(curUpgradeInfo.upgrade4_1 < itemSprite5.maxGrade){
            [itemSprite5 upgrade:itemSprite5.upgradeItem grade:itemSprite5.curGrade + 1 towerIndex:curFoucsPos];
            curUpgradeInfo.upgrade4_1 = curUpgradeInfo.upgrade4_1 + 1;
        }
    }
    
    
}

- (void)addSprites
{
    CGSize size = [[CCDirector sharedDirector] winSize];
    CCSpriteFrameCache *framCache = [CCSpriteFrameCache sharedSpriteFrameCache];
    
    [framCache addSpriteFramesWithFile:@"td_upgrade_sprites.plist"];
    CCSprite *bgSprite = [CCSprite spriteWithSpriteFrameName:@"upgrade_bg.png"];
    bgSprite.position = ccp(size.width / 2, size.height / 2);
    [self addChild:bgSprite z:0];
    
    CCSprite *slideViewBg = [CCSprite spriteWithSpriteFrameName:@"upgrade_lvlup_bg.png"];
    slideViewBg.position = ccp(55, 160.5);
    [self addChild:slideViewBg z:0];
    
    CCSprite *titleSprite = [CCSprite spriteWithSpriteFrameName:@"upgrade_lvlup_shop.png"];
    titleSprite.position = ccp(241.0f, 293.0f);
    [self addChild:titleSprite];
    
    //显示当前钻石
    CCSprite *diamondSprite = [CCSprite spriteWithSpriteFrameName:@"upgrade_diamond.png"];
    diamondSprite.position = ccp(size.width - 35, size.height - 25);
    [self addChild:diamondSprite];
    
    back = [CCSprite spriteWithSpriteFrameName:@"upgrade_back.png"];
    back.position = ccp(40, size.height - 25);
    [self addChild:back];
    
    //升级的按钮
    upgradeBtn = [CCSprite spriteWithSpriteFrameName:@"upgrade_lvlup.png"];
    upgradeBtn.position = ccp(430, 46);
    [self addChild:upgradeBtn z:1];
    
    // 免费获取
    forFree = [CCSprite spriteWithSpriteFrameName:@"upgrade_for_free.png"];
    forFree.position = ccp(28, 28);
    [self addChild:forFree z:1];
    
    // 现在购买
    buyNow = [CCSprite spriteWithSpriteFrameName:@"upgrade_buy_now.png"];
    buyNow.position = ccp(80, 28);
    [self addChild:buyNow z:1];
    
    //添加滑动框选中的精灵
    CCSprite *foucsSprite = [CCSprite spriteWithSpriteFrameName:@"upgrade_select_frame.png"];
    foucsSprite.position = ccp(57, 160);
    [self addChild:foucsSprite z:2];
    
    skillFocusFrame = [CCSprite spriteWithSpriteFrameName:@"upgrade_skill_focus_frame.png"];
    skillFocusFrame.position = ccp(155, 167);
    skillFocusFrame.visible = NO;
    [self addChild:skillFocusFrame z:2];
    
    skillExplain = [CCSprite spriteWithSpriteFrameName:@"upgrade_explosion_explain.png"];
    skillExplain.anchorPoint = ccp(0, 1.0f);
    skillExplain.position = ccp(125, 77);
    skillExplain.visible = NO;
    [self addChild:skillExplain];
    
    curGoldLabel = [CCLabelAtlas labelWithString:@"1000" charMapFile:@"number_upgrade_lvlup_owned_diamond.png" itemWidth:20 itemHeight:23 startCharMap:'0'];
    curGoldLabel.anchorPoint = ccp(1, 0.5f);
    curGoldLabel.position = ccp(size.width - 50, size.height - 25);
    [self addChild:curGoldLabel z:1];
    
    upgradeGoldLabel = [CCLabelAtlas labelWithString:@"30" charMapFile:@"number_upgrade_lvlup_diamond.png" itemWidth:10 itemHeight:13.5 startCharMap:'0'];
    upgradeGoldLabel.anchorPoint = ccp(1, 0.5f);
    upgradeGoldLabel.position = ccp(436, 58);
    [self addChild:upgradeGoldLabel z:1];
}

- (void)refreshUISprite
{
//    CGSize size = [[CCDirector sharedDirector] winSize];
    
//    skillFocusFrame.visible = NO;
//    skillExplain.visible = NO;
    
    [itemSprite1 removeFromParentAndCleanup:YES];
    [itemSprite2 removeFromParentAndCleanup:YES];
    [itemSprite3 removeFromParentAndCleanup:YES];
    [itemSprite4 removeFromParentAndCleanup:YES];
    [upgradeSkillTreeLine1 removeFromParentAndCleanup:YES];
    [upgradeSkillTreeLine2 removeFromParentAndCleanup:YES];
    
    // 只有塔2有5技能
    if (curFoucsPos != 2) {
        if (itemSprite5) {
            [itemSprite5 removeFromParentAndCleanup:YES];
            itemSprite5 = nil;
        }
        
        if (upgradeSkillTreeLine3) {
            [upgradeSkillTreeLine3 removeFromParentAndCleanup:YES];
            upgradeSkillTreeLine3 = nil;
        }
    }
    
    itemSprite1 = [[UpgradeItemSprite upgradeItem:upgrade1_1_idx curGrade:curUpgradeInfo.upgrade1_1 maxGrade:[self getMaxGradeByTower:curFoucsPos skillIndex:1] towerIndex:curFoucsPos canUpgrade:YES] retain];
    itemSprite1.position = ccp(155, 168);
    itemSprite1.delegate = self;
    [self addChild:itemSprite1 z:1];
    curFoucsUpgradeItem = itemSprite1;
    
    // 技能2是否能升级
    BOOL canSkill2Upgrade = (curUpgradeInfo.upgrade1_1 == [self getMaxGradeByTower:curFoucsPos skillIndex:1]);
    itemSprite2 = [[UpgradeItemSprite upgradeItem:upgrade2_1_idx curGrade:curUpgradeInfo.upgrade2_1 maxGrade:[self getMaxGradeByTower:curFoucsPos skillIndex:2] towerIndex:curFoucsPos canUpgrade:canSkill2Upgrade] retain];
    itemSprite2.position = ccp(238, 213);
    itemSprite2.delegate = self;
    [self addChild:itemSprite2 z:1];
    
    // 技能3是否能升级
    BOOL canSkill3Upgrade = (curUpgradeInfo.upgrade1_1 == [self getMaxGradeByTower:curFoucsPos skillIndex:1]);
    itemSprite3 = [[UpgradeItemSprite upgradeItem:upgrade2_2_idx curGrade:curUpgradeInfo.upgrade2_2 maxGrade:[self getMaxGradeByTower:curFoucsPos skillIndex:3] towerIndex:curFoucsPos canUpgrade:canSkill3Upgrade] retain];
    itemSprite3.position = ccp(238, 120);
    itemSprite3.delegate = self;
    [self addChild:itemSprite3 z:1];
    
    // 技能4是否能升级
    BOOL canSkill4Upgrade = ((curUpgradeInfo.upgrade2_1 == [self getMaxGradeByTower:curFoucsPos skillIndex:2]) && (curUpgradeInfo.upgrade2_2 == [self getMaxGradeByTower:curFoucsPos skillIndex:3]));
    itemSprite4 = [[UpgradeItemSprite upgradeItem:upgrade3_1_idx curGrade:curUpgradeInfo.upgrade3_1 maxGrade:[self getMaxGradeByTower:curFoucsPos skillIndex:4] towerIndex:curFoucsPos canUpgrade:canSkill4Upgrade] retain];
    itemSprite4.position = ccp(330, 168);
    itemSprite4.delegate = self;
    [self addChild:itemSprite4 z:1];
    
    [self addLineSprite1];    
    [self addLineSprite2];
    
    if (curFoucsPos == 2) {
        // 技能5是否能升级
        BOOL canSkill5Upgrade = (curUpgradeInfo.upgrade3_1 == [self getMaxGradeByTower:curFoucsPos skillIndex:4]);
        itemSprite5 = [[UpgradeItemSprite upgradeItem:upgrade4_1_idx curGrade:curUpgradeInfo.upgrade4_1 maxGrade:[self getMaxGradeByTower:curFoucsPos skillIndex:5] towerIndex:curFoucsPos canUpgrade:canSkill5Upgrade] retain];
        itemSprite5.position = ccp(420, 168);
        itemSprite5.delegate = self;
        [self addChild:itemSprite5 z:1];
        
        [self addLineSprite3];
    }
}

- (void)addLineSprite1
{
    if(itemSprite1.curGrade == itemSprite1.maxGrade){
        upgradeSkillTreeLine1 = [CCSprite spriteWithSpriteFrameName:@"upgrade_skill_tree_line_1_1.png"];
    }else{
        upgradeSkillTreeLine1 = [CCSprite spriteWithSpriteFrameName:@"upgrade_skill_tree_line_1_0.png"];
    }
    upgradeSkillTreeLine1.anchorPoint = ccp(0, 0.5f);
    upgradeSkillTreeLine1.position = ccp(165, 168);
    [self addChild:upgradeSkillTreeLine1 z:0];
}

- (void)addLineSprite2
{
    if(itemSprite2.curGrade == itemSprite2.maxGrade  && itemSprite3.curGrade == itemSprite3.maxGrade){
        upgradeSkillTreeLine2 = [CCSprite spriteWithSpriteFrameName:@"upgrade_skill_tree_line_2_1.png"];
    }else{
        upgradeSkillTreeLine2 = [CCSprite spriteWithSpriteFrameName:@"upgrade_skill_tree_line_2_0.png"];
    }
    upgradeSkillTreeLine2.anchorPoint = ccp(0, 0.5f);
    upgradeSkillTreeLine2.position = ccp(250, 168);
    [self addChild:upgradeSkillTreeLine2 z:0];
}

- (void)addLineSprite3
{
    if(itemSprite4.curGrade == itemSprite4.maxGrade){
        upgradeSkillTreeLine3 = [CCSprite spriteWithSpriteFrameName:@"upgrade_skill_tree_line_3_1.png"];
    }else{
        upgradeSkillTreeLine3 = [CCSprite spriteWithSpriteFrameName:@"upgrade_skill_tree_line_3_0.png"];
    }
    upgradeSkillTreeLine3.anchorPoint = ccp(0, 0.5f);
    upgradeSkillTreeLine3.position = ccp(350, 168);
    [self addChild:upgradeSkillTreeLine3 z:0];
}

- (void)addSlideView
{
    if (scrollView) {
        return;
    }
    
    NSMutableArray *picArray = [NSMutableArray arrayWithCapacity:2];
    
    for (int i = 1; i <= 4; i++) {
        NSString *imagePath = [NSString stringWithFormat:@"tower_%d.png", i];
        [picArray addObject:[UIImage imageNamed:imagePath]];
    }
    
    scrollView = [[UpAndDownSlideView alloc] initWithFrame:CGRectMake(7, 31, 80, 195) pictures:picArray];
    scrollView.delegate = self;
    [[[CCDirector sharedDirector] openGLView] addSubview:scrollView];
    [scrollView release];
}

//delegate
- (void)onAddNumberLabel:(id)numberLabel
{
//    [self addChild:numberLabel z:3];
}

- (void)onCurFoucsPos:(int)curPage
{
    curFoucsPos = curPage;
    
    //更新curUpgrade的数据
    [upgradeInfoDict setValue:curUpgradeInfo forKey:[NSString stringWithFormat:@"%d",curUpgradeInfo.towerNum]];
    
    if (curUpgradeInfo) {
        [curUpgradeInfo release];
        curUpgradeInfo = nil;
    }
    
    curUpgradeInfo = [[upgradeInfoDict objectForKey:[NSString stringWithFormat:@"%d",curPage]] retain];
//    if(curUpgradeInfo.towerNum == 0){
//        curUpgradeInfo = [[UpgradeInfo alloc] init];
//        curUpgradeInfo.towerNum = curPage;
//    }
    
//    NSLog(@"curUpgradeInfo.towerNum = %d,  %d, %d, %d, %d, %d", curUpgradeInfo.towerNum, curUpgradeInfo.upgrade1_1, curUpgradeInfo.upgrade2_1, curUpgradeInfo.upgrade2_2, curUpgradeInfo.upgrade3_1, curUpgradeInfo.upgrade4_1);
    
    //刷新界面
//    [self removeAllChildrenWithCleanup:YES];
    [self refreshUISprite];
}

// 获取塔的技能的最高等级
// test
- (int) getMaxGradeByTower: (int) aTower skillIndex: (int) aSkill
{
    int i;
    switch (aTower) {
        case 1:
            // 塔1
            switch (aSkill) {
                case 1:
                    // 塔1技能1的最高等级
                    i = 5;
                    break;
                    
                case 2:
                    // 塔1技能2的最高等级
                    i = 5;
                    break;
                    
                case 3:
                    // 塔1技能3的最高等级
                    i = 2;
                    break;
                    
                case 4:
                    // 塔1技能4的最高等级
                    i = 1;
                    break;
                    
                case 5:
                    // 塔1技能5的最高等级
                    i = 0;
                    break;
            }
            break;
            
        case 2:
            // 塔2
            switch (aSkill) {
                case 1:
                    // 塔2技能1的最高等级
                    i = 5;
                    break;
                    
                case 2:
                    // 塔2技能2的最高等级
                    i = 5;
                    break;
                    
                case 3:
                    // 塔2技能3的最高等级
                    i = 5;
                    break;
                    
                case 4:
                    // 塔2技能4的最高等级
                    i = 1;
                    break;
                    
                case 5:
                    // 塔2技能5的最高等级
                    i = 1;
                    break;
            }
            break;
            
        case 3:
            // 塔3
            switch (aSkill) {
                case 1:
                    // 塔3技能1的最高等级
                    i = 5;
                    break;
                    
                case 2:
                    // 塔3技能2的最高等级
                    i = 5;
                    break;
                    
                case 3:
                    // 塔3技能3的最高等级
                    i = 5;
                    break;
                    
                case 4:
                    // 塔3技能4的最高等级
                    i = 1;
                    break;
                    
                case 5:
                    // 塔3技能5的最高等级
                    i = 0;
                    break;
            }
            break;
            
        case 4:
            // 塔4
            switch (aSkill) {
                case 1:
                    // 塔4技能1的最高等级
                    i = 5;
                    break;
                    
                case 2:
                    // 塔4技能2的最高等级
                    i = 5;
                    break;
                    
                case 3:
                    // 塔4技能3的最高等级
                    i = 2;
                    break;
                    
                case 4:
                    // 塔4技能4的最高等级
                    i = 1;
                    break;
                    
                case 5:
                    // 塔4技能5的最高等级
                    i = 0;
                    break;
            }
            break;
    }
    return i;
}

@end
