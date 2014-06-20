//
//  AW_Property.h
//  AW_Steel Shapes Database Import Utility
//
//  Created by Alan Wang on 5/11/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AW_Shape;

@interface AW_Property : NSManagedObject

@property (nonatomic, strong) NSNumber *defaultOrder;
@property (nonatomic, strong) NSNumber *imp_displayType;
@property (nonatomic, strong) NSNumber *met_displayType;
@property (nonatomic, strong) NSString *imp_units;
@property (nonatomic, strong) NSDecimalNumber *imp_value;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *met_units;
@property (nonatomic, strong) NSDecimalNumber *met_value;
@property (nonatomic, strong) NSString *symbol;
@property (nonatomic, strong) NSString *longDescription;
@property (nonatomic, strong) NSString *group;
@property (nonatomic, strong) AW_Shape *shape;

- (NSAttributedString *)formattedSymbol;
- (NSString *)formattedValueForUnitSystem: (BOOL)isMetric;
- (NSString *)formattedUnitsForUnitSystem:(BOOL)isMetric;

@end
