//
//  AW_TraingleView.m
//  Shape DB
//
//  Created by Alan Wang on 8/20/14.
//  Copyright (c) 2014 Alan Wang. All rights reserved.
//

#import "AW_TriangleView.h"

@implementation AW_TriangleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGPoint topMiddleVertex = CGPointMake(self.bounds.size.width/2, 0);
    CGPoint leftBottomVertex = CGPointMake(0, self.bounds.size.height);
    CGPoint rightBottomVertex = CGPointMake(self.bounds.size.width, self.bounds.size.height);
    
    UIBezierPath *trianglePath = [UIBezierPath bezierPath];
    
    [trianglePath moveToPoint:topMiddleVertex];
    [trianglePath addLineToPoint:leftBottomVertex];
    [trianglePath addLineToPoint:rightBottomVertex];
    [trianglePath closePath];
    
    [[UIColor whiteColor]setFill];
    [trianglePath fill];
}


@end
