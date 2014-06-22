//
//  AW_FavoritesStore.h
//  Shape DB
//
//  Created by Alan Wang on 6/20/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AW_FavoritedShape, AW_Shape;

@interface AW_FavoritesStore : NSObject <NSCoding>

+ (instancetype)sharedStore;

- (NSArray *)allItems;
- (void)addShapeToTopOfList:(AW_FavoritedShape *)shape;
- (void)removeShapeFromList:(AW_FavoritedShape *)shape;
- (void)moveItemAtIndex:(NSUInteger)sourceIndex
                toIndex:(NSUInteger)destinationIndex;

- (AW_FavoritedShape *)favoritedShapeWithShape:(AW_Shape *)shape;

- (BOOL)saveStore;

@end
