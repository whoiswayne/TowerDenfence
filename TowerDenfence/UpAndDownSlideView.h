//
//  GestureView.h
//  TestGameChoose
//
//  Created by mir on 13-4-17.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SlideViewDelegate <NSObject>

- (void)onCurFoucsPos:(int)curPage;

@end

@interface UpAndDownSlideView : UIView <UIGestureRecognizerDelegate>{
    UIView *mainView;
    UIView *slideView;
    
    UIView *shadowView;
    
    UIImageView *curImageView;
    UIImageView *playImageView;
    
    BOOL isShow;
    int totalPage;  
    int curPage;
    CGRect scrollFrame;
    
    NSArray *imagesArray;               // 存放所有需要滚动的图片 UIImage
    NSMutableArray *curImages;          // 存放当前滚动的三张图片
    
    id<SlideViewDelegate> delegate;
}

@property (assign, nonatomic) id<SlideViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame pictures:(NSArray *)pictureArray;
- (void) showPlayBtn;
- (int) curPage;

@end
