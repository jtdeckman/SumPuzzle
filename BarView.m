//
//  BarView.m
//  SumPuzzle
//
//  Created by Jason Deckman on 5/19/15.
//  Copyright (c) 2015 JDeckman. All rights reserved.
//

#import "BarView.h"

@implementation BarView

- (void)initView: (JDColor*)bColor {
    
    backColor.red = bColor->red;
    backColor.green = bColor->green;
    backColor.blue = bColor->blue;
    
    indices[0].x = 0;
    indices[0].y = 0;
    
    indices[1].x = self.frame.size.width;
    indices[1].y = 0;
    
    indices[2].x = indices[1].x;
    indices[2].y = self.frame.size.height;
    
    indices[3].x = indices[0].x;
    indices[3].y = indices[2].y;
    
}

- (void)drawRect:(CGRect)rect {
    
    UIColor *clr = [UIColor colorWithRed:backColor.red green:backColor.green blue:backColor.blue alpha:1.0];
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:indices[0]];
    [path addLineToPoint:indices[1]];
    [path addLineToPoint:indices[2]];
    [path addLineToPoint:indices[3]];
    
    [path closePath];
    
    [clr setFill];
    [clr setStroke];
    
    [path fill];
    
}

@end
