//
//  AW_EnumHeader.h
//  Shape DB
//
//  Created by Alan Wang on 7/21/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

/* The purpose of this header is solely to hold the definition of enums so that we can import them into other files */
enum relationalOperator {LESS_THAN = 0, LESS_THAN_OR_EQUAL_TO = 1, EQUAL_TO = 2, GREATER_THAN_OR_EQUAL_TO = 3, GREATER_THAN = 4};

@interface AW_EnumHeader : NSObject

@end
