//
//  AW_FavoritesStore.m
//  Shape DB
//
//  Created by Alan Wang on 6/20/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import "AW_CoreDataStore.h"
#import "AW_FavoritesStore.h"
#import "AW_Database.h"
#import "AW_ShapeFamily.h"
#import "AW_Shape.h"

@interface AW_FavoritesStore()

@property (nonatomic, strong) NSMutableArray *favoritesList;

@end

@implementation AW_FavoritesStore

#pragma mark - Shared Store
+ (instancetype)sharedStore
{
    static AW_FavoritesStore *sharedStore;
    
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
}

#pragma mark - Initializers
- (instancetype)initPrivate     // Designated initializer
{
    self = [super init];
    
    if (self) {
        // Get previously saved favoritesList
        _favoritesList = [NSKeyedUnarchiver unarchiveObjectWithFile:[self getArchivePath]];
        
        if (!_favoritesList) {
            // No favoritesList currently exists. Intialize a new instance.
            _favoritesList = [[NSMutableArray alloc]init];
        }
    }
    
    return self;
}

- (instancetype)init
{
    [NSException raise:@"Singleton" format:@"Use +[AW_FavoritesStore sharedStore]"];
    return nil;
}

#pragma mark - Methods to manipulate store
- (NSArray *)allItems
{
    return [self.favoritesList copy];
}

- (void)addShapeToTopOfList:(AW_FavoritedShape *)shape
{
    [self.favoritesList insertObject:shape atIndex:0];
}

- (void)removeShapeFromList:(AW_FavoritedShape *)shape
{
    [self.favoritesList removeObjectIdenticalTo:shape];
}

- (void)moveItemAtIndex:(NSUInteger)sourceIndex
                toIndex:(NSUInteger)destinationIndex
{
    if (sourceIndex == destinationIndex) {
        //do nothing
    }
    else
    {
        AW_FavoritedShape *shape = self.favoritesList[sourceIndex];
        [self.favoritesList removeObjectIdenticalTo:shape];
        [self.favoritesList insertObject:shape atIndex:destinationIndex];
    }
}

- (AW_FavoritedShape *)favoritedShapeWithShape:(AW_Shape *)shape;
{
    NSString *databaseKey = shape.shapeFamily.database.key;
    NSString *impShapeKey = shape.imp_key;
    
    // Release unused memory
    [[AW_CoreDataStore sharedStore]returnObjectToFault:shape.shapeFamily.database];
    [[AW_CoreDataStore sharedStore]returnObjectToFault:shape.shapeFamily];
    
    NSPredicate *prediacte = [NSPredicate predicateWithFormat:@"databaseKey = %@ && impShapeKey = %@", databaseKey, impShapeKey];
    NSArray *filterResults = [self.favoritesList filteredArrayUsingPredicate:prediacte];
    
    AW_FavoritedShape *output;
    if ([filterResults count] == 0) {
        output = nil;
    }
    else {
        output = filterResults[0];
    }
    
    return output;
}

#pragma mark - Persistance
- (BOOL)saveStore
{
    return [NSKeyedArchiver archiveRootObject:self.favoritesList toFile:[self getArchivePath]];
}

- (NSString *)getArchivePath
{
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    
    NSString *path = [documentDirectory stringByAppendingString:@"/favoritesList.archive"];
    
    return path;
}

#pragma mark - NSCoding methods
-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.favoritesList forKey:@"favoritesList"];
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self) {
        _favoritesList = [aDecoder decodeObjectForKey:@"favoritesList"];
    }
    
    return self;
}


@end
