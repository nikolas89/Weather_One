//
//  WeatherDetailViewController.h
//  Weather_One
//
//  Created by Nick on 10/17/18.
//  Copyright © 2018 nick. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class WeatherCondition;

@interface WeatherDetailsViewController : UIViewController

@property (strong, nonatomic) WeatherCondition *currentWeather;

@end

NS_ASSUME_NONNULL_END
