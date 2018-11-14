//
//  WeatherManagedObject.h
//  Weather_One
//
//  Created by Nick on 10/6/18.
//  Copyright © 2018 nick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ModelObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface WeatherCondition : ModelObject

@property (nullable, nonatomic, copy) NSString *cityId;
@property (nullable, nonatomic, copy) NSString *cityName;
@property (nullable, nonatomic, copy) NSNumber *cloudsChance;
@property (nonatomic) double currentTemp;
@property (nullable, nonatomic, copy) NSNumber *humidity;
@property (nonatomic) double windSpeed;
@property (nullable, nonatomic, copy) NSNumber *weatherId;

+ (NSFetchRequest<WeatherCondition *> *)fetchRequest;

- (void)loadFromDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
