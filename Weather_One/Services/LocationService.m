//
//  LocationManager.m
//  Weather_One
//
//  Created by Nick on 10/10/18.
//  Copyright © 2018 nick. All rights reserved.
//

#import "LocationService.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface LocationService ()

@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) MKLocalSearch *localSearch;

@end

@implementation LocationService

- (void)performLocationSearchForText:(NSString *)text completion:(LocationServiceCallback)completionBlock {
    
    if (self.localSearch.searching) {
        [self.localSearch cancel];
    }
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = text;
    
    MKLocalSearchCompletionHandler completionHandler = ^(MKLocalSearchResponse *response, NSError *error) {
        
        if (error) {
            
            if (completionBlock) {
                completionBlock(nil, error);
            }
        } else {
            
            if (completionBlock) {
                
                NSArray *results = [NSArray arrayWithArray:response.mapItems];
                completionBlock(results, nil);
            }
        }
    };
    
    self.localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    [self.localSearch startWithCompletionHandler:completionHandler];
}

@end
