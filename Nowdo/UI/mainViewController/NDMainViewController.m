//
//  NDMainViewController.m
//  Nowdo
//
//  Created by ZCB-MAC on 16/5/16.
//  Copyright © 2016年 Leou. All rights reserved.
//

#import "NDMainViewController.h"
#import "NDTopView.h"
#import "NDMainScroll.h"

#define TOP_VIEW_HEIGHT  114
@interface NDMainViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray* arrDict;//分组标题
@property (nonatomic, strong) NDTopView *topView;//头部
@property (nonatomic, strong) NDMainScroll *mainScroll;//内容部分

@end

@implementation NDMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    [self addMainTopView];
    [self addMainContentView];
    
    __weak typeof(self) weakSelf = self;
    
    self.topView.clickBtn = ^(NSInteger tag) {
        
        weakSelf.mainScroll.contentOffset = CGPointMake(NDScreenWidth * (tag - 1), 0);
        
    };
}

- (void)addMainTopView
{
    if (!_topView)
    {
        self.topView = [[NDTopView alloc] initWithFrame:CGRectMake(0, 0, NDScreenWidth, TOP_VIEW_HEIGHT)];
        self.topView.backgroundColor = [UIColor colorWithRed:65 / 255.0 green:105 / 255.0 blue:225 / 255.0 alpha:1.0];
        self.topView.titleArr = self.arrDict;
        [self.view addSubview:self.topView];
    }
}

- (void)addMainContentView
{
    if (!self.mainScroll)
    {
        self.mainScroll = [[NDMainScroll alloc] initWithFrame:CGRectMake(0, TOP_VIEW_HEIGHT, NDScreenWidth, NDScreenHeight - TOP_VIEW_HEIGHT)];
        self.mainScroll.delegate = self;
        [self.view addSubview:self.mainScroll];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSArray*)arrDict
{
    if (!_arrDict) {
        _arrDict = [NSArray arrayWithObjects:@"动态", @"发现", @"小组", nil];
    }
    return _arrDict;
}

#pragma mark - UIScrollViewDelegate Method
- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    
    self.topView.bottomView.transform = CGAffineTransformMakeTranslation(scrollView.contentOffset.x / 3, 0);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView*)scrollView
{
    NSUInteger tagNum = (scrollView.contentOffset.x + NDScreenWidth * 0.5) / NDScreenWidth + 1;
    [self.topView changeBtnColor:tagNum];
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
