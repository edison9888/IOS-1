//
//  MessagePushController.h
//  NetDisk
//
//  Created by Yangsl on 13-8-5.
//
//

#import <UIKit/UIKit.h>

@interface MessagePushController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *table_view;
    /*
     自定义navBar
     */
    UIView *topView;
    NSMutableArray *table_array;
}

@property(nonatomic,retain) UITableView *table_view;
@property(nonatomic,retain) UIView *topView;
@property(nonatomic,retain) NSMutableArray *table_array;

@end
