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

- (void)initMinSpace {

    nbrs = [[NSMutableSet alloc] initWithCapacity:4];
}
   
@end
