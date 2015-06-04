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

    player1Spaces = [[NSMutableSet alloc] initWithCapacity:dimx*dimy + 1];
    player2Spaces = [[NSMutableSet alloc] initWithCapacity:dimx*dimy + 1];
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
    
    if(plyr == player1)
        [player1Spaces addObject:space];
    else
        [player2Spaces addObject:space];
    
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

- (void)convertPiece: (Space*)space : (int)val :(JDColor)clr : (Player)plyr {

    space.value = val;
    space.player = plyr;
    
    [space setColor:clr.red :clr.green :clr.blue :1.0f];
    [space configurePiece];
    
    if(plyr == player1) {
        [player1Spaces addObject:space];
        [player2Spaces removeObject:space];
    }
    else {
        [player2Spaces addObject:space];
        [player1Spaces removeObject:space];
    }
}

- (void)removePiece: (Space*)space {

    if(space.player == player1)
        [player1Spaces removeObject:space];
    else
        [player2Spaces removeObject:space];
    
    space.isOccupied = NO;
    space.isHighlighted = NO;
    space.player = notAssigned;
    space.piece.hidden = YES;
    
}

- (void)clearBoard {
    
    Space *space;
    
    for(int i=0; i<dimx; i++) {
        for(int j=0; j<dimy; j++) {
            
            space = spaces[i][j];
            
            space.isHighlighted = NO;
            space.isOccupied = NO;
            space.isSelected = NO;
            
            space.piece.hidden = YES;
        }
    }
    
    [player1Spaces removeAllObjects];
    [player2Spaces removeAllObjects];
}

- (int)numPieceForPlayer: (Player)player {
    
    Space *space;
    
    int count = 0;
    
    for(int i=0; i<dimx; i++) {
        for(int j=0; j<dimy; j++) {
            space = spaces[i][j];
            if(space.isOccupied && space.player == player)
                ++count;
        }
    }
    
    return count;
}

- (int)farthestRowForPlayer: (Player)player {
    
    int ind;
    
    if(player == player1) {
        ind = -1;
        for(Space* item in player1Spaces)
            if(item.iind > ind) ind = item.iind;
    }
    else {
        ind = dimx;
        for(Space* item in player2Spaces)
            if(item.iind < ind) ind = item.iind;
    }
    
    return ind;
}

- (Player)checkForWinner {

    int numPlyr1 = (int)[player1Spaces count];
    int numPlyr2 = (int)[player2Spaces count];
    
    if(numPlyr1 == 0)
        return player2;
    
    if(numPlyr2 == 0)
        return player1;
    
    if([self farthestRowForPlayer:player1] == dimx-1)
        return player1;
    
    if([self farthestRowForPlayer:player2] == 0)
        return player2;
    
    return notAssigned;
}

- (int)pointsForPlayer: (Player)player {
    
    int value = 0;
    
    if(player == player1) {
        for(Space* item in player1Spaces)
            if(item.isOccupied && item.player == player)
                value += item.value;
        
        return value;
    }
    
    if(player == player2) {
        for(Space* item in player2Spaces)
            if(item.isOccupied && item.player == player)
                value += item.value;
        
        return value;
    }
    
    
    return -1;
}


@end
