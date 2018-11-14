//
//  ModelObject.m
//  Weather_One
//
//  Created by Nick on 10/18/18.
//  Copyright © 2018 nick. All rights reserved.
//

#import "ModelObject.h"

@implementation ModelObject

+ (id)entityName {
    return NSStringFromClass(self);
}

+ (instancetype)insertNewObjectIntoContext:(NSManagedObjectContext*)context {
    return [NSEntityDescription insertNewObjectForEntityForName:[self entityName] inManagedObjectContext:context];
}

@end
