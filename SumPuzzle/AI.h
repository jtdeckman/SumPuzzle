//
//  AI.h
//  SumPuzzle
//
//  Created by Jason Deckman on 6/8/15.
//  Copyright (c) 2015 JDeckman. All rights reserved.
//

#import "Board.h"
#import "Move.h"

@interface AI : Board {
    
    int pieceInc;
}

- (void)setUpAI : (NSMutableArray*)spc : (NSMutableSet*)p1s : (NSMutableSet*)p2s : (int)dx : (int)dy : (int)pInc;
- (void)findSpaces : (Move*)compMove : (int)p1FltPieceVal : (int)compFloatPieceVal;

@end
