//
//  AW_CoreDataStore.m
//  Steel Shapes Database
//
//  Created by Alan Wang on 5/15/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import "AW_CoreDataStore.h"

@interface AW_CoreDataStore ()

@property (nonatomic, strong, readonly) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;

@end

@implementation AW_CoreDataStore

#pragma mark - Shared Store
+ (instancetype)sharedStore
{
    static AW_CoreDataStore *sharedStore;
    
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
}

#pragma mark - Initializers
- (instancetype)init
{
    [NSException raise:@"Singleton" format:@"Use +[AW_CoreDataStore sharedStore]"];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    
    if (self) {
        // Read in .xcdatamodeld
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        NSPersistentStoreCoordinator *persistantStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        
        // Select SQLite database to use and create persistant store coordinator
        NSURL *storeUrl = [[NSBundle mainBundle] URLForResource:@"AW_Steel_Shapes_Database_Import_Utility" withExtension:@"sqlite"];
        NSDictionary *options = @{ NSSQLitePragmasOption : @{@"journal_mode" : @"DELETE"} };
        
        NSError *error;
        
        
        if (![persistantStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                      configuration:nil
                                                                URL:storeUrl
                                                            options:options
                                                              error:&error]) {
            [NSException raise:@"Open Failure" format:[error localizedDescription]];
        }
        
        // Create managed object context
        _context = [[NSManagedObjectContext alloc] init];
        _context.persistentStoreCoordinator = persistantStoreCoordinator;
    }
    
    return self;
}

#pragma mark - Retrieving Data From Store
-(NSArray *)fetchAW_DatabaseObjects
{
    // Create fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AW_Database" inManagedObjectContext:self.context];
    [fetchRequest setEntity:entity];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects == nil) {
        [NSException raise:@"Bad Fetch" format:@"Error fetching AW_Database objects"];
    }
    
    return fetchedObjects;
}

- (AW_Shape *)fetchShapeWithImperialKey:(NSString *)impShapeKey fromDatabaseWithKey:(NSString *)databaseKey
{
    // Create fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AW_Shape" inManagedObjectContext:self.context];
    fetchRequest.entity = entity;
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"imp_key = %@ && shapeFamily.database.key = %@", impShapeKey, databaseKey];
    fetchRequest.predicate = predicate;
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    
    if (fetchedObjects == nil) {
        NSLog(@"Shape with imp_key = %@, and database key = %@ was not found.", impShapeKey, databaseKey);
        return nil;
    }
    
    return fetchedObjects[0];
}



#pragma mark - Releasing memory
- (void)returnObjectToFault:(NSManagedObject *)object
{
    [self.context refreshObject:object mergeChanges:NO];
}

- (void)resetContext
{
    [self.context reset];
}

@end
