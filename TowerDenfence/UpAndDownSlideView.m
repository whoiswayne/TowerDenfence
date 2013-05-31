//
//  GestureView.m
//  TestGameChoose
//
//  Created by mir on 13-4-17.
//  Copyright 2013年 __MyCompanyName__. All rights reserved.
//

#import "UpAndDownSlideView.h"
#import <QuartzCore/QuartzCore.h>

@interface UpAndDownSlideView  (Private)

- (void) refreshSlideView;
- (NSArray *) getDisplayImagesWithCurpage:(int)page;
- (int) validPageValue:(NSInteger)value;
- (UIImage *) scaleImage:(UIImage *)image toScale:(float)scaleSize;
- (void) loadGesture;
- (UIImage *) coverShadow: (UIImage *) image;
- (void) removePlayBtn;
- (void) clickPlayBtn;


@end

@implementation UpAndDownSlideView

@synthesize delegate;

- (id) initWithFrame:(CGRect)frame pictures:(NSArray *)pictureArray
{
    self = [super initWithFrame:frame];
    if(self)
    {
        scrollFrame = CGRectMake(0, 0, 80, 65);
        totalPage = pictureArray.count;
        curPage = 1;  // 显示的是图片数组里的第1张图片 数组照片：1 2 3
        curImages = [[NSMutableArray alloc] init];
        imagesArray = [[NSArray alloc] initWithArray:pictureArray];
        
        slideView = [[UIView alloc] initWithFrame:frame];
        slideView.backgroundColor = [UIColor clearColor];
        
        [self addSubview:slideView];
        [slideView release];
        
        slideView.frame = CGRectMake(0, 0, scrollFrame.size.width,
                                                scrollFrame.size.height * 3);
                
        [self refreshSlideView];
        
//        shadowView = [[UIView alloc] initWithFrame: CGRectMake(curImageView.frame.origin.x + 15, curImageView.frame.origin.y + 20, curImageView.image.size.width + 10, curImageView.image.size.height)];
//        
//        shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//        [self addSubview:shadowView];
//        [shadowView release];
        
//        NSLog(@"slideView.center.x = %f, y = %f", slideView.center.x, slideView.center.y);
        
        [self loadGesture];
        slideView.clipsToBounds = YES;
        
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
        if (i == 1) {
            curImageView = imageView;
        }
        
        imageView.frame = CGRectOffset(imageView.frame, 0, scrollFrame.size.height * (i - 1));
     
        [slideView addSubview:imageView];
        [imageView release];
    }
    
    slideView.center = self.center;
    
    if(delegate && [delegate respondsToSelector:@selector(onCurFoucsPos:)]){
        [delegate onCurFoucsPos:curPage];
    }
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
    [curImages addObject:[imagesArray objectAtIndex:curPage-1]];//默认选中
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
    UISwipeGestureRecognizer *upGesturerecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [upGesturerecognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [slideView addGestureRecognizer:upGesturerecognizer];
    [upGesturerecognizer release];
    
    UISwipeGestureRecognizer *downGesturerecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [downGesturerecognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [slideView addGestureRecognizer:downGesturerecognizer];
    [downGesturerecognizer release];
    
    UISwipeGestureRecognizer *shadowUpRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [shadowUpRecognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    [shadowView addGestureRecognizer:shadowUpRecognizer];
    [shadowUpRecognizer release];
    
    UISwipeGestureRecognizer *shadowDownRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    [shadowDownRecognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
    [shadowView addGestureRecognizer:shadowDownRecognizer];
    [shadowDownRecognizer release];     
    
}

- (void) handleSingleTap:(UITapGestureRecognizer *)recognizer
{
//    NSLog(@"handleSingleTap view");
}

- (void) handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer
{
       
    if(recognizer.direction == UISwipeGestureRecognizerDirectionDown) {
//        NSLog(@"swipe down");
        
        [UIView beginAnimations:nil context:NULL];

        [UIView animateWithDuration:0.2 animations:^
        {
            for (int i = 0; i < [[slideView subviews] count]; i ++) {
                UIImageView *tempImageView = [[slideView subviews] objectAtIndex:i];
                tempImageView.center = CGPointMake(tempImageView.center.x, tempImageView.center.y + 65);
            }
            
        } completion:^(BOOL finished)
        { 
            curPage = [self validPageValue:curPage - 1];
            [self refreshSlideView];
            
            if (isShow) {
                [self removePlayBtn];
                [self showPlayBtn];
            }
        }]; 
        [UIView commitAnimations];
    }
    
    if(recognizer.direction == UISwipeGestureRecognizerDirectionUp) {
//        NSLog(@"swipe up");
        
        //滑动动画
        [UIView beginAnimations:nil context:NULL];
        
        [UIView animateWithDuration:0.2 animations:^
         {
             for (int i = 0; i < [[slideView subviews] count]; i ++) {
                 UIImageView *tempImageView = [[slideView subviews] objectAtIndex:i];
                 tempImageView.center = CGPointMake(tempImageView.center.x, tempImageView.center.y - 65);
             }
         } completion:^(BOOL finished)
         {
             curPage = [self validPageValue:curPage + 1];
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
//    singleTap.delegate = self;
    singleTap.cancelsTouchesInView = NO;
    
    //这个可以加到任何控件上,比如你只想响应WebView，我正好填满整个屏幕
    [playImageView addGestureRecognizer:singleTap];
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
    
    if (CGRectContainsPoint(scrollFrame, point)) {
        [UIView beginAnimations:nil context:NULL];
        
        [UIView animateWithDuration:0.2 animations:^
         {
             for (int i = 0; i < [[slideView subviews] count]; i ++) {
                 UIImageView *tempImageView = [[slideView subviews] objectAtIndex:i];
                 tempImageView.center = CGPointMake(tempImageView.center.x, tempImageView.center.y + 65);
             }
             
         } completion:^(BOOL finished)
         {
             curPage = [self validPageValue:curPage - 1];
             [self refreshSlideView];
             
             if (isShow) {
                 [self removePlayBtn];
                 [self showPlayBtn];
             }
         }];
        [UIView commitAnimations];
    }
    
    CGRect scrollFrameBelow = CGRectMake(0, 130, 80, 65);
    if (CGRectContainsPoint(scrollFrameBelow, point)) {
        //滑动动画
        [UIView beginAnimations:nil context:NULL];
        
        [UIView animateWithDuration:0.2 animations:^
         {
             for (int i = 0; i < [[slideView subviews] count]; i ++) {
                 UIImageView *tempImageView = [[slideView subviews] objectAtIndex:i];
                 tempImageView.center = CGPointMake(tempImageView.center.x, tempImageView.center.y - 65);
             }
         } completion:^(BOOL finished)
         {
             curPage = [self validPageValue:curPage + 1];
             [self refreshSlideView];
             
             if (isShow) {
                 [self removePlayBtn];
                 [self showPlayBtn];
             }
         }];
        [UIView commitAnimations];
        
    }
}

- (void) clickPlayBtn
{
//    NSLog(@"当前是第%d关", curPage);
//    NSLog(@"clickPlayBtn");
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

- (int) curPage
{
    return curPage;
}

@end
