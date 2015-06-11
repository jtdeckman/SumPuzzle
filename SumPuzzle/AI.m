//
//  AI.m
//  SumPuzzle
//
//  Created by Jason Deckman on 6/8/15.
//  Copyright (c) 2015 JDeckman. All rights reserved.
//

#import "AI.h"
#import "MinSpace.h"
#import "Move.h"

@implementation AI

-(void)setUpAI : (NSMutableArray*)spc : (NSMutableSet*)p1s : (NSMutableSet*)p2s : (int)dx : (int)dy {

    dimx = dx;
    dimy = dy;
    
    spaces = spc;
    player1Spaces = p1s;
    player2Spaces = p2s;
    
}

- (void)findSpaces : (Space*)moveFrom : (Space*)moveTo : (int)pieceVal {
    
    NSMutableArray *tempBoard;
    NSMutableArray *moves;
    
    MinSpace *tempSpace, *currSpace;
    
    Move *currentMove;
    
    uint nmoves;
    int value;
    
    tempBoard = [self newTempBoard];
    
    moveFrom = nil;
    moveTo = nil;
    
    nmoves = 2*dimx*dimy*(int)[player1Spaces count];
    
    moves = [[NSMutableArray alloc] initWithCapacity:nmoves];
    
    [self resetTempBoard:tempBoard];
    
    for(Space* item in player2Spaces) {
        
        for(int i=0; i<dimx; i++) {
            for(int j=0; j<dimy; j++) {
                currentMove = [[Move alloc] init];
                currentMove.fromSpace = item;
                currSpace = tempBoard[item.iind][item.jind];
                tempSpace = tempBoard[i][j];
                if(tempSpace.player == notAssigned) {
                    value = (int)((float)item.value/2.0);
                    currSpace.value = value;
                    tempSpace.value = value;
                    tempSpace.player = player2;
                    currentMove.toSpace = [self getSpaceForIndices:i :j];
                    currentMove.rank = [self calcWeight:tempBoard :N_ITER];
                    [moves addObject:currentMove];
                }
                
                [self resetTempBoard:tempBoard];
            }
        }
    }
    
    NSArray *sortedMoves;
    
    sortedMoves = [moves sortedArrayUsingComparator:^NSComparisonResult(id move1, id move2) {
      
        Move *m1 = (Move*)move1;
        Move *m2 = (Move*)move2;
        
        if(m1.rank >= m2.rank) return YES;
    
        return NO;
    }];
}

- (float)calcWeight: (NSMutableArray*) tempBoard : (uint)nIter {

    NSMutableSet *p1Spaces = [[NSMutableSet alloc] initWithCapacity:dimx*dimy];
    NSMutableSet *computerSpaces = [[NSMutableSet alloc] initWithCapacity:dimx*dimy];
    
    MinSpace *currSpace;
    
    float weight = 0.0f;
    
    for(int i=0; i<dimx; i++) {
        for(int j=0; j<dimy; j++) {
            currSpace = tempBoard[i][j];
            if(currSpace.player == player1)
                [p1Spaces addObject:currSpace];
            else if(currSpace.player == player2)
                [computerSpaces addObject:currSpace];
        }
    }

    weight = [self calcBoardMetric:p1Spaces :computerSpaces];
    
    return weight;
}

- (float)calcBoardMetric: (NSMutableSet*)p1Spaces : (NSMutableSet*)compSpaces {

    float metric = 0;
    
    uint nP1Spaces = (uint)[p1Spaces count];
    uint nCompSpaces = (uint)[compSpaces count];
    
    int p1Total = [self scoreOfMinSpaceSet:p1Spaces];
    int compTotal = [self scoreOfMinSpaceSet:compSpaces];
    
    int scoreDiff = compTotal - p1Total;
    int pieceDiff = nCompSpaces - nP1Spaces;
    
    float avgDiff = compTotal/nCompSpaces - p1Total/nP1Spaces;
    
    metric = (float)(POINT_DIFF_FACT*scoreDiff) + (float)(NUM_DIFF_FACT*pieceDiff) + AVG_DIFF_FACT*avgDiff;
    
    return metric;
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
            tempSpace.locx = i;
            tempSpace.locy = j;
            tempSpace.value = space.value;
            tempSpace.player = space.player;
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
            [row addObject:newSpace];
        }
        
        [newBoard addObject:row];
    }
    
    return newBoard;
}

@end
