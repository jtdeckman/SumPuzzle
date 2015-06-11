//
//  AI.h
//  SumPuzzle
//
//  Created by Jason Deckman on 6/8/15.
//  Copyright (c) 2015 JDeckman. All rights reserved.
//

#import "Board.h"

@interface AI : Board {
    
}

- (void)setUpAI : (NSMutableArray*)spc : (NSMutableSet*)p1s : (NSMutableSet*)p2s : (int)dx : (int)dy;
- (void)findSpaces : (Space*)moveFrom : (Space*)moveTo : (int)pieceVal;

@end
