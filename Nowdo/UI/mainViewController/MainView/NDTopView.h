//
//  NDTopView.h
//  Nowdo
//
//  Created by ZCB-MAC on 16/5/17.
//  Copyright © 2016年 Leou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NDTopView : UIView
@property (nonatomic, strong) NSArray* titleArr;
@property (nonatomic, copy) void (^clickBtn)(NSInteger);
@property (nonatomic, weak) UIView* bottomView;
- (void)changeBtnColor:(NSInteger)tagNum;

@end
