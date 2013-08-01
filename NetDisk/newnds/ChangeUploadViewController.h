//
//  ChangeUploadViewController.h
//  NetDisk
//  定点上传
//  Created by Yangsl on 13-7-26.
//
//

#import <UIKit/UIKit.h>
//引用代理类
#import "UploadFile.h"
#import "UploadViewCell.h"

@interface ChangeUploadViewController : UIViewController <UploadFileDelegate,UITableViewDataSource,UITableViewDelegate,UploadViewCellDelegate>
{
    //头部视图
    UIView *topView;
    //底部视图
    //中间列表
    UITableView *uploadListTableView;
    //上传数据列表
    NSMutableArray *uploadingList;
    //历史纪录数据列表
    NSMutableArray *historyList;
    //如果为Flase,显示上传纪录，为True，显示历史纪录
    BOOL isHistoryShow;
    //上传至文件夹目录名称
    NSString *deviceName;
    //更多信息的内容
    UIControl *more_control;
    //背景图
    UIImageView *bgIamgeView;
    //全部开始
    UIButton *uploadAll_button;
    UILabel *uploadAll_label;
    //全部清空
    UIButton *deleteAll_button;
    UILabel *deleteAll_label;
    
    UILabel *title_leble;
    
    //是否全部上传
    BOOL isUploadAll;
}

@property(nonatomic,retain) UIView *topView;
@property(nonatomic,retain) UITableView *uploadListTableView;
@property(nonatomic,retain) NSMutableArray *uploadingList;
@property(nonatomic,retain) NSMutableArray *historyList;
@property(nonatomic,assign) BOOL isHistoryShow;
@property(nonatomic,retain) UIControl *more_control;
@property(nonatomic,assign) BOOL isUploadAll;

//上传成功
-(void)upFinish:(NSInteger)fileTag;
//上传进行时，发送上传进度数据
-(void)upProess:(float)proress fileTag:(NSInteger)fileTag;
//删除上传时列表
-(void)deleteUploadingIndexRow:(int)row_;
//删除上传记录列表
-(void)deleteFinishIndexRow:(int)row_;
//更新上传记录列表
-(void)updateReloadData;

@end
