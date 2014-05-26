//
//  AW_InfoBar.m
//  Steel Shapes Database
//
//  Created by Alan Wang on 5/25/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import "AW_InfoBar.h"

@implementation AW_InfoBar

#pragma mark - Initializers

// Designated initializer
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [[NSBundle mainBundle]loadNibNamed:@"AW_InfoBar" owner:self options:nil];
        [self addSubview:self.infoBarView];
    }
    
    return self;
}

- (instancetype)init
{
    return [self initWithCoder:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithCoder:nil];
}


@end
