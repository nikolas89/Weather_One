//
//  WeathersListTVC.m
//  Weather_One
//
//  Created by Nick on 10/6/18.
//  Copyright © 2018 nick. All rights reserved.
//

#import "WeatherConditionsListViewController.h"
#import <MapKit/MapKit.h>
#import "WeatherCell.h"
#import "WeatherCondition.h"
#import "SearchViewController.h"
#import "WeatherDetailsViewController.h"
#import "WeatherConditionsProvider.h"
#import "Helpers.h"

static NSString * const reuseIdentifier = @"WeatherCell";

@interface WeatherConditionsListViewController () <SearchViewControllerDelegate>

@end

@implementation WeatherConditionsListViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self configureUI];
    [self fetchWeatherConditions];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    if (![Helpers connected]) {
        [Helpers showNoConnectionAlertInViewController:self];
    }
}

#pragma mark - Config methods

- (void)configureUI {
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    [refresh addTarget:self
                action:@selector(refreshData)
      forControlEvents:UIControlEventValueChanged];
    refresh.tintColor = [UIColor whiteColor];
    self.refreshControl = refresh;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark - Networking

- (void)fetchWeatherConditions {
    
    if ([Helpers connected]) {
        
        self.tableView.refreshControl.attributedTitle = [self whiteAttributedStringFromString:@"Loading…"];
        
        __weak typeof(self)weakSelf = self;
        [self.dataProvider fetchWeatherConditionsWithCompletionHandler:^(NSError * _Nullable error) {
            
            if (!error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([weakSelf.refreshControl isRefreshing]) {
                        [weakSelf.refreshControl endRefreshing];
                    }
                });
            }
        }];
    } else {
        
        self.tableView.refreshControl.attributedTitle = [self whiteAttributedStringFromString:@"No Internet Connection"];
        
        if ([self.refreshControl isRefreshing]) {
            [self.refreshControl endRefreshing];
        }
    }
}

- (void)refreshData {
    [self fetchWeatherConditions];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataProvider.fetchedResultsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    WeatherCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    WeatherCondition *weather = [self.dataProvider.fetchedResultsController objectAtIndexPath:indexPath];
    
    [cell configureForWeather:weather];
    
    return cell;
}

- (BOOL)tableView:(UITableView*)tableView canEditRowAtIndexPath:(NSIndexPath*)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        WeatherCondition *conditionToDelete = [self.dataProvider.fetchedResultsController objectAtIndexPath:indexPath];
        NSManagedObjectContext *context = [CoreDataStack sharedInstanse].persistentContainer.viewContext;
        [context deleteObject:conditionToDelete];
        
        NSError *error = nil;
        if (![context save:&error]) {
            
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

#pragma mark - SearchVCDelegate

- (void)searchViewControllerDidCancel:(SearchViewController *)controller {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchViewController:(SearchViewController *)controller didFinishSearchingLocation:(CLLocation *)location withName:(NSString *)name {
    
    if (![self containsWeatherConditionForCity:name]) {
        
        [self.dataProvider fetchWeatherConditionForCityWithCoordinates:location.coordinate
                                                            completion:^(NSError * _Nullable error) {
            
                                                                if (error) {
                                                                    
                                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                                        [Helpers showToast:@"Error Finding City"
                                                                                  duration:3.0
                                                                                 inTheView:self.view];
                                                                    });
                                                                }
        }];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"AddCity"]) {
        
        SearchViewController *searchVC = segue.destinationViewController;
        searchVC.delegate = self;
    }
    
    if ([segue.identifier isEqualToString:@"ShowWeatherDetail"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        WeatherCondition *currentWeather = [self.dataProvider.fetchedResultsController objectAtIndexPath:indexPath];
        WeatherDetailsViewController *weatherDetailVC = segue.destinationViewController;
        weatherDetailVC.currentWeather = currentWeather;
    }
}

#pragma mark - Helpers

- (BOOL)containsWeatherConditionForCity:(NSString *)cityName {
    
    for (WeatherCondition *condition in self.dataProvider.fetchedResultsController.fetchedObjects) {
        
        if ([condition.cityName isEqualToString:cityName]) {
            return YES;
        }
    }
    
    return NO;
}

- (NSAttributedString *)whiteAttributedStringFromString:(NSString *)str {
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:str];
    NSDictionary *attributes = @{ NSForegroundColorAttributeName:[UIColor whiteColor] };
    [title setAttributes:attributes range:NSMakeRange(0, title.length)];
    
    return title;
}

@end
