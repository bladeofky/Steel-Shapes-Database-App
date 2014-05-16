//
//  AW_Database.h
//  AW_Steel Shapes Database Import Utility
//
//  Created by Alan Wang on 5/11/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AW_ShapeFamily;

@interface AW_Database : NSManagedObject

@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) NSString *designMethodology;
@property (nonatomic, strong) NSNumber *edition;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *organization;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) NSSet *shapeFamilies;
@end
