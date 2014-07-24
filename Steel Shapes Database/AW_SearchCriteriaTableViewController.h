//
//  AW_SearchCriteriaTableViewController.h
//  Shape DB
//
//  Created by Alan Wang on 7/21/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AW_Database.h"

@interface AW_SearchCriteriaTableViewController : UITableViewController

@property (nonatomic, strong) AW_Database *databaseCriteria;    // Expected to be nil if no criteria selected
@property (nonatomic, strong) NSArray *shapeFamilyCriteria; // Expected to be nil if no criteria selected. Holds array of AW_ShapeFamily objects.
@property (nonatomic, strong) NSArray *propertyCriteria;    // Expected to be nil if no criteria selected. Holds array of AW_PropertyCriteriaObject objects.

@end
