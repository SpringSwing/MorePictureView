//
//  ZoomInsideView.h
//  闪游资讯
//
//  Created by SHF on 15/10/25.
//  Copyright © 2015年 SHF. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ZoomInsideView : UIScrollView<UIScrollViewDelegate>
{
    CGFloat width;
    CGFloat height;
    CGFloat minimumScale;
}
@property (nonatomic,strong) UITapGestureRecognizer* singleTap;
@property (nonatomic,strong) UITapGestureRecognizer* doubleTap;
@property (nonatomic, retain) UIImageView *imageView;
@end
