//
//  GameViewController.m
//  SumPuzzle
//
//  Created by Jason Deckman on 5/19/15.
//  Copyright (c) 2015 JDeckman. All rights reserved.
//

#import "GameViewController.h"

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
    
    if(touch.view == bottomBar) {
        addTile = YES;
    }
    else {
        
        Space *space = [board getSpaceFromPoint:location];
        int nocc = [board nbrOccupied:space : currPlayer];
        
        if(space != NULL && ((nocc > 0 && addTile) || (nocc > 1 && !addTile))) {
            
            if(space.isOccupied) {
            
            }
            else {
                [self addPiece:space];
            }
        }
    }
}

- (void)addPiece: (Space*)space {
    
    int nbrSum = [board sumNbrs:space : currPlayer];
    
    if(addTile) {
        
        int num = (rand() % numberFact) + 1;
        int expf = rand() % 3;
        
        num *= pow(-1, expf);
        
        if(currPlayer == 1) {
            [board addPiece:space.iind :space.jind : nextValue+nbrSum :1 :p1Color];
        }
        else {
            [board addPiece:space.iind :space.jind : nextValue+nbrSum :2 :p2Color];
            addTile = NO;
            nextValue = num;
            nextTile.text = [NSString stringWithFormat:@"%d", nextValue];
        }
    }
    else {
        if(currPlayer == 1)
            [board addPiece:space.iind :space.jind : nbrSum :1 :p1Color];
        else
            [board addPiece:space.iind :space.jind : nbrSum :2 :p2Color];
    }
    
    if(currPlayer == 1) ++currPlayer;
    else --currPlayer;
    
    ++numPieces;
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
    p2Color.green = 0.1;
    p2Color.blue = 0.1;
}

- (void)loadData {
    
    dimx = 10;
    dimy = 10;
}

- (void)setUpLabels {
    
    CGRect viewFrame;
    
    Space *space = [board getSpaceForIndices:0 :0];
    
    viewFrame.origin.x = 0.15*self.view.frame.size.width;
    viewFrame.origin.y = 0.85*self.view.frame.size.height;
    viewFrame.size.width = space.spaceFrame.size.width;
    viewFrame.size.height = space.spaceFrame.size.height;
    
    nextTile = [[UILabel alloc] initWithFrame:viewFrame];
    nextTile.hidden = NO;
    nextTile.layer.cornerRadius = 3.0;
    nextTile.clipsToBounds = YES;
    
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
    
    //   viewFrame.origin.x = offset;
    //   viewFrame.origin.y = 2.0*offset;
    
    viewFrame.origin.x = 0.0;
    viewFrame.origin.y = 0.0;
    viewFrame.size.width = width;
    viewFrame.size.height = height;
    
    topBar = [[BarView alloc] initWithFrame:viewFrame];
    [topBar initView:&topColor];
    topBar.clearsContextBeforeDrawing = true;
    
    [self.view addSubview:topBar];
    
    // BoardView Set-Up
    
    // height = width*HEIGHT_FACT;
    
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
    
    //  viewFrame.origin.x = offset;
    //  viewFrame.origin.y = boardView.frame.origin.y + boardView.frame.size.height + offset;
    
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

- (void)setUpBoard:(CGFloat)offset {
    
    board = [[Board alloc] init];
    
    [board initBoard:boardView.frame :dimx :dimy :offset];
    
    [self addPiecesToView];
}

- (void)setUpGamePlay {
    
    numSpaces = dimx*dimy;
    numPieces = 0;
    numberFact = 5;
    
    currPlayer = 1;
    
    level = 1;
    
    int num = rand() % numberFact;
    
    [board addPiece:0 :5 :num :1 :p1Color];
    
    num = rand() % numberFact;
    
    [board addPiece:9 :4 :num :2 :p2Color];
    
    addTile = YES;
    
    nextValue = rand() % numberFact;
    
    nextTile.text = [NSString stringWithFormat:@"%d", nextValue];
}

@end
