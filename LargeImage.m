//
//  LargeImage.m
//  闪游资讯
//
//  Created by SHF on 15/10/22.
//  Copyright © 2015年 SHF. All rights reserved.
//

#import "LargeImage.h"

@interface LargeImage ()
{
    CGFloat width;
    CGFloat height;
    int hadLoad;
    int nowIndex;
}

@property (nonatomic,strong) UIScrollView * scroll;
@property (nonatomic,strong) UILabel *pageNum;
@end

@implementation LargeImage
- (BOOL)shouldAutorotate
{
    return YES;
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    hadLoad = 0;
    nowIndex = 0;
    NSMutableArray* urlArr = [[NSMutableArray alloc]init];
    [urlArr addObject:_data.ima];
    [urlArr addObjectsFromArray:[_data objectForKey:@"moreImage"]];
    _imageArr = [[NSMutableArray alloc]init];
    for (int i =0; i<urlArr.count; i++) {
        AVFile* tmp = urlArr[i];
        [_imageArr addObject:tmp.objectId];
    }
    [self photoScanWithNumber:(int)_imageArr.count];
   
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(dismissSelf)
                                                name:@"dismissController"
                                              object:nil
     ];
    
    
    // Do any additional setup after loading the view.
}

- (void) dismissSelf
{
    
    [self dismissViewControllerAnimated:YES completion:^{  }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) photoScanWithNumber:(int)num
{
    width = self.view.frame.size.width;
    height = self.view.frame.size.height;
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, width, height)];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.userInteractionEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_scrollView];
    [_scrollView setContentSize:CGSizeMake(width * num, height)];
    
    
    _pageNum = [[UILabel alloc]initWithFrame:CGRectMake(width/2-50, height/1.3, 100, 30)];
    _pageNum.text = [NSString stringWithFormat:@"%d/%d",1,(int)(_imageArr.count)];
    _pageNum.textColor = [UIColor whiteColor];
    _pageNum.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_pageNum];
    [self.view bringSubviewToFront:_pageNum];
    
    
    
    
    _zoomScrollView       = [[ZoomInsideView alloc]init];
    CGRect frame          = self.scrollView.frame;
    frame.origin.x        = 0;
    frame.origin.y        = 0;
    _zoomScrollView.frame = frame;
    
    UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    act.center = CGPointMake(_zoomScrollView.frame.size.width * 0.5, _zoomScrollView.frame.size.height * 0.7);
    
    [self.view addSubview:act];
    
    [act startAnimating];
    
    AVFile* file = _data.ima;
    [file getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        _zoomScrollView.imageView.image = [UIImage imageWithData:data];
        [act stopAnimating];
    }];
    [self.scrollView addSubview:_zoomScrollView];
    
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int index = scrollView.contentOffset.x / width;
    _pageNum.text = [NSString stringWithFormat:@"%d/%d",index+1,(int)(_imageArr.count)];
    if (index != nowIndex) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"scrollOut" object:nil];
        nowIndex = index;
        
    }

    if (index == 0) {
        return ;
    }
    else
    {
        if (hadLoad < index) {
            [self newZoomingWithNum:index];
            hadLoad++;
        }
    }

    
}
- (void) newZoomingWithNum:(int )num;
{
    width   = self.view.frame.size.width;
    height  = self.view.frame.size.height;
    
    _zoomScrollView         = [[ZoomInsideView alloc]init];
    CGRect   frame          = self.scrollView.frame;
    frame.origin.x          = num * width;
    frame.origin.y          = 0;
    _zoomScrollView.frame   = frame;
    
    UIActivityIndicatorView *act = [[UIActivityIndicatorView alloc]
                                    initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    
    act.center = CGPointMake(_zoomScrollView.frame.size.width * 0.5,
                             _zoomScrollView.frame.size.height * 0.7);
    
    [self.view addSubview:act];
    
    if (_zoomScrollView.imageView.image == nil) {
        [act       startAnimating];
    }
    
    
    // From Your Image Index get the Image URL
    NSString* oID = _imageArr[num];
    
    AVQuery*q     = [AVQuery queryWithClassName:@"_File"];
    [q whereKey:@"objectId" equalTo:oID];
    
    [q findObjectsInBackgroundWithBlock:^(NSArray *objects,
                                          NSError *error) {
        AVObject* url   = [objects firstObject];
        NSString* real  = [url objectForKey:@"url"];
        AVFile* file    = [AVFile fileWithURL:real];
        
        [file getDataInBackgroundWithBlock:^(NSData *data,
                                             NSError *error) {
            _zoomScrollView.imageView.image = [UIImage imageWithData:data];
            
            [act stopAnimating];
        }];
    }];
    
    
    [self.scrollView addSubview:_zoomScrollView];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
