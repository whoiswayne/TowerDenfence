//
//  UpgradeItemSprite.m
//  TowerDenfence
//
//  Created by mir-macmini5 on 13-4-19.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "UpgradeItemSprite.h"

@interface UpgradeItemSprite(Private)

- (id)initWithUpgradeItem:(UpgradeItems)aItem curGrade:(int)aCurGrade maxGrade:(int)aMaxGrade towerIndex:(int) towerIndex canUpgrade:(BOOL)canUpgrade;
- (void) addGradeNumber;

@end

@implementation UpgradeItemSprite

@synthesize upgradeItem;
@synthesize requiredGold;
@synthesize curGrade;
@synthesize delegate;

+ (id)upgradeItem:(UpgradeItems)aItem curGrade:(int)aCurGrade maxGrade:(int)aMaxGrade towerIndex:(int) towerIndex canUpgrade:(BOOL)canUpgrade
{
    return [[[self alloc] initWithUpgradeItem:aItem curGrade:aCurGrade maxGrade:aMaxGrade towerIndex:towerIndex canUpgrade:canUpgrade] autorelease];
}

- (id)initWithUpgradeItem:(UpgradeItems)aItem curGrade:(int)aCurGrade maxGrade:(int)aMaxGrade towerIndex:(int) towerIndex canUpgrade:(BOOL)canUpgrade
{
    self = [super init];
    if (self) {
        upgradeItem = aItem;
        curGrade = aCurGrade;
        maxGrade = aMaxGrade;
        
        NSString *update1_1_str = nil;
        NSString *update2_1_str = nil;
        NSString *update2_2_str = nil;
        NSString *update3_1_str = nil;
        NSString *update4_1_str = nil;
        
        switch (towerIndex) {
            case 1:
                update1_1_str = @"upgrade_att_speed_add10_%d.png";
                update2_1_str = @"upgrade_cri_%d.png";
                update2_2_str = @"upgrade_reduce_5coin_%d.png";
                update3_1_str = @"upgrade_multi_attack_%d.png";
                break;
                
            case 2:
                update1_1_str = @"upgrade_att_power_add10_%d.png";
                update2_1_str = @"upgrade_att_range_add10_%d.png";
                update2_2_str = @"upgrade_att_speed_add10_%d.png";
                update3_1_str = @"upgrade_firing_%d.png";
                update4_1_str = @"upgrade_premiums_50pct_%d.png";
                break;
                
            case 3:
                update1_1_str = @"upgrade_att_speed_add10_%d.png";
                update2_1_str = @"upgrade_prolong_land_slow_time_%d.png";
                update2_2_str = @"upgrade_att_power_add10_%d.png";
                update3_1_str = @"upgrade_all_slow_%d.png";
                break;
                
            case 4:
                update1_1_str = @"upgrade_att_range_add10_%d.png";
                update2_1_str = @"upgrade_att_speed_add10_%d.png";
                update2_2_str = @"upgrade_multi_attack_%d.png";
                update3_1_str = @"upgrade_explosion_%d.png";
                break;
        }
        
//        int index = aCurGrade == 0 ? 0 : 1;
        int index = canUpgrade ? 1 : 0;
        NSString *spriteName = nil;
        switch (aItem) {
            case upgrade1_1_idx:
                spriteName = [NSString stringWithFormat:update1_1_str,index];
                break;
            case upgrade2_1_idx:
                spriteName = [NSString stringWithFormat:update2_1_str,index];
                break;
            case upgrade2_2_idx:
                spriteName = [NSString stringWithFormat:update2_2_str,index];
                break;
            case upgrade3_1_idx:
                spriteName = [NSString stringWithFormat:update3_1_str,index];
                break;
            case upgrade4_1_idx:
                spriteName = [NSString stringWithFormat:update4_1_str,index];
                break;
        }
        
        [super initWithSpriteFrameName:spriteName];
        [self addGradeNumber];
    }
    return self;
}

- (void) addGradeNumber
{
    numberLabel = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%d/%d", curGrade, maxGrade] charMapFile:@"number_upgrade.png" itemWidth:4 itemHeight:6.5 startCharMap:'/'];
    numberLabel.anchorPoint = ccp(0.5f, 0.5f);
    numberLabel.position = ccp(31, 10);
    [self addChild:numberLabel];
}

- (void)setDelegate:(id<UpgradeItemDelegate>)aDelegate
{
    delegate = aDelegate;
    
//    CCSprite *numberBg = [CCSprite spriteWithSpriteFrameName:@"number_bg.png"];
//    numberBg.position = ccp(self.contentSize.width/2, 3);
//    [self addChild:numberBg];
    
//    numberLabel = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%d/%d",curGrade,maxGrade] charMapFile:@"number_upgrade.png" itemWidth:7.5 itemHeight:17 startCharMap:'/'];
//    numberLabel.anchorPoint = ccp(0.5f, 0.5f);
//    numberLabel.position = ccpAdd(self.position, ccp(0, -self.contentSize.height/2 + 5));
    
    if(delegate && [delegate respondsToSelector:@selector(onAddNumberLabel:)]){
//        [delegate onAddNumberLabel:numberLabel];
    }
}

- (void)upgrade:(UpgradeItems)aItem grade:(int)aGrade towerIndex:(int) towerIndex
{
    curGrade = aGrade;
    
    if (curGrade <= maxGrade) {
        [numberLabel setString:[NSString stringWithFormat:@"%d/%d",curGrade,maxGrade]];
    }
    
    NSString *update1_1_str = nil;
    NSString *update2_1_str = nil;
    NSString *update2_2_str = nil;
    NSString *update3_1_str = nil;
    NSString *update4_1_str = nil;
    
    switch (towerIndex) {
        case 1:
            update1_1_str = @"upgrade_att_speed_add10_1.png";
            update2_1_str = @"upgrade_cri_1.png";
            update2_2_str = @"upgrade_reduce_5coin_1.png";
            update3_1_str = @"upgrade_multi_attack_1.png";
            break;
            
        case 2:
            update1_1_str = @"upgrade_att_power_add10_1.png";
            update2_1_str = @"upgrade_att_range_add10_1.png";
            update2_2_str = @"upgrade_att_speed_add10_1.png";
            update3_1_str = @"upgrade_firing_1.png";
            update4_1_str = @"upgrade_premiums_50pct_1.png";
            break;
            
        case 3:
            update1_1_str = @"upgrade_att_speed_add10_1.png";
            update2_1_str = @"upgrade_prolong_land_slow_time_1.png";
            update2_2_str = @"upgrade_att_power_add10_1.png";
            update3_1_str = @"upgrade_all_slow_1.png";
            break;
            
        case 4:
            update1_1_str = @"upgrade_att_range_add10_1.png";
            update2_1_str = @"upgrade_att_speed_add10_1.png";
            update2_2_str = @"upgrade_multi_attack_1.png";
            update3_1_str = @"upgrade_explosion_1.png";
            break;

    }
    
    NSString *spriteName = nil;
    switch (aItem) {
        case upgrade1_1_idx:
            spriteName = update1_1_str;
            break;
        case upgrade2_1_idx:
            spriteName = [NSString stringWithFormat:update2_1_str,upgrade2_1_idx];
            break;
        case upgrade2_2_idx:
            spriteName = [NSString stringWithFormat:update2_2_str,upgrade2_2_idx];
            break;
        case upgrade3_1_idx:
            spriteName = [NSString stringWithFormat:update3_1_str,upgrade3_1_idx];
            break;
        case upgrade4_1_idx:
            spriteName = [NSString stringWithFormat:update4_1_str,upgrade4_1_idx];
            break;
    }

    CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:spriteName];
    [self setDisplayFrame:frame];
}

- (int) maxGrade
{
    return maxGrade;
}

@end
