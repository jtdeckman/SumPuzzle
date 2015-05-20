//
//  Space.m
//  SumPuzzle
//
//  Created by Jason Deckman on 5/19/15.
//  Copyright (c) 2015 JDeckman. All rights reserved.
//

#import "Space.h"

@implementation Space

@synthesize value, isOccupied, isTarget, piece, spaceFrame;
@synthesize nnbrs, iind, jind, player;

- (void)initSpace : (int)ii : (int)ji : (CGRect)spaceFrm : (CGRect)labelframe {
    
    iind = ii;
    jind = ji;
    
    isOccupied = NO;
    isTarget = NO;
    
    spaceFrame = spaceFrm;
    
    piece = [[UILabel alloc] initWithFrame:labelframe];
    piece.hidden = YES;
    piece.layer.cornerRadius = 3.0;
    piece.clipsToBounds = YES;
    
    [piece setTextAlignment:NSTextAlignmentCenter];
    [piece setFont:[UIFont fontWithName:@"Arial" size:FONT_FACT*spaceFrame.size.width]];
    
    for(int i=0; i<4; i++)
        nbrs[i][0] = -1;
    
    nnbrs = 0;
}

- (void)setColor: (CGFloat)red : (CGFloat)green : (CGFloat)blue : (CGFloat)alpha {
    
    color.red = red;
    color.green = green;
    color.blue = blue;
}

- (void)configurePiece {
    
    piece.text = [NSString stringWithFormat:@"%d", value];
    piece.backgroundColor = [UIColor colorWithRed:color.red green:color.green blue:color.blue alpha:1.0];
    piece.textColor = [UIColor whiteColor];
    piece.layer.borderColor = [[UIColor colorWithRed:color.red green:color.green blue:color.blue alpha:1.0] CGColor];
    piece.layer.borderWidth = 5.0f;
}

- (void)addNbr: (int)i : (int)j {
    
    if(nnbrs < 4) {
        nbrs[nnbrs][0] = i;
        nbrs[nnbrs][1] = j;
        ++nnbrs;
    }
}

- (void)getNbrIndices: (int)nbr : (int*)inbr : (int*)jnbr {
    
    *inbr = nbrs[nbr][0];
    *jnbr = nbrs[nbr][1];
}

@end
