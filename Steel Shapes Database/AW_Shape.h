//
//  AW_Shape.h
//  AW_Steel Shapes Database Import Utility
//
//  Created by Alan Wang on 5/11/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AW_Property, AW_ShapeFamily;

@interface AW_Shape : NSManagedObject

@property (nonatomic, strong) NSNumber *defaultOrder;
@property (nonatomic, strong) NSString *imp_displayName;
@property (nonatomic, strong) NSString *imp_key;
@property (nonatomic, strong) NSString *met_displayName;
@property (nonatomic, strong) NSString *met_key;
@property (nonatomic, strong) NSString *imp_group;
@property (nonatomic, strong) NSString *met_group;
@property (nonatomic, strong) NSString *note;
@property (nonatomic, strong) NSSet *properties;
@property (nonatomic, strong) AW_ShapeFamily *shapeFamily;
@end

