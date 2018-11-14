//
//  ForecastsService.h
//  Weather_One
//
//  Created by Nick on 10/7/18.
//  Copyright © 2018 nick. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ForecastsServiceCompletionHandler)(NSError* __nullable error, NSArray<NSDictionary *> *  __nullable results);

@interface ForecastsService : NSObject

- (void)getDailyForecastByCityID:(NSString *)cityID
                           count:(NSInteger)count
                      completion:(ForecastsServiceCompletionHandler)completion;

@end

NS_ASSUME_NONNULL_END
