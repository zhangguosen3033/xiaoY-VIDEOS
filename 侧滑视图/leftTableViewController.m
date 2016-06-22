//
//  leftTableViewController.m
//  Video
//
//  Created by MS on 15-12-31.
//  Copyright (c) 2015年 杨志远. All rights reserved.
//
#import "Video.h"
#import "CoreDataShare.h"
#import "SettingViewController.h"
#import "AppDelegate.h"
#import "leftTableViewController.h"
#define SIZE [UIScreen mainScreen].bounds.size



@interface leftTableViewController ()
{
    NSArray *_titleArray;
    
    NSArray *_imgArray;
    
    UIImageView *_imgView;
    
    UILabel *_nameLabel;
    

    NSArray *_urlArray;
    
    NSArray *array;
    
    
    AppDelegate *_delegate;

}
@end

@implementation leftTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(35,50, 60, 60)];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 10, 60, 40)];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeHeaderView:) name:@"headerView" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeText:) name:@"name" object:nil];
    
    _imgArray = @[@"1",@"18",@"20",@"12",@"5",@"17",@"19",@"shoucang_1",@"shezhi",@"15",@"shezhi"];
    _titleArray = @[@"要闻",@"八卦",@"搞笑",@"科技",@"财经",@"音乐",@"猎奇",@"收藏",@"设置"];
    
    _urlArray = @[@"%E5%A4%B4%E6%9D%A1",@"%E5%85%AB%E5%8D%A6",@"%E6%90%9E%E7%AC%91",@"%E7%A7%91%E6%8A%80",@"%E8%B4%A2%E7%BB%8F",@"%E9%9F%B3%E4%B9%90",@"%E7%8C%8E%E5%A5%87"];
    _delegate = [UIApplication sharedApplication].delegate;
    
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

-(void)changeHeaderView:(NSNotification *)notify
{
    
    
    _imgView.image = notify.object;
    
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    array = [[CoreDataShare shareinstance]fetch];
    
    
    
    if (array.count)
    {
        
        for (Video *video in array)
        {
            if (video.imgData != nil)
            {
                UIImage *image = [UIImage imageWithData:video.imgData];
                
                
                _imgView.image = image;
            }
        }
        
        
        
    }
    
    
}

-(void)changeText:(NSNotification *)notify
{
    _nameLabel.text = notify.object;
    
    [self.tableView reloadData];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ID"];
    }
    
    cell.imageView.image = [UIImage imageNamed:_imgArray[indexPath.row]];
    
    cell.textLabel.text = _titleArray[indexPath.row];
    
   
    
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    
    if (!view)
    {
        view = [[UIView alloc]initWithFrame:CGRectMake(0,0,100 , 100)];
        
        
        
        [view addSubview:_imgView];
        
        [view addSubview:_nameLabel];
        
        _imgView.clipsToBounds = YES;
        
        _imgView.layer.cornerRadius = 30;
       
        _imgView.backgroundColor = [UIColor lightGrayColor];

    
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(taped:)];
        
        [view addGestureRecognizer:tap];
        
    }
    
    return view;
}

-(void)taped:(UITapGestureRecognizer *)gesture
{
    
    
    [_delegate.yrSide hideSideViewController:YES];
    
    SettingViewController *setting = [[SettingViewController alloc]init];
    [_delegate.mainNav pushViewController:setting animated:YES];
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row<7)
    {
        
    
    NSString *type = _urlArray[indexPath.row];
    NSString *title = _titleArray[indexPath.row];
    
    [self.mydelegate changeTypeWithStrting:type AndTitle:title];
    
    
    
   
    }else if (indexPath.row == 8)
    {
    
        
        
        SettingViewController *setting = [[SettingViewController alloc]init];
        [_delegate.mainNav pushViewController:setting animated:YES];
        
        
    }else
    {
    
         NSString *title = _titleArray[indexPath.row];
        
        [self.mydelegate changeTitle:title];
    }

   [_delegate.yrSide hideSideViewController:YES];
    
}





-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 120;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
