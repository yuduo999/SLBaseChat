//
//  Common.m
//  OAChat
//
//  Created by song.zhang on 15/5/28.
//  Copyright (c) 2015年 sino-life. All rights reserved.
//

#import "BCCommon.h"

@implementation BCCommon


+(NSString *)getUserHeadImageSavePath:(NSString *)userId{
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *savePath = [NSString stringWithFormat:@"%@/%@/headImages", pathDocuments,userId];
    return savePath;
    
}
+(UIImage *)getUserHeadImageFromImageName:(NSString *)imageName withUserId:(NSString *)userId
{
    NSString *filePath = [[BCCommon getUserHeadImageSavePath:userId] stringByAppendingPathComponent:imageName];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (!blHave) {
        return [UIImage imageNamed:@"user_default_head.png"];
    }else
    {
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        UIImage *img = [[UIImage alloc] initWithData:data];
        // NSLog(@" have");
        return img;
    }
}

+(UIImage*)convertViewToImage:(UIView*)view{
    
    CGSize s =view.bounds.size;
    
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，关键就是第三个参数。
    
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
    
}

+(NSString *)ValiString:(NSString *)tempString {
    return [self ValiString:tempString defaultValue:@""];
    
}
+(NSString *)ValiString:(id)tempString  defaultValue:(NSString *)defaultValue{
    
    if ([tempString isKindOfClass:[NSNull class]]||tempString==nil || [NSString stringWithFormat:@"%@",tempString].length == 0){
        return defaultValue;
    }
    return [NSString stringWithFormat:@"%@",tempString];
    
}

+(NSInteger)ValiInt:(NSString *)tempString{
    return [self ValiInt:tempString defaultValue:0];
}
+(NSInteger)ValiInt:(id)tempString  defaultValue:(NSInteger)defaultValue{
    if ([tempString isKindOfClass:[NSNull class]]||tempString==nil || [NSString stringWithFormat:@"%@",tempString].length == 0){
        return defaultValue;
    }
    return [tempString integerValue];
    
}
+(id)ValiNumber:(id)tempString  {
    return [self ValiNumber:tempString defaultValue:@(0)];
}
+(id)ValiNumber:(id)tempString  defaultValue:(id)defaultValue{
    if ([tempString isKindOfClass:[NSNull class]]||tempString==nil || [NSString stringWithFormat:@"%@",tempString].length == 0){
        return defaultValue;
    }
    return tempString ;
}


+(NSString *)readLogData:(NSString *)fileName {
    
   
    
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *createPath = [NSString stringWithFormat:@"%@/logs", pathDocuments];
   
 
    
    NSString *filePath= [createPath
                         
                         stringByAppendingPathComponent:fileName];
    
    NSError *error=nil;
    
    //    通过指定的路径读取文本内容
    
    NSString *str=[NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
    if (error) {
        return @"暂无信息";
    }else{
        return str;
    }
}


+(void)SaveLogData:(NSString *)logData withlogName:(NSString *)fileName {

    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *datestr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *content = [NSString stringWithFormat:@"\nLogDate:%@\n%@\n",datestr,logData];
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *pathDocuments = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *createPath = [NSString stringWithFormat:@"%@/logs", pathDocuments];
    // 判断文件夹是否存在，如果不存在，则创建
    if (![[NSFileManager defaultManager] fileExistsAtPath:createPath]) {
        [fileManager createDirectoryAtPath:createPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    // File we want to create in the documents directory我们想要创建的文件将会出现在文件目录中
    
    // Result is: /Documents/file1.txt结果为：/Documents/file1.txt
    
    NSString *filePath= [createPath
                         
                         stringByAppendingPathComponent:fileName];
    
    if(![fileManager fileExistsAtPath:filePath]) //如果不存在
    {
       
        [content writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
        return;
    }
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:filePath];
    
    [fileHandle seekToEndOfFile];  //将节点跳到文件的末尾
    
   
    NSData* stringData  = [content dataUsingEncoding:NSUTF8StringEncoding];
    
    [fileHandle writeData:stringData]; //追加写入数据
    
    [fileHandle closeFile];
    
    
}

@end
