//
//  Forecast.h
//  Weather_One
//
//  Created by Nick on 10/11/18.
//  Copyright © 2018 nick. All rights reserved.
//

#import "ModelObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface Forecast : ModelObject

@property (nullable, nonatomic, copy) NSString *cityId;
@property (nullable, nonatomic, copy) NSDate *date;
@property (nonatomic) double temp;

+ (NSFetchRequest<Forecast *> *)fetchRequest;

- (void)loadFromDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
