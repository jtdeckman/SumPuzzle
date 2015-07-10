//
//  AINew.h
//  SumPuzzle
//
//  Created by Jason Deckman on 7/9/15.
//  Copyright (c) 2015 JDeckman. All rights reserved.
//

#import "Board.h"
#import "Move.h"

@interface AINew : Board {
    
    int pieceInc;
}

@property (nonatomic) BOOL captureFlagMode;

- (void)setUpAI : (NSMutableArray*)spc : (NSMutableSet*)p1s : (NSMutableSet*)p2s : (int)dx : (int)dy : (int)pInc : (BOOL)cfm;
- (void)findSpaces : (Move*)compMove : (int)p1FltPieceVal : (int)compFloatPieceVal;

@end

