//
//  WeatherCell.h
//  Weather_One
//
//  Created by Nick on 10/5/18.
//  Copyright © 2018 nick. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WeatherCondition;

NS_ASSUME_NONNULL_BEGIN

@interface WeatherCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *weatherAnimView;
@property (weak, nonatomic) IBOutlet UILabel *cityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentTempLabel;

- (void)configureForWeather:(WeatherCondition *)weather;

@end

NS_ASSUME_NONNULL_END
