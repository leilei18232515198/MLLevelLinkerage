///
///  HttpRequestModel.h
///  268EDU_Demo
///
///  Created by EDU268 on 15/10/29.
///  Copyright © 2015年 edu268. All rights reserved.
///

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HttpRequestModel : NSObject

/** 1 * post 请求 无进度 */
+ (void)httpRequest:(NSString *)urlString withParamters:(NSDictionary *)dic isPost:(BOOL)isPost success:(void (^)(id responseData))success failure:(void (^)(NSError *error))failure;


/** 2 * post 请求 无进度 */
+ (void)request:(NSString *)urlString withParamters:(NSDictionary *)dic success:(void (^)(id responseData))success failure:(void (^)(NSError *error))failure;


+ (HttpRequestModel *) sharedHttpRequestModel;
@end
