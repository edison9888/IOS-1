//
//  UploadFile.m
//  NetDisk
//
//  Created by Yangsl on 13-7-26.
//
//

#import "UploadFile.h"
//需要引用的类
#import <CommonCrypto/CommonDigest.h>
#import "WebData.h"

@implementation UploadFile
@synthesize demo;
@synthesize photoManger;
@synthesize uploderDemo;
@synthesize deviceName;
@synthesize delegate;
@synthesize finishName;
@synthesize connection;
@synthesize space_id;
@synthesize f_id,f_pid;

-(id)init
{
    self = [super init];
    if(self)
    {
        photoManger = [[SCBPhotoManager alloc] init];
        [photoManger setPhotoDelegate:self];
        [photoManger setNewFoldDelegate:self];
        uploderDemo = [[SCBUploader alloc] init];
        [uploderDemo setUpLoadDelegate:self];
    }
    return self;
}

//上传暂停
-(void)upStop
{
    isStop = TRUE;
    if(connection)
    {
        [connection cancel];
        connection = nil;
    }
}

//上传销毁
-(void)upClear
{
    if(connection)
    {
        [connection cancel];
        connection = nil;
    }
}

//上传开始
-(void)upload
{
    if([self.f_id isKindOfClass:[NSString class]])
    {
        if([self.f_id isEqualToString:@"A"])
        {
            [photoManger openFinderWithID:@"1" space_id:self.space_id];
        }
        else
        {
            [photoManger setPhotoDelegate:self];
            [photoManger getDetail:[self.f_id intValue]];
        }
    }
    else
    {
        [photoManger setPhotoDelegate:self];
        [photoManger getDetail:[self.f_id intValue]];
    }
    
    
    currTag = demo.index_id;
    self.deviceName = demo.deviceName;
    NSLog(@"1:打开文件目录:%@",self.deviceName);
}

//请求认证
-(void)requestVerify
{
    if(isStop)
    {
        return;
    }
    if(demo.f_data == nil)
    {
        ALAsset *result = demo.result;
        NSError *error = nil;
        Byte *data = malloc(result.defaultRepresentation.size);
        //获得照片图像数据
        [result.defaultRepresentation getBytes:data fromOffset:0 length:result.defaultRepresentation.size error:&error];
        demo.f_data = [NSData dataWithBytesNoCopy:data length:result.defaultRepresentation.size];
    }
    NSLog(@"1:申请效验");
    uploadData = [[NSString alloc] initWithString:[self md5:demo.f_data]];
    [uploderDemo requestUploadVerify:[self.f_id intValue] f_name:demo.f_base_name f_size:[NSString stringWithFormat:@"%i",[demo.f_data length]] f_md5:uploadData sapce_id:self.space_id];
}

#pragma mark ----文件管理类的代理

-(void)getFileDetail:(NSDictionary *)dictionary
{
    if(isStop)
    {
        return;
    }
    NSLog(@"打开成功 dictionary:%@ ",dictionary);
    int index = [[dictionary objectForKey:@"code"] intValue];
    if(index == 0)
    {
        [self requestVerify];
    }
    else
    {
        self.f_id = @"A";
        [photoManger openFinderWithID:@"1" space_id:self.space_id];
    }
}

-(void)newFold:(NSDictionary *)dictionary
{
    if(isStop)
    {
        return;
    }
    NSLog(@"newFold dictionary:%@",dictionary);
    if([[dictionary objectForKey:@"code"] intValue] != 0)
    {
        return;
    }
    if(self.f_pid==nil)
    {
        BOOL bl = TRUE;
        NSString *name = [dictionary objectForKey:@"f_name"];
        NSLog(@"name:%@",name);
        if([name isEqualToString:@"手机照片"])
        {
            bl = FALSE;
            self.f_pid = [[dictionary objectForKey:@"f_id"] retain];
            NSLog(@"创建%@目录------------------------------",self.deviceName);
            //创建文件夹
            [photoManger requestNewFold:self.deviceName FID:[self.f_pid intValue] space_id:self.space_id];
        }
    }
    else
    {
        NSString *name = [dictionary objectForKey:@"f_name"];
        if([name isEqualToString:self.deviceName])
        {
            self.f_id = [[dictionary objectForKey:@"f_id"] retain];
            demo.p_id = self.f_id;
            [self requestVerify];
        }
    }
}

-(void)openFile:(NSDictionary *)dictionary
{
    NSLog(@"deviceNAME:%@",self.deviceName);
    NSLog(@"dictionary:%@",dictionary);
    if(self.f_pid == nil)
    {
        BOOL bl = TRUE;
        NSArray *array = [dictionary objectForKey:@"files"];
        for(NSDictionary *dic in array)
        {
            NSString *name = [dic objectForKey:@"f_name"];
            if([name isEqualToString:@"手机照片"])
            {
                bl = FALSE;
                self.f_pid = [[dic objectForKey:@"f_id"] retain];
                NSLog(@"打开手机照片目录------------------------------");
                [photoManger openFinderWithID:self.f_pid space_id:self.space_id];
                break;
            }
        }
        if([array count]==0 || bl)
        {
            NSLog(@"创建手机照片目录------------------------------");
            //创建文件夹
            [photoManger requestNewFold:@"手机照片" FID:1 space_id:self.space_id];
        }
    }
    else if([self.f_id isEqualToString:@"A"])
    {
        BOOL bl = TRUE;
        NSArray *array = [dictionary objectForKey:@"files"];
        for(NSDictionary *dic in array)
        {
            NSString *name = [dic objectForKey:@"f_name"];
            if([name isEqualToString:self.deviceName])
            {
                bl = FALSE;
                self.f_id = [[dic objectForKey:@"f_id"] retain];
                demo.p_id = self.f_id;
                [self requestVerify];
                break;
            }
        }
        
        if([array count]==0 || bl)
        {
            NSLog(@"创建%@目录------------------------------",self.deviceName);
            //创建文件夹
            [photoManger requestNewFold:self.deviceName FID:[self.f_pid intValue] space_id:self.space_id];
        }
    }
}

-(void)didFailWithError
{
    
}

#pragma mark -----UpLoadDelegate
//上传效验
-(void)uploadVerify:(NSDictionary *)dictionary
{
    if(isStop)
    {
        return;
    }
    NSLog(@"upload:%@",dictionary);
    if([[dictionary objectForKey:@"code"] intValue] == 0 )
    {
        [uploderDemo requestUploadState:demo.f_base_name];
    }
    else if([[dictionary objectForKey:@"code"] intValue] == 5 )
    {
        [uploadData release];
        demo.f_lenght = [demo.f_data length];
        [demo insertTaskTable];
        
        WebData *web = [[WebData alloc] init];
        web.photo_name = demo.f_base_name;
        web.photo_id = [NSString stringWithFormat:@"%i",demo.f_id];
        [web insertWebData];
        [web release];
        
        [delegate upFinish:currTag];
    }
    else
    {
        [delegate upFinish:currTag];
//        [delegate upError:currTag];
    }
    
}

//申请上传状态
-(void)requestUploadState:(NSDictionary *)dictionary
{
    if(isStop)
    {
        return;
    }
    NSLog(@"dictionary:%@",dictionary);
    if([[dictionary objectForKey:@"code"] intValue] == 0)
    {
        finishName = [dictionary objectForKey:@"sname"];
        NSLog(@"demo.f_data:%i",[demo.f_data length]);
        if([demo.f_data length]==0)
        {
            NSLog(@"验证失败");
            [delegate upFinish:currTag];
        }
        else
        {
            NSLog(@"3:开始上传：%@",finishName);
            connection = [uploderDemo requestUploadFile:self.f_id f_name:demo.f_base_name s_name:finishName skip:[NSString stringWithFormat:@"%i",[demo f_lenght]] f_md5:[self md5:demo.f_data] Image:demo.f_data];
        }
    }
}

//上传文件完成
-(void)uploadFinish:(NSDictionary *)dictionary
{
    connection = nil;
    if(isStop)
    {
        return;
    }
    NSLog(@"uploadFinishdictionary:%@",dictionary);
        
    NSLog(@"uploadFinishdictionary:%@",dictionary);
    if([[dictionary objectForKey:@"code"] intValue] == 0)
    {
        [delegate upProess:1 fileTag:currTag];
        NSLog(@"4:提交上传表单:%@",finishName);
        [uploderDemo requestUploadCommit:self.f_id f_name:demo.f_base_name s_name:finishName device:@"" skip:@"" f_md5:uploadData img_createtime:@"" space_id:space_id];
    }
    else
    {
        NSLog(@"上传失败");
        [delegate upFinish:currTag];
//        [delegate upError:currTag];
    }
}

//查看上传记录
-(void)lookDescript:(NSDictionary *)dictionary
{

}

//上传文件流
-(void)uploadFiles:(int)proress
{
    if(isStop)
    {
        return;
    }
    NSLog(@"得到上传流");
    float f = (float)proress / (float)[demo.f_data length];
    [demo setProess:f];
    [delegate upProess:f fileTag:currTag];
    NSLog(@"uploadFiles-----------:%f",f);
}

//上传提交
-(void)uploadCommit:(NSDictionary *)dictionary
{
    if(isStop)
    {
        return;
    }
    NSLog(@"dictionary:%@",dictionary);
    NSLog(@"5:完成");
    
    if([[dictionary objectForKey:@"code"] intValue] == 0 || [[dictionary objectForKey:@"code"] intValue] == 5)
    {
        NSInteger fid = [[dictionary objectForKey:@"fid"] intValue];
        demo.f_id = fid;
        demo.f_state = 1;
        demo.f_lenght = [demo.f_data length];
        NSLog(@"Url-------:%@",demo.databasePath);
        if(demo.is_automic_upload)
        {
            [demo insertTaskTable];
        }
        else
        {
            [demo updateTaskTableFName];
        }
        
        
        WebData *web = [[WebData alloc] init];
        web.photo_name = demo.f_base_name;
        web.photo_id = [NSString stringWithFormat:@"%i",demo.f_id];
        [web insertWebData];
        [web release];
        [delegate upFinish:currTag];
        [uploadData release];
    }
}


#pragma mark  -----------常用方法

-(NSString *)md5:(NSData *)concat {
    CC_MD5_CTX md5_ctx;
    CC_MD5_Init(&md5_ctx);
    
    NSData* filedata = concat;
    CC_MD5_Update(&md5_ctx, [filedata bytes], [filedata length]);
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(result, &md5_ctx);
    NSMutableString *hash = [NSMutableString string];
    for(int i=0;i<CC_MD5_DIGEST_LENGTH;i++)
    {
        [hash appendFormat:@"%02x",result[i]];
    }
    return [hash lowercaseString];
}

-(void)dealloc
{
    [demo release];
    [photoManger release];
    [uploderDemo release];
    [finishName release];
    [super dealloc];
}

@end
