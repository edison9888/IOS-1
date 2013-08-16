//
//  AutomaticUpload.h
//  NetDisk
//
//  Created by Yangsl on 13-8-7.
//
//

/*
 
 自动上传逻辑
 
 1.搜索照片库的照片
 2.比对本地照片库信息
 3.只是上传本地数据库和服务器都没有的图片
 4.开启上传
 
 */

#import <Foundation/Foundation.h>
#import "UploadFile.h"
#import "ChangeUploadViewController.h"

@interface AutomaticUpload : NSObject <UploadFileDelegate>
{
    NSString *space_id;
    NSString *deviceName;
    NSString *f_id;
    ChangeUploadViewController *uploadViewController;
    ALAssetsLibrary *assetsLibrary;
    NSMutableOrderedSet *assetArray;
    UploadFile *upload_file;
    int netWorkState;
    NSTimer *upload_timer;
}

@property(nonatomic,retain) NSMutableOrderedSet *assetArray;
@property(nonatomic,retain) NSString *f_id;
@property(nonatomic,retain) NSString *deviceName;
@property(nonatomic,assign) int netWorkState;
@property(nonatomic,retain) NSTimer *upload_timer;

//比对本地数据库
-(void)isHaveData;

//开启自动上传
-(void)startAutomaticUpload;

//关闭自动上传
-(void)colseAutomaticUpload;



@end
