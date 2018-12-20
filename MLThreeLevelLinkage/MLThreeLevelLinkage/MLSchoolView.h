//
//  MLSchoolView.h
//  268EDU_Demo
//
//  Created by yizhilu on 2018/12/20.
//  Copyright © 2018年 edu268. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MLSchoolModel;
NS_ASSUME_NONNULL_BEGIN

@interface MLSchoolView : UIView
@property (nonatomic,copy) void(^selectBlock)(MLSchoolModel *schoolModel,MLSchoolModel *gradeModel,MLSchoolModel *classModel);
+ (instancetype)shareSchoolInstance;
- (void)displaySchoolView;
@end

NS_ASSUME_NONNULL_END
