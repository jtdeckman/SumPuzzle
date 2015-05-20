//
//  Board.h
//  SumPuzzle
//
//  Created by Jason Deckman on 5/19/15.
//  Copyright (c) 2015 JDeckman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Space.h"

@interface Board : NSObject {
    
    NSMutableArray *spaces;
    
    int dimx;
    int dimy;
    int numSpaces;
    
    CGFloat spaceWidth;
    CGFloat spaceHeight;
    CGFloat pieceHeight;
    CGFloat pieceWidth;
}

- (void)initBoard: (CGRect)bvFrame : (int)dimx : (int)dimy : (CGFloat)offset;
- (void)addPiece: (int)ii : (int)ji : (int)val : (int)player : (JDColor)clr;

- (Space*)getSpaceForIndices: (int)ii : (int)ji;
- (Space*)getSpaceFromPoint: (CGPoint)loc;

- (int)nbrOccupied: (Space*)space : (int)plyr;
- (int)sumNbrs: (Space*)space : (int)plyr;


@end
