//
//  AI.m
//  SumPuzzle
//
//  Created by Jason Deckman on 6/8/15.
//  Copyright (c) 2015 JDeckman. All rights reserved.
//

#import "AI.h"
#import "MinSpace.h"

@implementation AI

-(void)setUpAI : (NSMutableArray*)spc : (NSMutableSet*)p1s : (NSMutableSet*)p2s : (int)dx : (int)dy {

    dimx = dx;
    dimy = dy;
    
    spaces = spc;
    
    player1Spaces = p1s;
    player2Spaces = p2s;
    
}

- (void)findSpaces : (Move*)compMove : (int)p1FltPieceVal : (int)compFltPieceVal {
    
    NSMutableArray *tempBoard;
    NSMutableArray *moves;
    
    Space *tSpace;
    
    MinSpace *tempSpace, *currSpace;
    
    Move *currentMove;
    
    uint nmoves;
    int value;
    
    tempBoard = [self newTempBoard];
    
    compMove.fromSpace = nil;
    compMove.toSpace = nil;
    
    nmoves = 2*dimx*dimy*(int)[player1Spaces count];
    
    moves = [[NSMutableArray alloc] initWithCapacity:nmoves];
    
    [self resetTempBoard:tempBoard];
    
 // Free piece
    
    for(int i=0; i<dimx; i++) {
        for(int j=0; j<dimy; j++) {
    
            tempSpace = tempBoard[i][j];
            
            if(tempSpace.player == notAssigned) {
                
                Space* space = [self getSpaceForIndices:i :j];
                
                for(Space* item in player2Spaces) {
         
                    if([item isNearestNearestNbrOf:space]) {
                        
                        tempSpace.player = player2;
                        tempSpace.value = compFltPieceVal;
                
                        currentMove = [[Move alloc] init];
                        currentMove.fromSpace = nil;
                        currentMove.toSpace = [self getSpaceForIndices:i :j];
                        currentMove.rank = [self calcWeight:tempBoard :N_ITER :i :p1FltPieceVal :YES];
                        
                        currentMove.rank -= (1.0/compFltPieceVal)*FLOAT_FACT;
                        
                        [moves addObject:currentMove];
                        
                        [self resetTempBoard:tempBoard];
                    }
                }
            }
        }
    }
    
    for(Space* item in player2Spaces) {
        
        for(int i=0; i<dimx; i++) {
            for(int j=0; j<dimy; j++) {
                
                tSpace = [self getSpaceForIndices:i :j];
                
                if(!(item.iind == i && item.jind == j) && [item isNearestNearestNbrOf:tSpace]) {
                    
                    currSpace = tempBoard[item.iind][item.jind];
                    tempSpace = tempBoard[i][j];
                
                    if(tempSpace.player == notAssigned && currSpace.value > 1 ) {
             
                        currentMove = [[Move alloc] init];
                        currentMove.fromSpace = item;

                        value = (int)((float)item.value/2.0);
                        currSpace.value = value;
                        tempSpace.value = value;
                        tempSpace.player = player2;
                        currentMove.toSpace = [self getSpaceForIndices:i :j];
                        currentMove.rank = [self calcWeight:tempBoard :N_ITER :i :p1FltPieceVal :YES];
                        
                        [moves addObject:currentMove];
                        
                        currentMove = nil;
                    }
                    
                    else if(tempSpace.player != notAssigned ) {
                        
                        currentMove = [[Move alloc] init];
                        currentMove.fromSpace = item;
                        currentMove.toSpace = [self getSpaceForIndices:i :j];
                        
                        if(tempSpace.player == player1) {
                            
                            if(item.value > tempSpace.value) {
                                
                                currSpace.player = notAssigned;
                                tempSpace.value = currSpace.value;
                                tempSpace.player = player2;
                        
                                currentMove.rank = [self calcWeight:tempBoard :N_ITER :i :p1FltPieceVal :YES];
                                
                                [moves addObject:currentMove];
                            }
                        }
                        else {
                                currSpace.player = notAssigned;
                                tempSpace.value += currSpace.value;
                                tempSpace.player = player2;
                                
                                currentMove.rank = [self calcWeight:tempBoard :N_ITER :i :p1FltPieceVal :YES];
                            
                                [moves addObject:currentMove];
                                
                                currentMove = nil;
                        }
                    }
                    
                    [self resetTempBoard:tempBoard];
                }
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

- (float)calcWeight: (NSMutableArray*) tempBoard : (uint)nIter : (int)jval : (int)p1FpVal : (bool)calcP1Weight {

    NSMutableSet *p1Spaces = [[NSMutableSet alloc] initWithCapacity:dimx*dimy];
    NSMutableSet *computerSpaces = [[NSMutableSet alloc] initWithCapacity:dimx*dimy];
    
    float weight = 0.0f;

    [self findTempNumbers:p1Spaces :computerSpaces :tempBoard];
    
    weight = [self calcBoardMetric:p1Spaces :computerSpaces];
    
    weight += (dimy-jval)*DIST_WEIGHT;
    
    if(calcP1Weight)
        weight += [self player1Moves:tempBoard :p1FpVal];
    
    return weight;
}

- (float)calcP1Weight: (NSMutableArray*) tempBoard : (uint)nIter : (int)jval : (int)p1FpVal : (bool)calcP1Weight {
    
    NSMutableSet *p1Spaces = [[NSMutableSet alloc] initWithCapacity:dimx*dimy];
    NSMutableSet *computerSpaces = [[NSMutableSet alloc] initWithCapacity:dimx*dimy];
    
    float weight = 0.0f;
    
    [self findTempNumbers:p1Spaces :computerSpaces :tempBoard];
    
    weight = [self calcBoardMetric:p1Spaces :computerSpaces];
    
    weight += jval*DIST_WEIGHT;
    
    return weight;
}

- (float)player1Moves: (NSMutableArray*) currBoard : (int)p1Val {

    NSMutableArray *tempBoard = [self newTempBoard];
    
    NSMutableSet *p1Spaces = [[NSMutableSet alloc] initWithCapacity:dimx*dimy];
    NSMutableSet *computerSpaces = [[NSMutableSet alloc] initWithCapacity:dimx*dimy];

    float tempWeight, weight = 0;
    
    MinSpace *tempSpace, *currSpace;
    
    int value;

    Space *tSpace, *pSpace;
    
    [self copyTempBoard:tempBoard :currBoard];
    [self findTempNumbers:p1Spaces :computerSpaces :tempBoard];
    
    for(int i=0; i<dimx; i++) {
        for(int j=0; j<dimy; j++) {
            
            tempSpace = tempBoard[i][j];
            
            if(tempSpace.player == notAssigned) {
                
                tSpace = [self getSpaceForIndices:i :j];
                
                for(MinSpace* item in p1Spaces) {
                    
                    pSpace = [self getSpaceForIndices:item.locx :item.locy];
                    
                    if([pSpace isNearestNearestNbrOf:tSpace]) {
                        
                        tempSpace.player = player1;
                        tempSpace.value = p1Val;
                        
                        tempWeight = [self calcP1Weight:tempBoard :0 :i :0 :NO];
               
                        tempWeight += (1.0/p1Val)*FLOAT_FACT;
                        
                        if(tempWeight < weight) weight = tempWeight;
                        
                        [self copyTempBoard:tempBoard :currBoard];
                    }
                }
            }
        }
    }

    for(MinSpace* item in p1Spaces) {
        
        for(int i=0; i<dimx; i++) {
            for(int j=0; j<dimy; j++) {
                
                pSpace = [self getSpaceForIndices:item.locx :item.locy];
                tSpace = [self getSpaceForIndices:i :j];

                if(!(item.locx == i && item.locy == j) && [tSpace isNearestNearestNbrOf:pSpace]) {
                    
                    currSpace = tempBoard[item.locx][item.locy];
                    tempSpace = tempBoard[i][j];
                    
                    if(tempSpace.player == notAssigned && currSpace.value > 1) {
                        
                        value = (int)((float)item.value/2.0);
                        currSpace.value = value;
                        tempSpace.value = value;
                        tempSpace.player = player1;
                       
                        tempWeight = [self calcP1Weight:tempBoard :0 :i :0 :NO];
                        
                        if(tempWeight < weight) weight = tempWeight;
                        
                        [self copyTempBoard:tempBoard :currBoard];
                    }
                    
                    else if(tempSpace.player != notAssigned) {
                        
                        if(tempSpace.player == player2) {
                            
                            if(item.value > tempSpace.value) {
                                
                                currSpace.player = notAssigned;
                                tempSpace.value = currSpace.value;
                                tempSpace.player = player1;
                                
                                tempWeight = [self calcP1Weight:tempBoard :N_ITER :i :0 :NO];
                                
                                if(tempWeight < weight) weight = tempWeight;
                                
                                [self copyTempBoard:tempBoard :currBoard];
                            }
                        }
                        else {
                            
                            currSpace.player = notAssigned;
                            tempSpace.value += currSpace.value;
                            tempSpace.player = player1;
                            
                            tempWeight = [self calcP1Weight:tempBoard :N_ITER :i :0 :NO];
                            
                            if(tempWeight < weight) weight = tempWeight;
                            
                            [self copyTempBoard:tempBoard :currBoard];
                        }
                    }
                }
            }
        }
    }

    return weight;
}

- (void)findTempNumbers: (NSMutableSet*)p1S : (NSMutableSet*)compSpace : (NSMutableArray*) tBoard {
    
    MinSpace *currSpace;
    
    for(int i=0; i<dimx; i++) {
        for(int j=0; j<dimy; j++) {
            currSpace = tBoard[i][j];
            if(currSpace.player == player1)
                [p1S addObject:currSpace];
            else if(currSpace.player == player2)
                [compSpace addObject:currSpace];
        }
    }
}

- (float)calcBoardMetric: (NSMutableSet*)p1Spaces : (NSMutableSet*)compSpaces {

    float metric = 0;
    
    uint nP1Spaces = (uint)[p1Spaces count];
    uint nCompSpaces = (uint)[compSpaces count];
    
    int p1Total = [self scoreOfMinSpaceSet:p1Spaces];
    int compTotal = [self scoreOfMinSpaceSet:compSpaces];
    
    int scoreDiff = compTotal - p1Total;
    int pieceDiff = nCompSpaces - nP1Spaces;
    
   // float avgDiff = (float)compTotal/(float)nCompSpaces - (float)p1Total/(float)nP1Spaces;
    
    metric = (float)(POINT_DIFF_FACT*scoreDiff) + ([self stdDev:p1Spaces] - [self stdDev:compSpaces])*SD_FACT + (float)(NUM_DIFF_FACT*pieceDiff); // + AVG_DIFF_FACT*avgDiff;
    
    if(fabs(metric) > 10000) {
        NSLog(@"Shit");
    }
   // metric = (float)(POINT_DIFF_FACT*scoreDiff) + AVG_DIFF_FACT*avgDiff;
    
    return metric;
}

- (float)stdDev: (NSMutableSet*)pSpaces {
 
    float val, xsq=0, xave=0;
    
    uint nspaces = (uint)[pSpaces count];
    
    for(MinSpace* item in pSpaces) {
        val = item.value;
        xsq += val*val;
        xave += val;
    }
    
    xave /= nspaces;
    
    return sqrt(xsq/(float)nspaces + xave*xave);
}

- (int)scoreOfMinSpaceSet: (NSMutableSet*)minSet {
    
    int score = 0;
    
    for(MinSpace* item in minSet)
        score += item.value;
    
    return score;
}

- (void)resetTempBoard : (NSMutableArray*) tempBoard {
    
    Space *space;
    MinSpace *tempSpace;
    
    for(int i=0; i<dimx; i++) {
        for(int j=0; j<dimy; j++) {
            space = spaces[i][j];
            tempSpace = tempBoard[i][j];
          //  tempSpace.locx = i;
          //  tempSpace.locy = j;
            tempSpace.value = space.value;
            tempSpace.player = space.player;
        }
    }
}

- (void)copyTempBoard : (NSMutableArray*)tempBoard : (NSMutableArray*)referenceBoard {

    MinSpace *tempSpace, *refSpace;
    
    for(int i=0; i<dimx; i++) {
        for(int j=0; j<dimy; j++) {
            refSpace = referenceBoard[i][j];
            tempSpace = tempBoard[i][j];
            tempSpace.value = refSpace.value;
            tempSpace.player = refSpace.player;
        }
    }
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
            newSpace.locx = i;
            newSpace.locy = j;
            [row addObject:newSpace];
        }
        
        [newBoard addObject:row];
    }
    
    return newBoard;
}

@end
