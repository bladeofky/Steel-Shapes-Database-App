//
//  AW_PropertyTableViewCell.h
//  Steel Shapes Database
//
//  Created by Alan Wang on 5/31/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_PropertyTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *symbolLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;

@end
