//
//  AW_ShapeFamily.h
//  AW_Steel Shapes Database Import Utility
//
//  Created by Alan Wang on 5/11/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AW_Database, AW_Shape;

@interface AW_ShapeFamily : NSManagedObject

@property (nonatomic, strong) NSNumber *defaultOrder;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *symbol;
@property (nonatomic, strong) AW_Database *database;
@property (nonatomic, strong) NSSet *shapes;
@end

