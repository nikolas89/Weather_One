//
//  WeathersService.h
//  Weather_One
//
//  Created by Nick on 10/7/18.
//  Copyright © 2018 nick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^WCSWeatherByCoordinatesCompletionHandler)(NSError* __nullable error, NSDictionary *  __nullable result);
typedef void(^WCSWeatherByCityIDsCompletionHandler)(NSError* __nullable error, NSArray<NSDictionary *> *  __nullable results);

@interface WeatherConditionsService : NSObject

- (void)getWeatherByCityIDs:(NSArray *)cityIDs
                 completion:(WCSWeatherByCityIDsCompletionHandler)completion;
- (void)getWeatherByCoordinates:(CLLocationCoordinate2D)coordinates
                     completion:(WCSWeatherByCoordinatesCompletionHandler)completion;

@end

NS_ASSUME_NONNULL_END
