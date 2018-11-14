//
//  SearchVC.m
//  Weather_One
//
//  Created by Nick on 10/7/18.
//  Copyright © 2018 nick. All rights reserved.
//

#import "SearchViewController.h"
#import <MapKit/MapKit.h>
#import "LocationService.h"
#import "Helpers.h"

static NSString * const reuseIdentifier = @"CityCell";

@interface SearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *searchResults;
@property (strong, nonatomic) LocationService *locationService;

@end

@implementation SearchViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.locationService = [[LocationService alloc] init];
    
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.searchBar becomeFirstResponder];
}

#pragma mark - Search

- (void)performSearchForText:(NSString *)text {
    
    self.searchResults = [[NSMutableArray alloc] init];
    
    [self.locationService performLocationSearchForText:text completion:^(NSArray * _Nullable locations, NSError * _Nullable error) {
        
        if (error) {
            NSLog(@"Error = %@", error.debugDescription);
            return;
        }
        
        [self.searchResults addObjectsFromArray:locations];
        [self.tableView reloadData];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.searchResults == nil) {
        return 0;
    } else {
        return self.searchResults.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        
    MKMapItem *item = self.searchResults[indexPath.row];
    NSString *resultStr = [NSString stringWithFormat:@"%@, %@", item.placemark.country, item.placemark.name];
    
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = resultStr;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MKMapItem *selectedItem = self.searchResults[indexPath.row];
    
    [self.delegate searchViewController:self
             didFinishSearchingLocation:selectedItem.placemark.location
                               withName:selectedItem.placemark.name];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (searchBar.text.length > 0) {
        
        if ([Helpers connected]) {
            
            SEL searchSel = @selector(performSearchForText:);
            
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:searchSel object:nil];
            [self performSelector:searchSel withObject:searchText afterDelay:1];
        } else {
            [Helpers showNoConnectionAlertInViewController:self];
        }
    } else {
        
        self.searchResults = nil;
        [self.tableView reloadData];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.delegate searchViewControllerDidCancel:self];
}

#pragma mark - UIBarPositioningDelegate

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar {
    return UIBarPositionTopAttached;
}

@end
