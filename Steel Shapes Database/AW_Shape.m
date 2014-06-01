//
//  AW_Shape.m
//  AW_Steel Shapes Database Import Utility
//
//  Created by Alan Wang on 5/11/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import "AW_Shape.h"
#import "AW_Property.h"
#import "AW_ShapeFamily.h"


@implementation AW_Shape

@dynamic defaultOrder;
@dynamic imp_displayName;
@dynamic imp_key;
@dynamic met_displayName;
@dynamic met_key;
@dynamic imp_group;
@dynamic met_group;
@dynamic note;
@dynamic properties;
@dynamic shapeFamily;

// Formats display name with unicode characters for fractions and X's
- (NSString *)formattedDisplayNameForUnitSystem: (BOOL)isMetric
{
    NSString *displayName;
    NSString *output;
    
    if (isMetric) {
        displayName = self.met_displayName;
    }
    else {
        displayName = self.imp_displayName;
    }
    
    if ([self.shapeFamily.symbol isEqualToString:@"PIPE"]) {
        output = [self convertMixedFractionToUnicode:displayName];
    }
    else {
        output = [self stringFormattedWithUnicode:displayName];
    }
    
    return output;
}

// Formats group name with unicode characters for fractions and X's
- (NSString *)formattedGroupNameForUnitSystem: (BOOL)isMetric
{
    NSString *output; // Output value
    NSString *group;
    
    if (isMetric) {
        group = self.met_group;
    }
    else {
        group = self.imp_group;
    }
    
    if ([self.shapeFamily.symbol isEqualToString:@"PIPE"]) {
        output = group;
    }
    else {
        output = [self stringFormattedWithUnicode:group];
    }
    
    return output;
}

#pragma mark - Helper functions
- (NSString *) stringFormattedWithUnicode: (NSString *)originalString
{
    NSString *modifiedString;
    NSMutableArray *tokens = [[originalString componentsSeparatedByString:@"X"] mutableCopy];
    
    for (int index = 0; index < [tokens count]; index++) {
        NSString *token = tokens[index];
        tokens[index] = [self convertMixedFractionToUnicode:token];
        
        // Rebuild name string
        if (index == 0) {
            modifiedString = tokens[index];
        }
        else {
            // \u00D7 is the unicode X recommended to be used by AISC
            modifiedString = [modifiedString stringByAppendingString:[NSString stringWithFormat:@" \u00D7 %@",tokens[index]]];
        }
    }
    
    return modifiedString;
}


// Converts a mixed fraction of format 3-3/4 to unicode equivalent using subscripts and superscripts
// INPUT: originalText - This is the mixed fraction (i.e. 3-3/4)
- (NSString *)convertMixedFractionToUnicode: (NSString *)originalText
{
    NSString *output;
    NSString *wholeNumber;
    NSString *fraction;
    
    if ([originalText rangeOfString:@"/"].location != NSNotFound) {
        //This is a fraction of some kind
        wholeNumber = @"";
        
        if ([originalText rangeOfString:@"-"].location != NSNotFound) {
            //This is a mixed fraction
            NSArray *temp = [originalText componentsSeparatedByString:@"-"];
            
            wholeNumber = temp[0];
            fraction = temp[1];
            
        } //end if
        else {
            //This is a non-mixed fraction
            fraction = originalText;
        } //end else
        
        fraction = [self convertFractionToUnicode:fraction];
        
        output = [NSString stringWithFormat:@"%@%@", wholeNumber, fraction];
    }
    else {
        output = originalText;
    }
    
    return output;
}

//This method returns the unicode fraction using subscripts and superscripts given an original fraction string (i.e. 1/2)
- (NSString *)convertFractionToUnicode: (NSString *)originalText
{
    
    NSArray *tokens = [originalText componentsSeparatedByString:@"/"];
    
    NSString *numerator = tokens[0];
    NSString *denominator = tokens[1];
    
    numerator = [numerator stringByReplacingOccurrencesOfString:@"0" withString:@"\u2070"];
    numerator = [numerator stringByReplacingOccurrencesOfString:@"1" withString:@"\u00B9"];
    numerator = [numerator stringByReplacingOccurrencesOfString:@"2" withString:@"\u00B2"];
    numerator = [numerator stringByReplacingOccurrencesOfString:@"3" withString:@"\u00B3"];
    numerator = [numerator stringByReplacingOccurrencesOfString:@"4" withString:@"\u2074"];
    numerator = [numerator stringByReplacingOccurrencesOfString:@"5" withString:@"\u2075"];
    numerator = [numerator stringByReplacingOccurrencesOfString:@"6" withString:@"\u2076"];
    numerator = [numerator stringByReplacingOccurrencesOfString:@"7" withString:@"\u2077"];
    numerator = [numerator stringByReplacingOccurrencesOfString:@"8" withString:@"\u2078"];
    numerator = [numerator stringByReplacingOccurrencesOfString:@"9" withString:@"\u2079"];
    
    denominator = [denominator stringByReplacingOccurrencesOfString:@"0" withString:@"\u2080"];
    denominator = [denominator stringByReplacingOccurrencesOfString:@"1" withString:@"\u2081"];
    denominator = [denominator stringByReplacingOccurrencesOfString:@"2" withString:@"\u2082"];
    denominator = [denominator stringByReplacingOccurrencesOfString:@"3" withString:@"\u2083"];
    denominator = [denominator stringByReplacingOccurrencesOfString:@"4" withString:@"\u2084"];
    denominator = [denominator stringByReplacingOccurrencesOfString:@"5" withString:@"\u2085"];
    denominator = [denominator stringByReplacingOccurrencesOfString:@"6" withString:@"\u2086"];
    denominator = [denominator stringByReplacingOccurrencesOfString:@"7" withString:@"\u2087"];
    denominator = [denominator stringByReplacingOccurrencesOfString:@"8" withString:@"\u2088"];
    denominator = [denominator stringByReplacingOccurrencesOfString:@"9" withString:@"\u2089"];
    
    return [NSString stringWithFormat:@"%@/%@", numerator, denominator];
}


@end

