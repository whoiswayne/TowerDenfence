//
//  TowerModelInfo.m
//  TowerDefence
//
//  Created by mir-macmini5 on 13-4-9.
//
//

#import "TowerModelSprite.h"


/**
 * towermodel命名规则：tower_类型_model_1(2).png
 * 1，钱够，可以建造，2，钱不够，不可建造
 */
@interface TowerModelSprite(Private)

- (id)initWithNum:(int)num price:(int)aPrice curGold:(int)curGold;

@end

@implementation TowerModelSprite

@synthesize towerNumber;
@synthesize towerPrice;
@synthesize isGoldEnough;
@synthesize curGold;

@synthesize delegate;

+ (id)towerModelWithNum:(int)num price:(int)aPrice curGold:(int)curGold
{
    return [[[self alloc] initWithNum:num price:aPrice curGold:curGold] autorelease];
}

- (id)initWithNum:(int)num price:(int)aPrice curGold:(int)aGold
{
    if((self = [super init])){
        towerNumber = num;
        towerPrice = aPrice;
        curGold = aGold;
        
        int index = 0;
        if(curGold >= aPrice){
            index = 1;
            isGoldEnough = YES;
        }else{
            index = 2;
            isGoldEnough = NO;
        }
        
        NSString *frameName = [NSString stringWithFormat:@"tower_%d_model_%d.png",num,index];
        [super initWithSpriteFrameName:frameName];
        
//        NSString *frameName = nil;
//        if(num == 4 || num == 5 || num == 9){
//            frameName = [NSString stringWithFormat:@"tower_%d.png",num];
//        }else{
//            if(num == 1){
//                frameName = [NSString stringWithFormat:@"tower_%d_model.png",num];
//            }else{
//                frameName = [NSString stringWithFormat:@"tower_%d_001.png",num];
//            }
//        }
    }
    return self;
}

- (void)setDelegate:(id<TowerModelDelegate>)aDelegate
{
    delegate = aDelegate;
    
    CCLabelAtlas *piceLabel = [CCLabelAtlas labelWithString:[NSString stringWithFormat:@"%d",towerPrice] charMapFile:@"number_price.png" itemWidth:10 itemHeight:11 startCharMap:'0'];
    piceLabel.anchorPoint = ccp(0.5f, 0);
    piceLabel.position = ccpAdd(self.position, ccp(0, -self.contentSize.height/2));
    
    if(delegate && [delegate respondsToSelector:@selector(onAddPriceLabel:)]){
        [delegate onAddPriceLabel:piceLabel];
    }
}


- (void)dealloc
{
    [super dealloc];
}

- (void)shiftSprite
{
    NSString *frameName = [NSString stringWithFormat:@"tower_%d_model_1.png",towerNumber];
    
    isGoldEnough = YES;
    
    CCSpriteFrame *frame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:frameName];
    [self setDisplayFrame:frame];
}

@end
