//
//  AW_Property.h
//  AW_Steel Shapes Database Import Utility
//
//  Created by Alan Wang on 5/11/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AW_Shape, AW_PropertyDescription;

@interface AW_Property : NSManagedObject

@property (nonatomic, readonly, weak) NSNumber *defaultOrder;
@property (nonatomic, readonly, weak) NSNumber *imp_displayType;
@property (nonatomic, readonly, weak) NSNumber *met_displayType;
@property (nonatomic, readonly, weak) NSString *imp_units;
@property (nonatomic, readonly, strong) NSDecimalNumber *imp_value;
@property (nonatomic, readonly, strong) NSString *key;
@property (nonatomic, readonly, weak) NSString *met_units;
@property (nonatomic, readonly, weak) NSDecimalNumber *impToMetFactor;
@property (nonatomic, readonly, weak) NSString *symbol;
@property (nonatomic, readonly, weak) NSString *longDescription;
@property (nonatomic, readonly, weak) NSString *group;
@property (nonatomic, readonly, strong) AW_Shape *shape;
@property (nonatomic, readonly, strong) NSDecimalNumber *met_value;
@property (nonatomic, readonly, strong) AW_PropertyDescription *propertyDescription;

- (NSAttributedString *)formattedSymbol;
- (NSString *)formattedValueForUnitSystem: (BOOL)isMetric;
- (NSString *)formattedUnitsForUnitSystem:(BOOL)isMetric;

@end
