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
    
    Move *bestMove = [[Move alloc] init];

    SubSpace *origSpace = [[SubSpace alloc] init];
   
    compMove.fromSpace = nil;
    compMove.toSpace = nil;
    
    bestMove.fromSpace = nil;
    bestMove.toSpace = nil;
    bestMove.rank = -1.0e-30;
    
    double rank;
    
 // Free Moves
    
    for(Space* item in player2Spaces) {
        
        for(Space* nbr in item.nearestNbrs) {
        
            if(nbr.player == notAssigned) {
       
                nbr.value = compFltPieceVal;
                nbr.player = player2;
                
                [player2Spaces addObject:nbr];
                
                rank = [self calcWeight :N_ITER :nbr.iind :p1FltPieceVal : compFltPieceVal];
                
                if(rank > bestMove.rank) {
                    bestMove.toSpace = nbr;
                    bestMove.rank = rank;
                }
                
                nbr.player = notAssigned;
                nbr.value = 0;
                
                [player2Spaces removeObject:nbr];
            }
        }
    }
    
}

- (double)calcWeight: (uint)niter : (uint)ival : (int)p1Val : (int)p2Val {
    
    double weight = [self calcP2BoardMetric];
    
    if(niter > 0) {
        
    }
    
    return weight;
}

- (double)calcP2BoardMetric {
    
    double metric = 0;
    
    int p1Total = [self scoreOfMinSpaceSet:player1Spaces];
    int compTotal = [self scoreOfMinSpaceSet:player2Spaces];
    
    int scoreDiff = compTotal - p1Total;
    
    double sd = [self stdDev:player2Spaces]*SD_FACT;
    
    metric = (double)(POINT_DIFF_FACT*scoreDiff) - sd; //[self stdDev:player2Spaces]*SD_FACT;
    
    return metric;
}


- (int)scoreOfMinSpaceSet: (NSMutableSet*)minSet {
    
    int score = 0;
    
    for(Space* item in minSet)
        score += item.value;
    
    return score;
}

- (double)stdDev: (NSMutableSet*)pSpaces {
    
    double val, xsq=0, xave=0;
    
    uint nspaces = (uint)[pSpaces count];
    
    for(Space* item in pSpaces) {
        val = item.value;
        xsq += val*val;
        xave += val;
    }
    
    xave /= nspaces;
    
    return sqrt(xsq/(double)nspaces + xave*xave);
}

@end









/*   
 // NSMutableArray *moves;
 // uint nmoves = 2*dimx*dimy*(int)[player1Spaces count];
 // moves = [[NSMutableArray alloc] initWithCapacity:nmoves];
 
 
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
 } */

