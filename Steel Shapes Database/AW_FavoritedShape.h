//
//  AW_FavoritedShape.h
//  Shape DB
//
//  Created by Alan Wang on 6/19/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AW_Shape;

@interface AW_FavoritedShape : NSManagedObject

@property (nonatomic) BOOL defaultUnitSystem;
@property (nonatomic, strong) UIColor *barTintColor;
@property (nonatomic, strong) NSString *databaseShortName;
@property (nonatomic) double order;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) AW_Shape *shape;

-(instancetype)initWithShape:(AW_Shape *)shape
                   withOrder:(double)order
              withUnitSystem:(BOOL)unitSystem;

@end
