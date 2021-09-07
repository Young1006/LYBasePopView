# LYBasePopView
## 轻量级弹框基类，弹框载体可以是keyWindow或者自定义view，支持上下左右中五个方向弹出，并支持手势滑出。
## 自定义弹框需继承自该类，可重写生命周期。


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

LYBasePopView is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'LYBasePopView'
```
## 简单使用
PopView *pop = [[PopView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 400) overlayView:inView]; </br>
pop.clickBlock = clickBlock; </br>
pop.animationTime = 0.25; </br>
pop.colorAlpha = 0.15; </br>
pop.hiddenForTouchEmpty = YES; </br>
pop.shouldHideWhenDragging = YES; </br>
[pop showAnimation];

## 可设置参数

/// 弹窗载体背景颜色alpha值（默认值0.15）</br>
@property (nonatomic, assign) CGFloat colorAlpha;

/// 弹窗圆角（默认10.0）</br>
@property (nonatomic, assign) CGFloat radius;

/// 弹窗圆角方向（默认UIRectCornerTopLeft | UIRectCornerTopRight）</br>
@property (nonatomic, assign) UIRectCorner corner;

/// 弹出方向 （默认LYBasePopViewAnimationDirectionBottom）</br>
@property (nonatomic, assign) LYBasePopViewAnimationDirection direction;

/// 弹窗动画时长</br>
@property (nonatomic, assign) CGFloat animationTime;

/// 点击空白是否消失（默认YES）</br>
@property (nonatomic, assign, getter=isHiddenForTouchEmpty) BOOL hiddenForTouchEmpty;

/// 是否支持拖拽关闭弹窗（默认YES, 不支持LYBasePopViewAnimationDirectionCenter）</br>
@property (nonatomic, assign, getter=isShouldHideWhenDragging) BOOL shouldHideWhenDragging;

## License

LYBasePopView is available under the MIT license. See the LICENSE file for more info.
