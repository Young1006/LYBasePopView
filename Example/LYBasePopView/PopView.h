//
//  PopView.h
//  LYBasePopView
//
//  Created by 刘阳 on 2021/9/4.
//

#import "LYBasePopView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ClickBlock)(void);

@interface PopView : LYBasePopView

+ (void)show:(UIView *)inView clickBlock:(ClickBlock)clickBlock;

@end

NS_ASSUME_NONNULL_END
