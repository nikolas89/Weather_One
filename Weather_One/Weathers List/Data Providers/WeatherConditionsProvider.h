//
//  WeatherConditionsProvider.h
//  Weather_One
//
//  Created by Nick on 10/29/18.
//  Copyright © 2018 nick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@class WeatherConditionsService;

typedef void(^WCPCompletionHandler)(NSError* __nullable error);

@interface WeatherConditionsProvider : NSObject

@property (nonatomic, weak) id <NSFetchedResultsControllerDelegate> fetchedResultsControllerDelegate;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (instancetype)initWithWeathersService:(WeatherConditionsService *)webService;

- (void)fetchWeatherConditionsWithCompletionHandler:(WCPCompletionHandler)completion;
- (void)fetchWeatherConditionForCityWithCoordinates:(CLLocationCoordinate2D)coordinates
                                         completion:(WCPCompletionHandler)completion;

@end

NS_ASSUME_NONNULL_END
