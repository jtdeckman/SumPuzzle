//
//  AINew.m
//  SumPuzzle
//
//  Created by Jason Deckman on 7/9/15.
//  Copyright (c) 2015 JDeckman. All rights reserved.
//

#import "AINew.h"
#import "MinSpace.h"
#import "SubSpace.h"
#import "Math.h"

@implementation AINew

@synthesize nIter;

-(void)setUpAI : (NSMutableArray*)spc : (NSMutableSet*)p1s : (NSMutableSet*)p2s : (int)dx : (int)dy : (int)pInc : (BOOL)cfm : (uint)nit {
    
    dimx = dx;
    dimy = dy;
    
    spaces = spc;
    
    player1Spaces = p1s;
    player2Spaces = p2s;
    
    pieceInc = pInc;
    
    captureFlagMode = cfm;
    
    nIter = nit;
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
    
    int cnt = (int)[tempP1Spaces count];
    
    double rank;
    
    for(Space* item in player2Spaces) {
        
        for(Space* nbr in item.nearestNbrs) {
            
            
            if(nbr.player == notAssigned) {
                
                [tempP2Spaces addObject:nbr];
                
             // Free move
                
                nbr.value = compFltPieceVal;
                nbr.player = player2;
                
                rank = [self calcWeight: tempP2Spaces :tempP1Spaces :p1FltPieceVal : compFltPieceVal];
                
           //     rank -= (1.0/compFltPieceVal)*FLOAT_FACT;
                
                if(rank > bestMove.rank) {
                    bestMove.fromSpace = NULL;
                    bestMove.toSpace = [self getSpaceForIndices:nbr.iind :nbr.jind];
                    bestMove.rank = rank;
                }
                
                if([tempP1Spaces count] != cnt) {
                    NSLog(@"Fuck");
                }

             // Split move
                
                if(item.value > 1) {
                    
                    origSpace.value = item.value;
                    item.value = (int)(item.value/2.0);
                
                    nbr.value = item.value;
                    nbr.player = player2;
                
                    rank = [self calcWeight: tempP2Spaces :tempP1Spaces :p1FltPieceVal : compFltPieceVal+TILE_INC];
                
                    if(rank > bestMove.rank) {
                        bestMove.fromSpace = [self getSpaceForIndices:item.iind :item.jind];
                        bestMove.toSpace = [self getSpaceForIndices:nbr.iind :nbr.jind];
                        bestMove.rank = rank;
                    }

                    item.value = origSpace.value;
                
                    nbr.player = notAssigned;
                    nbr.value = 0;
                
                    [tempP2Spaces removeObject:nbr];
                    
                    if([tempP1Spaces count] != cnt) {
                        NSLog(@"Fuck");
                    }

                }
            }
            
            else if(nbr.player == player2) {
                
                nbrSpace.value = nbr.value;
                origSpace.value = item.value;
                
                nbr.value += item.value;
                
                item.value = 0;
                item.player = notAssigned;
                
                [tempP2Spaces removeObject:item];
                
                rank = [self calcWeight: tempP2Spaces :tempP1Spaces :p1FltPieceVal : compFltPieceVal+TILE_INC];
                
                if(rank > bestMove.rank) {
                    bestMove.fromSpace = [self getSpaceForIndices:item.iind :item.jind];
                    bestMove.toSpace = [self getSpaceForIndices:nbr.iind :nbr.jind];
                    bestMove.rank = rank;
                }
                
                item.value = origSpace.value;
                item.player = player2;
                
                nbr.value = nbrSpace.value;
                
                [tempP2Spaces addObject:item];
                
                if([tempP1Spaces count] != cnt) {
                    NSLog(@"Fuck");
                }

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
                
                rank = [self calcWeight: tempP2Spaces :tempP1Spaces :p1FltPieceVal : compFltPieceVal+TILE_INC];
                
           //     rank += fabs(rank)*OVERTAKE_FACT;
                
                if(rank > bestMove.rank) {
                    bestMove.fromSpace = [self getSpaceForIndices:item.iind :item.jind];
                    bestMove.toSpace = [self getSpaceForIndices:nbr.iind :nbr.jind];
                    bestMove.rank = rank;
                }

                nbr.value = nbrSpace.value;
                nbr.player = player1;
                
                item.value = origSpace.value;
                item.player = player2;
                
                [tempP2Spaces addObject:item];
                [tempP2Spaces removeObject:nbr];
                
                [tempP1Spaces addObject:nbr];
                
                if([tempP1Spaces count] != cnt) {
                    NSLog(@"Fuck");
                }

            }
            
            else {
                
            }
        }
    }
 
    compMove.fromSpace = bestMove.fromSpace;
    compMove.toSpace = bestMove.toSpace;
}

- (double)calcWeight: (NSMutableSet*) p2Spaces : (NSMutableSet*) p1Spaces : (int)p1Val : (int)p2Val {
    
    NSMutableArray *tempBoard = [self newTempBoard];
    
    NSMutableSet *tempP1Spaces = [self setUpTempBoardAndPlayerSpaces:tempBoard :p1Spaces];
    NSMutableSet *tempP2Spaces = [self setUpTempBoardAndPlayerSpaces:tempBoard :p2Spaces];
    
    double weight;
    
    int cnt = 1;
    
    if(![self makeBestP1Move:tempBoard :tempP1Spaces :tempP2Spaces :&p1Val])
        return [self calcP2BoardMetric:tempP1Spaces :tempP2Spaces];
    
    weight = [self calcP2BoardMetric:tempP1Spaces :tempP2Spaces];
    
    for(int i=0; i<nIter; i++) {
        
        if(![self makeBestP2Move:tempBoard :tempP1Spaces :tempP2Spaces :&p2Val]) break;
        if(![self makeBestP1Move:tempBoard :tempP1Spaces :tempP2Spaces :&p1Val]) break;
        
        weight += [self calcP2BoardMetric:tempP1Spaces :tempP2Spaces]/(++cnt);
    }
    
    weight += [self calcP2BoardMetric: tempP1Spaces : tempP2Spaces]/(++cnt);
    
    return weight;
}

- (double)calcP2BoardMetric : (NSMutableSet*)p1spcs : (NSMutableSet*)p2spcs {
    
    double metric = 0;
    
    int nP1Spc = (int)[p1spcs count];
    int nP2Spc = (int)[p2spcs count];

    int p1Total = [self scoreOfMinSpaceSet:p1spcs];
    int compTotal = [self scoreOfMinSpaceSet:p2spcs];
    
    int scoreDiff = compTotal - p1Total;

    double wavg = 0;
    
    if(nP2Spc > 0)
        wavg += (compTotal/nP2Spc)*PPN_FACT;
    
    if(nP1Spc > 0)
        wavg += PPN_O_FACT/(p1Total*nP1Spc);
    
      //  wavg = (compTotal*nP2Spc - p1Total*nP1Spc*nP1Spc)*WAVG_FACT;
    
  //  double sd = [self stdDev:p2spcs]*SD_FACT;
 //   double wd = [self weightedDistance:p2spcs :p1spcs]*WD_FACT;
    
    metric = (double)(POINT_DIFF_FACT*scoreDiff) + wavg;// + wd;
    
  //  if(captureFlagMode)
    //    metric += [self distWeight:p2spcs :player2]*DIST_WEIGHT;
    
    if(nP1Spc == 0) return metric + WIN_WEIGHT_FACT;
    
    return metric;
}

- (double)calcP1BoardMetric : (NSMutableSet*)p1spcs : (NSMutableSet*)p2spcs {
    
    double metric = 0;
    
    int nP1Spc = (int)[p1spcs count];
    int nP2Spc = (int)[p2spcs count];

    int p1Total = [self scoreOfMinSpaceSet:p1spcs];
    int compTotal = [self scoreOfMinSpaceSet:p2spcs];
    
    int scoreDiff = p1Total - compTotal;
    
    double wavg = 0;
    
    if(nP1Spc > 0)
        wavg += (p1Total/nP1Spc)*PPN_FACT;
    
    if(nP1Spc > 0)
        wavg += PPN_O_FACT/(compTotal*nP2Spc);
    
   // if(nP1Spc > 0 && nP2Spc > 0)
    //    wavg = (compTotal/nP2Spc + p1Total/nP1Spc)*WAVG_FACT;
     //   wavg = (p1Total*nP1Spc - compTotal*nP2Spc*nP2Spc)*WAVG_FACT;
    
   // double sd = [self stdDev:p1spcs]*SD_FACT;
   // double wd = [self weightedDistance:p1spcs :p2spcs]*WD_FACT;
    
    metric = (double)(POINT_DIFF_FACT*scoreDiff) + wavg;// + wd;
    
  //  if(captureFlagMode)
    //    metric += [self distWeight:p1spcs :player1]*DIST_WEIGHT;
    
    if(nP2Spc == 0) return metric + WIN_WEIGHT_FACT;
    
    return metric;
}

- (BOOL)makeBestP1Move: (NSMutableArray*)tmpBoard :(NSMutableSet*)p1Spaces : (NSMutableSet*)p2Spaces : (int*)origP1Val {

    NSMutableSet *newP1Spaces = [[NSMutableSet alloc] initWithSet:p1Spaces];
    NSMutableSet *newP2Spaces = [[NSMutableSet alloc] initWithSet:p2Spaces];
    
    SubSpace *origSpace = [[SubSpace alloc] init];
    SubSpace *nbrSpace = [[SubSpace alloc] init];
    
    SubSpace *moveFrom = [[SubSpace alloc] init];
    SubSpace *moveTo = [[SubSpace alloc] init];
    
    double value, rank, weight = -1e30;
    
    int p1Val = *origP1Val;
    
 //   BOOL winState = NO;
    
    moveFrom.space = NULL;
    moveTo.space = NULL;
    
    moveFrom.player = player1;
    
    for(MinSpace* item in p1Spaces) {
        
        for(MinSpace* nbr in item.nbrs) {
            
            if(nbr.player == notAssigned) {
                
                [newP1Spaces addObject:nbr];
                
                // Free move
                
                nbr.value = p1Val;
                nbr.player = player1;
                
                rank = [self calcP1BoardMetric:newP1Spaces : newP2Spaces];
                
          //     rank -= (1.0/p1Val)*FLOAT_FACT;
                
                if(rank > weight) {
                    moveFrom.space = NULL;
                    moveTo.space = [self getMinSpaceForIndices:tmpBoard :nbr.iind :nbr.jind];
                    weight = rank;
                }
                
                
                // Split move
                
                if(item.value > 1) {
                    
                    origSpace.value = item.value;
                    item.value = (int)(item.value/2.0);
                
                    nbr.value = item.value;
                    nbr.player = player1;
                
                    rank = [self calcP1BoardMetric:newP1Spaces : newP2Spaces];
                
                    if(rank > weight) {
                        moveFrom.space = [self getMinSpaceForIndices: tmpBoard:item.iind :item.jind];
                        moveTo.space = [self getMinSpaceForIndices:tmpBoard :nbr.iind :nbr.jind];
                        weight = rank;
                    }

                    item.value = origSpace.value;
                
                    nbr.player = notAssigned;
                    nbr.value = 0;
                
                    [newP1Spaces removeObject:nbr];
                }
            }
            
            else if(nbr.player == player1) {
                
                nbrSpace.value = nbr.value;
                origSpace.value = item.value;
                
                nbr.value += item.value;
                
                item.value = 0;
                item.player = notAssigned;
                
                [newP1Spaces removeObject:item];
                
                rank = [self calcP1BoardMetric:newP1Spaces : newP2Spaces];
                
                if(rank > weight) {
                    moveFrom.space = [self getMinSpaceForIndices: tmpBoard:item.iind :item.jind];
                    moveTo.space = [self getMinSpaceForIndices:tmpBoard :nbr.iind :nbr.jind];
                    weight = rank;
                }
                
                item.value = origSpace.value;
                item.player = player1;
                
                nbr.value = nbrSpace.value;
                
                [newP1Spaces addObject:item];
            }
            
            else if(nbr.player == player2 && ((item.value - nbr.value) >= 2)) {
                
                nbrSpace.value = nbr.value;
                origSpace.value = item.value;
                
                nbr.value = item.value - (float)(nbr.value)/2.0;
                nbr.player = player1;
                
                item.value = 0;
                item.player = notAssigned;
                
                [newP1Spaces addObject:nbr];
                [newP1Spaces removeObject:item];
                
                [newP2Spaces removeObject:nbr];
                
                rank = [self calcP1BoardMetric:newP1Spaces : newP2Spaces];
                
          //      rank += fabs(rank)*OVERTAKE_FACT;
                
                if(rank > weight) {
                    moveFrom.space = [self getMinSpaceForIndices: tmpBoard:item.iind :item.jind];
                    moveTo.space = [self getMinSpaceForIndices:tmpBoard :nbr.iind :nbr.jind];
                    weight = rank;
                }
                
                nbr.value = nbrSpace.value;
                nbr.player = player2;
                
                item.value = origSpace.value;
                item.player = player1;
                
                [newP1Spaces addObject:item];
                [newP1Spaces removeObject:nbr];
                
                [newP2Spaces addObject:nbr];
            }
            
            else {
                
                
            }
        }
    }

    [newP1Spaces removeAllObjects];
    [newP2Spaces removeAllObjects];
    
    newP1Spaces = nil;
    newP2Spaces = nil;
    
 // Change board to reflect best move
    
    if(moveTo.space == nil) return NO;
        
    if(moveFrom.space == nil) {
            
        moveTo.value = 0;
        moveTo.player = notAssigned;
        moveTo.space.value = p1Val;
        moveTo.space.player = player1;
            
        [p1Spaces addObject:moveTo.space];
        
        *origP1Val = TILE_INIT;
    }
        
    else {
        
        *origP1Val += TILE_INC;
        
        moveFrom.value = moveFrom.space.value;
        moveFrom.player = player1;
            
        if(moveTo.space.player == notAssigned) {
            
            moveTo.player = notAssigned;
            moveTo.value = 0;
                
            value = (float)(moveFrom.space.value)/2.0;
             
            moveFrom.space.value = value;
            moveTo.space.value = value;
                
            moveTo.space.player = player1;
                
            [p1Spaces addObject:moveTo.space];
        }
            
        else if(moveTo.space.player == player1) {
                
            moveTo.value = moveTo.space.value;
            moveTo.player = player1;
                
            moveTo.space.value += moveFrom.space.value;
                
            moveFrom.space.value = 0;
            moveFrom.space.player = notAssigned;
                
            [p1Spaces removeObject:moveFrom.space];
        }
            
        else if(moveTo.space.player == player2) {
                
            moveTo.value = moveTo.space.value;
            moveTo.player = player2;
                
            moveTo.space.value = moveFrom.space.value - moveTo.space.value/2.0;
            moveTo.space.player = player1;
                
            moveFrom.space.value = 0;
            moveFrom.space.player = notAssigned;
                
            [p1Spaces removeObject:moveFrom.space];
            [p1Spaces addObject:moveTo.space];
                
            [p2Spaces removeObject:moveTo.space];
        }
            
        else {
                
        }
    }
    
    return YES;
}

- (BOOL)makeBestP2Move: (NSMutableArray*)tmpBoard :(NSMutableSet*)p1Spaces : (NSMutableSet*)p2Spaces : (int*)origP2Val {
    
    NSMutableSet *newP1Spaces = [[NSMutableSet alloc] initWithSet:p1Spaces];
    NSMutableSet *newP2Spaces = [[NSMutableSet alloc] initWithSet:p2Spaces];
    
    SubSpace *origSpace = [[SubSpace alloc] init];
    SubSpace *nbrSpace = [[SubSpace alloc] init];
    
    SubSpace *moveFrom = [[SubSpace alloc] init];
    SubSpace *moveTo = [[SubSpace alloc] init];
    
    double value, rank, weight = -1e30;
    
    int p2Val = *origP2Val;
    
    moveFrom.space = NULL;
    moveTo.space = NULL;
    
    moveFrom.player = player1;
    
    for(MinSpace* item in p2Spaces) {
        
        for(MinSpace* nbr in item.nbrs) {
            
            if(nbr.player == notAssigned) {
                
                [newP2Spaces addObject:nbr];
                
                // Free move
                
                nbr.value = p2Val;
                nbr.player = player2;
                
                rank = [self calcP2BoardMetric:newP1Spaces : newP2Spaces];
                
         //       rank -= (1.0/p2Val)*FLOAT_FACT;
                
                if(rank > weight) {
                    moveFrom.space = NULL;
                    moveTo.space = [self getMinSpaceForIndices:tmpBoard :nbr.iind :nbr.jind];
                    weight = rank;
                }
                
                
                // Split move
                
                if(item.value > 1) {
                    
                    origSpace.value = item.value;
                    item.value = (int)(item.value/2.0);
                    
                    nbr.value = item.value;
                    nbr.player = player2;
                    
                    rank = [self calcP2BoardMetric:newP1Spaces : newP2Spaces];
                    
                    if(rank > weight) {
                        moveFrom.space = [self getMinSpaceForIndices: tmpBoard:item.iind :item.jind];
                        moveTo.space = [self getMinSpaceForIndices:tmpBoard :nbr.iind :nbr.jind];
                        weight = rank;
                    }
                    
                    item.value = origSpace.value;
                    
                    nbr.player = notAssigned;
                    nbr.value = 0;
                    
                    [newP2Spaces removeObject:nbr];
                }
            }
            
            else if(nbr.player == player2) {
                
                nbrSpace.value = nbr.value;
                origSpace.value = item.value;
                
                nbr.value += item.value;
                
                item.value = 0;
                item.player = notAssigned;
                
                [newP2Spaces removeObject:item];
                
                rank = [self calcP2BoardMetric:newP1Spaces : newP2Spaces];
                
                if(rank > weight) {
                    moveFrom.space = [self getMinSpaceForIndices: tmpBoard:item.iind :item.jind];
                    moveTo.space = [self getMinSpaceForIndices:tmpBoard :nbr.iind :nbr.jind];
                    weight = rank;
                }
                
                item.value = origSpace.value;
                item.player = player2;
                
                nbr.value = nbrSpace.value;
                
                [newP2Spaces addObject:item];
            }
            
            else if(nbr.player == player1 && ((item.value - nbr.value) >= 2)) {
                
                nbrSpace.value = nbr.value;
                origSpace.value = item.value;
                
                nbr.value = item.value - (float)(nbr.value)/2.0;
                nbr.player = player2;
                
                item.value = 0;
                item.player = notAssigned;
                
                [newP2Spaces addObject:nbr];
                [newP2Spaces removeObject:item];
                
                [newP1Spaces removeObject:nbr];
                
                rank = [self calcP2BoardMetric:newP1Spaces : newP2Spaces];
                
            //    rank += fabs(rank)*OVERTAKE_FACT;
                
                if(rank > weight) {
                    moveFrom.space = [self getMinSpaceForIndices: tmpBoard:item.iind :item.jind];
                    moveTo.space = [self getMinSpaceForIndices:tmpBoard :nbr.iind :nbr.jind];
                    weight = rank;
                }
                
                nbr.value = nbrSpace.value;
                nbr.player = player1;
                
                item.value = origSpace.value;
                item.player = player2;
                
                [newP2Spaces addObject:item];
                [newP2Spaces removeObject:nbr];
                
                [newP1Spaces addObject:nbr];
            }
            
            else {
                
                
            }
        }
    }
    
    [newP1Spaces removeAllObjects];
    [newP2Spaces removeAllObjects];
    
    newP1Spaces = nil;
    newP2Spaces = nil;
    
    // Change board to reflect best move
    
    if(moveTo.space == nil) return NO;
    
    if(moveFrom.space == nil) {
        
        moveTo.value = 0;
        moveTo.player = notAssigned;
        moveTo.space.value = p2Val;
        moveTo.space.player = player2;
        
        [p2Spaces addObject:moveTo.space];
        
        *origP2Val = TILE_INIT;
    }
    
    else {
        
        *origP2Val += TILE_INC;
        
        moveFrom.value = moveFrom.space.value;
        moveFrom.player = player2;
        
        if(moveTo.space.player == notAssigned) {
            
            moveTo.player = notAssigned;
            moveTo.value = 0;
            
            value = (float)(moveFrom.space.value)/2.0;
            
            moveFrom.space.value = value;
            moveTo.space.value = value;
            
            moveTo.space.player = player2;
            
            [p2Spaces addObject:moveTo.space];
        }
        
        else if(moveTo.space.player == player2) {
            
            moveTo.value = moveTo.space.value;
            moveTo.player = player2;
            
            moveTo.space.value += moveFrom.space.value;
            
            moveFrom.space.value = 0;
            moveFrom.space.player = notAssigned;
            
            [p2Spaces removeObject:moveFrom.space];
        }
        
        else if(moveTo.space.player == player1) {
            
            moveTo.value = moveTo.space.value;
            moveTo.player = player1;
            
            moveTo.space.value = moveFrom.space.value - moveTo.space.value/2.0;
            moveTo.space.player = player2;
            
            moveFrom.space.value = 0;
            moveFrom.space.player = notAssigned;
            
            [p2Spaces removeObject:moveFrom.space];
            [p2Spaces addObject:moveTo.space];
            
            [p1Spaces removeObject:moveTo.space];
            
        }
        
        else {
            
        }
    }
    
    return YES;
}

- (void)resetP1Spaces : (NSMutableSet*)p1Spaces : (NSMutableSet*)p2Spaces : (SubSpace*)fromSpace : (SubSpace*)toSpace {
    
    if(toSpace.space != nil) {
        
        if(fromSpace.space == nil) {
            
            toSpace.space.value = 0;
            toSpace.space.player = notAssigned;
            
            [p1Spaces removeObject:toSpace.space];
        }
        
        else if(toSpace.player == notAssigned) {
         
            fromSpace.space.value = fromSpace.value;
            fromSpace.space.player = player1;
            
            toSpace.space.value = 0;
            toSpace.space.player = notAssigned;
            
            [p1Spaces removeObject:toSpace.space];
        }
        
        else if(toSpace.player == player1) {
            
            fromSpace.space.value = fromSpace.value;
            fromSpace.space.player = player1;
            
            [p1Spaces addObject:fromSpace.space];
            
            toSpace.space.value = toSpace.value;
        }
        
        else if(toSpace.player == player2) {
            
            fromSpace.space.value = fromSpace.value;
            fromSpace.space.player = player1;
            
            toSpace.space.value = toSpace.value;
            toSpace.space.player = player2;
            
            [p1Spaces addObject:fromSpace.space];
            [p1Spaces removeObject:toSpace.space];
            
            [p2Spaces addObject:toSpace.space];
        }
    }
}

- (int)scoreOfMinSpaceSet: (NSMutableSet*)minSet {
    
    int score = 0;
    
    for(MinSpace* item in minSet)
        score += item.value;
    
    return score;
}

- (double)stdDev: (NSMutableSet*)pSpaces {
    
    double val, xsq=0, xave=0;
    
    uint nspaces = (uint)[pSpaces count];
    
    for(MinSpace* item in pSpaces) {
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
        
        for(MinSpace* item in playerSpaces)
            weight += item.iind*item.value;
    }
    else {
        for(MinSpace* item in playerSpaces)
            weight += (dimx - 1 - item.iind)*item.value;
    }
    
    return weight;
}

- (NSMutableArray*)newTempBoard {
    
    NSMutableArray *newBoard;
    NSMutableArray *row;
    
    newBoard = [[NSMutableArray alloc] initWithCapacity:dimx];
    
    MinSpace *newSpace;
    
    for(int i=0; i<dimx; i++) {
        
        row = [[NSMutableArray alloc] initWithCapacity:dimy];
        
        for(int j=0; j<dimy; j++) {
            newSpace = [[MinSpace alloc] init];
            [newSpace initMinSpace];
            newSpace.iind = i;
            newSpace.jind = j;
            [row addObject:newSpace];
        }
        
        [newBoard addObject:row];
    }
    
    return newBoard;
}

- (NSMutableSet*)setUpTempBoardAndPlayerSpaces: (NSMutableArray*)tempBoard : (NSMutableSet*)playerSpaces {
 
    NSMutableSet *newPlayerSpaces = [[NSMutableSet alloc] initWithCapacity:(dimx*dimy + 1)];
    
    MinSpace *boardPntr, *nbrPntr;
    
    for(Space* item in playerSpaces) {
        
        boardPntr = tempBoard[item.iind][item.jind];
        boardPntr.value = item.value;
        boardPntr.player = item.player;
        
        for(Space* nbr in item.nearestNbrs) {
            
            nbrPntr = tempBoard[nbr.iind][nbr.jind];
            [boardPntr.nbrs addObject:nbrPntr];
        }
        
        [newPlayerSpaces addObject:boardPntr];
    }
    
    return newPlayerSpaces;
}

- (double)weightedDistance : (NSMutableSet*)paSpaces : (NSMutableSet*)pbSpaces {

    double val, dist, diff, weight = 0;
    
    int x, y;
    
    for(MinSpace* item in paSpaces) {
        
        for(MinSpace* nbr in pbSpaces) {
            
            x = item.iind - nbr.iind;
            y = item.jind - nbr.jind;
            
            dist = sqrt(x*x + y*y);
            
            diff = (item.value - nbr.value);
            val = diff/(dist*dist);
            
            if(isnan(val)) {
                
            }
            weight += val;
        }
    }
    
    if(isnan(weight)) {
        
    }
    return  weight;
}

- (MinSpace*)getMinSpaceForIndices: (NSMutableArray*)tmpBoard :(int)ii : (int)ji {
    
    return tmpBoard[ii][ji];
}

- (void)deconstructAI {

    spaces = nil;
    
    player1Spaces = nil;
    player2Spaces = nil;
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

