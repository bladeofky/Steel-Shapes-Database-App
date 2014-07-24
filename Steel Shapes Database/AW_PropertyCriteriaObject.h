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

@property (nonatomic, strong) NSString *propertyDescriptionKey;
@property (nonatomic) enum relationalOperator relationship;
@property (nonatomic) double value;

- (NSPredicate *)generatePredicate;
- (NSAttributedString *)summary;

@end
