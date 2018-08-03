//
//  ViewController.m
//  自定义UIAlertController
//
//  Created by 高崇 on 2018/8/3.
//  Copyright © 2018年 LieLvWang. All rights reserved.
//

#import "ViewController.h"
#import "GCAlertController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    btn.backgroundColor = [UIColor orangeColor];
    [btn addTarget:self action:@selector(btn_click) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)btn_click
{
    GCAlertController *vc = [GCAlertController alertController];
    [vc addActionWithTitle:@"1" style:GCPreviewActionStyleDefault handler:nil];
    [vc addActionWithTitle:@"2" style:GCPreviewActionStyleDefault handler:nil];
    [vc addActionWithTitle:@"3" style:GCPreviewActionStyleCancel handler:nil];
   
    [self presentViewController:vc animated:YES completion:nil];
}


@end
