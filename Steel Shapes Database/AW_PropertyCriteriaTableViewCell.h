//
//  AW_PropertyCriteriaTableViewCell.h
//  Shape DB
//
//  Created by Alan Wang on 7/28/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AW_PropertyCriteriaTableViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *symbolLabel;
@property (strong, nonatomic) IBOutlet UILabel *relationshipLabel;
@property (strong, nonatomic) IBOutlet UILabel *valueLabel;
@property (strong, nonatomic) IBOutlet UILabel *unitsLabel;

@end
