//
//  GCAlertController.m
//  转场动画
//
//  Created by 高崇 on 17/2/8.
//  Copyright © 2017年 LieLvWang. All rights reserved.
//

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

#import "GCAlertController.h"
#import "UIView+Extension.h"

@interface GCAlertControllerManager : NSObject<UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL isPresent;
@property (nonatomic, strong) UIView *converView;
@end
@implementation GCAlertControllerManager

#pragma mark - UIViewControllerTransitioningDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    _isPresent = YES;
    return self;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    
    _isPresent = NO;
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    
    
    if (_isPresent) {
        UIView *containerView = [transitionContext containerView];
        
        self.converView.frame = containerView.bounds;
        [containerView addSubview:self.converView];
        
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];// UITableView
        [containerView addSubview:toView];
        
        NSLog(@"toView = %@", toView);
        
        toView.transform = CGAffineTransformMakeTranslation(0, toView.bounds.size.height);
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toView.transform = CGAffineTransformIdentity;
            self.converView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
    }else{
        UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];// UITableView
        
        NSLog(@"fromView = %@", fromView);
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            fromView.transform = CGAffineTransformMakeTranslation(0, fromView.bounds.size.height);
            self.converView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
            [self.converView removeFromSuperview];
        }];
    }
}

- (UIView *)converView
{
    if (!_converView) {
        _converView = [[UIView alloc] init];
        _converView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.0];
    }
    return _converView;
}
@end



@interface GCAlertController ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSMutableArray *arrM;
@property (nonatomic, strong) NSMutableDictionary *dictM;
@property (nonatomic, strong) GCAlertControllerManager *manager;
@end

@implementation GCAlertController

+ (instancetype)alertController
{  
    GCAlertController *vc = [[GCAlertController alloc] init];
    GCAlertControllerManager *manager = [GCAlertControllerManager new];
    vc.manager = manager;
    vc.transitioningDelegate = manager;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.containerView = ({
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:view];
        view;
    }); 
    NSLog(@"self.view = %@", self.view);
}

- (void)addActionWithTitle:(NSString *)title style:(GCPreviewActionStyle)style handler:(void (^)())handler
{
    if (style == GCPreviewActionStyleCancel)
    {// 取消
        UIView *bigView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 48)];
        [self.arrM addObject:bigView];
        
        UIView *lineView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
            view.frame = CGRectMake(0, 0, kScreenW, 4);
            view;
        });
        [bigView addSubview:lineView];
        
        UIButton *btn = ({
            UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
            [view addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
            view.frame = CGRectMake(0, lineView.height, kScreenW, 44);
            [view setTitle:title forState:UIControlStateNormal];
            [view setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            view;
        });
        [bigView addSubview:btn];
    }else{// 其他
        UIView *bigView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenW, 45)];
        [self.arrM addObject:bigView];
        
        UIButton *btn = ({
            UIButton *view = [UIButton buttonWithType:UIButtonTypeCustom];
            [view addTarget:self action:@selector(btn_click:) forControlEvents:UIControlEventTouchUpInside];
            view.frame = CGRectMake(0, 0, kScreenW, 44);
            [view setTitle:title forState:UIControlStateNormal];
            [view setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            view;
        });
        [bigView addSubview:btn];
        
        UIView *lineView = ({
            UIView *view = [[UIView alloc] init];
            view.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
            view.frame = CGRectMake(0, 44, kScreenW, 1);
            view;
        });
        [bigView addSubview:lineView];
    }
    
    if (handler) {
        [self.dictM setObject:handler forKey:title];
    }
}
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    UIView *lastView = nil;
    for (UIView *view in self.arrM) {
        view.y = lastView.bottom;
        [self.containerView addSubview:view];
        lastView = view;
    }
    self.containerView.width = kScreenW;
    self.containerView.height = lastView.bottom;
    self.containerView.bottom = kScreenH;
}


- (void)btn_click:(UIButton *)btn
{
    void(^handler)() = self.dictM[btn.titleLabel.text];
    handler();
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%s", __func__);
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (NSMutableArray *)arrM
{
    if (!_arrM) {
        _arrM = [NSMutableArray array];
    }
    return _arrM;
}
- (NSMutableDictionary *)dictM
{
    if (!_dictM) {
        _dictM = [NSMutableDictionary dictionary];
    }
    return _dictM;
}

 
@end



