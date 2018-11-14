//
//  WeathersService.m
//  Weather_One
//
//  Created by Nick on 10/7/18.
//  Copyright © 2018 nick. All rights reserved.
//

#import "WeatherConditionsService.h"
#import "OWMapAPIClient.h"

static NSString * const kWeathersServiceTypeGroup = @"/group?id=";
static NSString * const kWeathersServiceTypeWeather = @"/weather?";

@interface WeatherConditionsService ()

@property (strong, nonatomic) OWMapAPIClient *apiClient;
@property (nonatomic, strong) NSManagedObjectContext *context;

@end

@implementation WeatherConditionsService

#pragma mark - Lifecycle

- (instancetype)init {
    
    self = [super init];
    
    if (self) {
        self.apiClient = [[OWMapAPIClient alloc] init];
    }
    
    return self;
}

#pragma mark - Public

- (void)getWeatherByCityIDs:(NSArray *)cityIDs completion:(WCSWeatherByCityIDsCompletionHandler)completion {
    
    NSString *cityIDsString = [cityIDs componentsJoinedByString:@","];
    NSString *pathStr = [NSString stringWithFormat:@"%@%@", kWeathersServiceTypeGroup, cityIDsString];
    
    [self.apiClient getDataFromPath:pathStr
                         completion:^(NSError * _Nonnull error, NSDictionary * _Nonnull result) {
                             
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

- (void)getWeatherByCoordinates:(CLLocationCoordinate2D)coordinates completion:(WCSWeatherByCoordinatesCompletionHandler)completion {
    
    NSString *coordinatesStr = [NSString stringWithFormat:@"lat=%f&lon=%f", coordinates.latitude, coordinates.longitude];
    NSString *pathStr = [NSString stringWithFormat:@"%@%@", kWeathersServiceTypeWeather, coordinatesStr];
    
    [self.apiClient getDataFromPath:pathStr
                         completion:^(NSError * _Nullable error, NSDictionary * _Nullable result) {
                             
                             if (error) {
                                 
                                 if (completion) {
                                     completion(error, nil);
                                 }
                             } else {
                                 
                                 if (completion) {
                                     completion(nil, result);
                                 }
                             }
                         }];
}

@end
