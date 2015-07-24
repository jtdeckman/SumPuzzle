//
//  StatsViewController.h
//  SumPuzzle
//
//  Created by Jason Deckman on 7/22/15.
//  Copyright (c) 2015 JDeckman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatsViewController : UIViewController {
    
    UILabel *titleLabel;
    
    UILabel *elimLabel;
    UILabel *elimP1Label;
    UILabel *elimP2Label;
    UILabel *elimCompLabel;
    UILabel *elimTimeLabel;
    
    UILabel *elimP1Val;
    UILabel *elimP2Val;
    UILabel *elimCompVal;
    UILabel *elimTimeVal;
/*
    UILabel *CFLabel;
    UILabel *CFP1Label;
    UILabel *CFP2Label;
    UILabel *CFCompLabel;
    UILabel *CFTimeLabel;
    
    UILabel *CFP1Val;
    UILabel *CFP2Val;
    UILabel *CFCompVal;
    UILabel *CFTimeVal; */
    
    NSInteger p1Wins, p2Wins, compWins, bestTime;
    NSInteger CFp1Wins, CFp2Wins, CFCompWins, CFBestTime;
}

@end
