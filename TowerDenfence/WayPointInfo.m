//
//  WayPointInfo.m
//  TowerDefence_new
//
//  Created by mir-macmini5 on 13-3-27.
//
//

#import "WayPointInfo.h"

@implementation WayPointInfo

@synthesize nextPoint;
@synthesize position;

+ (id)wayPointWithPos:(CGPoint)tempPos
{
    return [[self alloc] initWithPosition:tempPos];
}

- (id)initWithPosition:(CGPoint)tempPos
{
    if((self = [super init])){
        position = tempPos;
    }
    return self;
}

@end
