//
//  LYBasePopView.m
//  LYBasePopView
//
//  Created by 刘阳 on 2021/9/3.
//

#import "LYBasePopView.h"

@interface LYBasePopView ()

@property (nonatomic, strong) UIView *overlayView;

@property (nonatomic, strong) UIView *backgroundView;

@property (nonatomic, strong) UIView *touchView;

@property (nonatomic, assign, getter=isMoving) BOOL moving;

@property (nonatomic, assign) CGPoint originPoint;

@end

@implementation LYBasePopView

#pragma mark - 初始化
+ (instancetype)popView:(CGRect)frame {
    return [[LYBasePopView alloc] initWithFrame:frame];
}

+ (instancetype)popViewWithFrame:(CGRect)frame overlayView:(UIView *)overlayView {
    return [[LYBasePopView alloc] initWithFrame:frame overlayView:overlayView];
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame overlayView:nil];
}

- (instancetype)initWithFrame:(CGRect)frame overlayView:(nullable UIView *)overlayView {
    if (self = [super initWithFrame:frame]) {
        [self getRealOverlayView:overlayView];
        [self config];
        [self setupUI];
        [self addPanGestureEventHandler];
    }
    return self;
}


#pragma mark - 基础配置
- (void)config {
    self.colorAlpha = 0.15;
    self.animationTime = 0.25;
    self.radius = 10.0;
    self.corner = UIRectCornerTopLeft | UIRectCornerTopRight;
    self.direction = LYBasePopViewAnimationDirectionBottom;
    self.moving = NO;
    self.hiddenForTouchEmpty = YES;
    self.shouldHideWhenDragging = YES;
    self.panVelocity = 600;
    self.originPoint = CGPointMake(0, 0);
    self.contentBackgroundColor = UIColor.whiteColor;
}

- (void)getRealOverlayView:(nullable UIView *)view {
    self.overlayView = view ?: [self keyWindow];
}

#pragma mark - UI
- (void)setupUI {
    if (!self.overlayView) {
        NSAssert(self.overlayView != nil, @"The overlayView of popView is can't be nil.");
        return;
    }
    
//    _popView = self;
    
    [self.overlayView addSubview:self.backgroundView];
    [self.overlayView bringSubviewToFront:self.backgroundView];
//    _backView = self.backgroundView;
    
    [self.backgroundView addSubview:self.touchView];
    
    CGFloat height = self.frame.size.height;
    if (height <= 0) {
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
    [self.backgroundView addSubview:self];
}

#pragma mark - 添加手势
- (void)addPanGestureEventHandler {
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
    [self addGestureRecognizer:panGesture];
}

- (void)panGestureAction:(UIPanGestureRecognizer *)gesture {
    if (self.direction == LYBasePopViewAnimationDirectionCenter) return;
    if (!self.isShouldHideWhenDragging) return;
    UIView *panView = gesture.view;
    if (!panView) return;
    CGPoint origin = panView.frame.origin;
    CGFloat width = panView.frame.size.width;
    CGFloat height = panView.frame.size.height;
    CGPoint point = [gesture translationInView:self.overlayView];
    switch (gesture.state) {
        case UIGestureRecognizerStateChanged: // 只能向相反方向运动
        {
            //NSLog(@"point.y ========== %.2f",point.y);
            switch (self.direction) {
                case LYBasePopViewAnimationDirectionBottom:
                    if (origin.y + point.y > origin.y) {
                        origin.y += point.y;
                    }
                    break;
                case LYBasePopViewAnimationDirectionTop:
                    if (origin.y + point.y < origin.y) {
                        origin.y += point.y;
                    }
                case LYBasePopViewAnimationDirectionLeft:
                    if (origin.x + point.x < origin.x) {
                        origin.x += point.x;
                    }
                    break;
                case LYBasePopViewAnimationDirectionRight:
                    if (origin.x + point.x > origin.x) {
                        origin.x += point.x;
                    }
                    break;
                default:
                    break;
            }
            panView.frame = CGRectMake(origin.x, origin.y, width, height);
            [gesture setTranslation:CGPointMake(0, 0) inView:self.overlayView];
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            CGPoint speed = [gesture velocityInView:gesture.view];
            //NSLog(@"spped ==== %@",NSStringFromCGPoint(speed));
            switch (self.direction) {
                case LYBasePopViewAnimationDirectionBottom:
                    if (speed.y >= self.panVelocity) {
                        [self popViewHide];
                    } else {
                        if (origin.y > self.originPoint.y + height / 2.0) {
                            [self popViewHide];
                        } else {
                            [self popViewShow];
                        }
                    }
                    break;
                case LYBasePopViewAnimationDirectionTop:
                    if (speed.y <= -self.panVelocity) {
                        [self popViewHide];
                    } else {
                        if (origin.y < self.originPoint.y - height / 2.0) {
                            [self popViewHide];
                        } else {
                            [self popViewShow];
                        }
                    }
                    break;
                case LYBasePopViewAnimationDirectionLeft:
                    if (speed.x <= -self.panVelocity) {
                        [self popViewHide];
                    } else {
                        if (origin.x < self.originPoint.x - width / 2.0) {
                            [self popViewHide];
                        } else {
                            [self popViewShow];
                        }
                    }
                    break;
                case LYBasePopViewAnimationDirectionRight:
                    if (speed.x >= self.panVelocity) {
                        [self popViewHide];
                    } else {
                        if (origin.x > self.originPoint.x - width / 2.0) {
                            [self popViewHide];
                        } else {
                            [self popViewShow];
                        }
                    }
                    break;
                default:
                    break;
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - 切圆角
- (void)setCornerRadius {
    if (self.radius > 0) {
        if (@available(iOS 11.0, *)) {
            self.layer.cornerRadius = self.radius;
            self.layer.maskedCorners = (CACornerMask)self.corner;
        } else {
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:self.corner cornerRadii:CGSizeMake(self.radius, self.radius)];
            CAShapeLayer *maskLayer = [CAShapeLayer layer];
            maskLayer.frame = self.bounds;
            maskLayer.path = path.CGPath;
            self.layer.mask = maskLayer;
        }
    }
}

#pragma mark - 显示与隐藏
- (void)show {
    [self popViewWillAppear];
    [self showAction];
    [self popViewDidAppear];
}

- (void)hide {
    [self popViewWillDisappear];
    [self afterHideAction];
}

- (void)showAnimation {
    [self popViewShow];
}

- (void)hideAnimation {
    [self popViewHide];
}

- (void)popViewShow {
    if (self.isMoving) return;
    [self popViewWillAppear];
    if (self.direction == LYBasePopViewAnimationDirectionCenter) {
        [self showInCenter:YES];
        return;
    }
    [UIView animateWithDuration:self.animationTime  delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self showAction];
    } completion:^(BOOL finished) {
        self.originPoint = self.frame.origin;
        [self popViewDidAppear];
    }];
}

- (void)popViewHide {
    if (self.isMoving) return;
    [self popViewWillDisappear];
    if (self.direction == LYBasePopViewAnimationDirectionCenter) {
        [self afterHideAction];
        return;
    }
    [UIView animateWithDuration:self.animationTime  delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self hideAction];
    } completion:^(BOOL finished) {
        self.originPoint = CGPointMake(0, 0);
        [self afterHideAction];
    }];
}

- (void)showAction {
    double colorAlpha = self.colorAlpha;
    CGFloat originX = self.frame.origin.x;
    CGFloat originY = self.frame.origin.y;
    CGFloat width   = self.frame.size.width;
    CGFloat height  = self.frame.size.height;
    CGFloat superWidth = self.overlayView.frame.size.width;
    CGFloat superHeight = self.overlayView.frame.size.height;
    switch (self.direction) {
        case LYBasePopViewAnimationDirectionBottom:
            originY = superHeight - height;
            break;
        case LYBasePopViewAnimationDirectionRight:
            originX = superWidth - width;
            break;
        case LYBasePopViewAnimationDirectionLeft:
            originX = 0;
            break;
        case LYBasePopViewAnimationDirectionTop:
            originY = 0;
        default:
            break;
    }
    CGRect frame = CGRectMake(originX, originY, width, height);
    self.frame = frame;
    self.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:colorAlpha];
}

- (void)hideAction {
    double colorAlpha = 0;
    CGFloat originX = self.frame.origin.x;
    CGFloat originY = self.frame.origin.y;
    CGFloat width   = self.frame.size.width;
    CGFloat height  = self.frame.size.height;
    CGFloat superWidth = self.overlayView.frame.size.width;
    CGFloat superHeight = self.overlayView.frame.size.height;
    switch (self.direction) {
        case LYBasePopViewAnimationDirectionBottom:
            originY = superHeight;
            break;
        case LYBasePopViewAnimationDirectionRight:
            originX = superWidth;
            break;
        case LYBasePopViewAnimationDirectionLeft:
            originX = -width;
            break;
        case LYBasePopViewAnimationDirectionTop:
            originY = -height;
        default:
            break;
    }
    CGRect frame = CGRectMake(originX, originY, width, height);
    self.frame = frame;
    self.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:colorAlpha];
}

- (void)afterHideAction {
    [self removeFromSuperview];
    [self.touchView removeFromSuperview];
    [self.backgroundView removeFromSuperview];
    [self popViewDidDisappear];
}

- (void)showInCenter:(BOOL)animation {
    self.center = self.backgroundView.center;
    if (animation) {
        [UIView animateWithDuration:self.animationTime * 0.3 animations:^{
            self.transform = CGAffineTransformMakeScale(1.05, 1.05);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:self.animationTime * 0.3 animations:^{
                self.transform = CGAffineTransformMakeScale(0.95, 0.95);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:self.animationTime * 0.2 animations:^{
                    self.transform = CGAffineTransformMakeScale(1.025, 1.025);
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:self.animationTime * 0.2 animations:^{
                        self.transform = CGAffineTransformIdentity;
                        [self popViewDidAppear];
                    }];
                }];
            }];
        }];
    }
}

#pragma mark - 点击空白事件
- (void)touchAction {
    if (!_hiddenForTouchEmpty) return;
    if (self.direction == LYBasePopViewAnimationDirectionCenter) {
        [self afterHideAction];
        return;
    }
    [self popViewHide];
}


#pragma mark - 生命周期
- (void)popViewWillAppear {
    self.moving = YES;
    [self setCornerRadius];
    self.layer.backgroundColor = self.contentBackgroundColor.CGColor;
    if (!self.backgroundView.superview) {
        [self.overlayView addSubview:self.backgroundView];
    }
    if (!self.touchView.superview) {
        [self.backgroundView addSubview:self.touchView];
    }
    if (!self.superview) {
        [self.backgroundView addSubview:self];
    }
}

- (void)popViewDidAppear {
    self.moving = NO;
}

- (void)popViewWillDisappear {
    self.moving = YES;
}

- (void)popViewDidDisappear {
    self.moving = NO;
}


#pragma mark - getter
- (nullable UIWindow *)keyWindow {
    if (@available(iOS 13.0, *)) {
        for (UIWindowScene* windowScene in [UIApplication sharedApplication].connectedScenes) {
            if (windowScene.activationState == UISceneActivationStateForegroundActive) {
                for (UIWindow *window in windowScene.windows) {
                    if (window.isKeyWindow) {
                        return window;
                        break;
                    }
                }
            }
        }
    } else {
        UIWindow *keyWindow = [[UIApplication sharedApplication].windows lastObject];
        if (!keyWindow) {
            keyWindow = [UIApplication sharedApplication].keyWindow;
        }
        return keyWindow;
    }
    return nil;
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:self.overlayView.bounds];
        _backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    }
    return _backgroundView;
}

- (UIView *)touchView {
    if (!_touchView) {
        _touchView = [[UIView alloc] initWithFrame:self.overlayView.bounds];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchAction)];
        [_touchView addGestureRecognizer:tap];
    }
    return _touchView;
}

@end
