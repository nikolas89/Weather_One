//
//  Helpers.h
//  Weather_One
//
//  Created by Nick on 10/23/18.
//  Copyright © 2018 nick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WHWeatherView.h"

NS_ASSUME_NONNULL_BEGIN

@interface Helpers : NSObject

+ (BOOL)connected;
+ (void)showNoConnectionAlertInViewController:(UIViewController *)controller;
+ (void)showToast:(NSString *)message duration:(NSTimeInterval)duration inTheView:(UIView *)view;
+ (WHWeatherType)weatherConditionTypeFromWeatherId:(NSInteger)weatherId;

@end

NS_ASSUME_NONNULL_END
