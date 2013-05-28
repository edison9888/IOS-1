//
//  LoginViewController.m
//  NetDisk
//
//  Created by fengyongning on 13-4-27.
//
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "SCBAccountManager.h"
#import "MBProgressHUD.h"
#import "RegistViewController.h"


@interface LoginViewController ()
@property(strong,nonatomic) UIAlertView *av;
@property(strong,nonatomic) MBProgressHUD *hud;
@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.hud=[[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    // Do any additional setup after loading the view from its nib.
    
    // observe keyboard hide and show notifications to resize the text view appropriately
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)userRegister:(id)sender
{
    RegistViewController *regist=[[[RegistViewController alloc] initWithNibName:@"RegistViewController" bundle:nil] autorelease];
    [self presentViewController:regist animated:YES completion:nil];
}
- (IBAction)login:(id)sender
{
    //把用户信息存储到数据库
    NSString *user_name = _userNameTextField.text;
    NSString *user_passwor = _passwordTextField.text;
    NSLog(@"user_name;%@,user_password:%@",user_name,user_passwor);
//    DBSqlite *sqlite3 = [[DBSqlite alloc] init];
//    if([sqlite3 initDatabase])
//    {
//        FMDatabase *dataBase = [sqlite3 getDatabase];
//        UserInfo *info = [[UserInfo alloc] init];
//        info.database = dataBase;
//        info.user_name = user_name;
//        info.user_password = user_passwor;
//        AppDelegate *app_delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//        [app_delegate setUser_name:user_name];
//        [info insertUserinfo];
//        [info release];
//        [dataBase close];
//    }
    
    [[SCBAccountManager sharedManager] setDelegate:self];
    [[SCBAccountManager sharedManager] UserLoginWithName:self.userNameTextField.text Password:self.passwordTextField.text];
    self.hud.labelText=@"正在登录...";
    self.hud.mode=MBProgressHUDModeIndeterminate;
    [self.hud show:YES];
}
#pragma mark - UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
    }
}
#pragma mark - SCBAccountManagerDelegate Methods
-(void)loginSucceed:(id)manager
{
    AppDelegate *app_delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [app_delegate setLogin];
    [[NSUserDefaults standardUserDefaults] setObject:_userNameTextField.text forKey:@"usr_name"];
    [[NSUserDefaults standardUserDefaults] setObject:_passwordTextField.text forKey:@"usr_pwd"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self dismissViewControllerAnimated:YES completion:^(void){}];
    [self.hud show:NO];
}
-(void)loginUnsucceed:(id)manager
{
    [self.hud show:NO];
    self.hud.labelText=@"登录失败！";
    self.hud.mode=MBProgressHUDModeText;
    self.hud.margin=10.f;
    [self.hud show:YES];
    [self.hud hide:YES afterDelay:0.5f];
    
}
#pragma mark - Responding to keyboard events

- (void)keyboardWillShow:(NSNotification *)notification {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    CGRect r=self.view.frame;
    r.origin.y=-100;
    [self.view setFrame:r];
//    NSDictionary *userInfo = [notification userInfo];
//    
//    // Get the origin of the keyboard when it's displayed.
//    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    
//    // Get the top of the keyboard as the y coordinate of its origin in self's view's
//    // coordinate system. The bottom of the text view's frame should align with the top
//    // of the keyboard's final position.
//    //
//    CGRect keyboardRect = [aValue CGRectValue];
//    keyboardRect = [self.view convertRect:keyboardRect fromView:nil];
//    
//    CGFloat keyboardTop = keyboardRect.origin.y;
//    CGRect newTextViewFrame = self.view.bounds;
//    newTextViewFrame.size.height = keyboardTop - self.view.bounds.origin.y;
//    
//    // Get the duration of the animation.
//    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSTimeInterval animationDuration;
//    [animationDurationValue getValue:&animationDuration];
//    
//    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:animationDuration];
//    
//    //self.textView.frame = newTextViewFrame;
//    
//    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    CGRect r=self.view.frame;
    r.origin.y=-100;
    [self.view setFrame:r];
//    NSDictionary *userInfo = [notification userInfo];
//    
//    /*
//     Restore the size of the text view (fill self's view).
//     Animate the resize so that it's in sync with the disappearance of the keyboard.
//     */
//    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSTimeInterval animationDuration;
//    [animationDurationValue getValue:&animationDuration];
//    
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:animationDuration];
//    
//    //self.textView.frame = self.view.bounds;
//    
//    [UIView commitAnimations];
}

@end
