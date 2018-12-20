//
//  ViewController.m
//  MLThreeLevelLinkage
//
//  Created by 268Edu on 2018/12/20.
//  Copyright © 2018年 268Edu. All rights reserved.
//

#import "ViewController.h"
#import "MLSchoolView.h"
#import "MLSchoolModel.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor magentaColor];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"点击" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(0, 0, 100, 50);
    button.center = self.view.center;
    [self.view addSubview:button];
}

- (void)clickAction:(UIButton *)button{
    [[MLSchoolView shareSchoolInstance] displaySchoolView];
    [MLSchoolView shareSchoolInstance].selectBlock = ^(MLSchoolModel * _Nonnull schoolModel, MLSchoolModel * _Nonnull gradeModel, MLSchoolModel * _Nonnull classModel) {
        
    };
}

@end
