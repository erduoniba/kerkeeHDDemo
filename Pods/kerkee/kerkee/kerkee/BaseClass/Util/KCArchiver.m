//
//  KCArchiver.m
//  kerkee
//
//  Created by zihong on 15/8/25.
//  Copyright (c) 2015年 zihong. All rights reserved.
//



#import "KCArchiver.h"
#import "KCLog.h"
#import "KCUtilFile.h"

@implementation KCArchiver

#pragma mark - Privates
+ (NSString*)_filePathForKey:(NSString*)key
{
    NSString* filename = [key stringByAppendingPathExtension:@"archive"];
    return [KCUtilFile appendToPath:self.path FileName:filename];
}

+ (void)_createDirectoryForKey:(NSString*)key
{
    NSString* dir = [[self _filePathForKey:key] stringByDeletingLastPathComponent];
    if (![KCUtilFile isExist:dir])
    {
        NSError* error = nil;
        [NSFileManager.defaultManager createDirectoryAtPath:dir
                                    withIntermediateDirectories:YES
                                                     attributes:nil
                                                          error:&error];
        if (error)
        {
            KCLog(@"%@", error);
        }
    }
}

#pragma mark - API

+ (BOOL)archiveRootObject:(id <NSCoding>)aRootObject forKey:(NSString*)aKey
{
    aKey = [aKey stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]];
    if (aKey.length == 0)
    {
        return NO;
    }
    @try
    {
        [self _createDirectoryForKey:aKey];
        return [NSKeyedArchiver archiveRootObject:aRootObject
                                           toFile:[self _filePathForKey:aKey]];
    }
    @catch (NSException* e)
    {
        KCLog(@"%@", e);
        return NO;
    }
}

+ (id)unarchiveObjectForKey:(NSString*)aKey
{
    id object = nil;
    @try
    {
        object = [NSKeyedUnarchiver unarchiveObjectWithFile:[self _filePathForKey:aKey]];
    }
    @catch (NSException* e)
    {
        KCLog(@"%@", e);
    }
    return object;
}

+ (id)unarchiveObjectForKey:(NSString*)aKey defaultObject:(id(^)())aDefaultObject
{
    id object = [self unarchiveObjectForKey:aKey];
    if (object == nil)
    {
        object = aDefaultObject();
    }
    return object;
}

+ (id)unarchiveObjectForKey:(NSString*)aKey failure:(void(^)())failure
{
    id object = [self unarchiveObjectForKey:aKey];
    if (object == nil)
    {
        failure();
    }
    return object;
}


+ (BOOL)removeArchiveForKey:(NSString*)aKey
{
    BOOL result = YES;
    NSString* filePath = [self _filePathForKey:aKey];
    if ([self archiveExistsForKey:aKey])
    {
        NSError* error = nil;
        result = [NSFileManager.defaultManager removeItemAtPath:filePath
                                                          error:&error];
        if (error)
        {
            KCLog(@"%@", error);
        }
    }
    return result;
}

+ (BOOL)archiveExistsForKey:(NSString*)aKey
{
    return [KCUtilFile isExist:[self _filePathForKey:aKey]];
}


+ (NSString*)path
{
    NSString* strPath = [KCUtilFile dataPath:@".Archiver"];
//    return NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
//    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    return strPath;
    
}



@end
