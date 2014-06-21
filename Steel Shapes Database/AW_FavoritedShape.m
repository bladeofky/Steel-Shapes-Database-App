//
//  AW_FavoritedShape.m
//  Shape DB
//
//  Created by Alan Wang on 6/19/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import "AW_FavoritedShape.h"
#import "AW_Database.h"
#import "AW_ShapeFamily.h"
#import "AW_Shape.h"
#import "AW_CoreDataStore.h"


@implementation AW_FavoritedShape

// Designated Initializer
-(instancetype)initWithShape:(AW_Shape *)shape
              withUnitSystem:(BOOL)unitSystem
{
    self = [super init];
    
    if (self) {
        _impShapeKey = shape.imp_key;
        _defaultUnitSystem = unitSystem;
        
        // Traverse through shape's heirarchy to get information needed, then return un-needed objects to fault
        AW_ShapeFamily *family = shape.shapeFamily;
        AW_Database *database = family.database;
        
        _barTintColor = [database.backgroundColor copy];
        _tintColor = [database.textColor copy];
        _databaseShortName = [database.shortName copy];
        _databaseLongName = [database.longName copy];
        _databaseKey = [database.key copy];
        
        // Clean up
        [[AW_CoreDataStore sharedStore]returnObjectToFault:database];
        [[AW_CoreDataStore sharedStore]returnObjectToFault:family];
    }
    
    return self;
}

- (instancetype)init
{
    return [self initWithShape:nil withUnitSystem:0];
}

- (AW_Shape *)shape
{
    return [[AW_CoreDataStore sharedStore]fetchShapeWithImperialKey:self.impShapeKey
                                                fromDatabaseWithKey:self.databaseKey];
}

#pragma mark - NSCoding Methods
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.impShapeKey forKey:@"impShapeKey"];
    [aCoder encodeObject:self.databaseKey forKey:@"databaseKey"];
    [aCoder encodeObject:self.databaseShortName forKey:@"databaseShortName"];
    [aCoder encodeObject:self.databaseLongName forKey:@"databaseLongName"];
    [aCoder encodeObject:self.barTintColor forKey:@"barTintColor"];
    [aCoder encodeObject:self.tintColor forKey:@"tintColor"];
    [aCoder encodeBool:self.defaultUnitSystem forKey:@"defaultUnitSystem"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        _impShapeKey = [aDecoder decodeObjectForKey:@"impShapeKey"];
        _databaseKey = [aDecoder decodeObjectForKey:@"databaseKey"];
        _databaseShortName = [aDecoder decodeObjectForKey:@"databaseShortName"];
        _databaseLongName = [aDecoder decodeObjectForKey:@"databaseLongName"];
        _barTintColor = [aDecoder decodeObjectForKey:@"barTintColor"];
        _tintColor = [aDecoder decodeObjectForKey:@"tintColor"];
        _defaultUnitSystem = [aDecoder decodeBoolForKey:@"defaultUnitSystem"];
    }
    
    return self;
}

@end
