//
//  GameViewController.m
//  SumPuzzle
//
//  Created by Jason Deckman on 5/19/15.
//  Copyright (c) 2015 JDeckman. All rights reserved.
//

#import "ViewController.h"
#import "BoardView.h"
#import "Constants.h"

@interface GameViewController ()

@end

@implementation GameViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setUpViewController];
    [self setUpGamePlay];
    
    timer = [NSTimer timerWithTimeInterval:1/4 target:self selector:@selector(runLoop) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

- (void)runLoop {
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touch.view];
    
    if(touch.view == topBar) {
        placeMode = freeState;
        [board clearSelectedSpace];
    }
    else if(touch.view == bottomBar) {
        placeMode = placeTile;
        [board clearSelectedSpace];
    }
    else if(touch.view == boardView) {
        
        Space *space = [board getSpaceFromPoint:location];
        
        if(space != NULL) {
            
            int nocc = [board nbrNearestOccupied:space : currentPlayer];
            
            if(placeMode == placeTile) {
                
                if(!space.isOccupied && nocc > 0)
                    [self addPiece:space];
            }
            else if(placeMode == freeState) {
                
                if(!space.isOccupied && nocc > 0) {
                    if([board nbrOccupied:space : currentPlayer] > 1)
                        [board highlightNeighbors:space : currentPlayer];
                    
                    placeMode = spaceSelected;
                }
                else if(space.isOccupied && space.player == currentPlayer) {
                  //  if([board numberOfNearestOppPieces:space] > 0) {
                  //      [board highlightOppPieces: space];
                  //      placeMode = overTake;
                  //  }
                    placeMode = swipeMove;
                    selectedPiece = space;
                    [self setUpFloatPiece: space];
                }
            }
            else if(placeMode == spaceSelected) {
                
                if(space.isHighlighted) {
                    space.isSelected = YES;
                    [space unHighlightPiece];
                    
                    if([board numSelected] > 1) {
                        [board addPieceToSelectedSpace:[self getColorForPlayer] : currentPlayer];
                        ++numPieces;
                        [board clearSelectedSpace];
                        placeMode = freeState;
                        [self switchPlayers];
                    }
                }
                else {
                    [board clearSelectedSpace];
                    placeMode = freeState;
                }
            }
            else if(placeMode == overTake) {
                if(space.isHighlighted) {
                    [board overTakeSpace:space :currentPlayer :[self getColorForPlayer]];
                    [board removePiece: board.selectedSpace];
                    --numPieces;
                    [self switchPlayers];
                    placeMode = freeState;
                }
                else {
                    [board clearSelectedSpace];
                    placeMode = freeState;
                }
            }
            
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touch.view];

    if(placeMode == swipeMove) {
     
        CGRect frm;
        frm.origin.x = location.x;// + boardView.frame.origin.x;
        frm.origin.y = location.y + boardView.frame.origin.y;
        
        frm.size = floatPiece.frame.size;
        [floatPiece setFrame:frm];
        
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touch.view];
    
    if(placeMode == swipeMove) {
        
        CGRect frm;
        frm.origin = location;
        frm.size = floatPiece.frame.size;
        
        [floatPiece setFrame:frm];
        floatPiece.hidden = YES;
        
        Space *space = [board getSpaceFromPoint:location];
        
        if(space != nil) {
            
            if(!space.isOccupied && selectedPiece.value > 2) {
                int newVal = (int)((float)selectedPiece.value/2.0);
                selectedPiece.value = newVal;
                selectedPiece.piece.text = [NSString stringWithFormat:@"%d", newVal];
                [board addPiece:space.iind :space.jind : newVal : currentPlayer : [self getColorForPlayer]];
                
                ++numPieces;
                [self switchPlayers];
                
            }
        }
        placeMode = freeState;
    }


}

- (void)addPiece: (Space*)space {
    
    //  int nbrSum = [board sumNbrs:space];
    
    int num = (rand() % numberFact) + 1;
    int expf = rand() % 3;
    
    num *= pow(-1, expf);
    
    [board addPiece:space.iind :space.jind : nextValue : currentPlayer : [self getColorForPlayer]];
    nextValue = num;
    nextTile.text = [NSString stringWithFormat:@"%d", nextValue];
    
    ++numPieces;
    
    placeMode = freeState;
    
    [self switchPlayers];
}

- (void)addPiecesToView {
    
    Space *space;
    
    for(int i=0; i<dimx; i++) {
        for(int j=0; j<dimy; j++) {
            space = [board getSpaceForIndices:i :j];
            [boardView addSubview:space.piece];
        }
    }
    
}

- (void)setUpFloatPiece: (Space*)space {

    CGRect frm;
    
    frm.origin.x = space.piece.frame.origin.x + boardView.frame.origin.x;
    frm.origin.y = space.piece.frame.origin.y + boardView.frame.origin.y;
    frm.size = space.piece.frame.size;
    
    floatPiece.hidden = NO;
    JDColor currClr = [self getColorForPlayer];
    floatPiece.text = [NSString stringWithFormat:@"%d", space.value];
    floatPiece.backgroundColor = [UIColor colorWithRed:currClr.red green:currClr.green blue:currClr.blue alpha:1.0];
    floatPiece.layer.borderColor = [[UIColor colorWithRed:currClr.red green:currClr.green blue:currClr.blue alpha:1.0] CGColor];

    [floatPiece setFrame:frm];
    
}

- (void)setUpGamePlay {
    
    numSpaces = dimx*dimy;
    numPieces = 0;
    
    numberFact = 5;
    
    level = 1;
    
    gameState = gameRunning;
    placeMode = placeTile;
    currentPlayer = player1;
    
    int num = 50;
    
    [board addPiece:0 :0 :num : player1 : p1Color];
    [board addPiece:0 :3 :num : player1 : p1Color];
    [board addPiece:0 :dimy-1 :num : player1 : p1Color];
    
    [board addPiece:dimx-1 :0 :num : player2 : p2Color];
    [board addPiece:dimx-1 :3 :num : player2 : p2Color];
    [board addPiece:dimx-1 :dimy-1 :num : player2 : p2Color];
    
    numPieces = 6;
    
    nextValue = rand() % numberFact;
    
    nextTile.text = [NSString stringWithFormat:@"%d", nextValue];
    playerLabel.text = [NSString stringWithFormat:@"Player 1"];
}

- (void)setUpBoard:(CGFloat)offset {
    
    board = [[Board alloc] init];
    [board initBoard:boardView.frame :dimx :dimy :offset];
    
    [self addPiecesToView];
}

- (void)setUpColors {
    
    topColor.red = 0.7;
    topColor.green = 0.6;
    topColor.blue = 0.5;
    
    botColor.red = 0.25;
    botColor.green = 0.25;
    botColor.blue = 0.95;
    
    p1Color.red = 0.25;
    p1Color.green = 0.55;
    p1Color.blue = 0.8;
    
    p2Color.red = 0.8;
    p2Color.green = 0.2;
    p2Color.blue = 0.2;
    
    tileColor.red = 0.7;
    tileColor.green = 0.5;
    tileColor.blue = 0.2;

}

- (JDColor)getColorForPlayer {

    if(currentPlayer == player1)
        return p1Color;
    
    return p2Color;
}

- (void)loadData {
    
    dimx = 7;
    dimy = 7;
}

- (void)switchPlayers {

    if(currentPlayer == player1) {
        currentPlayer = player2;
        playerLabel.text = [NSString stringWithFormat:@"Player 2"];
    }
    else {
        currentPlayer = player1;
        playerLabel.text = [NSString stringWithFormat:@"Player 1"];
    }
}

- (void)setUpLabels {
    
    CGRect viewFrame;
    
    Space *space = [board getSpaceForIndices:0 :0];
    
    viewFrame.origin.x = 0.5*self.view.frame.size.width - space.spaceFrame.size.width/2.0;
    viewFrame.origin.y = 0.85*self.view.frame.size.height;
    viewFrame.size.width = space.spaceFrame.size.width;
    viewFrame.size.height = space.spaceFrame.size.height;
    
    nextTile = [[UILabel alloc] initWithFrame:viewFrame];
    nextTile.hidden = NO;
    nextTile.layer.cornerRadius = 3.0;
    nextTile.clipsToBounds = YES;
    nextTile.backgroundColor = [UIColor colorWithRed:tileColor.red green:tileColor.green blue:tileColor.blue alpha:1.0];
    nextTile.layer.borderColor = [[UIColor whiteColor] CGColor];
    nextTile.layer.borderWidth = 2.0f;
    nextTile.textColor = [UIColor whiteColor];
    
    [nextTile setTextAlignment:NSTextAlignmentCenter];
    [nextTile setFont:[UIFont fontWithName:@"Arial" size:1.15*FONT_FACT*viewFrame.size.width]];
    
    [self.view addSubview:nextTile];
    
  
 // Movable (floating) piece
    
    floatPiece = [[UILabel alloc] initWithFrame:viewFrame];
    floatPiece.hidden = YES;
    floatPiece.layer.cornerRadius = 3.0;
    floatPiece.clipsToBounds = YES;
    floatPiece.backgroundColor = [UIColor colorWithRed:tileColor.red green:tileColor.green blue:tileColor.blue alpha:1.0];
    floatPiece.layer.borderWidth = 2.0f;
    floatPiece.textColor = [UIColor whiteColor];
    
    [floatPiece setTextAlignment:NSTextAlignmentCenter];
    [floatPiece setFont:[UIFont fontWithName:@"Arial" size:1.15*FONT_FACT*viewFrame.size.width]];
    
    [self.view addSubview:floatPiece];

    
 // Player label:
    
    viewFrame.size.width = 0.4*self.view.frame.size.width;
    viewFrame.size.height = 0.05*self.view.frame.size.height;
    viewFrame.origin.x = (self.view.frame.size.width - viewFrame.size.width)/2.0;
    viewFrame.origin.y = 0.075*self.view.frame.size.height;
    
    playerLabel = [[UILabel alloc] initWithFrame:viewFrame];
    
    playerLabel.hidden = NO;
    playerLabel.layer.cornerRadius = 3.0;
    playerLabel.clipsToBounds = YES;
    playerLabel.backgroundColor = [UIColor clearColor];
    playerLabel.layer.borderColor = [[UIColor whiteColor] CGColor];
    playerLabel.layer.borderWidth = 2.0f;
    playerLabel.textColor = [UIColor whiteColor];
    
    [playerLabel setTextAlignment:NSTextAlignmentCenter];
    [playerLabel setFont:[UIFont fontWithName:@"Arial" size:0.3*FONT_FACT*viewFrame.size.width]];

      [self.view addSubview:playerLabel];
}

- (void)setUpViewController {
    
    self.view.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    
    [self loadData];
    [self setUpColors];
    
    CGFloat width = self.view.frame.size.width*WIDTH_FACT;
    CGFloat height = self.view.frame.size.height*TOPBAR_V_FACT;
    CGFloat offset = self.view.frame.size.width*SPACING_FACT;
    
    CGFloat lineThickness = width*LINE_THICK_FACT;
    
    CGRect viewFrame;
    
    
    // Top Bar Set-Up
    
    viewFrame.origin.x = 0.0;
    viewFrame.origin.y = 0.0;
    viewFrame.size.width = width;
    viewFrame.size.height = height;
    
    topBar = [[BarView alloc] initWithFrame:viewFrame];
    [topBar initView:&topColor];
    topBar.clearsContextBeforeDrawing = true;
    
    [self.view addSubview:topBar];
    
    // BoardView Set-Up
    
    viewFrame.origin.x = offset;
    viewFrame.origin.y = topBar.frame.origin.y + topBar.frame.size.height + 3.0*offset;
    
    viewFrame.size.width = width - 2.0*offset;
    viewFrame.size.height = viewFrame.size.width*HEIGHT_FACT;
    
    boardView = [[BoardView alloc] initWithFrame:viewFrame];
    [boardView initBoardView:dimx :dimy :lineThickness];
    boardView.clearsContextBeforeDrawing = true;
    
    [self.view addSubview:boardView];
    
    [self.view bringSubviewToFront:boardView];
    
    // Bottom Bar Set-Up
    
    viewFrame.origin.x = 0;
    viewFrame.origin.y = boardView.frame.origin.y + boardView.frame.size.height + offset;
    
    viewFrame.size.width = width;
    viewFrame.size.height = self.view.frame.size.height - (topBar.frame.size.height + boardView.frame.size.height + 2.0*offset);
    
    bottomBar = [[BarView alloc] initWithFrame:viewFrame];
    [bottomBar initView:&botColor];
    bottomBar.clearsContextBeforeDrawing = true;
    
    [self.view addSubview:bottomBar];
    
    // Board set-up
    
    [self setUpBoard:lineThickness];
    [self setUpLabels];
}

@end
