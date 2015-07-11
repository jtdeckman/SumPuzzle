//
//  MinSpace.h
//  SumPuzzle
//
//  Created by Jason Deckman on 6/11/15.
//  Copyright (c) 2015 JDeckman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface MinSpace : NSObject

@property (nonatomic) uint iind;
@property (nonatomic) uint jind;

@property (nonatomic) int value;

@property (nonatomic) Player player;

@property (nonatomic) NSMutableSet* nbrs;

- (void)initMinSpace;


@end
