//
//  AW_DetailStyleTableViewCell.m
//  Shape DB
//
//  Created by Alan Wang on 8/14/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import "AW_DetailStyleTableViewCell.h"

@implementation AW_DetailStyleTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
