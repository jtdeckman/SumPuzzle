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

#define SPACING_FACT 0.05

#define LINE_THICK_FACT 0.0025

#define DIMX 10
#define DIMY 10

#define FONT_FACT 0.3

#define MAX_NEARBY_NEIGHBORS 8

#define N_ITER 0

// Weighting Factors

#define AVG_DIFF_FACT 0
#define POINT_DIFF_FACT 10
#define NUM_DIFF_FACT 25

#define DIST_WEIGHT 10.0

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

#endif
