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

@synthesize captureFlagMode;

-(void)setUpAI : (NSMutableArray*)spc : (NSMutableSet*)p1s : (NSMutableSet*)p2s : (int)dx : (int)dy : (int)pInc : (BOOL)cfm {
    
    dimx = dx;
    dimy = dy;
    
    spaces = spc;
    
    player1Spaces = p1s;
    player2Spaces = p2s;
    
    pieceInc = pInc;
    
    captureFlagMode = cfm;
}

- (void)findSpaces : (Move*)compMove : (int)p1FltPieceVal : (int)compFltPieceVal {
    
    NSMutableSet *tempP2Spaces = [[NSMutableSet alloc] initWithSet:player2Spaces];
    NSMutableSet *tempP1Spaces = [[NSMutableSet alloc] initWithSet:player1Spaces];
    
    Move *bestMove = [[Move alloc] init];
    
    SubSpace *origSpace = [[SubSpace alloc] init];
    SubSpace *nbrSpace = [[SubSpace alloc] init];
    
    compMove.fromSpace = nil;
    compMove.toSpace = nil;
    
    bestMove.fromSpace = nil;
    bestMove.toSpace = nil;
    bestMove.rank = -1.0e30;
    
    double rank;
    
    for(Space* item in player2Spaces) {
        
        for(Space* nbr in item.nearestNbrs) {
            
            if(nbr.player == notAssigned) {
                
                [tempP2Spaces addObject:nbr];
                
             // Free move
                
                nbr.value = compFltPieceVal;
                nbr.player = player2;
                
                rank = [self calcWeight: tempP2Spaces :tempP1Spaces :N_ITER :nbr.iind :p1FltPieceVal : compFltPieceVal];
                
                rank -= (1.0/compFltPieceVal)*FLOAT_FACT;
                
                NSLog(@"%f",rank);
                
                if(rank > bestMove.rank) {
                    bestMove.toSpace = nbr;
                    bestMove.rank = rank;
                }
                
                
             // Split move
                
                origSpace.value = item.value;
                item.value = (int)(item.value/2.0);
                
                nbr.value = item.value;
                nbr.player = player2;
                
                rank = [self calcWeight: tempP2Spaces :tempP1Spaces :N_ITER :nbr.iind :p1FltPieceVal : compFltPieceVal];
                
                NSLog(@"%f",rank);
                
                if(rank > bestMove.rank) {
                    bestMove.fromSpace = item;
                    bestMove.toSpace = nbr;
                    bestMove.rank = rank;
                }

                item.value = origSpace.value;
                
                nbr.player = notAssigned;
                nbr.value = 0;
                
                [tempP2Spaces removeObject:nbr];
            }
            
            else if(nbr.player == player2) {
                
                nbrSpace.value = nbr.value;
                origSpace.value = item.value;
                
                nbr.value += item.value;
                
                item.value = 0;
                item.player = notAssigned;
                
                [tempP2Spaces removeObject:item];
                
                rank = [self calcWeight: tempP2Spaces :tempP1Spaces :N_ITER :nbr.iind :p1FltPieceVal : compFltPieceVal];
                
                NSLog(@"%f",rank);
                
                if(rank > bestMove.rank) {
                    bestMove.fromSpace = item;
                    bestMove.toSpace = nbr;
                    bestMove.rank = rank;
                }
                
                item.value = origSpace.value;
                item.player = player2;
                
                nbr.value = nbrSpace.value;
                
                [tempP2Spaces addObject:item];
            }
            
            else if(nbr.player == player1 && ((item.value - nbr.value) >= 2)) {
                
                nbrSpace.value = nbr.value;
                origSpace.value = item.value;
                
                nbr.value = item.value - (float)(nbr.value)/2.0;
                nbr.player = player2;
                
                item.value = 0;
                item.player = notAssigned;
                
                [tempP2Spaces addObject:nbr];
                [tempP2Spaces removeObject:item];
                
                [tempP1Spaces removeObject:nbr];
                
                rank = [self calcWeight: tempP2Spaces :tempP1Spaces :N_ITER :nbr.iind :p1FltPieceVal : compFltPieceVal];
                
                NSLog(@"%f",rank);
                
                if(rank > bestMove.rank) {
                    bestMove.fromSpace = item;
                    bestMove.toSpace = nbr;
                    bestMove.rank = rank;
                }

                nbr.value = nbrSpace.value;
                nbr.player = player1;
                
                item.value = origSpace.value;
                item.player = player2;
                
                [tempP2Spaces addObject:item];
                [tempP2Spaces removeObject:nbr];
                
                [tempP1Spaces addObject:nbr];
            }
            
            else {
                
            }
        }
    }
 
    compMove.fromSpace = bestMove.fromSpace;
    compMove.toSpace = bestMove.toSpace;
}

- (double)calcWeight: (NSMutableSet*) p2spaces : (NSMutableSet*) p1Spaces : (uint)niter : (uint)ival : (int)p1Val : (int)p2Val {
    
    double weight = [self calcP2BoardMetric: p2spaces : p1Spaces];
    
    if(niter > 0) {
        
    }
    
    return weight;
}

- (double)calcP2BoardMetric : (NSMutableSet*)p2spcs : (NSMutableSet*)p1spcs {
    
    double metric = 0;
    
    int p1Total = [self scoreOfMinSpaceSet:p1spcs];
    int compTotal = [self scoreOfMinSpaceSet:p2spcs];
    
    int scoreDiff = compTotal - p1Total;
    
    double sd = [self stdDev:p2spcs]*SD_FACT;
    
    metric = (double)(POINT_DIFF_FACT*scoreDiff) - sd;
    
    if(captureFlagMode)
        metric += [self distWeight:p2spcs :player2]*DIST_WEIGHT;
    
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
    xsq /= nspaces;
    
    return sqrt(xsq - xave*xave);
}

- (double)distWeight : (NSMutableSet*)playerSpaces : (Player)player {
    
    float weight = 0;
    
    if(player == player1) {
        
        for(Space* item in playerSpaces)
            weight += item.iind*item.value;
    }
    else {
        for(Space* item in playerSpaces)
            weight += (dimx - 1 - item.iind)*item.value;
    }
    
    return weight;
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

