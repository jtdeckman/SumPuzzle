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
 
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if(controlItem == computerPlayerControl) {
        if(controlItem.selectedSegmentIndex == 1)
            [defaults setBool:NO forKey:@"computerPlayer"];
        else
            [defaults setBool:YES forKey:@"computerPlayer"];
    }
    
    else if(controlItem == difficultyControl)
        [defaults setInteger:controlItem.selectedSegmentIndex forKey:@"difficulty"];
    
    else if(controlItem == gameModeControl)
        [defaults setBool:controlItem.selectedSegmentIndex forKey:@"captureFlag"];
    
    else if(controlItem == boardSizeControl) {
        
        if(controlItem.selectedSegmentIndex == 0) {
            [defaults setInteger:5 forKey:@"dimx"];
            [defaults setInteger:5 forKey:@"dimy"];
        }
        else{
            [defaults setInteger:6 forKey:@"dimx"];
            [defaults setInteger:6 forKey:@"dimy"];
        }
    }

    else {
    
    }
}

- (void)buttonPressed: (UIButton*)button {

    if(button == backButton) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)setUpControls {
    
    CGRect viewFrame;
    
    CGFloat spcFct = SETTINGS_SPACE_FACT*self.view.frame.size.height;
  //  CGFloat marginFact = 0.4*spcFct;
    
    viewFrame.size.width = 0.275*self.view.frame.size.width;
    viewFrame.size.height = 0.05*self.view.frame.size.height;
    viewFrame.origin.x = (self.view.frame.size.width - viewFrame.size.width)/2.0;// marginFact;
    viewFrame.origin.y = 0.75*spcFct;
    
    playerLabel = [[UILabel alloc] initWithFrame:viewFrame];
    playerLabel.clipsToBounds =YES;
    playerLabel.backgroundColor = [UIColor clearColor];
    playerLabel.textColor = [UIColor whiteColor];
    [playerLabel setTextAlignment:NSTextAlignmentCenter];
    
    [playerLabel setFont:[UIFont fontWithName:@"Arial-ItalicMT" size:1.75*FONT_FACT*viewFrame.size.height]];
    playerLabel.text = @"Player";
    
    [self.view addSubview:playerLabel];
    
    viewFrame.size.width = 0.60*self.view.frame.size.width;
    viewFrame.origin.x = (self.view.frame.size.width - viewFrame.size.width)/2.0;// - marginFact ;//0.25*spcFct + viewFrame.size.width;
    viewFrame.size.height = 0.05*self.view.frame.size.height;
    viewFrame.origin.y += 0.65*spcFct;
    
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
    
   // spcFct += 0.5*viewFrame.size.height;
    
 // Difficulty
    
    viewFrame.origin.x = playerLabel.frame.origin.x;
    viewFrame.origin.y += spcFct;
    viewFrame.size = playerLabel.frame.size;
    
    difficultyLabel = [[UILabel alloc] initWithFrame:viewFrame];
    difficultyLabel.clipsToBounds =YES;
    difficultyLabel.backgroundColor = [UIColor clearColor];
    difficultyLabel.textColor = [UIColor whiteColor];
    [difficultyLabel setTextAlignment:NSTextAlignmentCenter];
    
    [difficultyLabel setFont:[UIFont fontWithName:@"Arial-ItalicMT" size:1.75*FONT_FACT*viewFrame.size.height]];
    difficultyLabel.text = @"Difficulty";
    
    [self.view addSubview:difficultyLabel];
    
    
    viewFrame.size = computerPlayerControl.frame.size;
    viewFrame.origin.x = computerPlayerControl.frame.origin.x;
    viewFrame.origin.y += 0.65*spcFct;
    
    difficultyControl = [[UISegmentedControl alloc] initWithItems:@[@"Standard",@"Advanced"]];
    [difficultyControl setFrame:viewFrame];
    [difficultyControl addTarget:self action:@selector(segmentedControlValueDidChange:) forControlEvents:UIControlEventValueChanged];
    [difficultyControl setTitleTextAttributes:attributes forState:UIControlStateNormal];

    [difficultyControl setSelectedSegmentIndex:diffculty];
    [self.view addSubview:difficultyControl];
    
 // Win settings
   /*
    viewFrame.size = difficultyLabel.frame.size;
    viewFrame.origin.x = difficultyLabel.frame.origin.x;
    viewFrame.origin.y += spcFct;
    
    gameModeLabel = [[UILabel alloc] initWithFrame:viewFrame];
    gameModeLabel.clipsToBounds =YES;
    gameModeLabel.backgroundColor = [UIColor clearColor];
    gameModeLabel.textColor = [UIColor whiteColor];
    [gameModeLabel setTextAlignment:NSTextAlignmentCenter];
    
    [gameModeLabel setFont:[UIFont fontWithName:@"Arial-ItalicMT" size:1.75*FONT_FACT*viewFrame.size.height]];
    gameModeLabel.text = @"Game Mode";
    
    [self.view addSubview:gameModeLabel];
    
    
    viewFrame.size = difficultyControl.frame.size;
    viewFrame.origin.x = difficultyControl.frame.origin.x;
    viewFrame.origin.y += 0.65*spcFct;
    
    gameModeControl = [[UISegmentedControl alloc] initWithItems:@[@"Elimination",@"Capture Flag"]];
    [gameModeControl setFrame:viewFrame];
    [gameModeControl addTarget:self action:@selector(segmentedControlValueDidChange:) forControlEvents:UIControlEventValueChanged];
    [gameModeControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    [gameModeControl setSelectedSegmentIndex:captureFlagMode];
    [self.view addSubview:gameModeControl]; */
    
 // Board Size
    
    viewFrame.size = difficultyLabel.frame.size;
    viewFrame.origin.x = difficultyLabel.frame.origin.x;
    viewFrame.origin.y += spcFct;
    
    boardSizeLabel = [[UILabel alloc] initWithFrame:viewFrame];
    boardSizeLabel.clipsToBounds =YES;
    boardSizeLabel.backgroundColor = [UIColor clearColor];
    boardSizeLabel.textColor = [UIColor whiteColor];
    [boardSizeLabel setTextAlignment:NSTextAlignmentCenter];
    
    [boardSizeLabel setFont:[UIFont fontWithName:@"Arial-ItalicMT" size:1.75*FONT_FACT*viewFrame.size.height]];
    boardSizeLabel.text = @"Board Size";
    
    [self.view addSubview:boardSizeLabel];
    
    
    viewFrame.size = difficultyControl.frame.size;
    viewFrame.origin.x = difficultyControl.frame.origin.x;
    viewFrame.origin.y += 0.65*spcFct;
    
    boardSizeControl = [[UISegmentedControl alloc] initWithItems:@[@"5x5",@"6x6"]];
    [boardSizeControl setFrame:viewFrame];
    [boardSizeControl addTarget:self action:@selector(segmentedControlValueDidChange:) forControlEvents:UIControlEventValueChanged];
    [boardSizeControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
    
    if(dimx == 5)
        [boardSizeControl setSelectedSegmentIndex:0];
    else
        [boardSizeControl setSelectedSegmentIndex:1];
    
    [self.view addSubview:boardSizeControl];

 
 // Back button
    
    viewFrame.size.height = 0.75*spcFct;
    viewFrame.size.width = spcFct;
    viewFrame.origin.x = (self.view.frame.size.width - viewFrame.size.width)/2.0; //0.5*spcFct;
    viewFrame.origin.y = self.view.frame.size.height - 0.5*spcFct - viewFrame.size.height;
    
    backButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [backButton setFrame:viewFrame];
    
    [self.view addSubview:backButton];
    
    backButton.layer.cornerRadius = 5.0;
    backButton.layer.borderColor = [[UIColor whiteColor] CGColor];
    
    [backButton.layer setBorderWidth:0.5f];
    [backButton setTitle:@"OK" forState:UIControlStateNormal];
    
    [backButton.titleLabel setFont:[UIFont fontWithName:@"Arial" size:1.25*FONT_FACT*viewFrame.size.height]];
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
