//
//  AW_PropertyDescription.m
//  AW_Steel Shapes Database Import Utility
//
//  Created by Alan Wang on 7/20/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import "AW_PropertyDescription.h"


@implementation AW_PropertyDescription

@dynamic defaultOrder;
@dynamic group;
@dynamic imp_displayType;
@dynamic imp_units;
@dynamic impToMetFactor;
@dynamic longDescription;
@dynamic met_displayType;
@dynamic met_units;
@dynamic symbol;
@dynamic key;
@dynamic shapeFamilies;

-(NSString *)description
{
    return [NSString stringWithFormat:@"%@ description", self.key];
}

#pragma mark - Formatting methods

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
