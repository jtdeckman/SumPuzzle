//
//  Space.h
//  SumPuzzle
//
//  Created by Jason Deckman on 5/19/15.
//  Copyright (c) 2015 JDeckman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import <UIKit/UIKit.h>

@interface Space : NSObject {
    
    int value;
    int iind;
    int jind;
    
    int nbrs[4][2];
    int nnbrs;
    
    BOOL isOccupied;
    BOOL isTarget;
    
    CGRect spaceFrame;
    
    UILabel *piece;
    
    JDColor color;
}

@property (nonatomic) int value;
@property (nonatomic) int iind;
@property (nonatomic) int jind;
@property (nonatomic) int nnbrs;

@property (nonatomic) CGRect spaceFrame;

@property (nonatomic) BOOL isOccupied;
@property (nonatomic) BOOL isTarget;

@property (nonatomic, strong) UILabel *piece;

- (void)initSpace: (int)ii : (int)ji : (CGRect)spaceFrm : (CGRect)labelframe;
- (void)setColor: (CGFloat)red : (CGFloat)green : (CGFloat)blue : (CGFloat)alpha;
- (void)configurePiece;
- (void)addNbr: (int)i : (int)j;
- (void)getNbrIndices: (int)nbr : (int*)inbr : (int*)jnbr;

@end
