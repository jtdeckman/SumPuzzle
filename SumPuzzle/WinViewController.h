//
//  WinViewController.h
//  SumPuzzle
//
//  Created by Jason Deckman on 7/21/15.
//  Copyright (c) 2015 JDeckman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface WinViewController : UIViewController {
    
    UIImageView *imgView;
}

- (void)initView: (Player)player;

@end
