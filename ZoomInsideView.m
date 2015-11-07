//
//  ZoomInsideView.m
//  闪游资讯
//
//  Created by SHF on 15/10/25.
//  Copyright © 2015年 SHF. All rights reserved.
//


#import "ZoomInsideView.h"

#define ScreenWidth      CGRectGetWidth([UIScreen mainScreen].applicationFrame)
#define ScreenHeight     CGRectGetHeight([UIScreen mainScreen].applicationFrame)

@interface ZoomInsideView (Utility)


@end

@implementation ZoomInsideView
@synthesize imageView;
- (id)initWithFrame:(CGRect)frame
{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        self.delegate = self;
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.backgroundColor = [UIColor blackColor];
        [self initImageView];
    }
    return self;
}

- (void)initImageView
{
    imageView = [[UIImageView alloc]init];
    
    imageView.frame = CGRectMake(0, ScreenHeight/4 , ScreenWidth * 2, ScreenHeight/ 3 *2.5);
    self.contentSize = CGSizeMake(ScreenWidth*2, ScreenHeight*2);
    imageView.userInteractionEnabled = YES;
    [self addSubview:imageView];
    
    _doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                         action:@selector(handleDoubleTap:)];
    [_doubleTap setNumberOfTapsRequired:2];
    [self.imageView addGestureRecognizer:_doubleTap];
    
    _singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                        action:@selector(dismiss)];
    [_singleTap setNumberOfTapsRequired:1];
    [self addGestureRecognizer:_singleTap];
    [_singleTap requireGestureRecognizerToFail:_doubleTap];
    
    
    minimumScale = self.frame.size.width / imageView.frame.size.width;
    [self setMinimumZoomScale:minimumScale];
    [self setZoomScale:minimumScale];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(scrollOut) name:@"scrollOut" object:nil];
    
}


#pragma mark - Zoom methods
-(void) dismiss
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"dismissController" object:nil];
}
- (void)handleDoubleTap:(UIGestureRecognizer *)gesture
{
    BOOL bigger = NO;
    CGFloat newScale;
    if (self.zoomScale  == 0.5) {
        newScale = self.zoomScale * 2;
        bigger = YES;
    }
    else
    {
        newScale = minimumScale;
    }
    
    CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gesture locationInView:gesture.view] andBigger:bigger];
    [self zoomToRect:zoomRect animated:YES];
}

- (CGRect)zoomRectForScale:(CGFloat)scale withCenter:(CGPoint)center andBigger:(BOOL)bigger
{
    CGRect zoomRect;

    zoomRect.size.height = self.frame.size.height / scale ;
    zoomRect.size.width  = self.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    

    return zoomRect;
}


#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [scrollView setZoomScale:scale animated:NO];
    self.contentSize = CGSizeMake(self.contentSize.width, ScreenHeight*1.5);

}
- (void) scrollOut
{
    [self setMinimumZoomScale:minimumScale];
    [self setZoomScale:minimumScale];
}
@end