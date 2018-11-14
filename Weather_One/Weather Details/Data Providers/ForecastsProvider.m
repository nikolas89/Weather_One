//
//  ForecastsProvider.m
//  Weather_One
//
//  Created by Nick on 11/8/18.
//  Copyright © 2018 nick. All rights reserved.
//

#import "ForecastsProvider.h"
#import "ForecastsService.h"
#import "CoreDataStack.h"
#import "Forecast.h"

@interface ForecastsProvider ()

@property (nonatomic, strong) ForecastsService *webService;
@property (nonatomic, strong) NSPersistentContainer *persistentContainer;
@property (nonatomic, copy) NSString *cityId;

@end

@implementation ForecastsProvider

#pragma mark - Lifecycle

- (instancetype)initWithForecastsService:(ForecastsService *)webService andCityId:(NSString *)cityId {
    
    self = [super init];
    
    if (self) {

        self.persistentContainer = [CoreDataStack sharedInstanse].persistentContainer;
        self.webService = webService;
        self.cityId = cityId;
    }
    
    return self;
}

#pragma mark - Custom Accessors

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (!_fetchedResultsController) {
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName: [Forecast entityName]];
        
        NSPredicate *cityPredicate = [NSPredicate predicateWithFormat:@"cityId == %@", self.cityId];
        [request setPredicate:cityPredicate];
        
        NSSortDescriptor *dateSortDesc = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
        [request setSortDescriptors:@[dateSortDesc]];
        
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:self.persistentContainer.viewContext sectionNameKeyPath:nil cacheName:nil];
        _fetchedResultsController.delegate = self.fetchedResultsControllerDelegate;
        
        [_fetchedResultsController performFetch:nil];
    }
    
    return _fetchedResultsController;
}

#pragma mark - Public

// Fetch Forecasts from the remote server.
- (void)fetchForecastsCount:(NSInteger)count completion:(FPCompletionHandler)completion {
    
    [self.webService getDailyForecastByCityID:self.cityId
                                        count:count
                                   completion:^(NSError * _Nullable error, NSArray<NSDictionary *> * _Nullable results) {
        
                                       if (error) {

                                           if (completion) {
                                               completion(error);
                                           }
                                       } else {

                                           if (completion) {
                                               [self importForecastsFromJSONArray:results];
                                               completion(nil);
                                           }
                                       }
    }];
}

#pragma mark - Private

- (void)importForecastsFromJSONArray:(NSArray *)jsonArray {
    // Create a context on a private queue to:
    // - Fetch existing Forecasts to compare with incoming data.
    // - Create new Forecasts as required.
    NSManagedObjectContext *taskContext = [self.persistentContainer newBackgroundContext];
    taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy;
    taskContext.undoManager = nil; // We don't need undo so set it to nil.
    
    [taskContext performBlockAndWait:^{ // Wait doesn't block as taskContext is a background context
        // Fetch the existing records with the same cityID, then remove
        // them and create new records with the latest data to replace them.
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[Forecast entityName]];
        NSPredicate *cityPredicate = [NSPredicate predicateWithFormat:@"cityId == %@", self.cityId];
        [fetchRequest setPredicate:cityPredicate];
        
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
            Forecast *forecast = [Forecast insertNewObjectIntoContext:taskContext];
            // Set the attribute values the Forecast object
            forecast.cityId = self.cityId;
            [forecast loadFromDictionary:condDict];
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
    }];
}

@end
