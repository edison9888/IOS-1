//
//  FavoritesViewController.m
//  NetDisk
//
//  Created by fengyongning on 13-5-16.
//
//

#import "FavoritesViewController.h"
#import "FavoritesData.h"
#import "PhotoLookViewController.h"
#import "YNFunctions.h"
#import "IconDownloader.h"
#import "OtherBrowserViewController.h"
#import "PhotoFile.h"
#import "QLBrowserViewController.h"
@interface FavoritesViewController ()

@end

@implementation FavoritesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc
{
    [[FavoritesData sharedFavoritesData] setFviewController:nil];
    self.imageDownloadsInProgress=nil;
    [super dealloc];
}
- (void)viewDidLoad
{
    self.imageDownloadsInProgress=[NSMutableDictionary dictionary];
    [super viewDidLoad];
    [[FavoritesData sharedFavoritesData] setFviewController:self];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self setHidesBottomBarWhenPushed:NO];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[FavoritesData sharedFavoritesData] reloadData];
    [self.tableView reloadData];
    [[FavoritesData sharedFavoritesData] startDownloading];
    [super viewDidAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    int count=[[FavoritesData sharedFavoritesData] count];
    return count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                         reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *dic=[[[FavoritesData sharedFavoritesData] allValues] objectAtIndex:indexPath.row];
    
    if (cell.imageView.subviews.count==0) {
        UIImageView *tagView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"favorite_tag_n.png"]];
        CGRect r=[tagView frame];
        r.origin.x=20;
        r.origin.y=20;
        [tagView setFrame:r];
        [cell.imageView addSubview:tagView];
    }
    
    NSString *name= [dic objectForKey:@"f_name"];
    NSString *t_fl = [[dic objectForKey:@"f_mime"] lowercaseString];
    NSString *f_size=[dic objectForKey:@"f_size"];
    NSString *f_id=[dic objectForKey:@"f_id"];
    NSString *f_time=[dic objectForKey:@"f_time"];

    
    cell.textLabel.text=name;
    
    NSString *fileName=[dic objectForKey:@"f_name"];
    NSString *filePath=[YNFunctions getFMCachePath];
    filePath=[filePath stringByAppendingPathComponent:fileName];
    
    UIImageView *tagImageView=(UIImageView *)[cell.imageView.subviews objectAtIndex:0];
    [tagImageView setImage:[UIImage imageNamed:@"favorite_tag_n.png"]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ %@",[YNFunctions convertSize:f_size],f_time];
        [tagImageView setImage:[UIImage imageNamed:@"favorite_tag.png"]];
    }else if([f_id isEqualToString:[[FavoritesData sharedFavoritesData] currentDownloadID]])
    {
        if (self.text!=nil) {
            cell.detailTextLabel.text=self.text;
        }else
        {
            cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ 0%%已下载",[YNFunctions convertSize:f_size]];
        }
    }else
    {
        cell.detailTextLabel.text=[NSString stringWithFormat:@"%@ 等待中...",[YNFunctions convertSize:f_size]];
    }
    if ([t_fl isEqualToString:@"png"]||
        [t_fl isEqualToString:@"jpg"]||
        [t_fl isEqualToString:@"jpeg"]||
        [t_fl isEqualToString:@"bmp"]||
        [t_fl isEqualToString:@"gif"])
    {
        CGRect r=[tagImageView frame];
        r.origin.x=20;
        r.origin.y=20;
        [tagImageView setFrame:r];
    }else
    {
        CGRect r=[tagImageView frame];
        r.origin.x=25;
        r.origin.y=25;
        [tagImageView setFrame:r];
    }

    
    if ([t_fl isEqualToString:@"png"]||
              [t_fl isEqualToString:@"jpg"]||
              [t_fl isEqualToString:@"jpeg"]||
              [t_fl isEqualToString:@"bmp"]||
              [t_fl isEqualToString:@"gif"])
    {
        NSString *compressaddr=[dic objectForKey:@"compressaddr"];
        compressaddr =[YNFunctions picFileNameFromURL:compressaddr];
        NSString *path=[YNFunctions getIconCachePath];
        path=[path stringByAppendingPathComponent:compressaddr];
        
        //"compressaddr":"cimage/cs860183fc-81bd-40c2-817a-59653d0dc513.jpg"
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) // avoid the app icon download if the app already has an icon
        {
            //UIImageView *tagView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:path]];
            UIImage *icon=[UIImage imageWithContentsOfFile:path];
            CGSize itemSize = CGSizeMake(40, 40);
            UIGraphicsBeginImageContext(itemSize);
            CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
            [icon drawInRect:imageRect];
            UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            cell.imageView.image = image;
        }else
        {
            [self startIconDownload:dic forIndexPath:indexPath];
            cell.imageView.image = [UIImage imageNamed:@"icon_pic.png"];
        }
        
    }else if ([t_fl isEqualToString:@"doc"]||
              [t_fl isEqualToString:@"docx"])
    {
        cell.imageView.image = [UIImage imageNamed:@"icon_doc.png"];
    }else if ([t_fl isEqualToString:@"mp3"])
    {
        cell.imageView.image = [UIImage imageNamed:@"icon_music.png"];
    }else if ([t_fl isEqualToString:@"mov"])
    {
        cell.imageView.image = [UIImage imageNamed:@"icon_movie.png"];
    }else if ([t_fl isEqualToString:@"ppt"])
    {
        cell.imageView.image = [UIImage imageNamed:@"icon_ppt.png"];
    }else
    {
        cell.imageView.image = [UIImage imageNamed:@"icon_unkown.png"];
    }
    [cell.imageView setFrame:CGRectMake(0, 0, 23, 23)];
    [cell.imageView setContentMode:UIViewContentModeScaleAspectFit];
    //CGRect rect=[cell.imageView frame];
    //NSLog(@"%f,%f,%f,%f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSArray *listArray=[[FavoritesData sharedFavoritesData] allValues];
        NSDictionary *dic=[listArray objectAtIndex:indexPath.row];
        NSString *f_id=[dic objectForKey:@"f_id"];
        NSString *fileName=[dic objectForKey:@"f_name"];
        NSString *filePath=[YNFunctions getFMCachePath];
        filePath=[filePath stringByAppendingPathComponent:fileName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            NSError *error=[[NSError alloc] init];
            if ([[NSFileManager defaultManager] removeItemAtPath:filePath error:&error]) {
                NSLog(@"删除本地收藏文件成功：%@",filePath);
            }else
            {
                NSLog(@"删除本地收藏文件失败：%@",filePath);
            }
        }
        [[FavoritesData sharedFavoritesData] removeObjectForKey:f_id];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (BOOL)shouldAutorotate{
    return YES;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *listArray=[[FavoritesData sharedFavoritesData] allValues];
    NSDictionary *dic=[listArray objectAtIndex:indexPath.row];
        //先做文件类型判断，是否是为可预览文件，如果为否，不做任何操作
        //判断文件是否下载完成，如果下载完成，打开预览，否则不做任何操作
        NSString *fileName=[dic objectForKey:@"f_name"];
        NSString *filePath=[YNFunctions getFMCachePath];
        filePath=[filePath stringByAppendingPathComponent:fileName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            QLBrowserViewController *previewController=[[QLBrowserViewController alloc] init];
            previewController.dataSource=self;
            previewController.delegate=self;
            
            previewController.currentPreviewItemIndex=indexPath.row;
            [previewController setHidesBottomBarWhenPushed:YES];
//            [self.navigationController pushViewController:previewController animated:YES];
            //[self presentModalViewController:previewController animated:YES];
            [self presentViewController:previewController animated:YES completion:^(void){
                NSLog(@"%@",previewController);
            }];
//            [self.navigationController.toolbar setBarStyle:UIBarStyleBlack];
        }else{
        }

}
#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    NSArray *listArray=[[FavoritesData sharedFavoritesData] allValues];
    if ([listArray count] > 0)
    {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            NSDictionary *dic = [listArray objectAtIndex:indexPath.row];
            NSString *compressaddr=[dic objectForKey:@"compressaddr"];
            compressaddr =[YNFunctions picFileNameFromURL:compressaddr];
            NSString *path=[YNFunctions getIconCachePath];
            path=[path stringByAppendingPathComponent:compressaddr];
            
            //"compressaddr":"cimage/cs860183fc-81bd-40c2-817a-59653d0dc513.jpg"
            if (![[NSFileManager defaultManager] fileExistsAtPath:path]) // avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:dic forIndexPath:indexPath];
            }
        }
    }
}
- (void)startIconDownload:(NSDictionary *)dic forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.data_dic=dic;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        [self.imageDownloadsInProgress setObject:iconDownloader forKey:indexPath];
        [iconDownloader startDownload];
        [iconDownloader release];
    }
}
- (void)appImageDidLoad:(NSIndexPath *)indexPath;
{
    IconDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (iconDownloader != nil)
    {
        UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        if (cell) {
            [self.tableView reloadRowsAtIndexPaths:@[iconDownloader.indexPathInTableView] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    
    // Remove the IconDownloader from the in progress list.
    // This will result in it being deallocated.
    [self.imageDownloadsInProgress removeObjectForKey:indexPath];
}
#pragma mark - UIDocumentInteractionControllerDelegate
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)interactionController
{
    return self;
}
#pragma mark - QLPreviewControllerDataSource
// Returns the number of items that the preview controller should preview
- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)previewController
{
    NSInteger numToPreview = 0;
//    
//    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
//    if (selectedIndexPath.section == 0)
//        numToPreview = NUM_DOCS;
//    else
//        numToPreview = self.documentURLs.count;
//    
//    return numToPreview;
    numToPreview=[self.tableView numberOfRowsInSection:0];
    return numToPreview;
}
- (void)previewControllerDidDismiss:(QLPreviewController *)controller
{
    // if the preview dismissed (done button touched), use this method to post-process previews
}
// returns the item that the preview controller should preview
- (id)previewController:(QLPreviewController *)previewController previewItemAtIndex:(NSInteger)idx
{
    NSURL *fileURL = nil;
    
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    NSDictionary *dic=[[[FavoritesData sharedFavoritesData] allValues] objectAtIndex:idx];
    NSString *fileName=[dic objectForKey:@"f_name"];
    NSString *filePath=[YNFunctions getFMCachePath];
    filePath=[filePath stringByAppendingPathComponent:fileName];
    fileURL=[NSURL fileURLWithPath:filePath];
    return fileURL;
}
#pragma mark - SCBDownloaderDelegate Methods
-(void)fileDidDownload:(int)index
{
    //int rows=[self.tableView numberOfRowsInSection:0];
    //if ([[FavoritesData sharedFavoritesData] count]!=rows) {
    [self.tableView reloadData];
    //}
    //[self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
    self.text=nil;
}
-(void)updateProgress:(long)size index:(int)index
{
    int rows=[self.tableView numberOfRowsInSection:0];
    if ([[FavoritesData sharedFavoritesData] count]!=rows) {
        [self.tableView reloadData];
    }
    NSDictionary *dic=[[[FavoritesData sharedFavoritesData] allValues] objectAtIndex:index];
    long t_size=[[dic objectForKey:@"f_size"] intValue];
    NSString *s_size=[YNFunctions convertSize:[NSString stringWithFormat:@"%ld",size]];
    NSString *s_tsize=[YNFunctions convertSize:[NSString stringWithFormat:@"%ld",t_size]];
    int value=(size/(double)t_size)*100;
    NSString *text=[NSString stringWithFormat:@"%@ %d%%已下载",s_tsize,value];
    //NSLog(@"%@",text);
    self.text=text;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:index inSection:0];
    //[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
    cell.detailTextLabel.text=text;
    //[self.tableView cellForRowAtIndexPath:indexPath];
}
-(void)updateCell
{
    [self.tableView reloadData];
}
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationPortrait);
//}
//
//- (BOOL)shouldAutorotate
//{
//    return NO;
//}
//
//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}
@end
