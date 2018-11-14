//
//  OWM_APIClient.m
//  Weather_One
//
//  Created by Nick on 10/6/18.
//  Copyright © 2018 nick. All rights reserved.
//

#import "OWMapAPIClient.h"
#import <AFNetworking/AFNetworking.h>

static NSString * const kOWMapAPIClientBaseURLString = @"https://api.openweathermap.org/data/";
static NSString * const kOWMapAPIClientAPIKey = @"a18dd76d496b9ef37d95c6c61c67064b";
static NSString * const kOWMapAPIClientAPIVersion = @"2.5";
static NSString * const kOWMapAPIClientTemperatureFormatCelcius = @"&units=metric";

@interface OWMapAPIClient()

@property (strong, nonatomic) NSURL *baseURL;
@property (copy, nonatomic) NSString *apiKey;
@property (copy, nonatomic) NSString *apiVersion;

@end

@implementation OWMapAPIClient

#pragma mark - Lifecycle

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        
        self.baseURL = [NSURL URLWithString:kOWMapAPIClientBaseURLString];
        self.apiKey = kOWMapAPIClientAPIKey;
        self.apiVersion = kOWMapAPIClientAPIVersion;
    }
    
    return self;
}

#pragma mark - Public

- (void)getDataFromPath:(NSString *)path completion:(OWMapAPIClientCallback)completion {
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:_baseURL sessionConfiguration:config];
    manager.requestSerializer.timeoutInterval = 5;
    
    NSString *pathStr = [NSString stringWithFormat:@"%@%@&APPID=%@%@", self.apiVersion, path, self.apiKey, kOWMapAPIClientTemperatureFormatCelcius];
    
    [manager GET:pathStr
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             
             dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
             dispatch_async(queue, ^{
                 
                 if (completion) {
                     completion(nil, responseObject);
                 }
                 
                 [manager invalidateSessionCancelingTasks:YES];
             });
         }
         failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             
             if (completion) {
                 completion(error, nil);
             }
             
             [manager invalidateSessionCancelingTasks:YES];
         }];
}

@end

