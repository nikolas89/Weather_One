//
//  CoreDataStack.h
//  Weather_One
//
//  Created by Nick on 10/29/18.
//  Copyright © 2018 nick. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataStack : NSObject

@property (strong, nonatomic, readonly) NSPersistentContainer *persistentContainer;

+ (instancetype)sharedInstanse;

@end

NS_ASSUME_NONNULL_END
