//
//  BarView.h
//  SumPuzzle
//
//  Created by Jason Deckman on 5/19/15.
//  Copyright (c) 2015 JDeckman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Constants.h"

@interface BarView : UIView {
    
    JDColor backColor;
    
    CGPoint indices[4];
    
}

- (void)initView: (JDColor*)bColor;

@end