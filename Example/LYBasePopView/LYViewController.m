//
//  LYViewController.m
//  LYBasePopView
//
//  Created by 754515065@qq.com on 09/06/2021.
//  Copyright (c) 2021 754515065@qq.com. All rights reserved.
//

#import "LYViewController.h"
#import "PopView.h"

@interface LYViewController ()

@end

@implementation LYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch* touch = [touches anyObject];
    if ([touch.view isDescendantOfView:[LYBasePopView overlayView]]) {

    } else {
        [self tapAction];
    }
}

- (void)tapAction {
    [PopView show:self.view clickBlock:^{
        NSLog(@"点我啊~~");
    }];
}

@end
