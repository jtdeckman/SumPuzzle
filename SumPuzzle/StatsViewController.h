//
//  StatsViewController.h
//  SumPuzzle
//
//  Created by Jason Deckman on 7/22/15.
//  Copyright (c) 2015 JDeckman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatsViewController : UIViewController {
    
    UILabel *elimLabel;
    UILabel *elimP1Label;
    UILabel *elimP2Label;
    UILabel *elimCompLabel;
    UILabel *elimTimeLabel;
    
    UILabel *CFLabel;
    UILabel *CFP1Label;
    UILabel *CFP2Label;
    UILabel *CFCompLabel;
    UILabel *CFTimeLabel;
    
    NSInteger p1Wins, p2Wins, compWins, bestTime;
    NSInteger CFp1Wins, CFp2Wins, CFCompWins, CFBestTime;
}

@end
