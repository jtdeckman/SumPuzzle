//
//  ViewController.m
//  SumPuzzle
//
//  Created by Jason Deckman on 5/19/15.
//  Copyright (c) 2015 JDeckman. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
   
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setUpButtons];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

- (void)buttonPressed: (UIButton*)button {
    
    gameViewController = [[GameViewController alloc] init];
    
    [self presentViewController:gameViewController animated:YES completion:nil];
    
}
- (void)setUpButtons {
    
    CGFloat fWidth = self.view.frame.size.width;
    CGFloat fHeight = self.view.frame.size.height;
    
    CGFloat bWidth = 1.25*BUTTON_WIDTH_FACT*fWidth;
    CGFloat bHeight = BUTTON_HEIGHT_FACT*fHeight;
    
    CGFloat spacing = BUTTON_SPACING_FACT*fWidth;
    
    CGFloat fontSize = 0.5*FONT_FACT*bHeight;
    
    CGPoint center, origin;
    
    center.x = fWidth/2.0;
    center.y = fHeight/2.0;
    
    // New Game button
    
    origin.x = center.x - bWidth/2.0;
    origin.y = center.y + bHeight/2.0 + spacing; //- bHeight/2.0 - spacing;
    
    newGameButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    newGameButton.frame = CGRectMake(origin.x, origin.y, bWidth, bHeight);
    
    [self.view addSubview:newGameButton];
    
    newGameButton.layer.cornerRadius = 5.0;
    newGameButton.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    //  [newGameButton setBackgroundColor:[UIColor lightGrayColor]];
    
    [newGameButton.layer setBorderWidth:1.0f];
    [newGameButton setTitle:@"New Game" forState:UIControlStateNormal];
    
    [newGameButton.titleLabel setFont:[UIFont fontWithName:@"Arial" size:fontSize]];
    [newGameButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [newGameButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    newGameButton.hidden = false;
}

@end
