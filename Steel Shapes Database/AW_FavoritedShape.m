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

@dynamic defaultUnitSystem;
@dynamic barTintColor;
@dynamic databaseShortName;
@dynamic order;
@dynamic tintColor;
@dynamic shape;

// Designated Initializer
-(instancetype)initWithShape:(AW_Shape *)shape
                   withOrder:(double)order
              withUnitSystem:(BOOL)unitSystem
{
    NSManagedObjectContext *context = [AW_CoreDataStore sharedStore].context;
    self = [super initWithEntity:[NSEntityDescription entityForName:@"AW_FavoritedShape" inManagedObjectContext:context] insertIntoManagedObjectContext:context];
    
    if (self) {
        self.shape = shape;
        self.order = order;
        self.defaultUnitSystem = unitSystem;
        
        // Traverse through shape's heirarchy to get information needed, then return un-needed objects to fault
        AW_ShapeFamily *family = shape.shapeFamily;
        AW_Database *database = family.database;
        
        self.barTintColor = [database.backgroundColor copy];
        self.tintColor = [database.textColor copy];
        self.databaseShortName = [database.shortName copy];
        
        // Clean up
        [[AW_CoreDataStore sharedStore]returnObjectToFault:database];
        [[AW_CoreDataStore sharedStore]returnObjectToFault:family];
    }
    
    return self;
}

-(instancetype)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context
{
    return [self initWithShape:nil withOrder:0 withUnitSystem:0];
}

@end
