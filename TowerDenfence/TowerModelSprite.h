//
//  TowerModelInfo.h
//  TowerDefence
//
//  Created by mir-macmini5 on 13-4-9.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@protocol TowerModelDelegate <NSObject>

- (void)onAddPriceLabel:(CCLabelAtlas *)priceLabel;

@end

@interface TowerModelSprite : CCSprite{
    int towerNumber;
    int towerPrice;
    int curGold;
    
    Boolean isGoldEnough;
    
    id<TowerModelDelegate> delegate;
}

@property (nonatomic,assign) int towerNumber;
@property (nonatomic,assign) int towerPrice;
@property (nonatomic,assign) int curGold;

@property (nonatomic,assign) Boolean isGoldEnough;

@property (nonatomic,assign) id<TowerModelDelegate> delegate;

+ (id)towerModelWithNum:(int)num price:(int)aPrice curGold:(int)curGold;

- (void)shiftSprite;

@end
