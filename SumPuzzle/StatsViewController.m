//
//  StatsViewController.m
//  SumPuzzle
//
//  Created by Jason Deckman on 7/22/15.
//  Copyright (c) 2015 JDeckman. All rights reserved.
//

#import "StatsViewController.h"
#import "Constants.h"

#define SPACE_FACT 0.1

@interface StatsViewController ()

@end

@implementation StatsViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setUpLabels];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)setUpLabels {

    CGRect viewFrame;
    
    CGFloat spcFct = SPACE_FACT*self.view.frame.size.height;
    
    JDColor blueColor;
    
    blueColor.red = 0.2;
    blueColor.green = 0.1;
    blueColor.blue = 0.9;
    
    [self getData];
    
    self.view.backgroundColor = [UIColor blackColor];
    [self.view sendSubviewToBack:self.view];

    viewFrame.size.width = 0.5*self.view.frame.size.width;
    viewFrame.size.height = 0.05*self.view.frame.size.height;
    viewFrame.origin.x = (self.view.frame.size.width - viewFrame.size.width)/4.0;// marginFact;
    viewFrame.origin.y = 1.75*spcFct;
    
    elimLabel = [[UILabel alloc] initWithFrame:viewFrame];
    elimLabel.clipsToBounds =YES;
    elimLabel.backgroundColor = [UIColor clearColor];
    elimLabel.textColor = [UIColor colorWithRed:blueColor.red green:blueColor.green blue:blueColor.blue alpha:1.0];
    [elimLabel setTextAlignment:NSTextAlignmentCenter];
    
    [elimLabel setFont:[UIFont fontWithName:@"Helvetica" size:2.25*FONT_FACT*viewFrame.size.height]];
    elimLabel.text = @"Elimination Mode:";
    
    [self.view addSubview:elimLabel];
    
    viewFrame.size.width = 0.55*self.view.frame.size.width;
    viewFrame.origin.x =  viewFrame.origin.x = (self.view.frame.size.width - viewFrame.size.width)/2.0;
    viewFrame.origin.y += 0.75*spcFct;
    
    elimP1Label = [[UILabel alloc] initWithFrame:viewFrame];
    elimP1Label.clipsToBounds =YES;
    elimP1Label.backgroundColor = [UIColor clearColor];
    elimP1Label.textColor = [UIColor whiteColor];
    [elimP1Label setTextAlignment:NSTextAlignmentLeft];
    
    [elimP1Label setFont:[UIFont fontWithName:@"Arial-ItalicMT" size:1.75*FONT_FACT*viewFrame.size.height]];
    elimP1Label.text = [NSString stringWithFormat:@"Your Wins:                   %d",(int)p1Wins];

    [self.view addSubview:elimP1Label];

    viewFrame.origin.y += 0.5*spcFct;
    
    elimCompLabel = [[UILabel alloc] initWithFrame:viewFrame];
    elimCompLabel.clipsToBounds =YES;
    elimCompLabel.backgroundColor = [UIColor clearColor];
    elimCompLabel.textColor = [UIColor whiteColor];
    [elimCompLabel setTextAlignment:NSTextAlignmentLeft];
    
    [elimCompLabel setFont:[UIFont fontWithName:@"Arial-ItalicMT" size:1.75*FONT_FACT*viewFrame.size.height]];
    elimCompLabel.text = [NSString stringWithFormat:@"Computer Wins:          %d",(int)compWins];
    
    [self.view addSubview:elimCompLabel];
    
    viewFrame.origin.y += 0.5*spcFct;
    
    elimP2Label = [[UILabel alloc] initWithFrame:viewFrame];
    elimP2Label.clipsToBounds =YES;
    elimP2Label.backgroundColor = [UIColor clearColor];
    elimP2Label.textColor = [UIColor whiteColor];
    [elimP2Label setTextAlignment:NSTextAlignmentLeft];
    
    [elimP2Label setFont:[UIFont fontWithName:@"Arial-ItalicMT" size:1.75*FONT_FACT*viewFrame.size.height]];
    elimP2Label.text = [NSString stringWithFormat:@"Player 2 Wins:            %d",(int)p2Wins];
    
    [self.view addSubview:elimP2Label];
    
    viewFrame.origin.y += 0.5*spcFct;
    
    elimTimeLabel= [[UILabel alloc] initWithFrame:viewFrame];
    elimTimeLabel.clipsToBounds =YES;
    elimTimeLabel.backgroundColor = [UIColor clearColor];
    elimTimeLabel.textColor = [UIColor whiteColor];
    [elimTimeLabel setTextAlignment:NSTextAlignmentLeft];
    
    [elimTimeLabel setFont:[UIFont fontWithName:@"Arial-ItalicMT" size:1.75*FONT_FACT*viewFrame.size.height]];
    
    if(p1Wins > 0)
        elimTimeLabel.text = [NSString stringWithFormat:@"Best Time:                 %@s",[self convertSecondsToHoursMinSec:(uint)bestTime]];
    else
        elimTimeLabel.text = [NSString stringWithFormat:@"Best Time:                 --"];
    
    [self.view addSubview:elimTimeLabel];
  }

- (void)getData {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    p1Wins = [defaults integerForKey:@"nP1Wins"];
    p2Wins = [defaults integerForKey:@"nP2Wins"];
    compWins = [defaults integerForKey:@"nCompWins"];
    bestTime = [defaults integerForKey:@"bestTime"];
    
    CFp1Wins = [defaults integerForKey:@"nP1WinsCF"];
    CFp2Wins = [defaults integerForKey:@"nP2WinsCF"];
    CFCompWins = [defaults integerForKey:@"nCompWinsCF"];
    CFBestTime = [defaults integerForKey:@"bestTimeCF"];
 
    [defaults synchronize];
}

- (NSString*)convertSecondsToHoursMinSec:(uint)nSeconds {
    
    NSString *timeVal = @"";
    
    uint min, sec;
    
    min = (int)(nSeconds/60);
    sec = nSeconds % 60;
    
    if(min < 10) {
        if(sec < 10)
            timeVal = [NSString stringWithFormat:@"0%d:0%d",min,sec];
        else
            timeVal = [NSString stringWithFormat:@"0%d:%d",min,sec];
    }
    else {
        if(sec < 10)
            timeVal = [NSString stringWithFormat:@"%d:0%d",min,sec];
        else
            timeVal = [NSString stringWithFormat:@"%d:%d",min,sec];
    }
    
    return timeVal;
}

- (BOOL)prefersStatusBarHidden {
    
    return YES;
}

@end
