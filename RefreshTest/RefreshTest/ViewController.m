//
//  ViewController.m
//  RefreshTest
//
//  Created by CtreeOne on 15/11/16.
//  Copyright © 2015年 tion126. All rights reserved.
//

#import "ViewController.h"
#import <ImageIO/ImageIO.h>
#import "UIScrollView+Associated.h"

@interface ViewController ()<UIScrollViewDelegate>

@property(nonatomic,strong) NSMutableArray *arrM;

@property(nonatomic,strong) UIScrollView *scrollView;

@property(nonatomic,strong) UIImageView *imgView;

@property(nonatomic,assign)  BOOL isPic1;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
  
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,self.view.frame.size.width , self.view.frame.size.height)];
    self.automaticallyAdjustsScrollViewInsets=NO;
//    self.preferredContentSize = CGSizeZero;
//      self.extendedLayoutIncludesOpaqueBars=NO;
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    _isPic1=NO;
    _scrollView.delegate=self;
    _scrollView.contentSize=CGSizeMake(0, 1500);
    _imgView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"pic_2"]];
    _imgView.frame=self.view.frame;
    _imgView.clipsToBounds=YES;
    _imgView.contentMode=UIViewContentModeScaleAspectFill;
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:_imgView];
    
//-------------------------------------------------------------------------------------
//模仿 天猫首页的刷新和导航栏渐变效果
    __weak typeof(self)VC=self;
    
    self.scrollView.refreshView=[[TiRefreshView alloc]initWithHandler:^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (VC.isPic1) {
                VC.imgView.image=[UIImage imageNamed:@"pic_2"];
                VC.isPic1=NO;
            }else{
                VC.imgView.image=[UIImage imageNamed:@"pic_1"];
                VC.isPic1=YES;
            }
            
            [VC.scrollView.refreshView stopRefresh];
        });
    }];
    
//    [self.scrollView.refreshView pullRefresh];
    
//-------------------------------------------------------------------------------------
    self.navigationController.navigationBar.barStyle=UIBarStyleDefault;
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.shadowImage=[UIImage new];
    
    [self.navigationController.navigationBar setBackgroundImage:[self getImageWithAlpha:1] forBarMetrics:UIBarMetricsDefault];
    
    
    [self scrollViewDidScroll:self.scrollView];
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
 
 
    if(scrollView.contentOffset.y<0) {
        
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        
    }else{
        
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        
        CGFloat alpha=scrollView.contentOffset.y/90.0f>1.0f?1:scrollView.contentOffset.y/90.0f;
        
        [self.navigationController.navigationBar setBackgroundImage:[self getImageWithAlpha:alpha] forBarMetrics:UIBarMetricsDefault];
    }
    
    
}



#pragma handle image -mark

-(UIImage *)getImageWithAlpha:(CGFloat)alpha{
    
    UIColor *color=[UIColor colorWithRed:1 green:0 blue:0 alpha:alpha];
    CGSize colorSize=CGSizeMake(1, 1);
    UIGraphicsBeginImageContext(colorSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, 1, 1));
    
    UIImage *img=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return img;
}


@end
