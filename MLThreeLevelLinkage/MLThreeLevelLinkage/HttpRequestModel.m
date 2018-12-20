///
///  HttpRequestModel.m
///  268EDU_Demo
///
///  Created by EDU268 on 15/10/29.
///  Copyright © 2015年 edu268. All rights reserved.
///

#import "HttpRequestModel.h"
#import "MBProgressHUD.h"
#import <AFNetworking.h>
@implementation HttpRequestModel

static HttpRequestModel *_requestModel = nil;
+(HttpRequestModel *) sharedHttpRequestModel
{
    if (!_requestModel){
        _requestModel = [self init];
    }
    return _requestModel;
}


/** 2 * 请求 */
+ (void)httpRequest:(NSString *)urlString withParamters:(NSDictionary *)dic isPost:(BOOL)isPost success:(void (^)(id responseData))success failure:(void (^)(NSError *error))failure {
    
    
    urlString = [NSString stringWithFormat:@"%@.json",urlString];
    
    __block MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].windows lastObject] animated:YES];
    
    HUD.animationType=MBProgressHUDAnimationFade;
    HUD.label.text=@"正在加载";
    
    [HUD showAnimated:YES];
    
    [self printRequestUrlString:urlString withParamter:dic];
    
    NSString *encoded = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    ///增加这几行代码；
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager.requestSerializer setTimeoutInterval:10.f];
    

    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    /// [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    if (isPost) {
        [manager POST:encoded parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            if (success != nil) {
                success(responseObject);
                [HUD performSelector:@selector(removeFromSuperview)  withObject:nil afterDelay:0.0];
                
            }
        }
              failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                  
                  if (failure != nil) {
                      failure(error);
                      [HUD performSelector:@selector(removeFromSuperview)  withObject:nil afterDelay:0.0];
                  }
                  
                  HUD.animationType = MBProgressHUDModeText;
                  
                  HUD.label.text=@"请求失败,重新发送请求";
                  [HUD performSelector:@selector(removeFromSuperview)  withObject:nil afterDelay:0.0];
                  
              }];
        
    } else {
        
        [manager GET:encoded parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success != nil) {
                success(responseObject);
            }
            
            [HUD performSelector:@selector(removeFromSuperview)  withObject:nil afterDelay:0.8];
            
        }
             failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                 
                 if (failure != nil) {
                     failure(error);
                 }
                 HUD.animationType = MBProgressHUDModeText;
                 
                 HUD.label.text=@"请求失败,重新发送请求";
                 
                 [HUD performSelector:@selector(removeFromSuperview)  withObject:nil afterDelay:0.8];
             }];
    }
}




/** 1 * post 请求 无进度 */
+ (void)request:(NSString *)urlString withParamters:(NSDictionary *)dic success:(void (^)(id responseData))success failure:(void (^)(NSError *error))failure {
    
//    YYReachability *reachable = [[YYReachability alloc] init];
//    /// 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
//    
//    if (reachable.status == YYReachabilityStatusNone) {
//        [MBProgressHUD showMBPAlertView:@"无可用网络" withSecond:1.0];
//        return;
//    }
    urlString = [NSString stringWithFormat:@"%@.json",urlString];
    
    [self printRequestUrlString:urlString withParamter:dic];
    NSString *encoded = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    ///增加这几行代码；
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager.requestSerializer setTimeoutInterval:10.f];

    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    
    [manager POST:encoded parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success != nil)
            success(responseObject);
    }
          failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
              
              
              if (failure != nil) {
                  failure(error);
              }
          }];
}


+ (void)printRequestUrlString:(NSString *)urlString withParamter:(NSDictionary *)dic {
    NSArray *dicKeysArray = [dic allKeys];
    NSString *urlWithParamterString = urlString;
    
    if (dicKeysArray.count != 0) {
        
        urlWithParamterString = [urlWithParamterString stringByAppendingString:@"?"];
    }
    
    for (NSInteger i = 0; i < dicKeysArray.count; i++) {
        
        urlWithParamterString = [urlWithParamterString stringByAppendingString:[NSString stringWithFormat:@"%@=%@&", dicKeysArray[i], [dic objectForKey:dicKeysArray[i]]]];
        
        if (i == dicKeysArray.count - 1) {
            
            urlWithParamterString = [urlWithParamterString substringToIndex:urlWithParamterString.length - 1];
        }
    }
}






@end
