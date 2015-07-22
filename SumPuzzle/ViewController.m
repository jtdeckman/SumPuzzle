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
#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize board, computer;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setUpViewController];
    [self setUpGamePlay];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1/1 target:self selector:@selector(runLoop) userInfo:nil repeats:YES];
}

- (void)viewDidAppear:(BOOL)animated {

    if(wentToSettingsView) {
   
      //  menu.hidden = YES;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
        if(computerPlayer != [defaults boolForKey:@"computerPlayer"])
            [self setUpNewGame];
    
        if(captureFlag != [defaults boolForKey:@"captureFlag"])
            [self setUpNewGame];
    
        if(dimx != (int)[defaults integerForKey:@"dimx"] || dimy != (int)[defaults integerForKey:@"dimy"])
            [self setUpNewGame];
        
        if(difficulty != [defaults integerForKey:@"difficulty"]) {
            
            difficulty = [defaults integerForKey:@"difficulty"];
            
            [self setUpDifficulty];
            
            if(computerPlayer && computer != nil) {
                computer.nIter = niter;
                computer.numRnIter = nRnIter;
            }
        }
        
        wentToSettingsView = NO;
    }
    
    else if(wentToGameWinView) {
        
        wentToGameWinView = NO;
    }
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

- (void)runLoop {
    
    if(gameState == gameRunning || gameState == preAI) {
        
       [self convertSecondsToHoursMinSec:gameTimeCnt++];
    }
    
    if(gameState == preWin) {
        
        if(winTimeCnt > 0) {
            
            gameState = winState;
            
            WinViewController *winView = [[WinViewController alloc] init];
            [winView initView:winner :computerPlayer];
        
            wentToGameWinView = YES;
            
            [self presentViewController:winView animated:NO completion:nil];
        }
        else {
            ++winTimeCnt;
        }
        
    }
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
                
                 if(placeMode == freeState) {
                    
                    if(space.isOccupied && space.player == currentPlayer) {
                        placeMode = swipeMove;
                        selectedPiece = space;
                        [self setUpFloatPiece: space];
                    }
                }
            }
        }
    }
    
    else if(gameState == howToPlay) {

        howToScreen.hidden = YES;
        gameState = gameMenu;
    }
    
    else if(gameState == gameMenu || gameState ==  winMenu) {
        
        if(touch.view != menu) {
            
            if(gameState == gameMenu)
                gameState = gameRunning;
            else
                gameState = winState;
            
            menu.hidden = YES;
        }
        else {
            
            location = [touch locationInView:menu];
            
            if([self isMenuBarItem:location :menu.settingsLabel.frame]) {
                
                wentToSettingsView = YES;
                SettingsViewController *settingsView = [[SettingsViewController alloc] init];
                
                [self presentViewController:settingsView animated:NO completion:nil];
                                                        
            }
            else if([self isMenuBarItem:location :menu.nwGameLabel.frame]) {
                
                menu.hidden = YES;
                [self setUpNewGame];
            }
            
            else if([self isMenuBarItem:location :menu.howToLabel.frame]) {
                
                gameState = howToPlay;
            
                [self.view bringSubviewToFront:howToScreen];
                howToScreen.hidden = NO;
            }
        }
    }
    
    else if(gameState == winState) {
        
        if(touch.view == bottomBar && [self isMenuBarLocation:location]) {
            gameState = winMenu;
            menu.hidden = NO;
            [self.view bringSubviewToFront:menu];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:boardView];
    
    if(gameState ==  gameRunning) {
        
        CGRect frm;
        
        if(placeMode == swipeMove) {
            
            frm.origin.x = location.x + floatOffset.x;// + boardView.frame.origin.x - 0.5*floatPiece.frame.size.width;
            frm.origin.y = location.y + floatOffset.y;// boardView.frame.origin.y - 0.5*floatPiece.frame.size.height;
            
            frm.size = floatPiece.frame.size;
            [floatPiece setFrame:frm];
            
        }
        else if(placeMode == placeTile) {
            
            frm.origin.x = location.x + floatOffset.x;// + boardView.frame.origin.x - 0.5*floatPiece.frame.size.width;
            frm.origin.y = location.y + floatOffset.y;// boardView.frame.origin.y - 0.5*floatPiece.frame.size.height;
            
            if(currentPlayer == player1) {
                frm.size = nextTile.frame.size;
                [nextTile setFrame:frm];
                [self.view bringSubviewToFront:nextTile];
            }
            else {
                frm.size = p2NextTile.frame.size;
                [p2NextTile setFrame:frm];
                [self.view bringSubviewToFront:p2NextTile];
            }
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
                
                if(currentPlayer == player1)
                    [nextTile setFrame:nextTileLoc];
                else
                    [p2NextTile setFrame:p2NextTileLoc];
                
                placeMode = freeState;
            }
        
        }
        if(placeMode == swipeMove) {
        
            CGRect frm;
            frm.origin.x = location.x + floatOffset.x;// + boardView.frame.origin.x - 0.5*floatPiece.frame.size.width;
            frm.origin.y = location.y + floatOffset.y;// boardView.frame.origin.y - 0.5*floatPiece.frame.size.height;
            
            frm.size = floatPiece.frame.size;
        
            [floatPiece setFrame:frm];
            floatPiece.hidden = YES;
        
            Space *space = [board getSpaceFromPoint:location];
        
            if(space != nil) {
            
                if(!space.isOccupied && selectedPiece.value > 1 && [selectedPiece isNearestNearestNbrOf:space]) {
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
                        
                        int newVal = selectedPiece.value - space.value*DIV_FACT;

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
    [p2NextTile setFrame:p2NextTileLoc];
    
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
    
    if(currentPlayer == player1) {
        if(crd.x >= nextTile.frame.origin.x && crd.x <= (nextTile.frame.origin.x + nextTile.frame.size.width)) {
    
            if((crd.y + bottomBar.frame.origin.y) >= nextTile.frame.origin.y && (crd.y + bottomBar.frame.origin.y) <= (nextTile.frame.origin.y + nextTile.frame.size.height)) return YES;
        }
    }
    
    else {
        if(crd.x >= p2NextTile.frame.origin.x && crd.x <= (p2NextTile.frame.origin.x + p2NextTile.frame.size.width)) {
            
            if((crd.y + bottomBar.frame.origin.y) >= p2NextTile.frame.origin.y && (crd.y + bottomBar.frame.origin.y) <= (p2NextTile.frame.origin.y + p2NextTile.frame.size.height)) return YES;
        }

    }
    
    return NO;
}

- (void)AIMove {
    
    Move *move = [[Move alloc] init];
    Space *moveFrom, *moveTo;
    
    [computer findSpaces:move :nextValueP1 :nextValueP2];
    
    moveFrom = move.fromSpace;
    moveTo = move.toSpace;
    
    moveInc = MOVE_NINC;
    
    if(moveTo == nil) {
    
        winner = player1;
        gameState = winState;
        
        [self gameWon];
    }
    
    else {
        
        moveToSpace = moveTo;
        
        if(moveFrom == nil) {
            
            moveInc = 2*MOVE_NINC;
            
            Space *tmpSpace = [[Space alloc] init];
            tmpSpace.piece = p2NextTile;
    
            p2NextTile.hidden = YES;
            
            [self animateComputerMove:tmpSpace :nextValueP2];
            
            [self addPiece:moveTo];
            
            moveTo.piece.hidden = YES;
        }
        
        else if(moveTo.player == notAssigned) {
            
            int value = (int)((float)moveFrom.value/2.0);
            
            moveFrom.value = value;
            moveFrom.piece.text = [NSString stringWithFormat:@"%d", value];
            
            [board addPiece:moveTo.iind :moveTo.jind : value : currentPlayer : [self getColorForPlayer]];
            
            [self animateComputerMove:moveFrom :value];
            
            [self updateCurrentPlayer:NO];
            [self switchPlayers];
        }
        else {
            
            if(moveTo.player == player1) {
                
                int newVal = moveFrom.value - moveTo.value*DIV_FACT;
                
                [self animateComputerMove:moveFrom :newVal];
                [board convertPiece:moveTo :newVal :[self getColorForPlayer] :player2];
                [board removePiece:moveFrom];
                
                moveTo.piece.text = [NSString stringWithFormat:@"%d", newVal];
                
                [self updateCurrentPlayer:NO];
                [self switchPlayers];
            }
            else {
                
                int newVal = (int)((float)moveFrom.value);
                
                [self animateComputerMove:moveFrom :newVal];
                
                [board removePiece:moveFrom];
                
                moveTo.value += newVal;
                moveTo.piece.text = [NSString stringWithFormat:@"%d", moveTo.value];
                
                [self updateCurrentPlayer:NO];
                [self switchPlayers];
            }
        }
    }
}

- (void)setUpGamePlay {
    
    numSpaces = dimx*dimy;
    
    gameState = gameRunning;
    placeMode = freeState;
    currentPlayer = player1;
    
    gameTimeCnt = 0;
    
    moveInc = MOVE_NINC;
    
    winLabel.hidden = YES;
    
    cFlagPos1 = dimy-1;
    cFlagPos2 = 0;
    
    board.cFlagPos1 = cFlagPos1;
    board.cFlagPos2 = cFlagPos2;
    
    [board addPiece:0 :0 :startValue : player1 : p1Color];
    [board addPiece:0 :dimy-1 :startValue : player1 : p1Color];
    
    [board addPiece:dimx-1 :0 :startValue : player2 : p2Color];
    [board addPiece:dimx-1 :dimy-1 :startValue : player2 : p2Color];
    
    nextValueP1 = tileValue;
    nextValueP2 = tileValue;
    
    [self upDateNextTiles];
    
    playerLabel.text = [NSString stringWithFormat:@"Player 1"];
    
    p1PointsOnBoard = [board pointsForPlayer:player1];
    p2PointsOnBoard = [board pointsForPlayer:player2];
    
    player1PntsLabel.text = [NSString stringWithFormat:@"%d", p1PointsOnBoard];
    player2PntsLabel.text = [NSString stringWithFormat:@"%d", p2PointsOnBoard];
    
    computer = [[AINew alloc] init];
    [computer setUpAI:board : tileInc : captureFlag :niter];
    
    computer.numRnIter = nRnIter;
    
    if(captureFlag) {
        
        Space *space = [board getSpaceForIndices:0 :cFlagPos2];
        
        CGRect viewFrame, frm = space.piece.frame;
        
        viewFrame = nextTile.frame;
        
        viewFrame.origin.x = boardView.frame.origin.x + frm.origin.x + frm.size.width/2.0;;
        viewFrame.origin.y = boardView.frame.origin.y + frm.origin.y - frm.size.height/2.0;;
        viewFrame.size.width *= 0.5;
        
        [flag1 setFrame:viewFrame];
        
        space = [board getSpaceForIndices:dimx-1 :cFlagPos1];
        
        frm = space.piece.frame;
        
        viewFrame.origin.x = boardView.frame.origin.x + frm.origin.x + frm.size.width/2.0;
        viewFrame.origin.y = boardView.frame.origin.y + frm.origin.y - frm.size.height/2.0;
        
        [flag2 setFrame:viewFrame];
        
        flag1.hidden = NO;
        flag2.hidden = NO;
        
        [self.view bringSubviewToFront:flag1];
        [self.view bringSubviewToFront:flag2];
    }
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
    
    captureFlag = [defaults boolForKey:@"captureFlag"];
    difficulty = [defaults integerForKey:@"difficulty"];
    
    startValue = (int)[defaults integerForKey:@"startValue"];
    tileValue = (int)[defaults integerForKey:@"tileValue"];
    tileInc = TILE_INC; //(int)[defaults integerForKey:@"tileInc"];
    
    [self setUpDifficulty];

    [defaults synchronize];
}

- (void)switchPlayers {
    
    winner = [board checkForWinner];
    
    if(winner != notAssigned)
        [self gameWon];
    
    else {
    
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

        [self upDateNextTiles];
    
        selectedPiece = nil;
    
        placeMode = freeState;
    
        if(computerPlayer && currentPlayer == player2)
            [self AIWaitLoop];
    }
}

- (void)AIWaitLoop {

    pauseTimer = [NSTimer scheduledTimerWithTimeInterval:1/2 target:self selector:@selector(AIPauseLoop) userInfo:nil repeats:YES];
    
    gameState = preAI;
    pauseTimeCnt = 0;
}

- (void)upDatePoints {

    p1PointsOnBoard = [board pointsForPlayer:player1];
    p2PointsOnBoard = [board pointsForPlayer:player2];
    
    player1PntsLabel.text = [NSString stringWithFormat:@"%d", p1PointsOnBoard];
    player2PntsLabel.text = [NSString stringWithFormat:@"%d", p2PointsOnBoard];
}

- (void)setUpBoard:(CGFloat)offset {
    
    board = [[Board alloc] init];
    [board initBoard:boardView.frame :dimx :dimy :offset :captureFlag];
    
    [self addPiecesToView];
    
    Space *tmpSpace = [board getSpaceForIndices:0 :0];
    imgSize = tmpSpace.spaceFrame.size;
    
}

- (void)setUpNewGame {
    
    [computer deconstructAI];
    [board deconstruct];
    
    [self cleanUp];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    [appDelegate resetApp];
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

- (void)upDateNextTiles {

    nextTile.text = [NSString stringWithFormat:@"%d",nextValueP1];
    p2NextTile.text = [NSString stringWithFormat:@"%d",nextValueP2];

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
- (void)AIPauseLoop {

    if(pauseTimeCnt >= AI_PAUSE_TIME) {
        [pauseTimer invalidate];
        pauseTimer = nil;
        
        if(gameState == preAI)
            gameState = gameRunning;
        
        [self AIMove];
    }
    else {
        ++pauseTimeCnt;
    }
}

- (void)animateComputerMove: (Space*)fromSpace : (int)value {
    
    gameState = gamePaused;

    [self setUpFloatPiece:fromSpace];
    
    floatPiece.text  = [NSString stringWithFormat:@"%d", value];
    
    moveToSpace.piece.hidden = YES;
    playerLabel.hidden = NO;

    CGRect frm = fromSpace.piece.frame;
    
    frm = moveToSpace.piece.frame;
    frm.origin.x += boardView.frame.origin.x;
    frm.origin.y += boardView.frame.origin.y;
    frm.size.width = floatPiece.frame.size.width;
    frm.size.height = floatPiece.frame.size.height;
    
    [UIView animateWithDuration:1.0
                     animations:^{
        floatPiece.frame = frm;}
            completion:^(BOOL finished) {
                [self movePieceLoop];
            }
     ];
}

- (void)movePieceLoop {
    
    if(gameState == gamePaused)
        gameState = gameRunning;
        
    floatPiece.hidden = YES;
    moveToSpace.piece.hidden = NO;
        
    p2NextTile.hidden = NO;
       
    playerLabel.text = @"Player 1";
    playerLabel.backgroundColor = [UIColor colorWithRed:p1Color.red green:p1Color.green blue:p1Color.blue alpha:1.0];
}

- (void)gameWon {
    
    gameState = preWin;
    winTimeCnt = 0;
    
    [self writeGameStats];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setInteger:winner forKey:@"winner"];
    [defaults synchronize];
}

- (void)setUpViewController {
    
    wentToSettingsView = NO;
    wentToGameWinView = NO;
    
    self.view.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    
    p1Img = [UIImage imageNamed:@"blueSquare.png"];
    p2Img = [UIImage imageNamed:@"orangeSquare.png"];
    
    [self loadData];
    [self setUpColors];
    
    CGFloat width = self.view.frame.size.width*WIDTH_FACT;
    CGFloat height = self.view.frame.size.height*TOPBAR_V_FACT;
    
  //  if(self.view.frame.size.height > 700)
  //      height *= 0.75;
    
    CGFloat offset = self.view.frame.size.width*SPACING_FACT;
    
    CGRect viewFrame;
    
    lineThickness = width*LINE_THICK_FACT;
    fpOffset = offset;

    if(dimx == 6)
        lineThickness *= 0.8;
        
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
    
    CGFloat aratio = self.view.frame.size.width/self.view.frame.size.height;
    
    if(aratio > 0.74) {
        viewFrame.size.width = 0.75*width;
        viewFrame.size.height = viewFrame.size.width;
        viewFrame.origin.x = (self.view.frame.size.width - viewFrame.size.width)/2.0;
    }
    
    boardView = [[BoardView alloc] initWithFrame:viewFrame];
    [boardView initBoardView:dimx :dimy :lineThickness :dimx];
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

 // How to play screen
    
    howToScreen = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"howToPlay.png"]];
    howToScreen.frame = self.view.frame;
    howToScreen.alpha = 1.0;
    howToScreen.hidden = YES;
    
    [self.view addSubview:howToScreen];
    
    
    // Board set-up
    
    [self setUpBoard:lineThickness];
    [self setUpLabels];
}

- (void)setUpLabels {
    
    CGRect viewFrame;
    
    Space *space = [board getSpaceForIndices:0 :0];
    
    // viewFrame.origin.x = 0.5*self.view.frame.size.width - space.spaceFrame.size.width/2.0;
    viewFrame.origin.x = 0.1*bottomBar.frame.size.width;// - space.spaceFrame.size.width/2.0;
    viewFrame.size.width = 0.98*space.spaceFrame.size.width;
    viewFrame.size.height = 0.98*space.spaceFrame.size.height;
    viewFrame.origin.y = bottomBar.frame.origin.y + bottomBar.frame.size.height/2.0 -viewFrame.size.height/2.0;
    
    nextTileLoc = viewFrame;
    
    nextTile = [[UILabel alloc] initWithFrame:viewFrame];
    nextTile.hidden = NO;
    nextTile.layer.cornerRadius = 10.0;
    nextTile.clipsToBounds = YES;
    
    nextTile.backgroundColor = [UIColor colorWithPatternImage:p1Img];
    nextTile.textColor = [UIColor whiteColor];
    
    [nextTile setTextAlignment:NSTextAlignmentCenter];
    [nextTile setFont:[UIFont fontWithName:@"Arial" size:1.15*FONT_FACT*viewFrame.size.width]];
    
    UIImage *img = p1Img;
    
    UIGraphicsBeginImageContext(imgSize);
    [img drawInRect:CGRectMake(0,0,imgSize.width,imgSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    nextTile.backgroundColor = [UIColor colorWithPatternImage:newImage];
    
    [self.view addSubview:nextTile];
    [self.view bringSubviewToFront:nextTile];
    
    // Player 2 next tile
    
    viewFrame.origin.x = bottomBar.frame.size.width - (nextTileLoc.origin.x + nextTileLoc.size.width);
    
    p2NextTileLoc = viewFrame;
    
    p2NextTile = [[UILabel alloc] initWithFrame:viewFrame];
    p2NextTile.hidden = NO;
    p2NextTile.layer.cornerRadius = 10.0;
    p2NextTile.clipsToBounds = YES;
    
    p2NextTile.backgroundColor = [UIColor colorWithPatternImage:p2Img];
    p2NextTile.textColor = [UIColor whiteColor];
    
    [p2NextTile setTextAlignment:NSTextAlignmentCenter];
    [p2NextTile setFont:[UIFont fontWithName:@"Arial" size:1.15*FONT_FACT*viewFrame.size.width]];
    
    img = p2Img;
    
    UIGraphicsBeginImageContext(imgSize);
    [img drawInRect:CGRectMake(0,0,imgSize.width,imgSize.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    p2NextTile.backgroundColor = [UIColor colorWithPatternImage:newImage];
    
    [self.view addSubview:p2NextTile];
    [self.view bringSubviewToFront:p2NextTile];
    
    // Movable (floating) piece
    
    floatPiece = [[UILabel alloc] initWithFrame:viewFrame];
    floatPiece.hidden = YES;
    floatPiece.layer.cornerRadius = 10.0;
    floatPiece.clipsToBounds = YES;
    floatPiece.backgroundColor = nextTile.backgroundColor;
    //  floatPiece.layer.borderWidth = 2.0f;
    floatPiece.textColor = [UIColor whiteColor];
    
    [floatPiece setTextAlignment:NSTextAlignmentCenter];
    [floatPiece setFont:[UIFont fontWithName:@"Arial" size:1.0*FONT_FACT*space.spaceFrame.size.width]];
    
    [self.view addSubview:floatPiece];
    
    floatOffset.x = boardView.frame.origin.x - 0.5*floatPiece.frame.size.width + fpOffset;
    floatOffset.y = boardView.frame.origin.y - 0.5*floatPiece.frame.size.height + fpOffset;
    
    // Menu bar
    
    viewFrame.size.width = 0.65*viewFrame.size.width;
    viewFrame.origin.x = bottomBar.frame.size.width/2.0 - viewFrame.size.width/2.0;
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
    viewFrame.origin.y = 0.11*self.view.frame.size.height;
    
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
    [player1PntsLabel setFont:[UIFont fontWithName:@"Arial" size:0.9*FONT_FACT*viewFrame.size.width]];
    
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
    [player2PntsLabel setFont:[UIFont fontWithName:@"Arial" size:0.9*FONT_FACT*viewFrame.size.width]];
    
    [self.view addSubview:player2PntsLabel];
    
 // Timer label
    
    viewFrame.size.height = player1PntsLabel.frame.size.height;
    viewFrame.size.width = 2.0*player1PntsLabel.frame.size.width;
    viewFrame.origin.y = player1PntsLabel.frame.origin.y - 1.15*viewFrame.size.height;
    viewFrame.origin.x = (self.view.frame.size.width - viewFrame.size.width)/2.0;
    
    timeLabel = [[UILabel alloc] initWithFrame:viewFrame];
    
    timeLabel.clipsToBounds = YES;
    timeLabel.backgroundColor = [UIColor clearColor];
    timeLabel.layer.borderColor = [[UIColor clearColor] CGColor];
    timeLabel.textColor = [UIColor whiteColor];
    [timeLabel setTextAlignment:NSTextAlignmentCenter];
    [timeLabel setFont:[UIFont fontWithName:@"Arial" size:1.5*FONT_FACT*viewFrame.size.height]];
    
    timeLabel.text = @"00:00";
    
    [self.view addSubview:timeLabel];
    
 // Win Label
    
    viewFrame = topBar.frame;
    
    viewFrame.size.width *= 0.75;
   // viewFrame.size.height *= 0.75;
    
    viewFrame.origin.x = self.view.frame.size.width/2.0 - 0.5*viewFrame.size.width;
    viewFrame.origin.y = self.view.frame.size.height/2.0 - 0.5*viewFrame.size.height;
    
    winLabel = [[UILabel alloc] initWithFrame:viewFrame];
    winLabel.hidden = YES;
    winLabel.clipsToBounds =YES;
    winLabel.backgroundColor = [UIColor clearColor];
    winLabel.textColor = [UIColor colorWithRed:0.9 green:0.1 blue:0.1 alpha:1.0];
    [winLabel setTextAlignment:NSTextAlignmentCenter];
    [winLabel setFont:[UIFont fontWithName:@"Arial" size:0.65*FONT_FACT*viewFrame.size.width]];
    
    winLabel.lineBreakMode = NSLineBreakByWordWrapping;
    winLabel.numberOfLines = 2;
    
    winLabel.text = [NSString stringWithFormat:@"You Won!"];
   // winLabel.hidden = NO;
    
    [self.view addSubview:winLabel];
    
    viewFrame = nextTile.frame;
    
    flag1 = [[UIImageView alloc] initWithFrame:viewFrame];
    flag2 = [[UIImageView alloc] initWithFrame:viewFrame];
    
    [flag1 setImage:[UIImage imageNamed:@"flag1.png"]];
    [flag2 setImage:[UIImage imageNamed:@"flag2.png"]];
    
    flag1.hidden = YES;
    flag2.hidden = YES;
    
    [self.view addSubview:flag1];
    [self.view addSubview:flag2];
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

- (void)cleanUp {

    p1Img = nil;
    p2Img = nil;
    
    flag1 = nil;
    flag2 = nil;
    
    selectedPiece = nil;
    moveToSpace = nil;
    
    playerLabel = nil;
    player1PntsLabel = nil;
    player2PntsLabel = nil;
    
    nextTile = nil;
    p2NextTile = nil;
    
    floatPiece = nil;
    
    board = nil;
    computer = nil;
    
    topBar = nil;
    bottomBar = nil;
    boardView = nil;
}

- (void)convertSecondsToHoursMinSec:(uint)nSeconds {
    
    uint min, sec;
    
    min = (int)(nSeconds/60);
    sec = nSeconds % 60;
    
    if(min < 10) {
        if(sec < 10)
            timeLabel.text = [NSString stringWithFormat:@"0%d:0%d",min,sec];
        else
            timeLabel.text = [NSString stringWithFormat:@"0%d:%d",min,sec];
    }
    else {
        if(sec < 10)
            timeLabel.text = [NSString stringWithFormat:@"%d:0%d",min,sec];
        else
            timeLabel.text = [NSString stringWithFormat:@"%d:%d",min,sec];
    }
    
}

- (void)setUpDifficulty {

    if(captureFlag) {
        
        if(difficulty == 1) {
            niter = 5;
            nRnIter = 1;
        }
        else {
            niter = 3;
            nRnIter = 1;
        }
    }
    else {
        
        if(difficulty == 1) {
            niter = 10;
            nRnIter = 1;
        }
        else {
            niter = 5;
            nRnIter = 1;
        }

    }
}

- (void)setUpFloatPiece: (Space*)space {
    
    CGRect frm;
    
    if(space.piece == nextTile || space.piece == p2NextTile) {
        
        frm.origin.x = space.piece.frame.origin.x;
        frm.origin.y = space.piece.frame.origin.y;
    }
    else {
        
        frm.origin.x = space.piece.frame.origin.x + boardView.frame.origin.x;
        frm.origin.y = space.piece.frame.origin.y + boardView.frame.origin.y;
    }
    
    frm.size = space.piece.frame.size;
    
    floatPiece.hidden = NO;
    
    floatPiece.text = [NSString stringWithFormat:@"%d", space.value];
    floatPiece.layer.borderColor = [[UIColor clearColor] CGColor];
    
    [self changeTileBackground:floatPiece];
    
    [floatPiece setFrame:frm];
    
    [self.view bringSubviewToFront:floatPiece];
}

- (void)writeGameStats {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if(winner == player1) {
    
        NSInteger bestTime;
        
        if(captureFlag) {

            bestTime = [defaults integerForKey:@"bestTimeCF"];
    
            if(gameTimeCnt < bestTime)
                [defaults setInteger:gameTimeCnt forKey:@"bestTimeCF"];;
            
            [defaults setInteger:[defaults integerForKey:@"nP1WinsCF"]+1 forKey:@"nP1WinsCF"];
        }
        
        else {
            
            bestTime = [defaults integerForKey:@"bestTime"];
            
            if(gameTimeCnt < bestTime)
                  [defaults setInteger:gameTimeCnt forKey:@"bestTime"];
            
            [defaults setInteger:[defaults integerForKey:@"nP1Wins"]+1 forKey:@"nP1Wins"];
        }
    }
    
    else {
        
        if(computerPlayer) {
            
            if(captureFlag)
                [defaults setInteger:[defaults integerForKey:@"nCompWinsCF"]+1 forKey:@"nCompWinsCF"];
            
            else
                [defaults setInteger:[defaults integerForKey:@"nCompWins"]+1 forKey:@"nCompWins"];
        }
        
        else {
            
            if(captureFlag)
                [defaults setInteger:[defaults integerForKey:@"nP2WinsCF"]+1 forKey:@"nP2WinsCF"];
            else
                [defaults setInteger:[defaults integerForKey:@"nP2Wins"]+1 forKey:@"nP2Wins"];
        }
    }
    
    [defaults synchronize];
}

@end
