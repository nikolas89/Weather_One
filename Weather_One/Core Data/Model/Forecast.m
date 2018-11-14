//
//  Forecast.m
//  Weather_One
//
//  Created by Nick on 10/11/18.
//  Copyright © 2018 nick. All rights reserved.
//

#import "Forecast.h"

@implementation Forecast

@dynamic cityId;
@dynamic date;
@dynamic temp;

+ (NSFetchRequest<Forecast *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"Forecast"];
}

- (void)loadFromDictionary:(NSDictionary *)dictionary {
    
    NSNumber *temp = dictionary[@"main"][@"temp"];
    self.temp = temp.doubleValue;
    self.date = [NSDate dateWithTimeIntervalSince1970:[dictionary[@"dt"] doubleValue]];
}

@end
