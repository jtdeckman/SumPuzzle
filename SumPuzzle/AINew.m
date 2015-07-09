//
//  AINew.m
//  SumPuzzle
//
//  Created by Jason Deckman on 7/9/15.
//  Copyright (c) 2015 JDeckman. All rights reserved.
//

#import "AINew.h"
#import "MinSpace.h"

@implementation AINew

-(void)setUpAI : (NSMutableArray*)spc : (NSMutableSet*)p1s : (NSMutableSet*)p2s : (int)dx : (int)dy : (int)pInc {
    
    dimx = dx;
    dimy = dy;
    
    spaces = spc;
    
    player1Spaces = p1s;
    player2Spaces = p2s;
    
    pieceInc = pInc;
}

- (void)findSpaces : (Move*)compMove : (int)p1FltPieceVal : (int)compFltPieceVal {
    
    NSMutableSet *p1Spaces, *p2Spaces;
    NSMutableArray *moves;
    
    uint nspaces = dimx*dimy;
    
    Move *currentMove;
    
    uint nmoves = 2*dimx*dimy*(int)[player1Spaces count];;
   
    compMove.fromSpace = nil;
    compMove.toSpace = nil;
    
    p1Spaces = [[NSMutableSet alloc] initWithCapacity:nspaces];
    p2Spaces = [[NSMutableSet alloc] initWithCapacity:nspaces];
    
    moves = [[NSMutableArray alloc] initWithCapacity:nmoves];
    
    for(Space* item in player1Spaces) {
        
        MinSpace* p1Spc = [[MinSpace alloc] init];
        
        p1Spc.iind = item.iind;
        p1Spc.jind = item.jind;
        
        p1Spc.value = item.value;
        p1Spc.player = item.player;
        
        [p1Spc addNeighborsFromSpaces:item.nearestNbrs];
        
        [p1Spaces addObject: p1Spc];
    }
    
    for(Space* item in player2Spaces) {
        
        MinSpace* p2Spc = [[MinSpace alloc] init];
        
        p2Spc.iind = item.iind;
        p2Spc.jind = item.jind;
        
        p2Spc.value = item.value;
        p2Spc.player = item.player;
        
        [p2Spc addNeighborsFromSpaces:item.nearestNbrs];
        
        [p2Spaces addObject: p2Spc];
    }

 // Free moves
    
    for(MinSpace* item in p2Spaces) {
    
        for(SubSpace* nbr in item.nbrs) {
            
            if(nbr.player == notAssigned) {
                
                MinSpace* minSpace = [[MinSpace alloc] init];
                
                minSpace.iind = nbr.iind;
                minSpace.jind = nbr.jind;
                
                minSpace.value = compFltPieceVal;
                
                minSpace.player = player2;
                
                [self createEmptyNeighborsForMinSpace:minSpace];
                
                [self findNeighborsNearMinSpace:p1Spaces :p2Spaces :minSpace];
                
                [p2Spaces addObject:minSpace];
                
                currentMove = [[Move alloc] init];
                currentMove.fromSpace = nil;
                currentMove.toSpace = [self getSpaceForIndices:minSpace.iind : minSpace.jind];
                currentMove.rank = [self calcWeight:p1Spaces : p2Spaces :N_ITER :minSpace.iind :p1FltPieceVal : compFltPieceVal];
                
                [moves addObject:currentMove];
                
                [p2Spaces removeObject:minSpace];
                
            }
        }
    }
    
    if([moves count] > 0) {
        
        NSArray *sortedMoves;
        
        sortedMoves = [moves sortedArrayUsingComparator:^NSComparisonResult(id move1, id move2) {
            
            Move *m1 = (Move*)move1;
            Move *m2 = (Move*)move2;
            
            if(m1.rank <= m2.rank) return YES;
            
            return NO;
        }];
        
        int cnt = 1;
        
        Move *tempMove, *bestMove = sortedMoves[0];
        
        for(int i=1; i < [sortedMoves count]; i++) {
            
            tempMove = sortedMoves[i];
            
            if(tempMove.rank != bestMove.rank)
                break;
            else
                ++cnt;
        }
        
        if(cnt > 1)
            bestMove = sortedMoves[rand() % cnt];
        
        compMove.rank = bestMove.rank;
        compMove.fromSpace = bestMove.fromSpace;
        compMove.toSpace = bestMove.toSpace;
    }
}

- (double)calcWeight: (NSMutableSet*)p1Spcs : (NSMutableSet*)p2Spcs : (uint)niter : (uint)ival : (int)p1Val : (int)p2Val {
    
    double weight = [self calcP2BoardMetric:p1Spcs :p2Spcs];
    
    if(niter > 0) {
        
    }
    
    return weight;
}

- (double)calcP2BoardMetric: (NSMutableSet*)p1Spaces : (NSMutableSet*)compSpaces {
    
    double metric = 0;
    
    int p1Total = [self scoreOfMinSpaceSet:p1Spaces];
    int compTotal = [self scoreOfMinSpaceSet:compSpaces];
    
    int scoreDiff = compTotal - p1Total;
    
    metric = (float)(POINT_DIFF_FACT*scoreDiff);// + ([self stdDev:p1Spaces] - [self stdDev:compSpaces])*SD_FACT + [self distWeight:compSpaces :player2]*DIST_WEIGHT*5.0;
    
    return metric;
}

- (void)findNeighborsNearMinSpace: (NSMutableSet*)p1Spcs : (NSMutableSet*)p2Spcs : (MinSpace*)minSpace {
    
    for(SubSpace* item in minSpace.nbrs) {
        
        for(MinSpace* nbrSpc in p1Spcs) {
            
            if((item.iind == nbrSpc.iind) && (item.jind == nbrSpc.jind)) {
                item.value = nbrSpc.value;
                item.player = nbrSpc.player;
                
                for(SubSpace* nbr in nbrSpc.nbrs) {
                    
                    if((nbr.iind == minSpace.iind) && (nbr.jind == minSpace.jind)) {
                        
                        nbr.value = minSpace.value;
                        nbr.player = minSpace.player;
                        break;
                    }
                }
            }
        }
        
        for(MinSpace* nbrSpc in p2Spcs) {
            
            if((item.iind == nbrSpc.iind) && (item.jind == nbrSpc.jind)) {
                item.value = nbrSpc.value;
                item.player = nbrSpc.player;
                
                for(SubSpace* nbr in nbrSpc.nbrs) {
                    
                    if((nbr.iind == minSpace.iind) && (nbr.jind == minSpace.jind)) {
                        
                        nbr.value = minSpace.value;
                        nbr.player = minSpace.player;
                        break;
                    }
                }
            }
        }
    }
}

- (void)createEmptyNeighborsForMinSpace: (MinSpace*)minSpace {

    minSpace.nbrs = [[NSMutableSet alloc] initWithCapacity:4];
    
    int iind = minSpace.iind;
    int jind = minSpace.jind;
    
    int inbr = iind-1;
    int jnbr = jind;
    
    if(inbr > -1) {
        SubSpace* newSpc = [[SubSpace alloc] init];
        newSpc.iind = inbr;
        newSpc.jind = jnbr;
        newSpc.value = -10000;
        newSpc.player = notAssigned;
        
        [minSpace.nbrs addObject:newSpc];
    }
    
    inbr = iind+1;
    
    if(inbr < dimy) {
        
        SubSpace* newSpc = [[SubSpace alloc] init];
        newSpc.iind = inbr;
        newSpc.jind = jnbr;
        newSpc.value = -10000;
        newSpc.player = notAssigned;
        
        [minSpace.nbrs addObject:newSpc];
    }
   
    
    inbr = iind;
    jnbr = jind-1;
   
    if(jnbr > -1) {
        
        SubSpace* newSpc = [[SubSpace alloc] init];
        newSpc.iind = inbr;
        newSpc.jind = jnbr;
        newSpc.value = -10000;
        newSpc.player = notAssigned;
        
        [minSpace.nbrs addObject:newSpc];
    }
    
    jnbr = jind+1;
    
    if(jnbr < dimx) {
        
        SubSpace* newSpc = [[SubSpace alloc] init];
        newSpc.iind = inbr;
        newSpc.jind = jnbr;
        newSpc.value = -10000;
        newSpc.player = notAssigned;
        
        [minSpace.nbrs addObject:newSpc];
    }
}

- (int)scoreOfMinSpaceSet: (NSMutableSet*)minSet {
    
    int score = 0;
    
    for(MinSpace* item in minSet)
        score += item.value;
    
    return score;
}

- (void)copySets : (NSMutableSet*)p1Set : (NSMutableSet*)p2Set : (NSMutableSet*)newP1Set : (NSMutableSet*)newP2Set {
    
    
}

@end
