//
//  WeatherManagedObject.m
//  Weather_One
//
//  Created by Nick on 10/6/18.
//  Copyright © 2018 nick. All rights reserved.
//

#import "WeatherCondition.h"

@implementation WeatherCondition

@dynamic cityId;
@dynamic cityName;
@dynamic cloudsChance;
@dynamic currentTemp;
@dynamic humidity;
@dynamic windSpeed;
@dynamic weatherId;

+ (NSFetchRequest<WeatherCondition *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:[self entityName]];
}

- (void)loadFromDictionary:(NSDictionary *)dictionary {
    
    self.cityName = dictionary[@"name"];
    self.cityId = [NSString stringWithFormat:@"%@", dictionary[@"id"]];
    NSNumber *temp = dictionary[@"main"][@"temp"];
    self.currentTemp = temp.doubleValue;
    
    NSNumber *windSpeed = dictionary[@"wind"][@"speed"];
    self.windSpeed = windSpeed.doubleValue;
    self.humidity = dictionary[@"main"][@"humidity"];
    self.cloudsChance = dictionary[@"clouds"][@"all"];
    
    NSArray *weatherArr = dictionary[@"weather"];
    NSDictionary *weatherDict = [weatherArr firstObject];
    self.weatherId = weatherDict[@"id"];
}

@end
