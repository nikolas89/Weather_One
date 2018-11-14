//
//  ForecastsService.m
//  Weather_One
//
//  Created by Nick on 10/7/18.
//  Copyright © 2018 nick. All rights reserved.
//

#import "ForecastsService.h"
#import "OWMapAPIClient.h"

static NSString * const kForecastsServiceTypeDailyForecast = @"/forecast?id=";

@interface ForecastsService ()

@property (strong, nonatomic) OWMapAPIClient *apiClient;

@end

@implementation ForecastsService

#pragma mark - Lifecycle

- (instancetype)init {
    
    self = [super init];
    
    if (self) { 
        self.apiClient = [[OWMapAPIClient alloc] init];
    }
    
    return self;
}

#pragma mark - Public

- (void)getDailyForecastByCityID:(NSString *)cityID
                           count:(NSInteger)count
                      completion:(ForecastsServiceCompletionHandler)completion {
    
    NSString *pathStr = [NSString stringWithFormat:@"%@%@&cnt=%ld", kForecastsServiceTypeDailyForecast, cityID, count];
    
    [self.apiClient getDataFromPath:pathStr completion:^(NSError * _Nonnull error, NSDictionary * _Nonnull result) {
        
        if (error) {
            
            if (completion) {
                completion(error, nil);
            }
        } else {
            
            if (completion) {
                completion(nil, result[@"list"]);
            }
        }
    }];
}

@end
