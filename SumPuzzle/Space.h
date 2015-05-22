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
    
    BOOL isOccupied;
    BOOL isHighlighted;
    BOOL isSelected;
    
    NSMutableSet *nearestNbrs;
    NSMutableSet *neighbors;
    
    CGRect spaceFrame;
    
    UILabel *piece;
    
    JDColor color;
    
    Player player;
}

@property (nonatomic) int value;
@property (nonatomic) int iind;
@property (nonatomic) int jind;

@property (nonatomic) CGRect spaceFrame;

@property (nonatomic) BOOL isOccupied;
@property (nonatomic) BOOL isHighlighted;
@property (nonatomic) BOOL isSelected;

@property (nonatomic) Player player;

@property (nonatomic, strong) UILabel *piece;
@property (nonatomic, strong) NSMutableSet *neighbors;
@property (nonatomic, strong) NSMutableSet *nearestNbrs;

- (void)initSpace: (int)ii : (int)ji : (CGRect)spaceFrm : (CGRect)labelframe;
- (void)setColor: (CGFloat)red : (CGFloat)green : (CGFloat)blue : (CGFloat)alpha;
- (void)configurePiece;

- (void)highlightPiece;
- (void)unHighlightPiece;

- (int)numSelPieces;

@end
