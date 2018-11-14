//
//  ModelObject.h
//  Weather_One
//
//  Created by Nick on 10/18/18.
//  Copyright © 2018 nick. All rights reserved.
//

#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface ModelObject : NSManagedObject

+ (id)entityName;
+ (instancetype)insertNewObjectIntoContext:(NSManagedObjectContext*)context;

@end

NS_ASSUME_NONNULL_END
