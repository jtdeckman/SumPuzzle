//
//  Move.h
//  SumPuzzle
//
//  Created by Jason Deckman on 6/11/15.
//  Copyright (c) 2015 JDeckman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Space.h"

@interface Move : NSObject

@property (nonatomic) Space* fromSpace;
@property (nonatomic) Space* toSpace;
@property (nonatomic) double rank;

@end
