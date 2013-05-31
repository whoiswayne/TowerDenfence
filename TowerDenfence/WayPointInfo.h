//
//  WayPointInfo.h
//  TowerDefence_new
//
//  Created by mir-macmini5 on 13-3-27.
//
//

#import <Foundation/Foundation.h>

@interface WayPointInfo : NSObject
{
    CGPoint position;
    WayPointInfo *nextPoint;
}

@property (nonatomic,assign) CGPoint position;
@property (nonatomic,assign) WayPointInfo *nextPoint;

+ (id)wayPointWithPos:(CGPoint)tempPos;
- (id)initWithPosition:(CGPoint)tempPos;

@end
