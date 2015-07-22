//
//  WinViewController.m
//  SumPuzzle
//
//  Created by Jason Deckman on 7/21/15.
//  Copyright (c) 2015 JDeckman. All rights reserved.
//

#import "WinViewController.h"

@interface WinViewController ()

@end

@implementation WinViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1/1 target:self selector:@selector(runLoop) userInfo:nil repeats:YES];
}

- (void)runLoop {
    
    [self animateTiles];
    [timer invalidate];
    timer = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initView: (Player)player :(bool)cp {

    bool ires = [self init];
    
    if(!ires) {
        
    }
    
    imgView = [[UIImageView alloc] initWithFrame:self.view.frame];
    
    if(player == player1) {
       // [imgView setImage:[UIImage imageNamed:@"youWing.png"]];
      //  self.view.backgroundColor = [UIColor colorWithRed:1.0 green:0.6 blue:0.0 alpha:1.0];
        self.view.backgroundColor = [UIColor colorWithRed:0.25 green:0.55 blue:0.9 alpha:1.0];

    }
    
    else {
       
        self.view.backgroundColor = [UIColor colorWithRed:0.25 green:0.55 blue:0.9 alpha:1.0];
    }
}

- (void)animateTiles {

    NSMutableArray *playerTiles;
    NSMutableArray *winTiles;
    
    UILabel *labelPtr;
    
    CGRect playerFrm, winFrm;
    CGFloat spacing, tilesWidth;
    
    UIImage *imgPlayer, *pImage, *wImage, *winImage;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    winner = [defaults integerForKey:@"winner"];
    computerPlayer = [defaults integerForKey:@"computerPlayer"];
    
   // if(winner == player1)
   //   imgPlayer = [UIImage imageNamed:@"blueSquare.png"];
   // else
      imgPlayer = [UIImage imageNamed:@"orangeSquare.png"];
    
    winImage = [UIImage imageNamed:@"redSquare.png"];
    
    if(winner == player1)
        playerFrm.size.width = self.view.frame.size.width/6;
    else
        playerFrm.size.width = self.view.frame.size.width/10;
    
    playerFrm.size.height = playerFrm.size.width;
    playerFrm.origin.y = self.view.frame.size.height;
    playerFrm.origin.x = 0;
    
    if(winner == player1)
        winFrm.size.width = 1.2*playerFrm.size.width;
    else 
        winFrm.size.width = 1.5*playerFrm.size.width;

    winFrm.size.height = winFrm.size.width;

    winFrm.origin.x = 0;
    winFrm.origin.y = self.view.frame.size.height;
    
    CGSize pSize, wSize;
    
    pSize = playerFrm.size;
    wSize = winFrm.size;
    
    UIGraphicsBeginImageContext(pSize);
    [imgPlayer drawInRect:CGRectMake(0,0,pSize.width,pSize.height)];
    pImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(wSize);
    [winImage drawInRect:CGRectMake(0,0,wSize.width,wSize.height)];
    wImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(winner == player1)
        spacing = playerFrm.size.width/4.0;
    else
        spacing = playerFrm.size.width/5.0;
    
    winTiles = [[NSMutableArray alloc] initWithCapacity:5];
    
    if(winner == player1) {
        
        playerTiles = [[NSMutableArray alloc] initWithCapacity:3];
        tilesWidth = 3.0*playerFrm.size.width + 2.0*spacing;
        playerFrm.origin.x = (self.view.frame.size.width - tilesWidth)/2.0;
        
        for(int i=0; i<3; i++) {
         
            labelPtr = [[UILabel alloc] initWithFrame:playerFrm];
            
            labelPtr.hidden = NO;
            labelPtr.layer.cornerRadius = 10.0;
            labelPtr.clipsToBounds = YES;
            labelPtr.backgroundColor = [UIColor colorWithPatternImage:pImage];
            labelPtr.textColor = [UIColor whiteColor];
            
            [labelPtr setTextAlignment:NSTextAlignmentCenter];
            [labelPtr setFont:[UIFont fontWithName:@"Arial" size:2.0*FONT_FACT*playerFrm.size.width]];
            
            [self.view addSubview:labelPtr];
            [playerTiles addObject:labelPtr];
            
            playerFrm.origin.x += playerFrm.size.width + spacing;
        }
        
        labelPtr = playerTiles[0];
        labelPtr.text = @"Y";
        
        labelPtr = playerTiles[1];
        labelPtr.text = @"O";
        
        labelPtr = playerTiles[2];
        labelPtr.text = @"U";
        
        tilesWidth = 4.0*winFrm.size.width + 3.0*spacing;
        winFrm.origin.x = (self.view.frame.size.width - tilesWidth)/2.0;
        
        for(int i=0; i<4; i++) {
            
            labelPtr = [[UILabel alloc] initWithFrame:winFrm];
            
            labelPtr.hidden = NO;
            labelPtr.layer.cornerRadius = 10.0;
            labelPtr.clipsToBounds = YES;
            labelPtr.backgroundColor = [UIColor colorWithPatternImage:wImage];
            labelPtr.textColor = [UIColor whiteColor];
            
            [labelPtr setTextAlignment:NSTextAlignmentCenter];
            [labelPtr setFont:[UIFont fontWithName:@"Arial" size:2.5*FONT_FACT*playerFrm.size.width]];
            
            [self.view addSubview:labelPtr];
            [winTiles addObject:labelPtr];
            
            winFrm.origin.x += winFrm.size.width + spacing;
        }
        
        labelPtr = winTiles[0];
        labelPtr.text = @"W";
        
        labelPtr = winTiles[1];
        labelPtr.text = @"I";
        
        labelPtr = winTiles[2];
        labelPtr.text = @"N";
        
        labelPtr = winTiles[3];
        labelPtr.text = @"!";
    }
    
    else {
        
        if(computerPlayer) {
            
            playerTiles = [[NSMutableArray alloc] initWithCapacity:8];
            tilesWidth = 8.0*playerFrm.size.width + 7.0*spacing;
            playerFrm.origin.x = (self.view.frame.size.width - tilesWidth)/2.0;
            
            for(int i=0; i<8; i++) {
                
                labelPtr = [[UILabel alloc] initWithFrame:playerFrm];
                
                labelPtr.hidden = NO;
                labelPtr.layer.cornerRadius = 10.0;
                labelPtr.clipsToBounds = YES;
                labelPtr.backgroundColor = [UIColor colorWithPatternImage:pImage];
                labelPtr.textColor = [UIColor whiteColor];
                
                [labelPtr setTextAlignment:NSTextAlignmentCenter];
                [labelPtr setFont:[UIFont fontWithName:@"Arial" size:2.0*FONT_FACT*playerFrm.size.width]];
                
                [self.view addSubview:labelPtr];
                [playerTiles addObject:labelPtr];
                
                playerFrm.origin.x += playerFrm.size.width + spacing;
            }

            
            labelPtr = playerTiles[0];
            labelPtr.text = @"C";
            
            labelPtr = playerTiles[1];
            labelPtr.text = @"O";
            
            labelPtr = playerTiles[2];
            labelPtr.text = @"M";
            
            labelPtr = playerTiles[3];
            labelPtr.text = @"P";
            
            labelPtr = playerTiles[4];
            labelPtr.text = @"U";
            
            labelPtr = playerTiles[5];
            labelPtr.text = @"T";
            
            labelPtr = playerTiles[6];
            labelPtr.text = @"E";
            
            labelPtr = playerTiles[7];
            labelPtr.text = @"R";
        }
        
        else {
            
        }
        
        tilesWidth = 4.0*winFrm.size.width + 3.0*spacing;
        winFrm.origin.x = (self.view.frame.size.width - tilesWidth)/2.0;
        
        for(int i=0; i<4; i++) {
            
            labelPtr = [[UILabel alloc] initWithFrame:winFrm];
            
            labelPtr.hidden = NO;
            labelPtr.layer.cornerRadius = 10.0;
            labelPtr.clipsToBounds = YES;
            labelPtr.backgroundColor = [UIColor colorWithPatternImage:wImage];
            labelPtr.textColor = [UIColor whiteColor];
            
            [labelPtr setTextAlignment:NSTextAlignmentCenter];
            [labelPtr setFont:[UIFont fontWithName:@"Arial" size:2.5*FONT_FACT*playerFrm.size.width]];
            
            [self.view addSubview:labelPtr];
            [winTiles addObject:labelPtr];
            
            winFrm.origin.x += winFrm.size.width + spacing;
        }

        labelPtr = winTiles[0];
        labelPtr.text = @"W";
        
        labelPtr = winTiles[1];
        labelPtr.text = @"I";
        
        labelPtr = winTiles[2];
        labelPtr.text = @"N";
        
        labelPtr = winTiles[3];
        labelPtr.text = @"S";
    }
    
    [self doAnimations:playerTiles :winTiles];
}

- (void)doAnimations: (NSMutableArray*)pieces :(NSMutableArray*)winPieces {
    
    UILabel *currPc = pieces[0];

        
    CGRect animFrm = currPc.frame;
    
    animFrm.origin.y = self.view.frame.size.height*0.4;
    
    [UIView animateWithDuration:0.75
                    animations:^{
                        currPc.frame = animFrm;}
                    completion:^(BOOL finished) {
                        //[self getNextPiece:pieces :currPc];
                    }
            ];
        
      /*  [UIView animateWithDuration:0.75
                              delay:1.0
                            options:UIViewAnimationOptionTransitionCrossDissolve
                         animations:^{
                             currPc.frame = animFrm;
                         } completion:^(BOOL finished) {
    
                         }]; */
        
    currPc = pieces[1];
    animFrm = currPc.frame;
    animFrm.origin.y = self.view.frame.size.height*0.4;
    
     [UIView animateWithDuration:0.75
                           delay:0.4
                         options:UIViewAnimationOptionTransitionCrossDissolve
                      animations:^{
                          currPc.frame = animFrm;
                      } completion:^(BOOL finished) {
                         
                      }];
    
    currPc = pieces[2];
    animFrm = currPc.frame;
    animFrm.origin.y = self.view.frame.size.height*0.4;
    
    [UIView animateWithDuration:0.75
                          delay:0.5
                        options:UIViewAnimationOptionTransitionCrossDissolve
                     animations:^{
                         currPc.frame = animFrm;
                     } completion:^(BOOL finished) {
                         
                     }];
    
    if([pieces count] > 3) {
 
        currPc = pieces[3];
        animFrm = currPc.frame;
        animFrm.origin.y = self.view.frame.size.height*0.4;
    
        [UIView animateWithDuration:0.75
                              delay:0.6
                            options:UIViewAnimationOptionTransitionCrossDissolve
                         animations:^{
                             currPc.frame = animFrm;
                         } completion:^(BOOL finished) {
                         
                         }];
        
        currPc = pieces[4];
        animFrm = currPc.frame;
        animFrm.origin.y = self.view.frame.size.height*0.4;
        
        [UIView animateWithDuration:0.75
                              delay:0.8
                            options:UIViewAnimationOptionTransitionCrossDissolve
                         animations:^{
                             currPc.frame = animFrm;
                         } completion:^(BOOL finished) {
                             
                         }];
        
        currPc = pieces[5];
        animFrm = currPc.frame;
        animFrm.origin.y = self.view.frame.size.height*0.4;
        
        [UIView animateWithDuration:0.75
                              delay:0.9
                            options:UIViewAnimationOptionTransitionCrossDissolve
                         animations:^{
                             currPc.frame = animFrm;
                         } completion:^(BOOL finished) {
                             
                         }];
        
        currPc = pieces[6];
        animFrm = currPc.frame;
        animFrm.origin.y = self.view.frame.size.height*0.4;
        
        [UIView animateWithDuration:0.75
                              delay:1.0
                            options:UIViewAnimationOptionTransitionCrossDissolve
                         animations:^{
                             currPc.frame = animFrm;
                         } completion:^(BOOL finished) {
                             
                         }];
    }
    
    if([pieces count] > 7) {
        
        currPc = pieces[7];
        animFrm = currPc.frame;
        animFrm.origin.y = self.view.frame.size.height*0.4;
        
        [UIView animateWithDuration:0.75
                              delay:1.1
                            options:UIViewAnimationOptionTransitionCrossDissolve
                         animations:^{
                             currPc.frame = animFrm;
                         } completion:^(BOOL finished) {
                             
                         }];
        
    }
    
    currPc = winPieces[0];
    animFrm = currPc.frame;
    animFrm.origin.y = self.view.frame.size.height*0.55;
    
    [UIView animateWithDuration:0.75
                          delay:1.2
                        options:UIViewAnimationOptionTransitionCrossDissolve
                     animations:^{
                         currPc.frame = animFrm;
                     } completion:^(BOOL finished) {
                         
                     }];

    
    currPc = winPieces[1];
    animFrm = currPc.frame;
    animFrm.origin.y = self.view.frame.size.height*0.6;
    
    [UIView animateWithDuration:0.75
                          delay:1.3
                        options:UIViewAnimationOptionTransitionCrossDissolve
                     animations:^{
                         currPc.frame = animFrm;
                     } completion:^(BOOL finished) {
                         
                     }];

    currPc = winPieces[2];
    animFrm = currPc.frame;
    animFrm.origin.y = self.view.frame.size.height*0.55;
    
    [UIView animateWithDuration:0.75
                          delay:1.4
                        options:UIViewAnimationOptionTransitionCrossDissolve
                     animations:^{
                         currPc.frame = animFrm;
                     } completion:^(BOOL finished) {
                         
                     }];
    
    
    currPc = winPieces[3];
    animFrm = currPc.frame;
    animFrm.origin.y = self.view.frame.size.height*0.6;
    
    [UIView animateWithDuration:0.75
                          delay:1.5
                        options:UIViewAnimationOptionTransitionCrossDissolve
                     animations:^{
                         currPc.frame = animFrm;
                     } completion:^(BOOL finished) {
                         
                     }];

    
}

@end
