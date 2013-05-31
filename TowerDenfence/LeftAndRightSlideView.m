//
//  GestureView.m
//  TestGameChoose
//
//  Created by mir on 13-4-17.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "LeftAndRightSlideView.h"
#import <QuartzCore/QuartzCore.h>

@interface LeftAndRightSlideView  (Private)


- (id)initWithFrame:(CGRect)frame pictures:(NSArray *)pictureArray pass:(int)aPass;

- (void) refreshSlideView;
- (NSArray *) getDisplayImagesWithCurpage:(int)page;
- (int) validPageValue:(NSInteger)value;
- (UIImage *) scaleImage:(UIImage *)image toScale:(float)scaleSize;
- (void) loadGesture;
- (UIImage *) coverShadow: (UIImage *) image;
- (void) removePlayBtn;
- (void) clickPlayBtn;
- (void) scrolling;


@end

@implementation LeftAndRightSlideView

@synthesize delegate;
@synthesize playBtnDelegate;
@synthesize scrollViewDelegate;

+ (id)slideViewWithFrame:(CGRect)frame pictures:(NSArray *)pictureArray pass:(int)aPass
{
    return [[[self alloc] initWithFrame:frame pictures:pictureArray pass:aPass] autorelease];
}

- (id) initWithFrame:(CGRect)frame pictures:(NSArray *)pictureArray pass:(int)aPass
{
    self = [super initWithFrame:frame];
    if(self)
    {
        scrollFrame = CGRectMake(0, 0, 240, 150);
        totalPage = pictureArray.count;
        curPage =  aPass;                      // 显示的是图片数组里的第1张图片 数组照片：1 2 3
        curImages = [[NSMutableArray alloc] init];
        imagesArray = [[NSArray alloc] initWithArray:pictureArray];
        
        slideView = [[UIView alloc] initWithFrame:frame];
        slideView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:slideView];
        [slideView release];
        
        slideView.frame = CGRectMake(0, 25, scrollFrame.size.width * 5,
                                                scrollFrame.size.height);
                
        [self refreshSlideView];
        slideView.center = self.center;
        
        [self loadGesture];
        
        isShow = NO;
    }
    
    return self;
}

- (void) dealloc
{
    [curImages removeAllObjects];
    [curImages release];
    [super dealloc];
}

- (void) refreshSlideView 
{
    NSArray *subViews = [slideView subviews];
    if([subViews count] != 0) {
        [subViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    [self getDisplayImagesWithCurpage:curPage];
    
    for (int i = 0; i < 5; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:scrollFrame];
        UIImage *img = [curImages objectAtIndex:i];
        img = [self scaleImage:img toScale:0.5f];
        imageView.image = img;
        imageView.contentMode = UIViewContentModeCenter;
        if (i != 2) {
//            UIView *shadowView = [[UIView alloc] initWithFrame: CGRectMake(imageView.frame.origin.x + 17, imageView.frame.origin.y + 5, imageView.image.size.width, imageView.image.size.height)];
//            
//            shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//            [imageView addSubview:shadowView];
//            [shadowView release];
        } else {
            curImageView = imageView;
        }
        
        imageView.frame = CGRectOffset(imageView.frame, scrollFrame.size.width * i, 0);
        
        [slideView addSubview:imageView];
        [imageView release];
    
        UIImageView *imgFrameView = [[UIImageView alloc] initWithFrame:scrollFrame];
        UIImage *imgFrame = [UIImage imageNamed:@"mission_frame.png"];
        imgFrame = [self scaleImage:imgFrame toScale:0.5f];
        imgFrameView.bounds = CGRectMake(imgFrameView.bounds.origin.x, imgFrameView.bounds.origin.y, imgFrameView.bounds.size.width * 0.9f, imgFrameView.bounds.size.height);
        imgFrameView.image = imgFrame;
        imgFrameView.frame = CGRectOffset(imgFrameView.frame, scrollFrame.size.width * i, 0);
        
        [slideView addSubview:imgFrameView];
        [imgFrameView release];
        
        
    }
    
    slideView.center = self.center;
    
}

- (UIImage *) coverShadow: (UIImage *) image
{
    // load the image
    UIImage *img = image;
    
    // begin a new image context, to draw our colored image onto
    UIGraphicsBeginImageContext(img.size);
    
    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the fill color
    [[UIColor colorWithRed:0 green:0 blue:1 alpha:0.1] setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // set the blend mode to color burn, and the original image
//    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGContextSetBlendMode(context, kCGBlendModeColorBurn);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextDrawImage(context, rect, img.CGImage);
    
    // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
    CGContextClipToMask(context, rect, img.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);
    
    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return the color-burned image
    return coloredImg;
}

- (NSArray *) getDisplayImagesWithCurpage:(int)page
{
    
    int pre2 = [self validPageValue:curPage-2];
    int pre1 = [self validPageValue:curPage-1];
    int last1 = [self validPageValue:curPage+1];
    int last2 = [self validPageValue:curPage+2];
    
    if([curImages count] != 0) [curImages removeAllObjects];
    
    [curImages addObject:[imagesArray objectAtIndex:pre2-1]];
    [curImages addObject:[imagesArray objectAtIndex:pre1-1]];
    [curImages addObject:[imagesArray objectAtIndex:curPage-1]];
    [curImages addObject:[imagesArray objectAtIndex:last1-1]];
    [curImages addObject:[imagesArray objectAtIndex:last2-1]];
    
    return curImages;
}

- (int) validPageValue:(NSInteger)value
{
    if(value <= 0) value = totalPage + value;
    if(value >= totalPage + 1) value = value - totalPage;
    
    return value;
}

- (UIImage *) scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    // 创建一个bitmap的context  
	// 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

- (void) loadGesture
{
    UISwipeGestureRecognizer *leftGesturerecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [leftGesturerecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [slideView addGestureRecognizer:leftGesturerecognizer];
    [leftGesturerecognizer release];
    
    UISwipeGestureRecognizer *rightGesturerecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [rightGesturerecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [slideView addGestureRecognizer:rightGesturerecognizer];
    [rightGesturerecognizer release];
      
}

- (void) handleSingleTap:(UITapGestureRecognizer *)recognizer
{
//    NSLog(@"handleSingleTap view");
}

- (void) handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
    if(recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
        
//        NSLog(@"swipe down");
        //执行程序
        
    }
    if(recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
        
//        NSLog(@"swipe up");
        //执行程序
    }
    
    if(recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        
//        NSLog(@"swipe left");
        //动画
        // Slide the view down off screen
//        CGRect frame = slideView.frame;   
        [UIView beginAnimations:nil context:NULL];

        [UIView animateWithDuration:0.2 animations:^
        {
            slideView.center = CGPointMake(slideView.center.x - 240, slideView.center.y);
        } completion:^(BOOL finished)
        { 
            curPage = [self validPageValue:curPage + 1];
            [self scrolling];
            [self refreshSlideView];
            
            if (isShow) {
                [self removePlayBtn];
                [self showPlayBtn];
            }
        }];
          
        [UIView commitAnimations];
    }
    
    if(recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        
//        NSLog(@"swipe right");
        //滑动动画
        [UIView beginAnimations:nil context:NULL];
        
        [UIView animateWithDuration:0.2 animations:^
         {
             slideView.center = CGPointMake(slideView.center.x + 240, slideView.center.y);
         } completion:^(BOOL finished)
         {
             curPage = [self validPageValue:curPage - 1];
             [self scrolling];
             [self refreshSlideView];
             
             if (isShow) {
                 [self removePlayBtn];
                 [self showPlayBtn];
             }
         }];
        [UIView commitAnimations];
        
    }
}

//增加Play按钮
- (void) showPlayBtn
{
    if (isShow) {
        return;
    }
    
    UIImage *dImage = [UIImage imageNamed:@"bt_play_n.png"];
    playImageView = [[UIImageView alloc] initWithFrame:CGRectMake(slideView.bounds.size.width / 2.0f - dImage.size.width / 4.0f, slideView.bounds.size.height / 2.0f - dImage.size.height / 4.0f, dImage.size.width / 2.0f, dImage.size.height / 2.0f)];
    playImageView.image = dImage;
    [slideView addSubview: playImageView];
    
    // 给Play按钮加点击手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
    [playImageView addGestureRecognizer:singleTap];//这个可以加到任何控件上,比如你只想响应WebView，我正好填满整个屏幕
    [singleTap release];
    
    isShow = YES;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:[touch view]];
    
    if (CGRectContainsPoint(playImageView.frame, point)) {
        [self clickPlayBtn];
    }
}

- (void) clickPlayBtn
{
    if(playBtnDelegate && [playBtnDelegate respondsToSelector:@selector(onClickPlayBtn:)]){
        [playBtnDelegate onClickPlayBtn:curPage];
    }
}

- (void) scrolling
{
    if (scrollViewDelegate && [scrollViewDelegate respondsToSelector:@selector(onScrolling:)]) {
        [scrollViewDelegate onScrolling:curPage];
    }
}

// 移除Play按钮
- (void) removePlayBtn
{
    if (isShow) {
        [playImageView release];
        [playImageView removeFromSuperview];
        isShow = NO;
    }
}

@end
