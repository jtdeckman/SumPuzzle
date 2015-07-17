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
    
    NSMutableSet *player1Spaces;
    NSMutableSet *player2Spaces;
    
    int dimx;
    int dimy;
    int numSpaces;
    
    uint cFlagPos1;
    uint cFlagPos2;
    
    CGFloat spaceWidth;
    CGFloat spaceHeight;
    CGFloat pieceHeight, ph2;
    CGFloat pieceWidth, pw2;
    
    BOOL captureFlagMode;
}

@property (nonatomic, strong) Space* selectedSpace;

@property (nonatomic, strong) NSMutableArray *spaces;
@property (nonatomic, strong) NSMutableSet *player1Spaces;
@property (nonatomic, strong) NSMutableSet *player2Spaces;

@property (nonatomic) int dimx;
@property (nonatomic) int dimy;

@property (nonatomic) uint cFlagPos1;
@property (nonatomic) uint cFlagPos2;

- (void)initBoard: (CGRect)bvFrame : (int)dimx : (int)dimy : (CGFloat)offset : (BOOL)cFlag;
- (void)addPiece: (int)ii : (int)ji : (int)val : (Player)plyr : (JDColor)clr;

- (Space*)getSpaceForIndices: (int)ii : (int)ji;
- (Space*)getSpaceFromPoint: (CGPoint)loc;

- (int)nbrNearestOccupied: (Space*)space : (Player)plyr;
- (int)nbrOccupied: (Space*)space : (Player)plyr;
- (int)sumNbrs: (Space*)space;

- (void)clearSelectedSpace;
- (void)highlightNeighbors: (Space*)space : (Player)plyr;
- (void)addPieceToSelectedSpace: (JDColor)clr : (Player)plyr;

- (int)numSelected;
- (int)numberOfNearestOppPieces: (Space*)space;

- (void)highlightOppPieces: (Space*)space;
//- (void)overTakeSpace: (Space*)space : (Player)plyr : (JDColor)clr;
- (void)removePiece: (Space*)space;

- (void)convertPiece: (Space*)space : (int)val :(JDColor)clr : (Player)plyr;

- (void)clearBoard;

- (Player)checkForWinner;

- (int)pointsForPlayer: (Player)player;

- (void)deconstruct;

@end

