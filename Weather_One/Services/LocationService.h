//
//  LocationManager.h
//  Weather_One
//
//  Created by Nick on 10/10/18.
//  Copyright © 2018 nick. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^LocationServiceCallback)(NSArray * __nullable locations, NSError * __nullable error);

@interface LocationService : NSObject

- (void)performLocationSearchForText:(NSString *)text completion:(LocationServiceCallback)completionBlock;

@end

NS_ASSUME_NONNULL_END
