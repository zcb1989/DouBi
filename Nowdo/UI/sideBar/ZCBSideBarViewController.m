//
//  ZCBSideBarViewController.m
//  Nowdo
//
//  Created by ZCB-MAC on 16/5/16.
//  Copyright © 2016年 Leou. All rights reserved.
//

#import "ZCBSideBarViewController.h"
#import "ZCBLeftViewController.h"//左侧视图
#import "NDMainViewController.h"//主界面
#import "NDNavigation.h"

@interface ZCBSideBarViewController ()
{
    UIViewController *currentMainViewController;
    CGFloat currentTranslate;
    UIPanGestureRecognizer *panGestureRecognizer;
    UITapGestureRecognizer *tapGestureRecognizer;
    NDNavigation *nav;
    
}

@property (nonatomic,strong) UIViewController *leftViewController;

@end

@implementation ZCBSideBarViewController

static ZCBSideBarViewController *rootController;
const int ContentMinOffset = 60;
const float MoveAnimationDuration = 0.8;

+(id)share
{
    return rootController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化根控制器
    if (rootController) {
        rootController = nil;
    }
    rootController = self;
    //起初，没有任何偏移
    currentTranslate = 0;
    _sideBarShowing = NO;
    //设置内容视图的边界阴影
    self.contentView.layer.shadowOffset = CGSizeMake(0, 0);
    self.contentView.layer.shadowOpacity = 1;//阴影透明度
    self.contentView.layer.shadowRadius = 3;//阴影半径 默认值是3
    //初始化内容视图和背景视图
    self.navBackView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.navBackView];
    self.contentView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.contentView];
    //添加子视图
    ZCBLeftViewController *leftVC = [[ZCBLeftViewController alloc] init];
    self.leftViewController = leftVC;
    [self addChildViewController:self.leftViewController];
    self.leftViewController.view.frame = self.navBackView.bounds;
    
    panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panInContentView:)];
    panGestureRecognizer.maximumNumberOfTouches = 1;
    [self.contentView addGestureRecognizer:panGestureRecognizer];
    
    //添加主界面视图
    [self addMainViewController];
    
    
}
- (void)addMainViewController
{
    NDMainViewController *mainVC = [[NDMainViewController alloc] init];
    nav = [[NDNavigation alloc] initWithRootViewController:mainVC];
    [self addChildViewController:nav];
    [self.contentView addSubview:nav.view];
    [self.view bringSubviewToFront:self.contentView];
    
}


- (void)panInContentView:(UIPanGestureRecognizer *)panReconizer
{
    CGPoint point = [panReconizer locationInView:panReconizer.view];
    CGFloat translation = [panReconizer translationInView:panReconizer.view].x;
//    NSLog(@"handle panRecongizer pointx is %f ; pointY is %f translation x is %f",point.x,point.y,translation);
    if (panReconizer.state == UIGestureRecognizerStateBegan)
    {
        //限制开始滑动的位置 只能滑动左侧
        if (point.x > panAreaX) {
            return;
        }
    }
    else if (panReconizer.state == UIGestureRecognizerStateChanged)
    {
        //fabs(translation) > ContentOffset 左滑的时候会多滑显示右侧部分
        if ((translation < 0 && _sideBarShowing == NO )|| fabs(translation) > ContentOffset || point.x > panAreaX) {
            
            return;//不让往左滑
        }
        self.contentView.transform = CGAffineTransformMakeTranslation(translation+currentTranslate, 0);
        UIView *view;
        if (translation+currentTranslate > 0)
        {
            view = self.leftViewController.view;
            
        }
        [self.navBackView bringSubviewToFront:view];
        //        [self statusBarView].transform = panReconizer.view.transform;
        
        
    }else if (panReconizer.state == UIGestureRecognizerStateEnded)
    {
        currentTranslate = self.contentView.transform.tx;
        if (!_sideBarShowing)
        {
            if (fabs(currentTranslate) < ContentMinOffset)
            {
                [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
            }
            //当前偏移量大于最小偏移量,显示左边SideBar
            else if(currentTranslate > ContentMinOffset)
            {
                [self moveAnimationWithDirection:SideBarShowDirectionLeft duration:MoveAnimationDuration];
            }
        }
        //SideBar已经显示的时候
        else
        {
            //如果当前偏移量的绝对值小于最大偏移量和最小偏移量的差,那么不显示SideBar
            if (fabs(currentTranslate)<ContentOffset - ContentMinOffset) {
                [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
            }
            //如果当前偏移量大于最大偏移量和最小偏移量的差,则显示左边SideBar(此时本来显示的是左边,即没有变化)
            else if (currentTranslate > ContentOffset - ContentMinOffset)
            {
                [self moveAnimationWithDirection:SideBarShowDirectionLeft duration:MoveAnimationDuration];
            }
        }
    }
}
// 移动视图的方法
- (void)moveAnimationWithDirection:(SideBarShowDirection)direction duration:(float)duration
{
    void (^animations)(void) = ^{
        
        switch (direction) {
            case SideBarShowDirectionNone:
            {
                [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:1 initialSpringVelocity:1.0 options:UIViewAnimationOptionTransitionNone animations:^{
                    self.contentView.transform = CGAffineTransformMakeTranslation(0, 0);
//                    [self statusBarView].transform = self.contentView.transform;
                }completion:nil];
            }
                break;
            case SideBarShowDirectionLeft:
            {
                [UIView animateWithDuration:duration delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:1.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                    self.contentView.transform  = CGAffineTransformMakeTranslation(ContentOffset, 0);
                    /*
                     CGAffineTransform trans  = CGAffineTransformMakeTranslation(ContentOffset, 0);
                     CGAffineTransform scale = CGAffineTransformMakeScale(0.8, 0.8);
                     CGAffineTransform newTransform = CGAffineTransformConcat(trans, scale);
                     self.contentView.transform = newTransform;
                     */
//                    [self statusBarView].transform = self.contentView.transform;
                } completion:nil];
            }
                break;
                
            default:
                break;
        }
    };
    
    void (^complete)(BOOL) = ^(BOOL finished){
        self.contentView.userInteractionEnabled = YES;
        self.navBackView.userInteractionEnabled = YES;
        if (direction == SideBarShowDirectionNone)
        {
            if (tapGestureRecognizer)
            {
                [self.contentView removeGestureRecognizer:tapGestureRecognizer];
                tapGestureRecognizer = nil;
            }
            _sideBarShowing = NO;
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isShowSlider"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else
        {
            [self contentViewAddTapGestures];
            _sideBarShowing = YES;
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isShowSlider"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        currentTranslate = self.contentView.transform.tx;
    };
    self.contentView.userInteractionEnabled = NO;
    self.navBackView.userInteractionEnabled = NO;
    [UIView animateWithDuration:duration animations:animations completion:complete];
}
/**
 添加单击手势
 */
- (void)contentViewAddTapGestures
{
    if (tapGestureRecognizer) {
        [self.contentView removeGestureRecognizer:tapGestureRecognizer];
        tapGestureRecognizer = nil;
    }
    tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapOnContentView:)];
    [self.contentView addGestureRecognizer:tapGestureRecognizer];
}
/**
 单机手势的处理事件
 */
- (void)tapOnContentView:(UITapGestureRecognizer *)tapGesture
{
    [self moveAnimationWithDirection:SideBarShowDirectionNone duration:MoveAnimationDuration];
}

/**
 获取当前状态栏的方法
 */
- (UIView*)statusBarView;
{
    UIView *statusBar = nil;
    NSData *data = [NSData dataWithBytes:(unsigned char []){0x73, 0x74, 0x61, 0x74, 0x75, 0x73, 0x42, 0x61, 0x72} length:9];
    NSString *key = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    id object = [UIApplication sharedApplication];
    if ([object respondsToSelector:NSSelectorFromString(key)]) statusBar = [object valueForKey:key];
    return statusBar;
}

#pragma mark - ZCBSideBarDelegate method
- (void)showSideBarControllerWithDirection:(SideBarShowDirection)direction
{
    if (direction != SideBarShowDirectionNone)
    {
        UIView *view;
        if (direction == SideBarShowDirectionLeft) {
            view = self.leftViewController.view;
        }
    }
    [self moveAnimationWithDirection:direction duration:MoveAnimationDuration];
}
- (void)leftSideBarSelectWithController:(UIViewController *)controller
{
    if ([controller isKindOfClass:[UINavigationController class]])
    {
        [(UINavigationController *)controller setDelegate:self];
    }
    if (currentMainViewController == nil)
    {
        controller.view.frame = self.contentView.bounds;
        currentMainViewController = controller;
        [self addChildViewController:currentMainViewController];
        [self.contentView addSubview:currentMainViewController.view];
        [currentMainViewController didMoveToParentViewController:self];
        [self.navBackView bringSubviewToFront:nav.view];
    }else if (controller != nil && currentMainViewController != controller)
    {
        controller.view.frame = self.contentView.bounds;
        [currentMainViewController willMoveToParentViewController:nil];
        [self addChildViewController:controller];
        self.view.userInteractionEnabled = NO;
        [self transitionFromViewController:currentMainViewController toViewController:controller duration:0 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished){
            
            self.view.userInteractionEnabled = YES;
            [currentMainViewController removeFromParentViewController];
            [controller didMoveToParentViewController:self];
            currentMainViewController = controller;
        }];
        [self.navBackView bringSubviewToFront:nav.view];
    }
    [self showSideBarControllerWithDirection:SideBarShowDirectionNone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UINavigationController的委托方法

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
}
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
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
