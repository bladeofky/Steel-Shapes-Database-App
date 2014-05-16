//
//  AW_CoreDataStore.h
//  Steel Shapes Database
//
//  Created by Alan Wang on 5/15/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AW_CoreDataStore : NSObject

+ (instancetype)sharedStore;
- (NSArray *)fetchAW_DatabaseObjects;

@end
