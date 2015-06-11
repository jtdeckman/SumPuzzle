//
//  TempBoard.h
//  SumPuzzle
//
//  Created by Jason Deckman on 6/9/15.
//  Copyright (c) 2015 JDeckman. All rights reserved.
//

#import "Board.h"

@interface TempBoard : NSObject {
    
    int dimx;
    int dimy;
    
    boardSpace spaces[DIMX][DIMY];
}

- (void)setUp : (int)dx : (int)dy;
- (boardSpace*)spaceForIndices: (uint)xind : (uint)yind;

@end
