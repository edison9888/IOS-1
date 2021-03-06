//
//  UserInfo.m
//  NetDisk
//
//  Created by Yangsl on 13-8-5.
//
//

#import "UserInfo.h"


@implementation UserInfo
@synthesize isTrue,keyString;
@synthesize descript;
@synthesize f_id;

//添加数据
-(BOOL)insertUserinfo
{
    sqlite3_stmt *statement;
    __block BOOL bl = TRUE;
    const char *dbpath = [self.databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &contactDB)==SQLITE_OK) {
        const char *insert_stmt = [InsertUserinfoTable UTF8String];
        int success = sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL);
        if (success != SQLITE_OK) {
            bl = FALSE;
        }
        sqlite3_bind_int(statement, 1, isTrue);
        sqlite3_bind_text(statement, 2, [keyString UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_text(statement, 3, [descript UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(statement, 4, f_id);
        success = sqlite3_step(statement);
        if (success == SQLITE_ERROR) {
            bl = FALSE;
        }
        NSLog(@"insertUserinfo:%i",success);
        sqlite3_finalize(statement);
        sqlite3_close(contactDB);
    }
    return bl;
}

//修改数据
-(BOOL)updateUserinfo
{
    sqlite3_stmt *statement;
    __block BOOL bl = TRUE;
    const char *dbpath = [self.databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &contactDB)==SQLITE_OK) {
        const char *insert_stmt = [UpdateUserinfoForName UTF8String];
        int success = sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL);
        if (success != SQLITE_OK) {
            bl = FALSE;
        }
        sqlite3_bind_int(statement, 1, isTrue);
        sqlite3_bind_text(statement, 2, [descript UTF8String], -1, SQLITE_TRANSIENT);
        sqlite3_bind_int(statement, 3, f_id);
        sqlite3_bind_text(statement, 4, [keyString UTF8String], -1, SQLITE_TRANSIENT);
        
        success = sqlite3_step(statement);
        if (success == SQLITE_ERROR) {
            bl = FALSE;
        }
        NSLog(@"updateUserinfo:%i",success);
        sqlite3_finalize(statement);
        sqlite3_close(contactDB);
    }
    return bl;
}

//查询数据
-(BOOL)selectIsTrueForKey
{
    sqlite3_stmt *statement;
    const char *dbpath = [self.databasePath UTF8String];
    __block BOOL bl = FALSE;
    if (sqlite3_open(dbpath, &contactDB)==SQLITE_OK) {
        const char *insert_stmt = [SelectForKey UTF8String];
        sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL);
        sqlite3_bind_text(statement, 1, [keyString UTF8String], -1, SQLITE_TRANSIENT);
        while (sqlite3_step(statement)==SQLITE_ROW) {
            int i = sqlite3_column_int(statement, 0);
            if(i==1)
            {
                bl = TRUE;
                break;
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(contactDB);
    }
    return bl;
}

//查询数据列表
-(NSMutableArray *)selectAllUserinfo
{
    sqlite3_stmt *statement;
    NSMutableArray *tableArray = [[NSMutableArray alloc] init];
    const char *dbpath = [self.databasePath UTF8String];
    if (sqlite3_open(dbpath, &contactDB)==SQLITE_OK) {
        const char *insert_stmt = [SelectAllKey UTF8String];
        sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL);
        sqlite3_bind_text(statement, 1, [keyString UTF8String], -1, SQLITE_TRANSIENT);
        while (sqlite3_step(statement)==SQLITE_ROW) {
            UserInfo *info = [[UserInfo alloc] init];
            info.isTrue = sqlite3_column_int(statement, 1);
            info.keyString = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
            info.descript = [NSString stringWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
            NSLog(@"info.descript:%@",info.descript);
            info.f_id = sqlite3_column_int(statement, 4);
            [tableArray addObject:info];
            [info release];
        }
        sqlite3_finalize(statement);
        sqlite3_close(contactDB);
    }
    return [tableArray autorelease];
}

@end
