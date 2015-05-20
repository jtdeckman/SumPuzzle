//
//  BoardView.m
//  SumPuzzle
//
//  Created by Jason Deckman on 5/19/15.
//  Copyright (c) 2015 JDeckman. All rights reserved.
//

#import "BoardView.h"

@implementation BoardView

- (void)initBoardView: (int)nx : (int)ny : (CGFloat)bt {
    
    barThick = bt;
    bThick2 = barThick/2.0;
    
    numx = nx;
    numy = ny;
    
    //CGFloat width = self.frame.size.width;
    
    barSpaceX = (self.frame.size.width - barThick)/numx;
    barSpaceY = (self.frame.size.height - barThick)/numy;
    
    backColor.red = 0.95;
    backColor.green = 0.95;
    backColor.blue = 0.95;
    
    barColor.red = 0.5;
    barColor.green = 0.5;
    barColor.blue = 0.5;
    
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
    
    [super drawRect:rect];
    
    /*  CGRect rectangle = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
     
     NSLog(@"%f %f",self.frame.origin.y, self.frame.size.height);
     
     CGContextRef context = UIGraphicsGetCurrentContext();
     
     CGContextSetRGBFillColor(context, backColor.red, backColor.green, backColor.blue, 1.0);
     CGContextSetRGBStrokeColor(context, backColor.red, backColor.green, backColor.blue, 1.0);
     CGContextFillRect(context, rectangle); */
    
    UIColor *clr = [UIColor colorWithRed:backColor.red green:backColor.green blue:backColor.blue alpha:1.0];
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    [path moveToPoint:indices[0]];
    [path moveToPoint:indices[0]];
    
    [path addLineToPoint:indices[1]];
    [path addLineToPoint:indices[2]];
    [path addLineToPoint:indices[3]];
    
    
    [path closePath];
    
    [clr setFill];
    [path fill];
    
    [self drawBars];
}

- (void)drawBars {
    
    UIColor *clr = [UIColor colorWithRed:barColor.red green:barColor.green blue:barColor.blue alpha:1.0];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGPoint point = {0, 0};
    
    [clr setFill];
    
    [path moveToPoint:point];
    
    point.x = self.frame.size.width;
    [path addLineToPoint:point];
    
    point.y = barThick ;
    [path addLineToPoint:point];
    
    point.x = 0;
    [path addLineToPoint:point];
    
    [path closePath];
    
    [path fill];
    path = NULL;
    
    // Left bar half
    
    path = [UIBezierPath bezierPath];
    
    point.x = 0.0;
    point.y = 0.0;
    
    [path moveToPoint:point];
    
    point.x = barThick;
    [path addLineToPoint:point];
    
    point.y = self.frame.size.height;
    [path addLineToPoint:point];
    
    point.x = 0;
    [path addLineToPoint:point];
    
    [path closePath];
    
    [path fill];
    path = NULL;
    
    // Right bar half
    
    path = [UIBezierPath bezierPath];
    
    point.x = self.frame.size.width;
    point.y = 0.0;
    
    [path moveToPoint:point];
    
    point.x -= barThick;
    [path addLineToPoint:point];
    
    point.y = self.frame.size.height;
    [path addLineToPoint:point];
    
    point.x += barThick;
    [path addLineToPoint:point];
    
    [path closePath];
    
    [path fill];
    path = NULL;
    
    // Bottom bar half
    
    path = [UIBezierPath bezierPath];
    
    point.x = 0.0;
    point.y = self.frame.size.height;
    
    [path moveToPoint:point];
    
    point.x = self.frame.size.width;
    [path addLineToPoint:point];
    
    point.y -= barThick;
    [path addLineToPoint:point];
    
    point.x = 0;
    [path addLineToPoint:point];
    
    [path closePath];
    
    [path fill];
    path = NULL;
    
    
    // Horizontal bars
    
    point.x = bThick2;
    point.y = 0;
    
    for(int i=0; i<numx-1; i++) {
        
        point.x = bThick2 + (i+1)*barSpaceX;
        
        path = [UIBezierPath bezierPath];
        [path moveToPoint:point];
        
        point.x -= bThick2;
        [path addLineToPoint:point];
        
        point.y = self.frame.size.height;
        [path addLineToPoint:point];
        
        point.x += barThick;
        [path addLineToPoint:point];
        
        point.y = 0;
        [path addLineToPoint:point];
        
        [path closePath];
        [path fill];
        
        path = NULL;
    }
    
    // Horizontal bars
    
    point.x = bThick2;
    point.y = 0;
    
    for(int i=0; i<numy-1; i++) {
        
        point.y = bThick2 + (i+1)*barSpaceY;
        
        path = [UIBezierPath bezierPath];
        [path moveToPoint:point];
        
        point.x = self.frame.size.width;
        [path addLineToPoint:point];
        
        point.y -= barThick;
        [path addLineToPoint:point];
        
        point.x = barThick;
        [path addLineToPoint:point];
        
        //  point.y = 0;
        //   [path addLineToPoint:point];
        
        [path closePath];
        [path fill];
        
        path = NULL;
    }
}

@end
