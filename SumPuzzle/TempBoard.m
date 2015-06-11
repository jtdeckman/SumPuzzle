//
//  TempBoard.m
//  SumPuzzle
//
//  Created by Jason Deckman on 6/9/15.
//  Copyright (c) 2015 JDeckman. All rights reserved.
//

#import "TempBoard.h"
#import "Constants.h"

@implementation TempBoard

- (void)setUp : (int)dx : (int)dy {
    
    dimx = dx;
    dimy = dy;
    
}

- (boardSpace*)spaceForIndices: (uint)xind : (uint)yind {
    
    return &spaces[xind][yind];
}

@end
