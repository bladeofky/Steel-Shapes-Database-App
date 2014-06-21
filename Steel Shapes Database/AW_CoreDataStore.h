//
//  AW_CoreDataStore.h
//  Steel Shapes Database
//
//  Created by Alan Wang on 5/15/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AW_Shape;

@interface AW_CoreDataStore : NSObject

+ (instancetype)sharedStore;

- (NSArray *)fetchAW_DatabaseObjects;
- (AW_Shape *)fetchShapeWithImperialKey:(NSString *)impShapeKey
                    fromDatabaseWithKey:(NSString *)databaseKey;

- (void)returnObjectToFault:(NSManagedObject *)object;
- (void)resetContext;

@end
