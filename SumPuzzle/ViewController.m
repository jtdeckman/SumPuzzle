//
//  ViewController.m
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

@synthesize board, computer;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setUpViewController];
    [self setUpGamePlay];
    
    // timer = [NSTimer timerWithTimeInterval:1/4 target:self selector:@selector(runLoop) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

- (void)runLoop {
    
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:touch.view];
    
    if(gameState == gameRunning) {
        
        if(touch.view == topBar) {
            placeMode = freeState;
            [board clearSelectedSpace];
        }
        else if(touch.view == bottomBar && [self didTouchAddPiece:location]) {
            placeMode = placeTile;
            [board clearSelectedSpace];
        }
        else if(touch.view == bottomBar && [self isMenuBarLocation:location]) {
            gameState = gameMenu;
            menu.hidden = NO;
            [self.view bringSubviewToFront:menu];
        }
        else if(touch.view == boardView) {
            
            Space *space = [board getSpaceFromPoint:location];
            
            if(space != NULL) {
                
                if(placeMode == placeTile) {
                    if(!space.isOccupied && [board nbrNearestOccupied:space : currentPlayer] > 0)
                        [self addPiece:space];
                }
                else if(placeMode == freeState) {
                    
                    if(space.isOccupied && space.player == currentPlayer) {
                        placeMode = swipeMove;
                        selectedPiece = space;
                        [self setUpFloatPiece: space];
                    }
                }
            }
        }
    }
    
    else if(gameState == gameMenu) {
        
        if(touch.view != menu) {
            gameState = gameRunning;
            menu.hidden = YES;
        }
        else {
            location = [touch locationInView:menu];
            if([self isMenuBarItem:location :menu.settingsLabel.frame]) {
                
            }
            else if([self isMenuBarItem:location :menu.nwGameLabel.frame]) {
                menu.hidden = YES;
              
                [board deconstruct];
                [computer deconstruct];
                
                board = nil;
                computer = nil;
                
                [self setUpViewController];
                [self setUpGamePlay];
            }
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:boardView];
    
    if(gameState ==  gameRunning) {
        
        CGRect frm;
        
        if(placeMode == swipeMove) {
            
            frm.origin.x = location.x;// + boardView.frame.origin.x;
            frm.origin.y = location.y + boardView.frame.origin.y;
            
            frm.size = floatPiece.frame.size;
            [floatPiece setFrame:frm];
            
        }
        else if(placeMode == placeTile) {
            
            frm.origin.x = location.x;
            frm.origin.y = location.y + boardView.frame.origin.y;
            
            frm.size = nextTile.frame.size;
            [nextTile setFrame:frm];
        }
    }
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:boardView];
    
    if(gameState == gameRunning) {
        if(placeMode == placeTile) {
        
            Space *space = [board getSpaceFromPoint:location];
        
            if(!space.isOccupied && [board nbrNearestOccupied:space : currentPlayer] > 0)
                [self addPiece:space];
            else {
                [nextTile setFrame:nextTileLoc];
                placeMode = freeState;
            }
        
        }
        if(placeMode == swipeMove) {
        
            CGRect frm;
            frm.origin = location;
            frm.size = floatPiece.frame.size;
        
            [floatPiece setFrame:frm];
            floatPiece.hidden = YES;
        
            Space *space = [board getSpaceFromPoint:location];
        
            if(space != nil) {
            
                if(!space.isOccupied && selectedPiece.value > 2 && [selectedPiece isNearestNearestNbrOf:space]) {
                    int newVal = (int)((float)selectedPiece.value/2.0);
                    selectedPiece.value = newVal;
                    selectedPiece.piece.text = [NSString stringWithFormat:@"%d", newVal];
                    [board addPiece:space.iind :space.jind : newVal : currentPlayer : [self getColorForPlayer]];
                    [self updateCurrentPlayer:NO];
                    [self switchPlayers];
                
                }
                else if(space.isOccupied && [selectedPiece isNearestNearestNbrOf:space]) {
                    if(space.player == currentPlayer) {
                        space.value += selectedPiece.value;
                        [board removePiece:selectedPiece];
                        space.piece.text = [NSString stringWithFormat:@"%d", space.value];
                        [self updateCurrentPlayer:NO];
                        [self switchPlayers];
                    }
                    else if(space.player != currentPlayer && selectedPiece.value > space.value) {
#ifdef DIFF_MODE
                        int newVal = selectedPiece.value - space.value/2.0;
#else
                        int newVal = selectedPiece.value;
#endif
                        [board convertPiece:space :newVal :[self getColorForPlayer] :currentPlayer];
                        [board removePiece:selectedPiece];
                        [self updateCurrentPlayer:NO];
                        [self switchPlayers];
                    }
                }
            }
        
            placeMode = freeState;
        }
    }
}

- (void)addPiece: (Space*)space {
    
    int nextValue = [self getNextValueForPlayer];
    
    [board addPiece:space.iind :space.jind : nextValue : currentPlayer : [self getColorForPlayer]];
    
    [self updateCurrentPlayer:YES];
    
    [nextTile setFrame:nextTileLoc];
    
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

- (bool)didTouchAddPiece: (CGPoint)crd {
    
    if(crd.x >= nextTile.frame.origin.x && crd.x <= (nextTile.frame.origin.x + nextTile.frame.size.width)) {
    
        if((crd.y + bottomBar.frame.origin.y) >= nextTile.frame.origin.y && (crd.y + bottomBar.frame.origin.y) <= (nextTile.frame.origin.y + nextTile.frame.size.height)) return YES;
    }
    
    return NO;
}

- (void)setUpFloatPiece: (Space*)space {
    
    CGRect frm;
    
    frm.origin.x = space.piece.frame.origin.x + boardView.frame.origin.x;
    frm.origin.y = space.piece.frame.origin.y + boardView.frame.origin.y;
    frm.size = space.piece.frame.size;
    
    floatPiece.hidden = NO;
  
    floatPiece.text = [NSString stringWithFormat:@"%d", space.value];
    floatPiece.layer.borderColor = [[UIColor clearColor] CGColor];
    
    [self changeTileBackground:floatPiece];
    
    [floatPiece setFrame:frm];
}

- (void)setUpGamePlay {
    
    numSpaces = dimx*dimy;
    
    gameState = gameRunning;
    placeMode = freeState;
    currentPlayer = player1;
    
    [board addPiece:0 :0 :startValue : player1 : p1Color];
    [board addPiece:0 :dimy-1 :startValue : player1 : p1Color];
    
    [board addPiece:dimx-1 :0 :startValue : player2 : p2Color];
    [board addPiece:dimx-1 :dimy-1 :startValue : player2 : p2Color];
    
    nextValueP1 = tileValue;
    nextValueP2 = tileValue;
    
    [self changeNextTileForPlayer];
    
    playerLabel.text = [NSString stringWithFormat:@"Player 1"];
    
    p1PointsOnBoard = [board pointsForPlayer:player1];
    p2PointsOnBoard = [board pointsForPlayer:player2];
    
    player1PntsLabel.text = [NSString stringWithFormat:@"%d", p1PointsOnBoard];
    player2PntsLabel.text = [NSString stringWithFormat:@"%d", p2PointsOnBoard];
    
    computer = [[AINew alloc] init];
    
    [computer setUpAI:board.spaces :board.player1Spaces :board.player2Spaces :dimx :dimy : tileInc : YES];
}

- (void)setUpBoard:(CGFloat)offset {
    
    board = [[Board alloc] init];
    [board initBoard:boardView.frame :dimx :dimy :offset];
    
    [self addPiecesToView];
    
    Space *tmpSpace = [board getSpaceForIndices:0 :0];
    imgSize = tmpSpace.spaceFrame.size;

}

- (JDColor)getColorForPlayer {
    
    if(currentPlayer == player1)
        return p1Color;
    
    return p2Color;
}

- (void)loadData {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    dimx = (int)[defaults integerForKey:@"dimx"];
    dimy = (int)[defaults integerForKey:@"dimy"];
    
    computerPlayer = [defaults boolForKey:@"computerPlayer"];
    
    startValue = (int)[defaults integerForKey:@"startValue"];
    tileValue = (int)[defaults integerForKey:@"tileValue"];
    tileInc = (int)[defaults integerForKey:@"tileInc"];
    
    [defaults synchronize];
}

- (void)switchPlayers {
    
    if(currentPlayer == player1) {
        currentPlayer = player2;
        if(computerPlayer)
            playerLabel.text = @"Computer";
        else
            playerLabel.text = @"Player 2";
         playerLabel.backgroundColor = [UIColor colorWithRed:p2Color.red green:p2Color.green blue:p2Color.blue alpha:1.0];
    }
    else {
        currentPlayer = player1;
        playerLabel.text = @"Player 1";
        playerLabel.backgroundColor = [UIColor colorWithRed:p1Color.red green:p1Color.green blue:p1Color.blue alpha:1.0];
    }
    
    [self upDatePoints];
    [self changeNextTileForPlayer];
    
    selectedPiece = nil;
    
    placeMode = freeState;
    
    Player winner;
    
    winner = [board checkForWinner];
    
    if(winner != notAssigned) {
        NSLog(@"Winner is fart");
    }
    
    if(computerPlayer && currentPlayer == player2)
        [self AIMove];
}

- (void)AIMove {

    Move *move = [[Move alloc] init];
    Space *moveFrom, *moveTo;
    
    [computer findSpaces:move :nextValueP1 :nextValueP2];
    
    moveFrom = move.fromSpace;
    moveTo = move.toSpace;
    
    if(moveTo == nil) {
        
    }
    else {
    
        if(moveFrom == nil) {
            [self addPiece:moveTo];
        }
        
        else if(moveTo.player == notAssigned) {
            
            int value = (int)((float)moveFrom.value/2.0);
            
            moveFrom.value = value;
            moveFrom.piece.text = [NSString stringWithFormat:@"%d", value];
            
            [board addPiece:moveTo.iind :moveTo.jind : value : currentPlayer : [self getColorForPlayer]];
            
            [self updateCurrentPlayer:NO];
            [self switchPlayers];
        }
        else {
            
            if(moveTo.player == player1) {

#ifdef DIFF_MODE
                int newVal = moveFrom.value - moveTo.value/2.0;
#else
                int newVal = moveFrom.value;
#endif
                
                [board convertPiece:moveTo :newVal :[self getColorForPlayer] :player2];
                [board removePiece:moveFrom];
                
                moveTo.piece.text = [NSString stringWithFormat:@"%d", newVal];
                
                [self updateCurrentPlayer:NO];
                [self switchPlayers];
            }
            else {
                
                int newVal = (int)((float)moveFrom.value);
                
                [board removePiece:moveFrom];
                
                moveTo.value += newVal;
                moveTo.piece.text = [NSString stringWithFormat:@"%d", moveTo.value];
                
                [self updateCurrentPlayer:NO];
                [self switchPlayers];
            }
        }
    }
}

- (void)upDatePoints {

    p1PointsOnBoard = [board pointsForPlayer:player1];
    p2PointsOnBoard = [board pointsForPlayer:player2];
    
    player1PntsLabel.text = [NSString stringWithFormat:@"%d", p1PointsOnBoard];
    player2PntsLabel.text = [NSString stringWithFormat:@"%d", p2PointsOnBoard];
}

- (void)setUpLabels {
    
    CGRect viewFrame;
    
    Space *space = [board getSpaceForIndices:0 :0];
    
    viewFrame.origin.x = 0.5*self.view.frame.size.width - space.spaceFrame.size.width/2.0;
   // viewFrame.origin.y = 0.85*self.view.frame.size.height;
    viewFrame.size.width = space.spaceFrame.size.width;
    viewFrame.size.height = space.spaceFrame.size.height;
    viewFrame.origin.y = bottomBar.frame.origin.y + bottomBar.frame.size.height/2.0 -viewFrame.size.height/2.0;
    
    nextTileLoc = viewFrame;
    
    nextTile = [[UILabel alloc] initWithFrame:viewFrame];
    nextTile.hidden = NO;
    nextTile.layer.cornerRadius = 3.0;
    nextTile.clipsToBounds = YES;
 
    nextTile.backgroundColor = [UIColor colorWithPatternImage:p1Img];
   // nextTile.layer.borderColor = [[UIColor whiteColor] CGColor];
  //  nextTile.layer.borderWidth = 2.0f;
    nextTile.textColor = [UIColor whiteColor];
    
    [nextTile setTextAlignment:NSTextAlignmentCenter];
    [nextTile setFont:[UIFont fontWithName:@"Arial" size:1.15*FONT_FACT*viewFrame.size.width]];
 
    [self changeTileBackground:nextTile];
    
    [self.view addSubview:nextTile];
    
    
    // Movable (floating) piece
    
    floatPiece = [[UILabel alloc] initWithFrame:viewFrame];
    floatPiece.hidden = YES;
    floatPiece.layer.cornerRadius = 3.0;
    floatPiece.clipsToBounds = YES;
    floatPiece.backgroundColor = nextTile.backgroundColor;
  //  floatPiece.layer.borderWidth = 2.0f;
    floatPiece.textColor = [UIColor clearColor];
    
    [floatPiece setTextAlignment:NSTextAlignmentCenter];
    [floatPiece setFont:[UIFont fontWithName:@"Arial" size:1.15*FONT_FACT*viewFrame.size.width]];
    
    [self.view addSubview:floatPiece];
    
    
    // Menu bar
    
    viewFrame.origin.x = 0.1*bottomBar.frame.size.width;
    viewFrame.size.width = 0.65*viewFrame.size.width;
    viewFrame.size.height = 0.65*viewFrame.size.height;
    
    viewFrame.origin.y = bottomBar.frame.origin.y + bottomBar.frame.size.height/2.0 -viewFrame.size.height/2.0;
    
    menuBar = [[UIImageView alloc] initWithFrame:viewFrame];
    menuBar.image = [UIImage imageNamed:@"menuBars.png"];
    menuBar.hidden = NO;
    
    [self.view addSubview:menuBar];
    
    // Player label:
    
    viewFrame.size.width = 0.4*self.view.frame.size.width;
    viewFrame.size.height = 0.055*self.view.frame.size.height;
    viewFrame.origin.x = (self.view.frame.size.width - viewFrame.size.width)/2.0;
    viewFrame.origin.y = 0.085*self.view.frame.size.height;
    
    playerLabel = [[UILabel alloc] initWithFrame:viewFrame];
    
    playerLabel.hidden = NO;
    playerLabel.layer.cornerRadius = 3.0;
    playerLabel.clipsToBounds = YES;
    playerLabel.backgroundColor = [UIColor colorWithRed:p1Color.red green:p1Color.green blue:p1Color.blue alpha:1.0];
    playerLabel.layer.borderColor = [[UIColor whiteColor] CGColor];
    playerLabel.layer.borderWidth = 2.0f;
    playerLabel.textColor = [UIColor whiteColor];
    
    [playerLabel setTextAlignment:NSTextAlignmentCenter];
    [playerLabel setFont:[UIFont fontWithName:@"Arial" size:0.4*FONT_FACT*viewFrame.size.width]];
    
    [self.view addSubview:playerLabel];
    
    viewFrame.size.width /= 2.5;
    
    CGFloat crd = (topBar.frame.size.width - playerLabel.frame.size.width)/2.0;
    
    viewFrame.origin.x = crd/2.0 - viewFrame.size.width/2.0;
    
    JDColor clr;
    clr.red = 0.4;
    clr.green = 0.4;
    clr.blue = 0.4;
    
    player1PntsLabel = [[UILabel alloc] initWithFrame:viewFrame];
    
    player1PntsLabel.hidden = NO;
    player1PntsLabel.layer.cornerRadius = 3.0;
    player1PntsLabel.clipsToBounds = YES;
    player1PntsLabel.backgroundColor = [UIColor clearColor];
   // player1PntsLabel.layer.borderColor = [[UIColor colorWithRed:clr.red green:clr.green blue:clr.blue alpha:1.0] CGColor];
    player1PntsLabel.layer.borderColor = [[UIColor whiteColor] CGColor];
    player1PntsLabel.layer.borderWidth = 2.0f;
    player1PntsLabel.textColor = [UIColor colorWithRed:p1Color.red green:p1Color.green blue:p1Color.blue alpha:1.0];
    [player1PntsLabel setTextAlignment:NSTextAlignmentCenter];
    [player1PntsLabel setFont:[UIFont fontWithName:@"Arial" size:0.85*FONT_FACT*viewFrame.size.width]];
    
    [self.view addSubview:player1PntsLabel];

    crd = playerLabel.frame.origin.x - (player1PntsLabel.frame.origin.x + player1PntsLabel.frame.size.width);
    viewFrame.origin.x = playerLabel.frame.origin.x + playerLabel.frame.size.width + crd;
    
    player2PntsLabel = [[UILabel alloc] initWithFrame:viewFrame];
    
    player2PntsLabel.hidden = NO;
    player2PntsLabel.layer.cornerRadius = 3.0;
    player2PntsLabel.clipsToBounds = YES;
    player2PntsLabel.backgroundColor = [UIColor clearColor];
  //  player2PntsLabel.layer.borderColor = [[UIColor colorWithRed:clr.red green:clr.green blue:clr.blue alpha:1.0] CGColor];
      player2PntsLabel.layer.borderColor = [[UIColor whiteColor] CGColor];
    player2PntsLabel.layer.borderWidth = 2.0f;
    player2PntsLabel.textColor = [UIColor colorWithRed:p2Color.red green:p2Color.green blue:p2Color.blue alpha:1.0];
   
    [player2PntsLabel setTextAlignment:NSTextAlignmentCenter];
    [player2PntsLabel setFont:[UIFont fontWithName:@"Arial" size:0.85*FONT_FACT*viewFrame.size.width]];
    
    [self.view addSubview:player2PntsLabel];

}

- (void)setUpViewController {
    
    self.view.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    
    p1Img = [UIImage imageNamed:@"blueSquare.png"];
    p2Img = [UIImage imageNamed:@"orangeSquare.png"];
    
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
    viewFrame.origin.y = topBar.frame.origin.y + topBar.frame.size.height +  offset;//3.0*offset;
    
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
    
   // viewFrame.size.width *= 0.5;
    viewFrame.size.height = self.view.frame.size.height/2.0;
    viewFrame.origin.y = viewFrame.size.height;
    
    menu = [[MenuView alloc] initWithFrame:viewFrame];
    menu.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.9];
    
    menu.hidden = YES;
    [menu setUpView];
    
    [self.view addSubview:menu];
    
    // Board set-up
    
    [self setUpBoard:lineThickness];
    [self setUpLabels];
    
    
}

- (void)setUpNewGame {
    
    [board clearBoard];
    [self loadData];
    [self setUpGamePlay];
}

- (int)getNextValueForPlayer {
    
    if(currentPlayer == player1)
        return nextValueP1;
    
    return nextValueP2;
}

- (void)resetNextValueForPlayer {
    
    if(currentPlayer == player1)
        nextValueP1 = tileValue;
    else
        nextValueP2 = tileValue;
}

- (void)changeNextTileForPlayer {
    
    if(currentPlayer == player1)
        nextTile.text = [NSString stringWithFormat:@"%d",nextValueP1];
    else
        nextTile.text = [NSString stringWithFormat:@"%d",nextValueP2];

    [self changeTileBackground:nextTile];
}

- (void)updateCurrentPlayer: (bool)isFloatPiece {
    
    if(currentPlayer == player1) {
        if(isFloatPiece) nextValueP1 = tileValue;
        else nextValueP1 += tileInc;
    }
    else {
        if(isFloatPiece) nextValueP2 = tileValue;
        else nextValueP2 += tileInc;
    }
}

- (bool)isMenuBarLocation: (CGPoint)crd {
    
    if(crd.x >= menuBar.frame.origin.x && crd.x <= (menuBar.frame.origin.x + menuBar.frame.size.width)) {
        if((crd.y + bottomBar.frame.origin.y) >= menuBar.frame.origin.y && (crd.y + bottomBar.frame.origin.y) <= (menuBar.frame.origin.y + menuBar.frame.size.height)) return YES;
    }

    return NO;
}

- (bool)isMenuBarItem: (CGPoint)crd  : (CGRect)viewFrame {
    
    if(crd.x >= viewFrame.origin.x && crd.x <= (viewFrame.origin.x + viewFrame.size.width)) {
        if(crd.y >= viewFrame.origin.y && crd.y <= (viewFrame.origin.y + viewFrame.size.height)) return YES;
    }
    
    return NO;
}

- (void)changeTileBackground: (UILabel*)tile {

    UIImage *img;
    
    if(currentPlayer == player1)
        img = p1Img;
    else
        img = p2Img;
    
    UIGraphicsBeginImageContext(imgSize);
    [img drawInRect:CGRectMake(0,0,imgSize.width,imgSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    tile.backgroundColor = [UIColor colorWithPatternImage:newImage];

}

- (void)setUpColors {
    
  //  topColor.red = 0.8;
  //  topColor.green = 0.75;
  //  topColor.blue = 0.65;
    
    topColor.red = 0.2;
    topColor.green = 0.4;
    topColor.blue = 0.5;
    
 //   botColor.red = 0.25;
 //   botColor.green = 0.55;
 //   botColor.blue = 0.8;
   
 //   botColor.red = 0.6;
 //   botColor.green = 0.5;
 //   botColor.blue = 0.3;
    
    
     botColor.red = 0.7;
     botColor.green = 0.7;
     botColor.blue = 0.7;

    
    p1Color.red = 0.25;
    p1Color.green = 0.55;
    p1Color.blue = 0.9;
    
 //   p1Color.red = 0.8;
 //   p1Color.green = 0.65;
 //   p1Color.blue = 0.2;
    
    //  p1Color.red = 0.2;
    //  p1Color.green = 0.3;
    //  p1Color.blue = 0.8;
    
    p2Color.red = 1.0;
    p2Color.green = 0.6;
    p2Color.blue = 0.0;
    
    tileColor.red = 0.4;
    tileColor.green = 0.4;
    tileColor.blue = 0.4;
    
}

@end
