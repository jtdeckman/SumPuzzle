//
//  Constants.h
//  SumPuzzle
//
//  Created by Jason Deckman on 5/19/15.
//  Copyright (c) 2015 JDeckman. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef NumSum_Constants_h
#define NumSum_Constants_h

#define WIDTH_FACT 1.00
#define HEIGHT_FACT 1.00
#define TOPBAR_V_FACT 0.2

#define BUTTON_WIDTH_FACT 0.25
#define BUTTON_HEIGHT_FACT 0.1
#define BUTTON_SPACING_FACT 0.1

#define SPACING_FACT 0.025

#define LINE_THICK_FACT 0.015

#define DIMX 10
#define DIMY 10

#define FONT_FACT 0.3

#define MAX_NEARBY_NEIGHBORS 8

#define N_ITER 20
#define NUM_R_ITER 1

#define TILE_INIT 10
#define TILE_INC 20

#define WIN_WEIGHT_FACT 1e10

#define DIV_FACT 0.5

// Weighting Factors

#define AVG_DIFF_FACT 0
#define POINT_DIFF_FACT 25
#define NUM_FACT 25
#define FLOAT_FACT 1000

#define DIST_WEIGHT 1.0

#define WD_FACT 0.1
#define SD_FACT 1.0

#define WAVG_FACT 0.1
#define OVERTAKE_FACT 0.1
#define PPN_FACT 1.0
#define PPN_O_FACT 100000
#define DIFF_MODE 0

#define MOVE_NINC 3500
#define AI_PAUSE_TIME 1

typedef struct {
    
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    
} JDColor;

typedef enum : NSUInteger {
    
    gameRunning,
    gamePaused,
    gameOver,
    gameMenu,
    winState,
    winMenu,
    preAI,
    newGame
    
} GameState;

typedef enum : NSUInteger {
    
    freeState,
    pieceSelected,
    spaceSelected,
    overTake,
    placeTile,
    swipeMove,
    
} PlaceMode;

typedef enum : NSUInteger {
  
    placeMove,
    splitMove,
    addMove,
    overtakeMove
    
} MoveType;

typedef enum : NSUInteger {
    
    notAssigned,
    player1,
    player2
    
} Player;

typedef struct {
    
    int locx;
    int locy;
    int value;
    
    Player player;
    
} boardSpace; 

typedef enum : NSUInteger {
    
    easy,
    standard,
    hard
    
} Difficulty;

#endif
