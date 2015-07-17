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

@property (nonatomic) uint nIter;
@property (nonatomic) uint numRnIter;

@property (nonatomic) uint flagPos1;
@property (nonatomic) uint flagPos2;

- (void)setUpAI : (Board*)board :(int)pInc :(BOOL)cfm :(uint)nit;
- (void)findSpaces : (Move*)compMove :(int)p1FltPieceVal :(int)compFloatPieceVal;
- (void)deconstructAI;

@end

