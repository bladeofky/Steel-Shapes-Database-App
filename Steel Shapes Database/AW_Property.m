//
//  AW_Property.m
//  AW_Steel Shapes Database Import Utility
//
//  Created by Alan Wang on 5/11/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import "AW_Property.h"
#import "AW_PropertyDescription.h"
#import "AW_Shape.h"

// C-style helper function to calculate the greatest common divisor of two numbers n and m where m > n
static int gcd(int n, int m);   //Function prototype

static int gcd(int n, int m)
{
    int gcd;
    int remainder;
    
    while (n != 0) {
        remainder = m % n;
        m = n;
        n = remainder;
    }
    
    gcd = m;
    
    return gcd;
}

@implementation AW_Property

@dynamic imp_value;
@dynamic key;
@dynamic shape;
@dynamic propertyDescription;

#pragma mark - Accessors

- (NSString *)met_units
{
    return self.propertyDescription.met_units;
}

- (NSDecimalNumber *)impToMetFactor
{
    return self.propertyDescription.impToMetFactor;
}

- (NSString *)symbol
{
    return self.propertyDescription.symbol;
}

- (NSString *)longDescription
{
    return self.propertyDescription.longDescription;
}

- (NSString *)group
{
    return self.propertyDescription.group;
}

-(NSNumber *)defaultOrder
{
    return self.propertyDescription.defaultOrder;
}

- (NSNumber *)imp_displayType
{
    return self.propertyDescription.imp_displayType;
}

- (NSNumber *)met_displayType
{
    return self.propertyDescription.met_displayType;
}

-(NSString *)imp_units
{
    return self.propertyDescription.imp_units;
}

- (NSDecimalNumber *)met_value
{
    return [self.imp_value decimalNumberByMultiplyingBy:self.impToMetFactor];
}

#pragma mark - Custom methods

- (NSAttributedString *)formattedSymbol
{
    NSAttributedString *output;
    NSString *font = @"TimesNewRomanPS-BoldItalicMT";
    float mainFontSize = 22.0f;
    float subscriptFontSize = 14.0f;
    
    NSString *originalString = self.symbol;
    
    if ([originalString rangeOfString:@"/"].location != NSNotFound) {
        // This is a fraction
        NSArray *tokens = [originalString componentsSeparatedByString:@"/"];
        
        // Format numerator and denominator
        NSAttributedString *numerator = [self makeSymbolStyleWithSymbol:tokens[0]
                                                               withFont:font
                                                         withSymbolSize:mainFontSize
                                                      withSubscriptSize:subscriptFontSize];
        NSAttributedString *denominator = [self makeSymbolStyleWithSymbol:tokens[1]
                                                                 withFont:font
                                                           withSymbolSize:mainFontSize
                                                        withSubscriptSize:subscriptFontSize];
        // Build output
        NSMutableAttributedString *outputBuilder = [[NSMutableAttributedString alloc]initWithAttributedString:numerator];
        [outputBuilder appendAttributedString:[[NSAttributedString alloc]initWithString:@" / "]];
        [outputBuilder appendAttributedString:denominator];
        
        output = [outputBuilder copy];
    }
    else {
        // This is not a fraction
        output = [self makeSymbolStyleWithSymbol:self.symbol
                                        withFont:font
                                  withSymbolSize:mainFontSize
                               withSubscriptSize:subscriptFontSize];
    }
    
    return output;
}

- (NSString *)formattedValueForUnitSystem: (BOOL)isMetric
{
    NSString *output;
    NSDecimalNumber *value;
    int displayType;
    
    // Format output
    NSNumberFormatter *valueFormatter = [[NSNumberFormatter alloc]init];
    [valueFormatter setUsesSignificantDigits:YES];
    [valueFormatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    valueFormatter.minimumSignificantDigits = 3;
    valueFormatter.maximumSignificantDigits = 3;
    
    // Get appropriate value
    if (isMetric) {
        value = self.met_value;
        displayType = [self.met_displayType intValue];
    }
    else {
        value = self.imp_value;
        displayType = [self.imp_displayType intValue];
    }
    
    
    if (displayType == 1) {
        // This is displayed as a whole or decimal value
        [valueFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        output = [valueFormatter stringFromNumber:value];
    }
    else if (displayType == 2) {
        // This is displayed as a mixed fraction
        double doubleValue = [value doubleValue]; // This will always be exact because the mixed fractions are always in multiples of 1/2, therefore they can be stored exactly in binary
        
        int wholeNumberPortion = (int)doubleValue; // This will truncate the decimal portion
        double decimalPortion = doubleValue - wholeNumberPortion;
        
        int denominator = 32; // We assume that no measurement will be reported to a precision greater than 1/32 of an inch
        int numerator = (int)(decimalPortion * denominator);
        
        // Reduce the fraction
        int greatestCommonDivisor = gcd(numerator, denominator);
        int reducedNumerator = numerator/greatestCommonDivisor;
        int reducedDenominator = denominator/greatestCommonDivisor;
        
        // Create the fraction string
        NSString *fraction;
        if (reducedNumerator == 0) {
            fraction = @"";
        }
        else {
            fraction = [NSString stringWithFormat:@"%i/%i", reducedNumerator, reducedDenominator];
            fraction = [self convertFractionToUnicode:fraction];
        }
        
        // Create full output string
        if (wholeNumberPortion == 0) {
            output = [NSString stringWithFormat:@"%@", fraction];
        }
        else {
            output = [NSString stringWithFormat:@"%i%@", wholeNumberPortion, fraction];
        }
    } // end else if displayType == 2
    else {
        [NSException raise:@"Bad format" format:@"Unrecognized value for displayType"];
    }
    
    return output;
}

-(NSString *) formattedUnitsForUnitSystem:(BOOL)isMetric
{
    NSString *originalString;
    NSString *output;
    
    if (isMetric) {
        originalString = self.met_units;
    }
    else {
        originalString = self.imp_units;
    }
    
    if (!originalString) {
        // There are no units for this property
        output = @"";
    }
    else {
        output = [self convertExponentToUnicode:originalString];
    }
    
    return output;
}   //end printUnits

#pragma mark - Helper methods

// Helper method that converts a string into Times New Roman Bold Italics with all but the first character as subscript
// It assumes the main script and subscript are separated with the character "_"
-(NSAttributedString *) makeSymbolStyleWithSymbol: (NSString *) symbol withFont: (NSString *) symbolFont withSymbolSize: (float) symbolSize withSubscriptSize: (float) subscriptSize
{
    // Separate into main script and sub script
    NSArray *tokens = [symbol componentsSeparatedByString:@"_"];
    
    // Main symbol
    NSString *mainScript = tokens[0];
    UIFont *mainFont = [UIFont fontWithName:symbolFont
                                       size:symbolSize];
    
    // Special action needed for the tan(ALPHA) property
    if ([self.key rangeOfString:@"ALPHA"].location != NSNotFound) {
        mainScript = [mainScript stringByReplacingOccurrencesOfString:@"ALPHA" withString:@"\u03B1"];
    }
    
    NSMutableAttributedString *output = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",mainScript]
                                                                               attributes:@{NSFontAttributeName: mainFont} ];
    
    if ([tokens count] == 2) {
        // Subscript
        NSString *subScript = tokens[1];
        
        NSNumber *baseLineOffset = [[NSNumber alloc] initWithFloat: -5.0f];
        UIFont *font = [UIFont fontWithName:symbolFont
                                       size:subscriptSize];
        
        NSDictionary *attributes = @{NSBaselineOffsetAttributeName:baseLineOffset,
                                     NSFontAttributeName: font};
        
        NSAttributedString *attributedSubscript = [[NSAttributedString alloc] initWithString:subScript
                                                                                  attributes: attributes];
        
        // Create output
        [output appendAttributedString:attributedSubscript];
    } //end if
    
    return output;
}

// Helper method that replaces numbers with their unicode equivalent to mimic a fraction
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

// Helper method that replaces powers with a unicode subscript
// Assumes exponents are denoted with "^" character
// originalText MUST HAVE A "^" CHARACTER or else this method will throw an exception
- (NSString *)convertExponentToUnicode: (NSString *)originalText
{
    NSString *output;
    
    if ([originalText rangeOfString:@"^"].location != NSNotFound) {
        // The originalText has an exponent
        
        NSArray *tokens = [originalText componentsSeparatedByString:@"^"];
        NSString *unit = tokens[0];
        
        // Convert exponent to unicode superscript
        NSString *exponent = tokens[1];
        int exponentValue = [exponent intValue];   // tokens will always have two elements because of the if/else check
        
        switch (exponentValue) {
            case 0:
                exponent = @"";
                break;
            case 2:
                exponent = @"\u00B2";
                break;
            case 3:
                exponent = @"\u00B3";
                break;
            case 4:
                exponent = @"\u2074";
                break;
            case 6:
                exponent = @"\u2076";
                break;
            default:
                exponent = [NSString stringWithFormat:@"%i", exponentValue];
                break;
        } //end switch
        
        // Build output
        output = [NSString stringWithFormat:@"%@%@", unit, exponent];
    }
    else {
        // The original string has no exponent
        output = originalText;
    }
    
    return output;
}

@end


