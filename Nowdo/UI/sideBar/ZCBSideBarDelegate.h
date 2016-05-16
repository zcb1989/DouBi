//
//  ZCBSideBarDelegate.h
//  Nowdo
//
//  Created by ZCB-MAC on 16/5/16.
//  Copyright © 2016年 Leou. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum ZCBSideBarShowDirection
{
    SideBarShowDirectionNone = 0,
    SideBarShowDirectionLeft = 1
}SideBarShowDirection;

@protocol ZCBSideBarDelegate <NSObject>

-(void)leftSideBarSelectWithController:(UIViewController *)controller;
-(void)showSideBarControllerWithDirection:(SideBarShowDirection)direction;

@end
