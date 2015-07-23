//
//  HowToViewController.m
//  SumPuzzle
//
//  Created by Jason Deckman on 7/22/15.
//  Copyright (c) 2015 JDeckman. All rights reserved.
//

#import "HowToViewController.h"

@interface HowToViewController ()

@end

@implementation HowToViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIImageView *howToScreen = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"howToPlay.png"]];
    
    howToScreen.frame = self.view.frame;
    howToScreen.alpha = 1.0;
    howToScreen.hidden = NO;
    
    [self.view addSubview:howToScreen];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)prefersStatusBarHidden {
    
    return YES;
}

@end
