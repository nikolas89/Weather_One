//
//  WeatherConditionsProvider.m
//  Weather_One
//
//  Created by Nick on 10/29/18.
//  Copyright © 2018 nick. All rights reserved.
//

#import "WeatherConditionsProvider.h"
#import "WeatherConditionsService.h"
#import "WeatherCondition.h"
#import "CoreDataStack.h"

@interface WeatherConditionsProvider ()

@property (nonatomic, strong) WeatherConditionsService *webService;
@property (nonatomic, strong) NSPersistentContainer *persistentContainer;

@end

@implementation WeatherConditionsProvider

#pragma mark - Lifecycle

- (instancetype)initWithWeathersService:(WeatherConditionsService *)webService {
    
    self = [super init];
    
    if (self) {
        [self registerDefaults];
        self.persistentContainer = [CoreDataStack sharedInstanse].persistentContainer;
        self.webService = webService;
    }
    
    return self;
}

#pragma mark - Custom Accessors

- (NSFetchedResultsController *)fetchedResultsController {

    if (!_fetchedResultsController) {
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: [WeatherCondition entityName]];
        NSSortDescriptor *cityNameSortDesc = [NSSortDescriptor sortDescriptorWithKey:@"cityName" ascending:YES];
        request.sortDescriptors = @[cityNameSortDesc];

        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.persistentContainer.viewContext sectionNameKeyPath:nil cacheName:nil];
        _fetchedResultsController.delegate = self.fetchedResultsControllerDelegate;

        [_fetchedResultsController performFetch:nil];
    }

    return _fetchedResultsController;
}

#pragma mark - Public

// Fetch WeatherConditions from the remote server.
- (void)fetchWeatherConditionsWithCompletionHandler:(WCPCompletionHandler)completion {
    
    [self.webService getWeatherByCityIDs:[self storedCityIDs]
                              completion:^(NSError * _Nullable error, NSArray<NSDictionary *> * _Nullable results) {
                                  
                                  if (error) {
                                      
                                      if (completion) {
                                          completion(error);
                                      }
                                  } else {
                                      
                                      if (completion) {
                                          [self importWeatherConditionsFromJSONArray:results];
                                          completion(nil);
                                      }
                                  }
                              }];
}

// Fetch WeatherCondition for city with specific coordinates from the remote server.
- (void)fetchWeatherConditionForCityWithCoordinates:(CLLocationCoordinate2D)coordinates
                                         completion:(WCPCompletionHandler)completion {
    
    [self.webService getWeatherByCoordinates:coordinates
                                  completion:^(NSError * _Nullable error, NSDictionary * _Nullable result) {

                                      if (error) {

                                          if (completion) {
                                              completion(error);
                                          }
                                      } else {

                                          if (completion) {
                                              [self importWeatherConditionFromJSONDictionary:result];
                                              completion(nil);
                                          }
                                      }
    }];
}

#pragma mark - Private

- (BOOL)importWeatherConditionsFromJSONArray:(NSArray *)jsonArray {
    // Create a context on a private queue to:
    // - Fetch existing WeatherConditions to compare with incoming data.
    // - Create new WeatherConditions as required.
    NSManagedObjectContext *taskContext = [self.persistentContainer newBackgroundContext];
    taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    taskContext.undoManager = nil; // We don't need undo so set it to nil.
    
    BOOL __block success = NO;
    [taskContext performBlockAndWait:^{ // Wait doesn't block as taskContext is a background context
        // Fetch the existing records with the same cityID, then remove
        // them and create new records with the latest data to replace them.
        NSMutableArray *conditionsIDs = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in jsonArray) {
            
            NSString *cityID = [NSString stringWithFormat:@"%@", dict[@"id"]];
            [conditionsIDs addObject:cityID];
        }
        
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[WeatherCondition entityName]];
        NSPredicate *cityIDsPredicate = [NSPredicate predicateWithFormat:@"(cityId IN %@)", conditionsIDs];
        [fetchRequest setPredicate:cityIDsPredicate];
        
        // Create batch delete request and set the result type to NSBatchDeleteResultTypeObjectIDs
        // so that we can merge the changes
        NSBatchDeleteRequest *batchDeleteRequest = [[NSBatchDeleteRequest alloc] initWithFetchRequest:fetchRequest];
        batchDeleteRequest.resultType = NSBatchDeleteResultTypeObjectIDs;
        
        // Execute the request to de batch delete and merge the changes to viewContext,
        // which triggers the UI update
        NSError *requestError = nil;
        NSBatchDeleteResult *batchDeleteResult = [taskContext executeRequest:batchDeleteRequest error:&requestError];
        
        if (requestError) {
            NSLog(@"RequestError = %@", requestError);
        } else {
            
            NSArray *deletedObjectIDs = batchDeleteResult.result;
            [NSManagedObjectContext mergeChangesFromRemoteContextSave:@{NSDeletedObjectsKey : deletedObjectIDs} intoContexts:@[self.persistentContainer.viewContext]];
        }
        
        // Create new records.
        for (NSDictionary *condDict in jsonArray) {
            WeatherCondition *condition = [WeatherCondition insertNewObjectIntoContext:taskContext];
            // Set the attribute values the WeatherCondition object.
            [condition loadFromDictionary:condDict];
        }
        
        // Save all the changes just made and reset the taskContext to free the cache.
        if (taskContext.hasChanges) {
            
            NSError *saveError = nil;
            [taskContext save:&saveError];
            
            if (!saveError) {
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"FirstLaunch"];
            }
            
            [taskContext reset];
        }
        success = YES;
    }];
    
    return success;
}

- (void)importWeatherConditionFromJSONDictionary:(NSDictionary *)jsonDictionary {
    
    // Create a context on a private queue
    NSManagedObjectContext *taskContext = [self.persistentContainer newBackgroundContext];
    taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    taskContext.undoManager = nil; // We don't need undo so set it to nil.
    
    // Create new WeatherCondition as required.
    WeatherCondition *condition = [WeatherCondition insertNewObjectIntoContext:taskContext];
    [condition loadFromDictionary:jsonDictionary];
    
    // Save new WeatherCondition and reset the taskContext to free the cache.
    [taskContext performBlockAndWait:^{ // Wait doesn't block as taskContext is a background context
        
        NSError *saveError = nil;
        [taskContext save:&saveError];
        [taskContext reset];
    }];
}

#pragma mark - Helpers

- (NSArray *)storedCityIDs {
    
    BOOL firstLaunch = [[NSUserDefaults standardUserDefaults]boolForKey:@"FirstLaunch"];
    
    if (firstLaunch) {
        
        NSDictionary *defaultCities = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"DefaultCities"];
        
        return [defaultCities allValues];
    } else {
        
        NSMutableArray *cityIDs = [[NSMutableArray alloc] init];
        for (WeatherCondition *weather in self.fetchedResultsController.fetchedObjects) {
            [cityIDs addObject:weather.cityId];
        }
        
        return cityIDs;
    }
}

#pragma mark - NSUserDefaults

- (void)registerDefaults {
    
    NSDictionary *defaultCities = @{ @"Kyiv"   : @"703448",
                                     @"Odessa" : @"698740" };
    NSDictionary *dictionary = @{ @"FirstLaunch"   : @YES,
                                  @"DefaultCities" : defaultCities };
    [[NSUserDefaults standardUserDefaults]registerDefaults:dictionary];
}

@end
