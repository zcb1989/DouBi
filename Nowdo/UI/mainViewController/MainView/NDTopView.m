//
//  NDTopView.m
//  Nowdo
//
//  Created by ZCB-MAC on 16/5/17.
//  Copyright © 2016年 Leou. All rights reserved.
//

#import "NDTopView.h"

@interface NDTopView ()

@property (nonatomic, assign) NSInteger numTag;
@end

@implementation NDTopView

- (void)setTitleArr:(NSArray *)titleArr
{
    _titleArr = titleArr;
    UIScreen *mainScreen = [UIScreen mainScreen];
    
    CGFloat btnW = mainScreen.bounds.size.width / 3;
    CGFloat btnH = 30;
    CGFloat btnY = 80;
    
    for (NSInteger i = 0; i < titleArr.count; i ++)
    {
        UIButton *navBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        navBtn.frame = CGRectMake(btnW * i, btnY, btnW, btnH);
        [self addSubview:navBtn];
        [navBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        navBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [navBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        navBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        navBtn.tag = i + 1;
        [navBtn addTarget:self action:@selector(navBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [(UIButton *)[self viewWithTag:1]setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.numTag = 1;
    
    UIView *bottomBar = [[UIView alloc] initWithFrame:CGRectMake(12, 111, btnW - 24, 3)];
    bottomBar.backgroundColor = [UIColor colorWithRed:239 / 255.0 green:239 / 255.0 blue:239 / 255.0 alpha:1.0];
    bottomBar.layer.cornerRadius = 1.5;
    
    [self addSubview:bottomBar];
    
    self.bottomView = bottomBar;
}

- (void)navBtnClicked:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    
    [self changeBtnColor:btn.tag];
    
    if (self.clickBtn) {
        
        self.clickBtn(btn.tag);
    }
}

- (void)changeBtnColor:(NSInteger)tagNum
{
    if (self.numTag != 0)
    {
        [(UIButton *)[self viewWithTag:self.numTag] setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    [(UIButton *)[self viewWithTag:tagNum] setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.numTag = tagNum;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
