//
//  OWM_APIClient.h
//  Weather_One
//
//  Created by Nick on 10/6/18.
//  Copyright © 2018 nick. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^OWMapAPIClientCallback)(NSError* __nullable error, NSDictionary * __nullable result);

@interface OWMapAPIClient : NSObject

- (void)getDataFromPath:(NSString *)path completion:(OWMapAPIClientCallback)completion;

@end

NS_ASSUME_NONNULL_END
