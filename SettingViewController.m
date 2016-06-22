//
//  SettingViewController.m
//  Video
//
//  Created by MS on 15-12-31.
//  Copyright (c) 2015年 杨志远. All rights reserved.
//
#import "UMSocial.h"
#import "Video.h"
#import "CoreDataShare.h"
#import "NameViewController.h"
#import "AppDelegate.h"
#import "SettingViewController.h"

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UITableView *_tableView;
    NSArray *_dataArray1;
    NSArray *_dataArray2;
    
    AppDelegate *_delegate;
    UIImagePickerController *_picker;
}
@end

@implementation SettingViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArray1 = @[@"意见反馈",@"评分",@"版本号 1.0.0",@"清理缓存"];
    
    _dataArray2 = @[@"设置头像",@"修改昵称"];
    
    _delegate = [UIApplication sharedApplication].delegate;
    _delegate.yrSide.needSwipeShowMenu = NO;
    [self createTableView];
}

-(void)createTableView
{
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    _tableView.dataSource = self;
    
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
    
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 4;
    }else
    {
        return 2;
    }
    
    
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == 0)
    {
        cell.textLabel.text = _dataArray1[indexPath.row];
        if (indexPath.row == 2)
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }else
    {
        cell.textLabel.text = _dataArray2[indexPath.row];
    }
    
    

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                [self gotoFeedBack];
                
            
            }
                break;
            case 1:
            {
                [self goToAppStore];
            }
                break;
            case 2:
            {
                [self goToLogin];

            }
                break;
            case 3:
            {
                [self clearData];
                
            }
                break;
                
            default:
                break;
        }
    }else
    {
        switch (indexPath.row)
        {
            case 0:
            {
                [self gotoPhotoLibrary];
                
                
            }
                break;
                
            case 1:
            {
                NameViewController *name = [[NameViewController alloc]init];
                [self.navigationController pushViewController:name animated:YES];
            }
                break;
            default:
                break;
        }
        
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)goToAppStore
{
    NSString *str = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d",1074249377];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}

-(void)gotoPhotoLibrary
{
    _picker = [[UIImagePickerController alloc]init];
    
    _picker.allowsEditing = YES;
    
    _picker.delegate =self;
    
    
    [self presentViewController:_picker animated:YES completion:^{
        
    }];
    
    
}

-(void)clearData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                       
        
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
    NSLog(@"files :%lu",(unsigned long)[files count]);
                       
        
    for (NSString *p in files) {
        NSError *error;
    NSString *path = [cachPath stringByAppendingPathComponent:p];
                           
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               
    [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        }
                           
    }
                       
    [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];});
    
}


    


-( void )clearCacheSuccess

{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"已清除缓存" message:@"" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alter show];
    
}

-(void)goToLogin
{
    
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(self, [UMSocialControllerService defaultControllerService], YES, ^(UMSocialResponseEntity *response) {
        
        NSLog(@"response is %@", response);
        
        // 如果是授权到新浪微博，SSO之后如果想获取用户的昵称、头像等需要再获取一次账户信息
        
        [[UMSocialDataService defaultDataService]requestSocialAccountWithCompletion:^(UMSocialResponseEntity *response) {
            
            // 打印用户昵称
            
            NSLog(@"用户 %@", [[[response.data objectForKey:@"accounts"]objectForKey:UMShareToQQ] objectForKey:@"username"]);
            
        }];
        
    });
    
    
    
    
}


-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSArray *array = [[CoreDataShare shareinstance]fetch];
    
    if (array.count)
    {
        for (Video *video in array)
        {
            if (video.imgData != nil)
            {
                [[CoreDataShare shareinstance]deleteDataWithModel:video];
            }
        }
    }
    

    static UIImage *image = nil;
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary)
    {
        
        image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        
        
    }else
    {
        
        image = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        
    }
    
    NSData *data = UIImagePNGRepresentation(image);
    
    [[CoreDataShare shareinstance]insertDataWithName:nil IconUrl:nil HeaderImage:data Title:@"头像" SourceName:nil ID:nil];
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"headerView" object:image];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)gotoFeedBack
{
    
    UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"反馈信息" message:@"请发送电子邮件到748603349@qq.com企业邮箱" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [view show];
    
}









- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
