//
//  AW_AddPropertyCriteriaViewController.h
//  Shape DB
//
//  Created by Alan Wang on 8/2/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AW_PropertyCriteriaTableViewCell.h"

@class AW_SearchCriteriaTableViewController, AW_PropertyCriteriaObject;

@interface AW_AddPropertyCriteriaViewController : UIViewController

@property (weak, nonatomic) AW_SearchCriteriaTableViewController *searchCriteriaVC;

@property (nonatomic, strong) AW_PropertyCriteriaObject *criteria;


@end
