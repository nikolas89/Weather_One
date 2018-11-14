//
//  SearchVC.h
//  Weather_One
//
//  Created by Nick on 10/7/18.
//  Copyright © 2018 nick. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SearchViewController;
@class CLLocation;

@protocol SearchViewControllerDelegate <NSObject>

- (void)searchViewControllerDidCancel:(SearchViewController *)controller;
- (void)searchViewController:(SearchViewController *)controller didFinishSearchingLocation:(CLLocation *)location withName:(NSString *)name;

@end

@interface SearchViewController : UIViewController

@property (weak, nonatomic) id <SearchViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
