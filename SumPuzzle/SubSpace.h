//
//  SubSpace.h
//  SumPuzzle
//
//  Created by Jason Deckman on 7/9/15.
//  Copyright (c) 2015 JDeckman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"
#import "MinSpace.h"

@interface SubSpace : NSObject {
     
     uint iind;
     uint jind;
    
     int value;
     
     Player player;
}

@property (nonatomic) uint iind;
@property (nonatomic) uint jind;

@property (nonatomic) int value;

@property (nonatomic) Player player;

@property (nonatomic) MinSpace* space;

@end
