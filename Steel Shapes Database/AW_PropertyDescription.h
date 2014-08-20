//
//  AW_PropertyDescription.h
//  AW_Steel Shapes Database Import Utility
//
//  Created by Alan Wang on 7/20/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface AW_PropertyDescription : NSManagedObject

@property (nonatomic, strong) NSDecimalNumber * defaultOrder;
@property (nonatomic, strong) NSString * group;
@property (nonatomic, strong) NSNumber * imp_displayType;
@property (nonatomic, strong) NSString * imp_units;
@property (nonatomic, strong) NSDecimalNumber * impToMetFactor;
@property (nonatomic, strong) NSString * longDescription;
@property (nonatomic, strong) NSNumber * met_displayType;
@property (nonatomic, strong) NSString * met_units;
@property (nonatomic, strong) NSString * symbol;
@property (nonatomic, strong) NSString * key;
@property (nonatomic, strong) NSSet *shapeFamilies;

-(NSAttributedString *)formattedSymbol;
-(NSString *) formattedUnitsForUnitSystem:(BOOL)isMetric;

@end
