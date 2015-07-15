//
//  SettingsViewController.m
//  SumPuzzle
//
//  Created by Jason Deckman on 7/14/15.
//  Copyright (c) 2015 JDeckman. All rights reserved.
//

#import "SettingsViewController.h"

#define SETTINGS_SPACE_FACT 0.1

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self loadData];
    [self setUpViewController];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
}

- (void)loadData {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setBool:NO forKey:@"settingsChanged"];
    
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

- (void)segmentedControlValueDidChange : (UISegmentedControl*)controlItem {
    
}

- (void)buttonPressed: (UIButton*)button {

    if(button == backButton) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)setUpControls {
    
    CGRect viewFrame;
    
    CGFloat spcFct = SETTINGS_SPACE_FACT*self.view.frame.size.height;
    CGFloat marginFact = 0.5*spcFct;
    
    viewFrame.size.width = 0.35*self.view.frame.size.width;
    viewFrame.size.height = 0.05*self.view.frame.size.height;
    viewFrame.origin.x = marginFact;
    viewFrame.origin.y = spcFct;
    
    playerLabel = [[UILabel alloc] initWithFrame:viewFrame];
    playerLabel.clipsToBounds =YES;
    playerLabel.backgroundColor = [UIColor clearColor];
    playerLabel.textColor = [UIColor whiteColor];
   // [playerLabel setTextAlignment:NSTextAlignmentCenter];
    
    [playerLabel setFont:[UIFont fontWithName:@"Arial" size:2.0*FONT_FACT*viewFrame.size.height]];
    playerLabel.text = @"Player:";
    
    [self.view addSubview:playerLabel];
    
    viewFrame.size.width = 0.55*self.view.frame.size.width;
    viewFrame.origin.x = self.view.frame.size.width - viewFrame.size.width - marginFact ;//0.25*spcFct + viewFrame.size.width;
    viewFrame.size.height = 0.05*self.view.frame.size.height;
 //   viewFrame.origin.x = (self.view.frame.size.width - viewFrame.size.width)/2.0;
   

    
    UIFont *font = [UIFont fontWithName:@"Arial" size:1.5*FONT_FACT*viewFrame.size.height];
    NSDictionary *attributes = [NSDictionary dictionaryWithObject:font
                                                           forKey:NSFontAttributeName];
    
    computerPlayerControl = [[UISegmentedControl alloc] initWithItems:@[@"Computer",@"Two Player"]];
    [computerPlayerControl setFrame:viewFrame];
    [computerPlayerControl addTarget:self action:@selector(segmentedControlValueDidChange:) forControlEvents:UIControlEventValueChanged];
    [computerPlayerControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    if(computerPlayer)
        [computerPlayerControl setSelectedSegmentIndex:0];
    else
        [computerPlayerControl setSelectedSegmentIndex:1];
    
    [self.view addSubview:computerPlayerControl];
    
    spcFct += viewFrame.size.height;
    
    
 // Back button
    
    viewFrame.size.height = 0.5*spcFct;
    viewFrame.size.width = spcFct;
    viewFrame.origin.x = 0.5*spcFct;
    viewFrame.origin.y = self.view.frame.size.height - 0.5*spcFct - viewFrame.size.height;
    
    backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backButton setFrame:viewFrame];
    
    [self.view addSubview:backButton];
    
    backButton.layer.cornerRadius = 5.0;
    backButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    [backButton.layer setBorderWidth:1.0f];
    [backButton setTitle:@"Back" forState:UIControlStateNormal];
    
    [backButton.titleLabel setFont:[UIFont fontWithName:@"Arial" size:FONT_FACT*viewFrame.size.height]];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [backButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    backButton.hidden = false;
}

- (void)setUpViewController {

    self.view.backgroundColor = [UIColor blackColor];
    
    [self setUpControls];
}

- (BOOL)prefersStatusBarHidden {

    return YES;
}

@end
