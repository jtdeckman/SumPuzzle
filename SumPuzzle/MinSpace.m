//
//  MinSpace.m
//  SumPuzzle
//
//  Created by Jason Deckman on 6/11/15.
//  Copyright (c) 2015 JDeckman. All rights reserved.
//

#import "MinSpace.h"

@implementation MinSpace

@synthesize iind, jind, value, player;

@synthesize nbrs;

- (void)addNeighborsFromSpaces: (NSMutableSet*)spaces {

    nbrs = [[NSMutableSet alloc] initWithCapacity:4];
    
    for(Space* item in spaces) {
        
        SubSpace* newSpc = [[SubSpace alloc] init];
        
        newSpc.iind = item.iind;
        newSpc.jind = item.jind;
        newSpc.value = item.value;
        newSpc.player = item.player;
        
        [nbrs addObject:newSpc];
    }
}
   
@end
