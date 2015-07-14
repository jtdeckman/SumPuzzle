//
//  SettingsViewController.m
//  SumPuzzle
//
//  Created by Jason Deckman on 7/14/15.
//  Copyright (c) 2015 JDeckman. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

- (void)loadData {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    dimx = (int)[defaults integerForKey:@"dimx"];
    dimy = (int)[defaults integerForKey:@"dimy"];
    
    computerPlayer = [defaults boolForKey:@"computerPlayer"];
    captureFlagMode = [defaults boolForKey:@"captureFlag"];
                       
    startValue = (int)[defaults integerForKey:@"startValue"];
    tileValue = (int)[defaults integerForKey:@"tileValue"];
    tileInc = (int)[defaults integerForKey:@"tileInc"];
    
    diffculty = (NSUInteger)[defaults integerForKey:@"difficulty"];
    
    [defaults synchronize];
}

@end
