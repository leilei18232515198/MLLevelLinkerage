//
//  MLSchoolView.m
//  268EDU_Demo
//
//  Created by yizhilu on 2018/12/20.
//  Copyright © 2018年 edu268. All rights reserved.
//

#import "MLSchoolView.h"
#import "MLSchoolModel.h"
#import "HttpRequestModel.h"
#import <YYKit.h>
#define kScreen_width         [UIScreen mainScreen].bounds.size.width
#define kScreen_height         [UIScreen mainScreen].bounds.size.height
@interface MLSchoolView ()<UIGestureRecognizerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic,strong)NSArray *entity;
@property (nonatomic,strong)UIView *maskView;
@property (nonatomic,strong)UIPickerView *pickView;
@property (nonatomic,strong)MLSchoolModel *model;
@property (nonatomic,strong)MLSchoolModel *nextModel;
@property (nonatomic,strong)MLSchoolModel *lastModel;
@end
@implementation MLSchoolView


+ (instancetype)shareSchoolInstance{
    static MLSchoolView *schoolView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        schoolView = [[self alloc] initWithFrame:CGRectMake(0, kScreen_height, kScreen_width, 300)];
    });
    return schoolView;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self setUpMajor];
    }
    return self;
}

- (void)displaySchoolView{
   
//    调用班级接口
    if (!self.entity.count) {
//        NSString *url = @"http://www.dameihanzi.com/app/get/school/grade/classno";
//        [HttpRequestModel request:url withParamters:nil success:^(id responseData) {
//            NSArray *entity = [NSArray modelArrayWithClass:[MLSchoolModel class] json:responseData[@"entity"]];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"class" ofType:@"json"];
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *entity = [NSArray modelArrayWithClass:[MLSchoolModel class] json:dict[@"entity"]];
        self.entity = entity;
        [self configureData];
        [self.pickView reloadAllComponents];
//        } failure:^(NSError *error) {
//            
//        }];
    }
    [self.maskView addSubview:self];
    [UIView  animateWithDuration:.5 animations:^{
        self.transform = CGAffineTransformTranslate(self.transform, 0, -300);
    }];
}

- (void)configureData{
    self.model = self.entity.firstObject;
    self.nextModel = self.model.gradeList.firstObject;
    self.lastModel = self.nextModel.classNoList.firstObject;
}

- (void)setUpMajor {
    
    UIView *topLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    topLineView.backgroundColor = [UIColor grayColor];
    [self addSubview:topLineView];
    
    YYLabel *title = [self creatLabel:CGRectMake(CGRectGetMidX(topLineView.frame)-50, 0, 100, 50) color:[UIColor blackColor] text:@"班级选择"];
    [topLineView addSubview:title];
    
    YYLabel *cancel = [self creatLabel:CGRectMake(15, 0, 50, 50) color:[UIColor redColor] text:@"取消"];
    [topLineView addSubview:cancel];
    cancel.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        [self dismissView];
    };
    
    
    YYLabel *confirm = [self creatLabel:CGRectMake(kScreenWidth-50-15, 0, 50, 50) color:[UIColor redColor] text:@"确定"];
    confirm.textTapAction = ^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
        if (self.selectBlock) {
            self.selectBlock(self.model, self.nextModel, self.lastModel);
            [self dismissView];
        }
    };
    
    [topLineView addSubview:confirm];
    
    self.pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(topLineView.frame), kScreenWidth, CGRectGetHeight(self.frame)-CGRectGetHeight(topLineView.frame))];
    self.pickView.dataSource = self;
    self.pickView.delegate = self;
    [self addSubview:self.pickView];
    
}

#pragma mark - 该方法的返回值决定该控件包含多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView{
    return 3;
}

#pragma mark - 设置文字样式
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel *pickerLabel = (UILabel*)view;
    
    if (!pickerLabel){
        
        pickerLabel = [[UILabel alloc] init];
        [pickerLabel setTextColor:[UIColor blackColor]];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:17.0f]];
        
    }
    
    if (0 == component) {
        MLSchoolModel *model = self.entity[row];
        pickerLabel.text = model.name;
    }
    else if (1 == component){
        NSInteger rowProvince = [pickerView selectedRowInComponent:0];
        MLSchoolModel *model = self.entity[rowProvince];
        MLSchoolModel *nextModel = model.gradeList[row];
        pickerLabel.text = nextModel.name;
    }else {
        NSInteger rowProvince = [pickerView selectedRowInComponent:0];
        NSInteger rowCity = [pickerView selectedRowInComponent:1];
        MLSchoolModel *model = self.entity[rowProvince];
        MLSchoolModel *nextModel = model.gradeList[rowCity];
        MLSchoolModel *lastModel = nextModel.classNoList[row];
        pickerLabel.text = lastModel.name;
        
    }
    return pickerLabel;
}

#pragma mark - 该方法的返回值决定该控件指定列包含多少个列表项
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (0 == component)
    {
        return self.entity.count;
    }
    else if (1 == component)
    {
        NSInteger rowProvince = [pickerView selectedRowInComponent:0];
        MLSchoolModel *model = self.entity[rowProvince];
        return model.gradeList.count;
    }
    else{
        NSInteger rowProvince = [pickerView selectedRowInComponent:0];
        NSInteger rowCity = [pickerView selectedRowInComponent:1];
        MLSchoolModel *model = self.entity[rowProvince];
        MLSchoolModel *nextModel = model.gradeList[rowCity];
        return nextModel.classNoList.count;
    }
    
}

#pragma mark - 当用户选中UIPickerViewDataSource中指定列和列表项时激发该方法
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(0 == component){
        [pickerView reloadComponent:1];
        [pickerView reloadComponent:2];
    }
    if(1 == component){
        [pickerView reloadComponent:2];
    }
    NSInteger rowOne = [pickerView selectedRowInComponent:0];
    NSInteger rowTow = [pickerView selectedRowInComponent:1];
    NSInteger rowThree = [pickerView selectedRowInComponent:2];
    
    MLSchoolModel *model = self.entity[rowOne];
    MLSchoolModel *nextModel = model.gradeList[rowTow];
    MLSchoolModel *lastModel = nextModel.classNoList.count?nextModel.classNoList[rowThree]:nil;
    self.model = model;
    self.nextModel = nextModel;
    self.lastModel = lastModel;

}

//防止手势冲突（父视图影响子视图）
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if ([touch.view isDescendantOfView:self]) {
        return NO;
    }
    [self dismissView];
    return YES;
}


- (void)dismissView{
    
    [UIView animateWithDuration:.5 animations:^{
        self.transform = CGAffineTransformTranslate(self.transform, 0, 300);
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
        self.maskView = nil;
    }];
}

-(YYLabel*)creatLabel:(CGRect)frame color:(UIColor*)color text:(NSString*)text{
    
    YYLabel *label = [[YYLabel alloc]initWithFrame:frame];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:17.0f];
    label.textColor = color;
    label.text = text;
    return label;
}


- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreen_width, kScreen_height)];
        _maskView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:.5];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        tap.delegate = self;
        [_maskView addGestureRecognizer:tap];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:_maskView];
    }
    return _maskView;
}

@end
