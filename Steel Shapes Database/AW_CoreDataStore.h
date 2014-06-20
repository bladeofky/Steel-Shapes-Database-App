//
//  AW_CoreDataStore.h
//  Steel Shapes Database
//
//  Created by Alan Wang on 5/15/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface AW_CoreDataStore : NSObject

@property (nonatomic, strong, readonly) NSManagedObjectContext *context;

+ (instancetype)sharedStore;

- (NSArray *)fetchAW_DatabaseObjects;

- (void)returnObjectToFault:(NSManagedObject *)object;
- (void)resetContext;

@end
