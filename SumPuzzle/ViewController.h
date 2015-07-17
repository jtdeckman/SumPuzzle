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
#import "AINew.h"
#import "Move.h"
#import "SettingsViewController.h"

@interface ViewController : UIViewController {
    
    BarView *topBar;
    BarView *bottomBar;
    
    MenuView *menu;
    
    BoardView *boardView;
    Board *board;
    
    Space *selectedPiece;
    Space *moveToSpace;
    
    AINew *computer;
    
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
    
    int p1PointsOnBoard;
    int p2PointsOnBoard;
    
    int gameTimeCnt;
    int moveTimeCnt;
    int pauseTimeCnt;
    
    int moveInc;
    
    uint niter;
    
    UILabel *nextTile;
    UILabel *p2NextTile;
    UILabel *playerLabel;
    UILabel *floatPiece;
    
    UILabel *player1PntsLabel;
    UILabel *player2PntsLabel;
    
    UILabel *timeLabel;
    
    UILabel *winLabel;
    
    UIImage *p1Img;
    UIImage *p2Img;
    
    CGSize imgSize;
    
    UIImageView *menuBar;
    
    NSTimer *timer;
    NSTimer *moveTimer;
    NSTimer *pauseTimer;
    
    GameState gameState;
    PlaceMode placeMode;
    Player currentPlayer;
    Player winner;
    
    CGRect nextTileLoc;
    CGRect p2NextTileLoc;
    CGRect movePieceLoc;
    
    CGFloat lineThickness;
    CGFloat moveXinc;
    CGFloat moveYinc;
    
    BOOL computerPlayer;
    BOOL captureFlag;
    BOOL wentToSettingsView;
    
    Difficulty difficulty;
}

@property (nonatomic) Board *board;
@property (nonatomic, strong) AINew *computer;

- (void)runLoop;

- (void)setUpViewController;
- (void)setUpColors;
- (void)setUpBoard: (CGFloat)offset;
- (void)addPiecesToView;
- (void)addPiece: (Space*)space;
- (void)switchPlayers;

- (JDColor)getColorForPlayer;

- (bool)didTouchAddPiece: (CGPoint)crd;
- (bool)isMenuBarItem: (CGPoint)crd  : (CGRect)viewFrame;

- (void)movePieceLoop;

@end

