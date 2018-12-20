//
//  MLSchoolModel.h
//  268EDU_Demo
//
//  Created by yizhilu on 2018/12/20.
//  Copyright © 2018年 edu268. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MLSchoolModel : NSObject

@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *schoolId;
@property (nonatomic, copy) NSString *gradeId;
@property (nonatomic, strong) NSArray *gradeList;
@property (nonatomic, strong) NSArray *classNoList;
@end

NS_ASSUME_NONNULL_END
