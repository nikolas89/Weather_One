//
//  WeatherDetailViewController.m
//  Weather_One
//
//  Created by Nick on 10/17/18.
//  Copyright © 2018 nick. All rights reserved.
//

#import "WeatherDetailsViewController.h"
#import "WeatherCondition.h"
#import "Forecast.h"
#import "ForecastsService.h"
#import "Helpers.h"
#import "ForecastsProvider.h"
#import "WHWeatherView.h"

static NSString * const reuseIdentifier = @"ForecastCell";

@interface WeatherDetailsViewController () <NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *weatherDetailsView;
@property (weak, nonatomic) IBOutlet UILabel *currentTempLabel;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;
@property (weak, nonatomic) IBOutlet UILabel *cloudsChanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) ForecastsProvider *dataProvider;
@property (weak, nonatomic) IBOutlet UIView *weatherAnimView;
@property (strong, nonatomic) WHWeatherView *weatherView;

@end

@implementation WeatherDetailsViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self configureViewWithWeather:self.currentWeather];
    [self configureDataProvider];
    [self fetchForecasts];
}

#pragma mark - Config methods

- (void)configureViewWithWeather:(WeatherCondition *)weather {
    
    self.title = weather.cityName;
    
    [self configureWeatherDetailsViewWithWeather:weather];
    [self configureTableView];
    [self configureWeatherAnimationViewWithWeather:weather];
}

- (void)configureWeatherDetailsViewWithWeather:(WeatherCondition *)weather {
    
    self.currentTempLabel.text = [NSString stringWithFormat:@"%ld℃", lround(weather.currentTemp)];
    self.windLabel.text = [NSString stringWithFormat:@"%ldm/s", lround(weather.windSpeed)];
    self.cloudsChanceLabel.text = [NSString stringWithFormat:@"%ld%%", (long)weather.cloudsChance.integerValue];
    self.humidityLabel.text = [NSString stringWithFormat:@"%ld%%", (long)weather.humidity.integerValue];
}

- (void)configureTableView {
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.tableView.bounds), 1)];
    self.tableView.tableHeaderView.backgroundColor = [UIColor lightTextColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)configureWeatherAnimationViewWithWeather:(WeatherCondition *)weather {
    
    self.weatherView = [[WHWeatherView alloc] init];
    self.weatherView.weatherBackImageView.frame = self.weatherAnimView.bounds;
    [self.weatherAnimView addSubview:self.weatherView.weatherBackImageView];
    
    self.weatherView.frame = self.weatherAnimView.bounds;
    [self.weatherAnimView addSubview:self.weatherView];
    
    WHWeatherType type = [Helpers weatherConditionTypeFromWeatherId:weather.weatherId.integerValue];
    [self.weatherView showWeatherAnimationWithType:type];
}

- (void)configureDataProvider {
    
    ForecastsService *service = [[ForecastsService alloc] init];
    ForecastsProvider *dataProvider = [[ForecastsProvider alloc] initWithForecastsService:service andCityId:self.currentWeather.cityId];
    self.dataProvider = dataProvider;
    self.dataProvider.fetchedResultsControllerDelegate = self;
}

#pragma mark - Networking

- (void)fetchForecasts {
    
    if ([Helpers connected]) {
        [self.dataProvider fetchForecastsCount:5
                                    completion:^(NSError * _Nullable error) {
                                                    
                                        if (error) {
                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                [Helpers showToast:@"Something go wrong"
                                                          duration:3.0
                                                         inTheView:self.view];
                                            });
                                        }
        }];
    } else {
        [Helpers showNoConnectionAlertInViewController:self];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataProvider.fetchedResultsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *forecatCell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    Forecast *forecast = [self.dataProvider.fetchedResultsController objectAtIndexPath:indexPath];
    
    forecatCell.textLabel.text = [self formatDate:forecast.date];
    forecatCell.detailTextLabel.text = [NSString stringWithFormat:@"%ld℃", lround(forecast.temp)];
    
    return forecatCell;
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

#pragma mark - Helpers

- (NSString *)formatDate:(NSDate *)theDate {
    
    static NSDateFormatter *formatter = nil;
    
    if (!formatter) {
        
        formatter = [[NSDateFormatter alloc]init];
        formatter.dateFormat = @"EEEE HH:mm a";
    }
    
    return [formatter stringFromDate:theDate];
}

@end
