//
//  PopView.m
//  LYBasePopView
//
//  Created by 刘阳 on 2021/9/4.
//

#import "PopView.h"

@interface PopView ()

@property (nonatomic, strong) UIView *inView;

@property (nonatomic, copy) ClickBlock clickBlock;

@end

@implementation PopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor cyanColor];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(167, 150, 80, 40);
//        button.center = self.center;
//        button.backgroundColor = [UIColor whiteColor];
        [button setTitle:@"点我啊" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame overlayView:(UIView *)overlayView {
    if (self = [super initWithFrame:frame overlayView:overlayView]) {
//        self.backgroundColor = [UIColor cyanColor];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(167, 150, 80, 40);
//        button.center = self.center;
//        button.backgroundColor = [UIColor whiteColor];
        [button setTitle:@"点我啊" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    return self;
}

- (void)tapAction {
    if (self.clickBlock) {
        self.clickBlock();
    }
}

//- (void)popViewWillAppear {
//    [super popViewWillAppear];
//    NSLog(@"popViewWillAppear");
//}
//
//- (void)popViewDidAppear {
//    [super popViewDidAppear];
//    NSLog(@"popViewDidAppear");
//}
//
//- (void)popViewWillDisappear {
//    [super popViewWillDisappear];
//    NSLog(@"popViewWillDisappear");
//}
//
//- (void)popViewDidDisappear {
//    [super popViewDidDisappear];
//    NSLog(@"popViewDidDisappear");
//}

+ (void)show:(UIView *)inView clickBlock:(ClickBlock)clickBlock {
    PopView *pop = [[PopView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 400) overlayView:inView];
    pop.clickBlock = clickBlock;
    pop.animationTime = 0.25;
    pop.colorAlpha = 0.15;
    pop.hiddenForTouchEmpty = YES;
    pop.shouldHideWhenDragging = YES;
    [pop showAnimation];
}

@end
