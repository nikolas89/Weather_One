//
//  ForecastsProvider.h
//  Weather_One
//
//  Created by Nick on 11/8/18.
//  Copyright © 2018 nick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@class ForecastsService;

typedef void(^FPCompletionHandler)(NSError* __nullable error);

@interface ForecastsProvider : NSObject

@property (nonatomic, weak) id <NSFetchedResultsControllerDelegate> fetchedResultsControllerDelegate;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (instancetype)initWithForecastsService:(ForecastsService *)webService andCityId:(NSString *)cityId;

- (void)fetchForecastsCount:(NSInteger)count completion:(FPCompletionHandler)completion;

@end

NS_ASSUME_NONNULL_END
