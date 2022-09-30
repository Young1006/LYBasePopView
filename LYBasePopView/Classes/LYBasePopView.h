//
//  LYBasePopView.h
//  LYBasePopView
//
//  Created by 刘阳 on 2021/9/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, LYBasePopViewAnimationDirection) {
    LYBasePopViewAnimationDirectionBottom    = 0,    // 底部弹出
    LYBasePopViewAnimationDirectionRight,            // 右侧弹出
    LYBasePopViewAnimationDirectionLeft,             // 左侧弹出
    LYBasePopViewAnimationDirectionTop,              // 顶部弹出
    LYBasePopViewAnimationDirectionCenter,           // 中间弹出
};


@interface LYBasePopView : UIView

/// 弹窗载体背景颜色alpha值（默认值0.15）
@property (nonatomic, assign) CGFloat colorAlpha;

/// 弹框内容背景颜色
@property (nonatomic, strong) UIColor *contentBackgroundColor;

/// 弹窗圆角（默认10.0）
@property (nonatomic, assign) CGFloat radius;

/// 弹窗圆角方向（默认UIRectCornerTopLeft | UIRectCornerTopRight）
@property (nonatomic, assign) UIRectCorner corner;

/// 弹出方向 （默认LYBasePopViewAnimationDirectionBottom）
@property (nonatomic, assign) LYBasePopViewAnimationDirection direction;

/// 弹窗动画时长
@property (nonatomic, assign) CGFloat animationTime;

/// 点击空白是否消失（默认YES）
@property (nonatomic, assign, getter=isHiddenForTouchEmpty) BOOL hiddenForTouchEmpty;

/// 是否支持拖拽关闭弹窗（默认YES, 不支持LYBasePopViewAnimationDirectionCenter）
@property (nonatomic, assign, getter=isShouldHideWhenDragging) BOOL shouldHideWhenDragging;

/// 弹框消平移位置未达到弹框一半时消失要求达到的速率 默认600
@property (nonatomic, assign) CGFloat panVelocity;


/// 初始化（overlayView为nil时，自动获取keyWindow）
+ (instancetype)popView:(CGRect)frame;
+ (instancetype)popViewWithFrame:(CGRect)frame overlayView:(nullable UIView *)overlayView;
- (instancetype)initWithFrame:(CGRect)frame overlayView:(nullable UIView *)overlayView;

/// 弹窗将要显示
- (void)popViewWillAppear NS_REQUIRES_SUPER;

/// 弹窗已经显示
- (void)popViewDidAppear NS_REQUIRES_SUPER;

/// 弹窗将要消失
- (void)popViewWillDisappear NS_REQUIRES_SUPER;

/// 弹窗已经已经消失
- (void)popViewDidDisappear NS_REQUIRES_SUPER;

/// 弹出（无动画）
- (void)show;

/// 消失（无动画）
- (void)hide;

/// 弹出（有动画）
- (void)showAnimation;

/// 消失（有动画）
- (void)hideAnimation;

@end

NS_ASSUME_NONNULL_END
