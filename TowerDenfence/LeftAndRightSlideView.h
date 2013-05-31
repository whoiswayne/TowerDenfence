//
//  GestureView.h
//  TestGameChoose
//
//  Created by mir on 13-4-17.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PlayBtnDelegate <NSObject>

- (void)onClickPlayBtn:(int)curPage;

@end

@protocol ScrollViewDelegate <NSObject>

- (void) onScrolling:(int)curPage;

@end


@interface LeftAndRightSlideView : UIView <UIGestureRecognizerDelegate>{
    UIView *mainView;
    UIView *slideView;
    
    UIImageView *curImageView;
    UIImageView *playImageView;
    
    BOOL isShow;
    int totalPage;  
    int curPage;
    CGRect scrollFrame;
    
    NSArray *imagesArray;               // 存放所有需要滚动的图片 UIImage
    NSMutableArray *curImages;          // 存放当前滚动的三张图片
    
    id<PlayBtnDelegate> playBtnDelegate;
    id<ScrollViewDelegate> scrollViewDelegate;
}

@property (assign, nonatomic) id delegate;
@property (assign, nonatomic) id<PlayBtnDelegate> playBtnDelegate;
@property (assign, nonatomic) id<ScrollViewDelegate> scrollViewDelegate;

+ (id)slideViewWithFrame:(CGRect)frame pictures:(NSArray *)pictureArray pass:(int)aPass;
- (void) showPlayBtn;

@end
