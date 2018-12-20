//
//  MLSchoolModel.m
//  268EDU_Demo
//
//  Created by yizhilu on 2018/12/20.
//  Copyright © 2018年 edu268. All rights reserved.
//

#import "MLSchoolModel.h"
#import <YYKit.h>
@implementation MLSchoolModel
+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"ID" : @"id"};
}

- (void)setGradeList:(NSArray *)gradeList{
    _gradeList = gradeList;
    _gradeList = [NSArray modelArrayWithClass:[MLSchoolModel class] json:_gradeList];
}

- (void)setClassNoList:(NSArray *)classNoList{
    _classNoList = classNoList;
    _classNoList = [NSArray modelArrayWithClass:[MLSchoolModel class] json:_classNoList];
}
@end
