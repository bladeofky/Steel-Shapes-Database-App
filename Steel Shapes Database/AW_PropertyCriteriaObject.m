//
//  AW_PropertyCriteriaObject.m
//  Shape DB
//
//  Created by Alan Wang on 7/21/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import "AW_PropertyCriteriaObject.h"
#import "AW_PropertyDescription.h"


@implementation AW_PropertyCriteriaObject

-(NSAttributedString *)symbol
{
    return [self.propertyDescription formattedSymbol];
}

-(NSString *)relationshipSymbol
{
    NSString *output;
    
    switch (self.relationship) {
        case GREATER_THAN:
            output = @">";
            break;
        case GREATER_THAN_OR_EQUAL_TO:
            output = @"\u2265";
            break;
        case EQUAL_TO:
            output = @"=";
            break;
        case LESS_THAN_OR_EQUAL_TO:
            output = @"\u2264";
            break;
        case LESS_THAN:
            output = @"<";
            break;
            
        default:
            output = @"UNKN";
            break;
    } // end switch
   
    return output;
}


-(NSString *)units
{
    return [self.propertyDescription formattedUnitsForUnitSystem:self.isMetric];
}
@end
