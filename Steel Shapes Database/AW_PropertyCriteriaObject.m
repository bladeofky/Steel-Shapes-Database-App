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

//-(NSPredicate *)generatePredicate
//{
//    // This predicate is meant to act on an AW_Property object
//    NSPredicate *propertyPredicate = [NSPredicate predicateWithFormat:@"%K MATCHES %@", @"key", self.propertyDescription.key];
//    
//    NSDecimalNumber *criteriaImpValue;
//    
//    if (self.isMetric) {
//        //self.value is a metric value and must be converted
//        criteriaImpValue = [self.value decimalNumberByDividingBy:self.propertyDescription.impToMetFactor];
//    }
//    else {
//        criteriaImpValue = self.value;
//    }
//    
//    NSDecimalNumber *criteriaImpValuePlusThreshold = [criteriaImpValue decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"1.05"]];
//    NSDecimalNumber *criteriaImpValueMinusThreshold = [criteriaImpValue decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"0.95"]];
//    
//    NSPredicate *valuePredicate;
//    
//    switch (self.relationship) {
//        case GREATER_THAN:
//            valuePredicate = [NSPredicate predicateWithFormat:@"%K > %@", @"imp_value", criteriaImpValue];
//            break;
//        case GREATER_THAN_OR_EQUAL_TO:
//            valuePredicate = [NSPredicate predicateWithFormat:@"%K >= %@", @"imp_value", criteriaImpValue];
//            break;
//        case EQUAL_TO:
//            valuePredicate = [NSPredicate predicateWithFormat:@"%K BETWEEN {%@, %@}", @"imp_value", criteriaImpValueMinusThreshold, criteriaImpValuePlusThreshold];
//            break;
//        case LESS_THAN_OR_EQUAL_TO:
//            valuePredicate = [NSPredicate predicateWithFormat:@"%K <= %@", @"imp_value", criteriaImpValue];
//            break;
//        case LESS_THAN:
//            valuePredicate = [NSPredicate predicateWithFormat:@"%K < %@", @"imp_value", criteriaImpValue];
//            break;
//            
//        default:
//            [NSException raise:@"Invalid relational operator" format:@"Relational operator in property criteria is invalid."];
//            break;
//    } // end switch
//    
//    return [NSCompoundPredicate andPredicateWithSubpredicates:@[propertyPredicate, valuePredicate]];
//}

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
