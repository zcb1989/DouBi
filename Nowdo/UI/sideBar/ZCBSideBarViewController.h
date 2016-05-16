//
//  ZCBSideBarViewController.h
//  Nowdo
//
//  Created by ZCB-MAC on 16/5/16.
//  Copyright © 2016年 Leou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCBSideBarDelegate.h"

/**
 *  SideBar偏移量
 */
#define ContentOffset ([UIScreen mainScreen].bounds.size.width) / 6 * 5 - 10

@interface ZCBSideBarViewController : UIViewController<ZCBSideBarDelegate,UINavigationControllerDelegate>

@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UIView *navBackView;
@property (nonatomic,assign) BOOL   sideBarShowing;

+(id)share;

@end
