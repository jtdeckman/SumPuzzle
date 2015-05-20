//
//  GameViewController.h
//  SumPuzzle
//
//  Created by Jason Deckman on 5/19/15.
//  Copyright (c) 2015 JDeckman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardView.h"
#import "Board.h"
#import "BarView.h"

@interface GameViewController : UIViewController {
    
    BarView *topBar;
    BarView *bottomBar;
    
    BoardView *boardView;
    Board *board;
    
    JDColor topColor;
    JDColor botColor;
    JDColor pieceColor;
    JDColor targetColor;
    
    int dimx;
    int dimy;
    
    int numSpaces;
    int numTargets;
    int numPieces;
    
    int level;
    int targetFact;
    int numberFact;
    
    int nextValue;
    
    BOOL addTile;
    
    UILabel *nextTile;
    
    NSTimer *timer;
}

- (void)runLoop;

- (void)setUpViewController;
- (void)setUpColors;
- (void)setUpBoard: (CGFloat)offset;
- (void)addPiecesToView;

- (void)addPiece: (Space*)space;
- (void)addTarget;

@end
