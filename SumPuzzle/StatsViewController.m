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
    
    JDColor blueColor, goldColor;
    
    blueColor.red = 0.25;
    blueColor.green = 0.55;
    blueColor.blue = 0.9;
    
    goldColor.red = 0.9;
    goldColor.green = 0.5;
    goldColor.blue = 0.3;
    
    [self getData];
    
    self.view.backgroundColor = [UIColor blackColor];
    [self.view sendSubviewToBack:self.view];

    viewFrame.size.width = 0.75*self.view.frame.size.width;
    viewFrame.size.height = 0.1*self.view.frame.size.height;
    viewFrame.origin.x = (self.view.frame.size.width - viewFrame.size.width)/2;// marginFact;
    viewFrame.origin.y = 0.55*spcFct;

    titleLabel = [[UILabel alloc] initWithFrame:viewFrame];
    titleLabel.clipsToBounds =YES;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor lightGrayColor];
    
    [titleLabel setTextAlignment:NSTextAlignmentLeft];
    
    [titleLabel setFont:[UIFont fontWithName:@"Arial-ItalicMT" size:2.0*FONT_FACT*viewFrame.size.height]];
    titleLabel.text = @"Game Stats";
    
    [self.view addSubview:titleLabel];

    
    viewFrame.size.width = 0.5*self.view.frame.size.width;
    viewFrame.size.height = 0.05*self.view.frame.size.height;
    viewFrame.origin.x = (self.view.frame.size.width - viewFrame.size.width)/3.5;// marginFact;
    viewFrame.origin.y = 1.90*spcFct;
    
    
    elimLabel = [[UILabel alloc] initWithFrame:viewFrame];
    elimLabel.clipsToBounds =YES;
    elimLabel.backgroundColor = [UIColor clearColor];
    elimLabel.textColor = [UIColor colorWithRed:blueColor.red green:blueColor.green blue:blueColor.blue alpha:1.0];
    [elimLabel setTextAlignment:NSTextAlignmentLeft];
    
    [elimLabel setFont:[UIFont fontWithName:@"Arial-ItalicMT" size:2.25*FONT_FACT*viewFrame.size.height]];
    elimLabel.text = @"Standard Difficulty";
    
    [self.view addSubview:elimLabel];
    
    viewFrame.size.width = 0.4*self.view.frame.size.width;
    viewFrame.origin.x =  viewFrame.origin.x = (self.view.frame.size.width - viewFrame.size.width)/2.5;
    viewFrame.origin.y += 0.75*spcFct;
    
    elimP1Label = [[UILabel alloc] initWithFrame:viewFrame];
    elimP1Label.clipsToBounds =YES;
    elimP1Label.backgroundColor = [UIColor clearColor];
    elimP1Label.textColor = [UIColor whiteColor];
    [elimP1Label setTextAlignment:NSTextAlignmentLeft];
    
    [elimP1Label setFont:[UIFont fontWithName:@"Arial" size:1.75*FONT_FACT*viewFrame.size.height]];
    elimP1Label.text = [NSString stringWithFormat:@"Your Wins:"];//,(int)p1Wins];

    [self.view addSubview:elimP1Label];

    viewFrame.origin.x += elimP1Label.frame.size.width + 0.05*spcFct;
    viewFrame.size.width = 0.25*elimP1Label.frame.size.width;
    
    elimP1Val = [[UILabel alloc] initWithFrame:viewFrame];
    elimP1Val.clipsToBounds =YES;
    elimP1Val.backgroundColor = [UIColor clearColor];
    elimP1Val.textColor = [UIColor colorWithRed:goldColor.red green:goldColor.green blue:goldColor.blue alpha:1.0];
    [elimP1Val setTextAlignment:NSTextAlignmentRight];
    
    [elimP1Val setFont:[UIFont fontWithName:@"Arial" size:2.0*FONT_FACT*viewFrame.size.height]];
    elimP1Val.text = [NSString stringWithFormat:@"%d",(int)p1Wins];
    
    [self.view addSubview:elimP1Val];
    
    viewFrame.size.width = elimP1Label.frame.size.width;
    viewFrame.origin.x = elimP1Label.frame.origin.x;
    viewFrame.origin.y += 0.5*spcFct;
    
    elimCompLabel = [[UILabel alloc] initWithFrame:viewFrame];
    elimCompLabel.clipsToBounds =YES;
    elimCompLabel.backgroundColor = [UIColor clearColor];
    elimCompLabel.textColor = [UIColor whiteColor];
    [elimCompLabel setTextAlignment:NSTextAlignmentLeft];
    
    [elimCompLabel setFont:[UIFont fontWithName:@"Arial" size:1.75*FONT_FACT*viewFrame.size.height]];
    elimCompLabel.text = [NSString stringWithFormat:@"Computer Wins:"];
    
    [self.view addSubview:elimCompLabel];
    
    viewFrame.origin.x += elimP1Label.frame.size.width + 0.05*spcFct;
    viewFrame.size.width = 0.25*elimP1Label.frame.size.width;
    
    elimCompVal = [[UILabel alloc] initWithFrame:viewFrame];
    elimCompVal.clipsToBounds =YES;
    elimCompVal.backgroundColor = [UIColor clearColor];
    elimCompVal.textColor = [UIColor colorWithRed:goldColor.red green:goldColor.green blue:goldColor.blue alpha:1.0];
    [elimCompVal setTextAlignment:NSTextAlignmentRight];
    
    [elimCompVal setFont:[UIFont fontWithName:@"Arial" size:2.0*FONT_FACT*viewFrame.size.height]];
    elimCompVal.text = [NSString stringWithFormat:@"%d",(int)compWins];
    
    [self.view addSubview:elimCompVal];

    viewFrame.size.width = elimP1Label.frame.size.width;
    viewFrame.origin.x = elimP1Label.frame.origin.x;
    viewFrame.origin.y += 0.5*spcFct;
    
    elimP2Label = [[UILabel alloc] initWithFrame:viewFrame];
    elimP2Label.clipsToBounds =YES;
    elimP2Label.backgroundColor = [UIColor clearColor];
    elimP2Label.textColor = [UIColor whiteColor];
    [elimP2Label setTextAlignment:NSTextAlignmentLeft];
    
    [elimP2Label setFont:[UIFont fontWithName:@"Arial" size:1.75*FONT_FACT*viewFrame.size.height]];
    elimP2Label.text = [NSString stringWithFormat:@"Player 2 Wins:"];
    
    [self.view addSubview:elimP2Label];
    
    viewFrame.origin.x += elimP1Label.frame.size.width + 0.05*spcFct;
    viewFrame.size.width = 0.25*elimP1Label.frame.size.width;
    
    elimP2Val = [[UILabel alloc] initWithFrame:viewFrame];
    elimP2Val.clipsToBounds =YES;
    elimP2Val.backgroundColor = [UIColor clearColor];
    elimP2Val.textColor = [UIColor colorWithRed:goldColor.red green:goldColor.green blue:goldColor.blue alpha:1.0];
    [elimP2Val setTextAlignment:NSTextAlignmentRight];
    
    [elimP2Val setFont:[UIFont fontWithName:@"Arial" size:2.0*FONT_FACT*viewFrame.size.height]];
    elimP2Val.text = [NSString stringWithFormat:@"%d",(int)p2Wins];
    
    [self.view addSubview:elimP2Val];

    viewFrame.size.width = elimP1Label.frame.size.width;
    viewFrame.origin.x = elimP1Label.frame.origin.x;
    viewFrame.origin.y += 0.5*spcFct;
    
    elimTimeLabel= [[UILabel alloc] initWithFrame:viewFrame];
    elimTimeLabel.clipsToBounds =YES;
    elimTimeLabel.backgroundColor = [UIColor clearColor];
    elimTimeLabel.textColor = [UIColor whiteColor];
    [elimTimeLabel setTextAlignment:NSTextAlignmentLeft];
    
    [elimTimeLabel setFont:[UIFont fontWithName:@"Arial" size:1.75*FONT_FACT*viewFrame.size.height]];
    elimTimeLabel.text = [NSString stringWithFormat:@"Best Time:"];
    
    [self.view addSubview:elimTimeLabel];
    
    viewFrame.origin.x += 0.725*elimP1Label.frame.size.width;// + 0.05*spcFct;
    viewFrame.size.width = 0.55*elimP1Label.frame.size.width;
    
    elimTimeVal = [[UILabel alloc] initWithFrame:viewFrame];
    elimTimeVal.clipsToBounds =YES;
    elimTimeVal.backgroundColor = [UIColor clearColor];
    elimTimeVal.textColor = [UIColor colorWithRed:goldColor.red green:goldColor.green blue:goldColor.blue alpha:1.0];
    [elimTimeVal setTextAlignment:NSTextAlignmentRight];
    
    [elimTimeVal setFont:[UIFont fontWithName:@"Arial" size:2.0*FONT_FACT*viewFrame.size.height]];
    
    if(p1Wins > 0)
        elimTimeVal.text = [NSString stringWithFormat:@"%@",[self convertSecondsToHoursMinSec:(uint)bestTime]];
    else
        elimTimeVal.text = @"00:00:00";
                                                                                        
    [self.view addSubview:elimTimeVal];
    
    
 // Capture the flag labels
 
    viewFrame = elimLabel.frame;
    viewFrame.size.width = 0.65*self.view.frame.size.width;
    viewFrame.origin.y = elimTimeVal.frame.origin.y + 1.1*spcFct;
    
    CFLabel = [[UILabel alloc] initWithFrame:viewFrame];
    CFLabel.clipsToBounds =YES;
    CFLabel.backgroundColor = [UIColor clearColor];
    CFLabel.textColor = [UIColor colorWithRed:blueColor.red green:blueColor.green blue:blueColor.blue alpha:1.0];
    [CFLabel setTextAlignment:NSTextAlignmentLeft];
    
    [CFLabel setFont:[UIFont fontWithName:@"Arial-ItalicMT" size:2.25*FONT_FACT*viewFrame.size.height]];
    CFLabel.text = @"Advanced Difficulty";
    
    [self.view addSubview:CFLabel];
    
    viewFrame.size.width = 0.4*self.view.frame.size.width;
    viewFrame.origin.x =  viewFrame.origin.x = (self.view.frame.size.width - viewFrame.size.width)/2.5;
    viewFrame.origin.y += 0.75*spcFct;
    
    CFP1Label = [[UILabel alloc] initWithFrame:viewFrame];
    CFP1Label.clipsToBounds =YES;
    CFP1Label.backgroundColor = [UIColor clearColor];
    CFP1Label.textColor = [UIColor whiteColor];
    [CFP1Label setTextAlignment:NSTextAlignmentLeft];
    
    [CFP1Label setFont:[UIFont fontWithName:@"Arial" size:1.75*FONT_FACT*viewFrame.size.height]];
    CFP1Label.text = [NSString stringWithFormat:@"Your Wins:"];
    
    [self.view addSubview:CFP1Label];
    
    viewFrame.origin.x += CFP1Label.frame.size.width + 0.05*spcFct;
    viewFrame.size.width = 0.25*CFP1Label.frame.size.width;
    
    CFP1Val = [[UILabel alloc] initWithFrame:viewFrame];
    CFP1Val.clipsToBounds =YES;
    CFP1Val.backgroundColor = [UIColor clearColor];
    CFP1Val.textColor = [UIColor colorWithRed:goldColor.red green:goldColor.green blue:goldColor.blue alpha:1.0];
    [CFP1Val setTextAlignment:NSTextAlignmentRight];
    
    [CFP1Val setFont:[UIFont fontWithName:@"Arial" size:2.0*FONT_FACT*viewFrame.size.height]];
    CFP1Val.text = [NSString stringWithFormat:@"%d",(int)CFp1Wins];
    
    [self.view addSubview:CFP1Val];
    
    viewFrame.size.width = CFP1Label.frame.size.width;
    viewFrame.origin.x = CFP1Label.frame.origin.x;
    viewFrame.origin.y += 0.5*spcFct;
    
    CFCompLabel = [[UILabel alloc] initWithFrame:viewFrame];
    CFCompLabel.clipsToBounds =YES;
    CFCompLabel.backgroundColor = [UIColor clearColor];
    CFCompLabel.textColor = [UIColor whiteColor];
    [CFCompLabel setTextAlignment:NSTextAlignmentLeft];
    
    [CFCompLabel setFont:[UIFont fontWithName:@"Arial" size:1.75*FONT_FACT*viewFrame.size.height]];
    CFCompLabel.text = [NSString stringWithFormat:@"Computer Wins:"];
    
    [self.view addSubview:CFCompLabel];
    
    viewFrame.origin.x += CFP1Label.frame.size.width + 0.05*spcFct;
    viewFrame.size.width = 0.25*CFP1Label.frame.size.width;
    
    CFCompVal = [[UILabel alloc] initWithFrame:viewFrame];
    CFCompVal.clipsToBounds =YES;
    CFCompVal.backgroundColor = [UIColor clearColor];
    CFCompVal.textColor = [UIColor colorWithRed:goldColor.red green:goldColor.green blue:goldColor.blue alpha:1.0];
    [CFCompVal setTextAlignment:NSTextAlignmentRight];
    
    [CFCompVal setFont:[UIFont fontWithName:@"Arial" size:2.0*FONT_FACT*viewFrame.size.height]];
    CFCompVal.text = [NSString stringWithFormat:@"%d",(int)CFCompWins];
    
    [self.view addSubview:CFCompVal];
    
    viewFrame.size.width = CFP1Label.frame.size.width;
    viewFrame.origin.x = CFP1Label.frame.origin.x;
    viewFrame.origin.y += 0.5*spcFct;
    
    CFP2Label = [[UILabel alloc] initWithFrame:viewFrame];
    CFP2Label.clipsToBounds =YES;
    CFP2Label.backgroundColor = [UIColor clearColor];
    CFP2Label.textColor = [UIColor whiteColor];
    [CFP2Label setTextAlignment:NSTextAlignmentLeft];
    
    [CFP2Label setFont:[UIFont fontWithName:@"Arial" size:1.75*FONT_FACT*viewFrame.size.height]];
    CFP2Label.text = [NSString stringWithFormat:@"Player 2 Wins:"];
    
    [self.view addSubview:CFP2Label];
    
    viewFrame.origin.x += CFP1Label.frame.size.width + 0.05*spcFct;
    viewFrame.size.width = 0.25*CFP1Label.frame.size.width;
    
    CFP2Val = [[UILabel alloc] initWithFrame:viewFrame];
    CFP2Val.clipsToBounds =YES;
    CFP2Val.backgroundColor = [UIColor clearColor];
    CFP2Val.textColor = [UIColor colorWithRed:goldColor.red green:goldColor.green blue:goldColor.blue alpha:1.0];
    [CFP2Val setTextAlignment:NSTextAlignmentRight];
    
    [CFP2Val setFont:[UIFont fontWithName:@"Arial" size:2.0*FONT_FACT*viewFrame.size.height]];
    CFP2Val.text = [NSString stringWithFormat:@"%d",(int)CFp2Wins];
    
    [self.view addSubview:CFP2Val];
    
    viewFrame.size.width = CFP1Label.frame.size.width;
    viewFrame.origin.x = CFP1Label.frame.origin.x;

    viewFrame.origin.y += 0.5*spcFct;
    
    CFTimeLabel= [[UILabel alloc] initWithFrame:viewFrame];
    CFTimeLabel.clipsToBounds =YES;
    CFTimeLabel.backgroundColor = [UIColor clearColor];
    CFTimeLabel.textColor = [UIColor whiteColor];
    [CFTimeLabel setTextAlignment:NSTextAlignmentLeft];
    
    [CFTimeLabel setFont:[UIFont fontWithName:@"Arial" size:1.75*FONT_FACT*viewFrame.size.height]];
    CFTimeLabel.text = [NSString stringWithFormat:@"Best Time:"];
    
    [self.view addSubview:CFTimeLabel];
    
    viewFrame.origin.x += 0.725*CFP1Label.frame.size.width;
    viewFrame.size.width = 0.55*CFP1Label.frame.size.width;
    
    CFTimeVal = [[UILabel alloc] initWithFrame:viewFrame];
    CFTimeVal.clipsToBounds =YES;
    CFTimeVal.backgroundColor = [UIColor clearColor];
    CFTimeVal.textColor = [UIColor colorWithRed:goldColor.red green:goldColor.green blue:goldColor.blue alpha:1.0];
    [CFTimeVal setTextAlignment:NSTextAlignmentRight];
    
    [CFTimeVal setFont:[UIFont fontWithName:@"Arial" size:2.0*FONT_FACT*viewFrame.size.height]];
    
    if(CFp1Wins > 0)
        CFTimeVal.text = [NSString stringWithFormat:@"%@",[self convertSecondsToHoursMinSec:(uint)CFBestTime]];
    else
        CFTimeVal.text = @"00:00:00";
    
    [self.view addSubview:CFTimeVal];
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
