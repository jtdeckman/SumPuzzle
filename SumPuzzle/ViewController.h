//
//  ViewController.h
//  SumPuzzle
//
//  Created by Jason Deckman on 5/19/15.
//  Copyright (c) 2015 JDeckman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BoardView.h"
#import "Board.h"
#import "BarView.h"
#import "MenuView.h"

@interface ViewController : UIViewController {
    
    BarView *topBar;
    BarView *bottomBar;
    
    MenuView *menu;
    
    BoardView *boardView;
    Board *board;
    
    Space *selectedPiece;
    
    JDColor topColor;
    JDColor botColor;
    JDColor p1Color;
    JDColor p2Color;
    JDColor tileColor;
    
    int dimx;
    int dimy;
    
    int numSpaces;
    
    int nextValueP1;
    int nextValueP2;
    
    int startValue;
    int tileValue;
    int tileInc;
    
    UILabel *nextTile;
    UILabel *playerLabel;
    UILabel *floatPiece;
    
    UIImageView *menuBar;
    
    NSTimer *timer;
    
    GameState gameState;
    PlaceMode placeMode;
    Player currentPlayer;
    
    CGRect nextTileLoc;
    
    BOOL computerPlayer;
}

- (void)runLoop;

- (void)setUpViewController;
- (void)setUpColors;
- (void)setUpBoard: (CGFloat)offset;
- (void)addPiecesToView;
- (void)addPiece: (Space*)space;
- (void)switchPlayers;

- (JDColor)getColorForPlayer;

- (bool)didTouchAddPiece: (CGPoint)crd;

@end

