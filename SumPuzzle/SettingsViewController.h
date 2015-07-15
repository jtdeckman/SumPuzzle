//
//  SettingsViewController.h
//  SumPuzzle
//
//  Created by Jason Deckman on 7/14/15.
//  Copyright (c) 2015 JDeckman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface SettingsViewController : UIViewController {
    
    int dimx, dimy;
    
    int startValue;
    int tileValue;
    int tileInc;

    BOOL computerPlayer;
    BOOL captureFlagMode;
    
    Difficulty diffculty;
    
    UISegmentedControl *computerPlayerControl;
    UISegmentedControl *gameModeControl;
    UISegmentedControl *difficultyControl;
    UISegmentedControl *boardSizeControl;
    
    UIButton *backButton;
    
    UILabel *playerLabel;
    UILabel *difficultyLabel;
    UILabel *winModeLabel;
    UILabel *boardSizeLabel;
}

@end
