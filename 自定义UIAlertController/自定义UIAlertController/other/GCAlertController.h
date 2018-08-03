//
//  GCAlertController.h
//  转场动画
//
//  Created by 高崇 on 17/2/8.
//  Copyright © 2017年 LieLvWang. All rights reserved.
// 自定义 UIAlertController


#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,GCPreviewActionStyle) {
    GCPreviewActionStyleDefault=0,
    GCPreviewActionStyleSelected,
    GCPreviewActionStyleDestructive,
    GCPreviewActionStyleCancel,
};

@interface GCAlertController : UIViewController


+ (instancetype)alertController;
- (void)addActionWithTitle:(NSString *)title style:(GCPreviewActionStyle)style handler:(void (^)())handler;

@end

