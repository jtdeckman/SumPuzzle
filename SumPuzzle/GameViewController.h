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
    
    Space *selectedPiece;
    
    JDColor topColor;
    JDColor botColor;
    JDColor p1Color;
    JDColor p2Color;
    JDColor tileColor;
    
    Space *spacePair[2];
    
    int dimx;
    int dimy;
    
    int numSpaces;
    int numPieces;
    
    int level;
    int numberFact;
    
    int nextValue;
    
    UILabel *nextTile;
    UILabel *playerLabel;
    UILabel *floatPiece;
    
    NSTimer *timer;
    
    GameState gameState;
    PlaceMode placeMode;
    Player currentPlayer;
}

- (void)runLoop;

- (void)setUpViewController;
- (void)setUpColors;
- (void)setUpBoard: (CGFloat)offset;
- (void)addPiecesToView;
- (void)addPiece: (Space*)space;
- (void)switchPlayers;

- (JDColor)getColorForPlayer;

@end

