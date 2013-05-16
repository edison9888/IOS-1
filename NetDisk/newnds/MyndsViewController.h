//
//  MyndsViewController.h
//  NetDisk
//
//  Created by fengyongning on 13-4-28.
//
//

#import <UIKit/UIKit.h>

typedef enum {
    kMyndsTypeDefault,
    kMyndsTypeSelect,
} MyndsType;

@interface MyndsViewController : UITableViewController
@property (strong,nonatomic) NSDictionary *dataDic;
@property (strong,nonatomic) NSArray *listArray;
@property (strong,nonatomic) NSString *f_id;
@property (assign,nonatomic) MyndsType myndsType;
@property (assign,nonatomic) MyndsViewController *delegate;
-(void)loadData;
@end

@interface FileItem : NSObject
{
}
@property (nonatomic, assign)	BOOL checked;
+ (FileItem*) fileItem;
@end