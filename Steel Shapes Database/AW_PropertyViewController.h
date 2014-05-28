//
//  AW_PropertyViewController.h
//  Steel Shapes Database
//
//  Created by Alan Wang on 5/27/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AW_Shape, AW_InfoBar;

@interface AW_PropertyViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) AW_Shape *shape;
@property (nonatomic, weak) IBOutlet AW_InfoBar *infoBar;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end
