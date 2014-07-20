//
//  AW_FavoritesTableViewCell.m
//  Shape DB
//
//  Created by Alan Wang on 6/20/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import "AW_FavoritesTableViewCell.h"

@implementation AW_FavoritesTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    // Hard code desired cell style. This is to get around Apple's hardcoded dequeReusableCellWithIdentifier which always uses UITableViewCellStyleDefault
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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
