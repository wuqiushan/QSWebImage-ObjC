//
//  QSDiskCache.m
//  QSWebImage
//
//  Created by apple on 2019/10/2.
//  Copyright © 2019年 wuqiushan. All rights reserved.
//

#import "QSDiskCache.h"
#import "LruCache.h"
#import "LruNode.h"

/*
 存储数据到硬盘, 操作io口
 删除指定的路径下的文件夹
 计算路径下的总大小
 计算单个文件的总大小
 读取当前硬盘大小，一般是程序启动时读一下
 */

@interface QSDiskCache()

/** 维护一个 lru  key:文件名，value:文件大小 */
@property (nonatomic, strong) LruCache *lruCache;
@property (nonatomic, assign) long long maxStoreSize;
@property (nonatomic, assign) long long useStoreSize;
@property (nonatomic, strong) NSString *storePath;
@property (nonatomic, strong) NSFileManager *fileManager;

@end

@implementation QSDiskCache

#pragma mark - 初始化、文件操作
- (instancetype)init
{
    return [self initWithStorePath:nil maxStoreSize:0];
}

- (instancetype)initWithStorePath:(NSString *)path maxStoreSize:(long long)size
{
    self.storePath = path;
    self.maxStoreSize = size;
    
    self = [super init];
    if (self) {
        
        if (self.maxStoreSize == 0) {
            self.maxStoreSize = 500 * 1024;
        }
        if (self.storePath == nil) {
            // 默认路径： ../caches/QSWebImage
            NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
            self.storePath = [cachesPath stringByAppendingPathComponent:@"QSWebImage"];
        }
        
        // 创建对应的路径
        if (![self.fileManager fileExistsAtPath:self.storePath]) {
            
            NSError *error;
            [self.fileManager createDirectoryAtPath:self.storePath
                        withIntermediateDirectories:YES
                                         attributes:nil
                                              error:&error];
            if (error) {
                self.storePath = nil;
                NSAssert(self.storePath != nil, @"QSDiskCache路径创建失败");
            }
        }
        
        // 读取配置文件，初始 lruCache和useStoreSize 变量
        [self initlruCacheAndSize];
        // 通知
        [self initNotify];
    }
    return self;
}


/**
 写入文件到磁盘里
 1.如果对应路径有此文件，则先删除，再创建文件，写入数据

 @param name 文件名称
 @param data 文件内容
 */
- (void)writeFileWithName:(NSString *)name content:(NSData *)data {
    
    [self removeFileWithName:name];
    NSString *filePath = [self.storePath stringByAppendingPathComponent:name];
    BOOL isSuccess = [self.fileManager createFileAtPath:filePath contents:data attributes:nil];
    NSAssert(isSuccess == true, @"写入文件失败");
    
    // 如果文件总大小超过域值就是循环去删除，直到文件合理
    if (isSuccess) {
        // 读出存储文件的大小
        long long fileSize = [self getFileSize:name];
        self.useStoreSize += fileSize;
        [self.lruCache putKey:name value:[NSNumber numberWithLongLong:fileSize]];
        
        while (self.useStoreSize > self.maxStoreSize) {
            NSString *tailKey = [self.lruCache getTailKey];
            [self removeFileWithName:tailKey];
        }
    }
}

/**
 读取图片文件，通过key,

 @param name 是图片链接的MD5值
 */
- (NSData *)readFileWithName:(NSString *)name {
    
    NSString *filePath = [self.storePath stringByAppendingPathComponent:name];
    if ([self.fileManager fileExistsAtPath:filePath]) {
        NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:filePath];
        NSData *fileData = [handle readDataToEndOfFile];
        [handle closeFile];
        
        // 读取完后要把指定的图片 lru 排在头节点
        [self.lruCache get:name];
        
        return fileData;
    }
    return nil;
}


/**
 删除文件，通过文件名

 @param name 图片的文件名
 */
- (void)removeFileWithName:(NSString *)name {
    
    NSError *error;
    NSString *filePath = [self.storePath stringByAppendingPathComponent:name];
    if ([self.fileManager fileExistsAtPath:filePath]) {
        [self.fileManager removeItemAtPath:filePath error:&error];
        NSAssert(error == nil, @"移除文件失败");
        
        // 当文件删除后，使用大小要变化，同时把lru元素g移除
        if (!error) {
            long long fileSize = ((NSNumber *)[self.lruCache get:name]).longLongValue;
            if (self.useStoreSize >= fileSize) {
                self.useStoreSize -= fileSize;
            }
            else {
                self.useStoreSize = 0;
            }
            [self.lruCache removeWithKey:name];
        }
    }
}


/**
 获取所有文件大小

 @return 返回所有文件大小值
 */
- (long long)getDirectorySize {
    return [self getFileSize:nil];
}


/**
 获取指定的文件大小

 @param name 文件名称
 @return 返回指定文件的大小
 */
- (long long)getFileSize:(NSString *)name {
    
    unsigned long long fileLength = 0;
    NSError *error;
    NSString *filePath = self.storePath;
    if ((name != nil) && (name.length > 0)) {
        filePath = [filePath stringByAppendingPathComponent:name];
    }
    if ([self.fileManager fileExistsAtPath:filePath]) {
        NSDictionary *dic =[self.fileManager attributesOfItemAtPath:self.storePath error:&error];
        if (error) {
            return 0;
        }
        else {
            // 这里有个问题，用方法读出来要远小于用mac直接查看的值
            fileLength = [dic fileSize];
            return fileLength * 1000 / 8;
        }
    }
    return 0;
}


#pragma mark - lruCache 处理


/**
 当程序启动时，把上次lruCache记录读出来供本次使用
 1.把plist文件读取出来
 2.然后遍历，填充在lruCache变量中
 3.遍历所有文件，如果在lruCache中找不到就删除
 (注意不能用LruCacheget类中的get方法，因为get会导致Lru链表重新排序，直接 类.dic 操作)
 4.计算当前使用存储大小
 */
- (void)initlruCacheAndSize {
    
    NSString *lruCachePath = [self.storePath stringByAppendingPathComponent:@"lruCache.plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:lruCachePath];
    if (!dic) {
        self.useStoreSize = 0;
    }
    else {
        // 因为从后往前，所以最新的排在首节点
        NSString *tail = [dic objectForKey:@"tail"];
        while (tail != nil) {
            
            NSDictionary *contentDic = [dic objectForKey:tail];
            long long size = [[contentDic objectForKey:@"size"] longLongValue];
            NSNumber *value = [NSNumber numberWithLongLong:size];
            [self.lruCache putKey:tail value:value];
            
            tail = [contentDic objectForKey:@"prev"];
        }
        
        NSError *error;
        NSArray<NSString *> *fileList = [self.fileManager contentsOfDirectoryAtPath:self.storePath error:&error];
        NSEnumerator *enumerator = [fileList objectEnumerator];
        id element = nil;
        while (element = [enumerator nextObject]) {
            NSString *elementStr = (NSString *)element;
            if ([elementStr isEqualToString:@".DS_Store"] ||
                [elementStr isEqualToString:@"lruCache.plist"]) {
                continue ;
            }
            
            if (![self.lruCache.dic objectForKey:elementStr]) {
                [self removeFileWithName:elementStr];
            }
        }
        
        self.useStoreSize = [self getDirectorySize];
    }
}


/**
 程序进入非活动状态、后台、杀死等通知
 */
- (void)initNotify {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(savelruCache) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(savelruCache) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(savelruCache) name:UIApplicationWillTerminateNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
}

/**
 当程序退出时，才存储
 1.把遍历Lru转成字典如： {tail:MD5, MD5: { size: 20,  prev: MD5}, MD5: { size: 20,  prev: MD5}}
 2.删除之前存储的plist文件
 2.把转化后的字典用plist文件存储在对应的位置上
 
 */
- (void)savelruCache {
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    if (!self.lruCache.getTailKey) {
        return ;
    }
    [dic setObject:self.lruCache.getTailKey forKey:@"tail"];
    [self.lruCache.dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[LruNode class]]) {
            LruNode *node = (LruNode *)obj;
            NSMutableDictionary *subDic = [[NSMutableDictionary alloc] init];
            if (node.value) {
                [subDic setObject:node.value forKey:@"size"];
            }
            if (node.prev.key) {
                [subDic setObject:node.prev.key forKey:@"prev"];
            }
            [dic setObject:subDic forKey:node.key];
        }
    }];
    
    NSString *lruCachePath = [self.storePath stringByAppendingPathComponent:@"lruCache.plist"];
    if ([self.fileManager fileExistsAtPath:lruCachePath]) {
        NSError *error;
        [self.fileManager removeItemAtPath:lruCachePath error:&error];
        NSAssert(error == nil, @"保存配置lruCache时，删除之前的plist出错");
    }
    [dic writeToFile:lruCachePath atomically:YES];
}

#pragma mark - 懒加载
- (NSFileManager *)fileManager {
    if (!_fileManager) {
        _fileManager = [NSFileManager defaultManager];
    }
    return _fileManager;
}

- (LruCache *)lruCache {
    if (!_lruCache) {
        _lruCache = [[LruCache alloc] init];
    }
    return _lruCache;
}

@end
