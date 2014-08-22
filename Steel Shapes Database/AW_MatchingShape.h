//
//  AW_MatchingShape.h
//  Shape DB
//
//  Created by Alan Wang on 8/22/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AW_Shape, AW_Property;

@interface AW_MatchingShape : NSObject

@property (nonatomic, strong) AW_Property *property;
@property (nonatomic, strong) NSDecimalNumber *imp_value;
@property (nonatomic, strong) AW_Shape *shape;

@end
