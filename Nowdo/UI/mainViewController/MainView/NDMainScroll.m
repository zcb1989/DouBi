//
//  NDMainScroll.m
//  Nowdo
//
//  Created by ZCB-MAC on 16/5/17.
//  Copyright © 2016年 Leou. All rights reserved.
//

#import "NDMainScroll.h"

#import "NDDynamicView.h"//动态
#import "NDDiscoverView.h"//发现
#import "NDTeamView.h"//小组

@implementation NDMainScroll

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.backgroundColor = [UIColor clearColor];
        self.bounces = NO;
        
        CGFloat vW = [UIScreen mainScreen].bounds.size.width;
        
        for (NSInteger i = 0; i < 3; i ++)
        {
            if (i == 0)
            {
                NDDynamicView *view = [[NDDynamicView alloc] initWithFrame:CGRectMake(vW * i, 0, vW, [UIScreen mainScreen].bounds.size.height)];
                view.backgroundColor = [UIColor redColor];
                [self addSubview:view];
            }
            
            if (i == 1)
            {
                NDDiscoverView *view = [[NDDiscoverView alloc] initWithFrame:CGRectMake(vW * i, 0, vW, [UIScreen mainScreen].bounds.size.height)];
                view.backgroundColor = [UIColor yellowColor];
                [self addSubview:view];
            }
            
            if (i == 2)
            {
                NDTeamView *view = [[NDTeamView alloc] initWithFrame:CGRectMake(vW * i, 0, vW, [UIScreen mainScreen].bounds.size.height)];
                view.backgroundColor = [UIColor purpleColor];
                [self addSubview:view];
            }
        }
        self.contentSize = CGSizeMake(3 * vW, 0);
        self.pagingEnabled = YES;
    }
    
    return self;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self];
    CGPoint location = [gestureRecognizer locationInView:self];
    
    NSLog(@"velocity.x:%f----location.x:%d",velocity.x,(int)location.x%(int)[UIScreen mainScreen].bounds.size.width);
    if (velocity.x > 0.0f&&(int)location.x%(int)[UIScreen mainScreen].bounds.size.width<60) {
        return NO;
    }
    return YES;
}

@end
