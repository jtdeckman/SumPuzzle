//
//  Board.m
//  SumPuzzle
//
//  Created by Jason Deckman on 5/19/15.
//  Copyright (c) 2015 JDeckman. All rights reserved.
//

#import "Board.h"

@implementation Board

@synthesize selectedSpace;

- (void)initBoard: (CGRect)bvFrame : (int)dx : (int)dy : (CGFloat)offset {
    
    NSMutableArray *row;
    
    Space *newSpace;
    
    CGFloat os2 = offset/2.0;
    CGFloat xini, yini;
    
    CGRect spcFrm, pcFrm;
    
    dimx = dx;
    dimy = dy;
    
    numSpaces = dimx*dimy;
    
    spaceWidth = (bvFrame.size.width - offset)/(CGFloat)dx;
    spaceHeight = (bvFrame.size.height - offset)/(CGFloat)dy;
    
    pieceWidth = spaceWidth - offset;
    pieceHeight = spaceHeight - offset;
    
    spcFrm.size.width = spaceWidth;
    spcFrm.size.height = spaceHeight;
    
    pcFrm.size.width = pieceWidth;
    pcFrm.size.height = pieceHeight;
    
    spaces = [[NSMutableArray alloc] initWithCapacity:dimx];
    
    xini = os2;
    yini = os2;
    
    for(int i=0; i<dimx; i++) {
        
        row = [[NSMutableArray alloc] initWithCapacity:dimy];
        
        for(int j=0; j<dimy; j++) {
            
            spcFrm.origin.x = xini + j*spaceWidth;
            spcFrm.origin.y = yini + i*spaceHeight;
            
            pcFrm.origin.x = spcFrm.origin.x + os2;
            pcFrm.origin.y = spcFrm.origin.y;// + os2;
            
            newSpace = [[Space alloc] init];
            
            [newSpace initSpace:i :j :spcFrm :pcFrm];
            
            [row addObject:newSpace];
        }
        
        [spaces addObject:row];
    }
    
    [self findNeighbors];
}


- (void)findNeighbors {
    
    Space *space;
    
    int inbr, jnbr;
    
    for(int i=0; i<dimx; i++) {
        for(int j=0; j<dimy; j++) {
            
            space = [self getSpaceForIndices:i :j];
            
            inbr = i-1;
            jnbr = j;
            
            if(inbr > -1) {
                [space.nearestNbrs addObject:[self getSpaceForIndices:inbr :jnbr]];
                [space.neighbors addObject:[self getSpaceForIndices:inbr :jnbr]];
            }
            
            inbr = i+1;
            if(inbr < dimy) {
                [space.nearestNbrs addObject:[self getSpaceForIndices:inbr :jnbr]];
                [space.neighbors addObject:[self getSpaceForIndices:inbr :jnbr]];
            }
            
            inbr = i;
            jnbr = j-1;
            if(jnbr > -1) {
                [space.nearestNbrs addObject:[self getSpaceForIndices:inbr :jnbr]];
                [space.neighbors addObject:[self getSpaceForIndices:inbr :jnbr]];
            }
            
            jnbr = j+1;
            if(jnbr < dimx) {
                [space.nearestNbrs addObject:[self getSpaceForIndices:inbr :jnbr]];
                [space.neighbors addObject:[self getSpaceForIndices:inbr :jnbr]];
            }
            
            inbr = i-1;
            jnbr = j-1;
            if(inbr > -1 && jnbr > -1)
                [space.neighbors addObject:[self getSpaceForIndices:inbr :jnbr]];
            
            jnbr = j+1;
            if(inbr > -1 && jnbr < dimx)
                [space.neighbors addObject:[self getSpaceForIndices:inbr :jnbr]];
            
            inbr = i+1;
            if(inbr < dimy && jnbr < dimx)
                [space.neighbors addObject:[self getSpaceForIndices:inbr :jnbr]];
            
            jnbr = j-1;
            if(inbr < dimy && jnbr > -1)
                [space.neighbors addObject:[self getSpaceForIndices:inbr :jnbr]];
        }
    }
}

- (void)addPiece: (int)ii : (int)ji : (int)val : (Player)plyr : (JDColor)clr {
    
    Space *space = spaces[ii][ji];
    
    space.isOccupied = YES;
    space.value = val;
    
    space.player = plyr;
    
    [space setColor:clr.red :clr.green :clr.blue :1.0f];
    [space configurePiece];
    
    space.piece.hidden = false;
}

- (Space*)getSpaceForIndices: (int)ii : (int)ji {
    
    return spaces[ii][ji];
}

- (Space*)getSpaceFromPoint: (CGPoint)loc {
    
    Space *space;
    
    for(int i=0; i<dimx; i++) {
        for(int j=0; j<dimy; j++) {
            
            space = spaces[i][j];
            
            if((loc.x >= space.spaceFrame.origin.x && loc.x < space.spaceFrame.origin.x + space.spaceFrame.size.width) && (loc.y >= space.spaceFrame.origin.y && loc.y < space.spaceFrame.origin.y + space.spaceFrame.size.height)) return space;
        }
    }
    
    return NULL;
}

- (int)nbrNearestOccupied: (Space*)space : (Player)plyr{
    
    int nocc = 0;
    
    if(space != nil)
        for(Space* item in space.nearestNbrs)
            if(item.isOccupied && item.player == plyr) ++nocc;
    
    return nocc;
}

- (int)nbrOccupied: (Space*)space : (Player)plyr {
    
    int nocc = 0;
    
    if(space != nil)
        for(Space* item in space.neighbors)
            if(item.isOccupied && item.player == plyr) ++nocc;
    
    return nocc;
}
- (int)numberOfNearestOppPieces: (Space*)space {

    int nocc = 0;
    
    if(space != nil)
        for(Space* item in space.nearestNbrs)
            if(item.isOccupied && item.player != space.player && item.value <= space.value) ++nocc;
    
    return nocc;
}

- (void)highlightOppPieces: (Space*)space {
    
    int count = 0;
    
    if(space != nil) {
        for(Space* item in space.nearestNbrs) {
            if(item.isOccupied && item.player != space.player && item.value <= space.value) {
                item.isHighlighted = YES;
                item.isSelected = NO;
                [item highlightPiece];
                ++count;
                if(count >= 8) break;
            }
        }
    }
    
    selectedSpace = space;
}

- (void)overTakeSpace: (Space*)space : (Player)plyr : (JDColor)clr {
    
    if(space != nil) {
        space.value = selectedSpace.value - space.value;
        space.player = plyr;
        [space setColor:clr.red :clr.green :clr.blue :1.0f];
        [space configurePiece];
    }
}
- (int)sumNbrs: (Space*)space {
    
    int sum = 0;
    
    for(Space* item in space.neighbors) {
        if(item.isOccupied && item.isSelected)
            sum += item.value;
    }
    
    return sum;
}

- (void)clearSelectedSpace {
    
    if(selectedSpace != nil) {
        
        for(Space* item in selectedSpace.neighbors) {
            item.isHighlighted = NO;
            item.isSelected = NO;
            [item unHighlightPiece];
        }
        
        selectedSpace = nil;
    }
}

- (void)highlightNeighbors: (Space*)space : (Player)plyr{
    
    int count = 0;
    
    if(space != nil) {
        for(Space* item in space.neighbors) {
            if(item.isOccupied && item.player == plyr) {
                item.isHighlighted = YES;
                item.isSelected = NO;
                [item highlightPiece];
                ++count;
                if(count >= 8) break;
            }
        }
    }
    
    selectedSpace = space;
}

- (int)numSelected {
    
    int count = 0;
    
    if(selectedSpace != nil) {
        for(Space* item in selectedSpace.neighbors)
            if(item.isSelected) ++ count;
    }
    
    return count;
}

- (void)addPieceToSelectedSpace: (JDColor)clr : (Player)plyr {
    
    selectedSpace.isOccupied = YES;
    
    selectedSpace.value = [self sumNbrs:selectedSpace];
    
    selectedSpace.player = plyr;
    
    [selectedSpace setColor:clr.red :clr.green :clr.blue :1.0f];
    [selectedSpace configurePiece];
    
    selectedSpace.piece.hidden = false;
    
    [self clearSelectedSpace];
}

- (void)removePiece: (Space*)space {

    space.isOccupied = NO;
    space.isHighlighted = NO;
    space.player = notAssigned;
    space.piece.hidden = YES;
    
}

@end
