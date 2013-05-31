//
//  UpgradeInfoDB.h
//  TowerDenfence
//
//  Created by mir-macmini5 on 13-4-22.
//
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface UpgradeInfoDB : NSObject
{
    sqlite3 *db;
}
@end
