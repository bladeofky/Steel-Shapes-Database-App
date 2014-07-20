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
@end
