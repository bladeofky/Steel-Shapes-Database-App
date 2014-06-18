//
//  AW_ShapeFamily.m
//  AW_Steel Shapes Database Import Utility
//
//  Created by Alan Wang on 5/11/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import "AW_ShapeFamily.h"
#import "AW_Database.h"
#import "AW_Shape.h"


@implementation AW_ShapeFamily

@dynamic defaultOrder;
@dynamic displayName;
@dynamic key;
@dynamic group;
@dynamic symbol;
@dynamic database;
@dynamic shapes;

@synthesize image = _image;

- (UIImage *)image
{
    if (!_image) {
        // Get the appropriate image from the asset collection
        
        NSDictionary *imageNameDictionary = @{@"W" : @"W2.png",
                                              @"M" : @"M.png",
                                              @"S" : @"S.png",
                                              @"HP": @"HP.png",
                                              @"C" : @"C.png",
                                              @"MC": @"MC.png",
                                              @"WT": @"WT.png",
                                              @"MT": @"MT.png",
                                              @"ST": @"ST.png",
                                              @"L" : @"L.png",
                                              @"2L": @"2L.png",
                                              @"HSSRect": @"HSSRect.png",
                                              @"HSSSquare": @"HSSSquare.png",
                                              @"HSSRound": @"HSSRound.png",
                                              @"PIPE" : @"PIPE.png"
                                              };
        
        _image = [UIImage imageNamed:imageNameDictionary[self.key]];        
    }
    
    return _image;
}

@end

