//
//  BoardView.h
//  SumPuzzle
//
//  Created by Jason Deckman on 5/19/15.
//  Copyright (c) 2015 JDeckman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface BoardView : UIView {
    
    int numx;
    int numy;
    
    CGFloat barThick;
    CGFloat bThick2;
    
    CGFloat barSpaceX;
    CGFloat barSpaceY;
    
    JDColor backColor;
    JDColor barColor;
    
    CGPoint indices[4];
}

- (void)initBoardView: (int)nx : (int)ny : (CGFloat)bt : (uint)dim;
//- (void)drawBars;

@end
