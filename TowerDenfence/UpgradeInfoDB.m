//
//  UpgradeInfoDB.m
//  TowerDenfence
//
//  Created by mir-macmini5 on 13-4-22.
//
//

#import "UpgradeInfoDB.h"

#define DBNAME @"upgradeInfo.sqlite"
#define TABLENAME @"upgradeInfo"

@implementation UpgradeInfoDB

- (id)init
{
    self = [super init];
    if (self) {
        NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS PERSONINFO (NUM INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, age INTEGER, address TEXT)";
        [self execSql:sqlCreateTable];
    }
    return self;
}

- (void)openDB
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    
    NSString *dbPath = [documents stringByAppendingPathComponent:DBNAME];
    
    if (sqlite3_open([dbPath UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库打开失败");
    }
}

- (void)execSql:(NSString *)sql
{
    char *err;
    if (sqlite3_exec(db, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(db);
        NSLog(@"数据库操作数据失败!");
    }
}

- (NSMutableArray *)findAllInfo
{
    NSMutableArray *infoArray = [[NSMutableArray alloc] initWithCapacity:2];
    
    NSString *sqlQuery = @"SELECT * FROM PERSONINFO";
    sqlite3_stmt * statement = nil;
    
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
//            char *name = (char*)sqlite3_column_text(statement, 1);
//            NSString *nsNameStr = [[NSString alloc]initWithUTF8String:name];
//            
//            int age = sqlite3_column_int(statement, 2);
//            
//            char *address = (char*)sqlite3_column_text(statement, 3);
//            
//            NSString *nsAddressStr = [[NSString alloc]initWithUTF8String:address];
//            
//            NSLog(@"name:%@ age:%d address:%@",nsNameStr,age, nsAddressStr);
        }
    }
    sqlite3_close(db);
    
    return infoArray;
}

@end
