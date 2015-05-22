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

@interface ViewController ()

@end

@implementation ViewController

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
                    }
                }
                else {
                    [board clearSelectedSpace];
                    placeMode = freeState;
                }
            }
            
        }
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

- (void)setUpGamePlay {
    
    numSpaces = dimx*dimy;
    numPieces = 0;
    
    numberFact = 5;
    
    level = 1;
    
    gameState = gameRunning;
    placeMode = placeTile;
    currentPlayer = player1;
    
    int num = rand() % numberFact;
    
    [board addPiece:9 :0 :num : currentPlayer : [self getColorForPlayer]];
    
    nextValue = rand() % numberFact;
    
    nextTile.text = [NSString stringWithFormat:@"%d", nextValue];
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
    
    dimx = 10;
    dimy = 10;
}

- (void)switchPlayers {

    if(currentPlayer == player1)
        currentPlayer = player2;
    else
        currentPlayer = player1;
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
    [nextTile setFont:[UIFont fontWithName:@"Arial" size:FONT_FACT*viewFrame.size.width]];
    
    [self.view addSubview:nextTile];
    
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
