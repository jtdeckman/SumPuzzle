//
//  Space.m
//  SumPuzzle
//
//  Created by Jason Deckman on 5/19/15.
//  Copyright (c) 2015 JDeckman. All rights reserved.
//

#import "Space.h"

@implementation Space

@synthesize value, isOccupied, piece, spaceFrame, player;
@synthesize iind, jind, neighbors, isHighlighted, isSelected;
@synthesize nearestNbrs;

- (void)initSpace : (int)ii : (int)ji : (CGRect)spaceFrm : (CGRect)labelframe {
    
    iind = ii;
    jind = ji;
    
    isOccupied = NO;
    isHighlighted = NO;
    isSelected = NO;
    
    spaceFrame = spaceFrm;
    
    player = notAssigned;
    
    piece = [[UILabel alloc] initWithFrame:labelframe];
    piece.hidden = YES;
    piece.layer.cornerRadius = 5.0;
    piece.clipsToBounds = YES;
    piece.opaque = NO;
    
    [piece setTextAlignment:NSTextAlignmentCenter];
    [piece setFont:[UIFont fontWithName:@"Arial" size:1.15*FONT_FACT*spaceFrame.size.width]];
    
    nearestNbrs = [[NSMutableSet alloc] initWithCapacity:4];
    neighbors = [[NSMutableSet alloc] initWithCapacity:10];
    
    p1Img = [UIImage imageNamed:@"blueSquare.png"];
    p2Img = [UIImage imageNamed:@"orangeSquare.png"];
    
}

- (void)setColor: (CGFloat)red : (CGFloat)green : (CGFloat)blue : (CGFloat)alpha {
    
    color.red = red;
    color.green = green;
    color.blue = blue;
}

- (void)configurePiece {
    
    UIImage *img;
    
    if(player == player1)
        img = p1Img;
    else
        img = p2Img;
    
    CGSize imgSize = piece.frame.size;
    UIGraphicsBeginImageContext(imgSize);
    [img drawInRect:CGRectMake(0,0,imgSize.width,imgSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    piece.text = [NSString stringWithFormat:@"%d", value];
    piece.backgroundColor = [UIColor colorWithPatternImage:newImage];
 
    // piece.backgroundColor = [UIColor colorWithRed:color.red green:color.green blue:color.blue alpha:1.0];
    piece.textColor = [UIColor whiteColor];
    piece.layer.borderColor = [[UIColor clearColor] CGColor];
   // piece.layer.borderColor = [[UIColor colorWithRed:color.red green:color.green blue:color.blue alpha:1.0] CGColor];
  //  piece.layer.borderWidth = 2.0f;
}

- (void)highlightPiece {
    
    piece.layer.borderColor = [[UIColor whiteColor] CGColor];
    
}

- (void)unHighlightPiece {
    
    piece.layer.borderColor = [[UIColor colorWithRed:color.red green:color.green blue:color.blue alpha:1.0] CGColor];
}

- (int)numSelPieces {
    
    int numSel = 0;
    
    for(Space* item in neighbors) {
        if(item.isSelected) ++numSel;
    }
    
    return numSel;
}

- (bool)isNearestNearestNbrOf: (Space*)space {

    if([nearestNbrs containsObject:space]) return YES;
    
    return NO;
}

@end
