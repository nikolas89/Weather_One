//
//  WeathersListTVC.h
//  Weather_One
//
//  Created by Nick on 10/6/18.
//  Copyright © 2018 nick. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataStack.h"

@class WeatherConditionsProvider;

NS_ASSUME_NONNULL_BEGIN

@interface WeatherConditionsListViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) WeatherConditionsProvider *dataProvider;

@end

NS_ASSUME_NONNULL_END
