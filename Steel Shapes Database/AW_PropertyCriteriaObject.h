//
//  AW_PropertyCriteriaObject.h
//  Shape DB
//
//  Created by Alan Wang on 7/21/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AW_EnumHeader.h"

@class AW_PropertyDescription;

@interface AW_PropertyCriteriaObject : NSObject

@property (nonatomic, strong) AW_PropertyDescription *propertyDescription;
@property (nonatomic) enum relationalOperator relationship;
@property (nonatomic, strong) NSDecimalNumber *value;
@property (nonatomic) BOOL isMetric;

- (NSPredicate *)generatePredicate;
- (NSAttributedString *)symbol;
- (NSString *)relationshipSymbol;
- (NSString *)units;

@end
