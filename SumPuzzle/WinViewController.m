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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initView: (Player)player {

    BOOL ires = [self init];
    
    if(!ires) {
        
    }
    
    imgView = [[UIImageView alloc] initWithFrame:self.view.frame];
    
    if(player == player1)
        [imgView setImage:[UIImage imageNamed:@"youWing.png"]];
    else if(player == player2)
        [imgView setImage:[UIImage imageNamed:@"player2Win.png"]];
    else
        [imgView setImage:[UIImage imageNamed:@"computerWin.png"]];
    
    [self.view addSubview:imgView];
}

@end
