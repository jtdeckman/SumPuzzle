//
//  Board.m
//  SumPuzzle
//
//  Created by Jason Deckman on 5/19/15.
//  Copyright (c) 2015 JDeckman. All rights reserved.
//

#import "Board.h"

@implementation Board

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
    
    int inbr, jnbr;
    
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
            
            inbr = i-1;
            jnbr = j;
            if(inbr > -1) [newSpace addNbr:inbr :jnbr];
            
            inbr = i+1;
            if(inbr < dimy) [newSpace addNbr:inbr :jnbr];
            
            inbr = i;
            jnbr = j-1;
            if(jnbr > -1) [newSpace addNbr:inbr :jnbr];
            
            jnbr = j+1;
            if(jnbr < dimx) [newSpace addNbr:inbr :jnbr];
        }
        
        [spaces addObject:row];
    }
    
}

- (void)addPiece: (int)ii : (int)ji : (int)val : (BOOL)isTar : (JDColor)clr {
    
    Space *space = spaces[ii][ji];
    
    space.isOccupied = YES;
    space.isTarget = isTar;
    
    space.value = val;
    
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

- (int)nbrOccupied: (Space*)space {
    
    Space *nbrSpace;
    
    int inbr, jnbr, nocc = 0;
    
    for(int i=0; i<space.nnbrs; i++) {
        
        [space getNbrIndices:i :&inbr :&jnbr];
        
        nbrSpace = [self getSpaceForIndices:inbr :jnbr];
        
        if(nbrSpace.isOccupied && !nbrSpace.isTarget) ++nocc;
    }
    
    return nocc;
}

- (int)sumNbrs: (Space*)space {
    
    int sum = 0;
    
    Space *nbrSpace;
    
    int inbr, jnbr;
    
    for(int i=0; i<space.nnbrs; i++) {
        
        [space getNbrIndices:i :&inbr :&jnbr];
        
        nbrSpace = [self getSpaceForIndices:inbr :jnbr];
        
        if(!nbrSpace.isTarget)
            sum += nbrSpace.value;
    }
    
    return sum;
}

@end
