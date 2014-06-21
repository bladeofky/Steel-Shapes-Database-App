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

@interface AW_FavoritedShape: NSObject <NSCoding>

@property (nonatomic) BOOL defaultUnitSystem;
@property (nonatomic, strong) UIColor *barTintColor;
@property (nonatomic, strong) NSString *databaseKey;
@property (nonatomic, strong) NSString *databaseShortName;
@property (nonatomic, strong) NSString *databaseLongName;
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, strong) NSString *impShapeKey;    // Imperial key is used because it is more reliable (metric key is sometimes calculated)

-(instancetype)initWithShape:(AW_Shape *)shape
              withUnitSystem:(BOOL)unitSystem;

- (AW_Shape *)shape;

@end
