//
//  WeatherCell.m
//  Weather_One
//
//  Created by Nick on 10/5/18.
//  Copyright © 2018 nick. All rights reserved.
//

#import "WeatherCell.h"
#import "WeatherCondition.h"
#import "WHWeatherView.h"
#import "Helpers.h"

@interface WeatherCell ()

@property (nonatomic, strong) WHWeatherView *weatherView;

@end

@implementation WeatherCell

#pragma mark - Lifecycle

-(void)prepareForReuse {
    
    [super prepareForReuse];
    
    self.cityNameLabel.text = nil;
    self.currentTempLabel.text = nil;
    self.weatherView = nil;
}

#pragma mark - Public

- (void)configureForWeather:(WeatherCondition *)weather {
    
    self.cityNameLabel.text = weather.cityName;
    self.currentTempLabel.text = [NSString stringWithFormat:@"%ld℃", lround(weather.currentTemp)];

    self.weatherView = [[WHWeatherView alloc] init];
    self.weatherView.weatherBackImageView.frame = self.weatherAnimView.bounds;
    [self.weatherAnimView addSubview:self.weatherView.weatherBackImageView];

    self.weatherView.frame = self.weatherAnimView.bounds;
    [self.weatherAnimView addSubview:self.weatherView];
    
    WHWeatherType type = [Helpers weatherConditionTypeFromWeatherId:weather.weatherId.integerValue];
    [self.weatherView showWeatherAnimationWithType:type];
}

@end
