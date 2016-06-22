//
//  MainViewController.m
//  Video
//
//  Created by MS on 15-12-31.
//  Copyright (c) 2015年 杨志远. All rights reserved.
//
#import "SecondViewController.h"
#import "FullViewController.h"
#import "FMGVideoPlayView.h"
#import "UMSocial.h"
#import "Video.h"
#import "UIImageView+WebCache.h"
#import "CoreDataShare.h"
#import "BaseModel.h"
#import "AFNetworking.h"
#import "MainTableViewCell.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "Header.h"
#import "MJRefresh.h"
#define SIZE [UIScreen mainScreen].bounds.size
@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate,myDelegate,myCellDelegate,FMGVideoPlayViewDelegate>
{

    
    AppDelegate *_delegate;
    
    UITableView *_tableView;
    
    int _page;
    
    NSMutableArray *_dataArray;
    
    BOOL _isPulling;
    
    NSMutableArray *_selectArray;
    
    
    NSString *vidUrl;
    
    BaseModel *_model;
    
    FMGVideoPlayView *_videoPlayer;
    
    FullViewController *_fullVc;
    
    
    BOOL _isPlaying;
    
    

    
}
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
   self.title = @"要闻";
    self.navigationController.navigationBarHidden = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    
    _delegate = [UIApplication sharedApplication].delegate;
    
    _dataArray = [[NSMutableArray alloc]init];
    _page = 0;
    
    _isPulling = NO;
    
    _videoPlayer = [FMGVideoPlayView videoPlayView];
    
    _videoPlayer.delegate = self;
    
    _fullVc = [[FullViewController alloc]init];
    
    _selectArray = [[NSMutableArray alloc]init];
    
    
    _type = @"%E5%A4%B4%E6%9D%A1";
    
    [self createbarbuttonItem];
    

    [self createData];
    
    [self createTableView];

    
    


    
}

-(void)changeTitle:(NSString *)title
{
    
    self.title = title;
    
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    

    [button setTitle:@"编辑" forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [button setTitleColor:[UIColor greenColor] forState:UIControlStateHighlighted];
    
    [button addTarget:self action:@selector(clickRight:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:button];

    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    if (_selectArray.count)
    {
        [_selectArray removeAllObjects];


    }
    
    NSArray *array = [[CoreDataShare shareinstance]fetch];
    
    for (Video *video in array)
    {
        if (video.imgData == nil)
        {
            [_selectArray addObject:video];
        }
    }
    
    [_tableView reloadData];

    
    [self createTableView];
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [_delegate.yrSide hideSideViewController:YES] ;
    
    _delegate.yrSide.needSwipeShowMenu = YES;
    
        
    
}

-(void)createbarbuttonItem
{
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg_actionbar_320x64@2x"]];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    UIImage *image = [[UIImage imageNamed:@"caidan"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(clickLeft)];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
    
    
    
    
}

-(void)clickLeft
{
    
    [_delegate.yrSide showLeftViewController:YES];
    
}

-(void)clickRight:(UIButton *)item
{
    if ([item.titleLabel.text isEqualToString:@"编辑"])
    {

        [item setTitle:@"取消" forState:UIControlStateNormal];
        //设置tableView进入编辑模式
        _tableView.editing  = YES;
        //设置编辑时不允许多选
        _tableView.allowsMultipleSelectionDuringEditing = NO;
        
    }else
    {

        [item setTitle:@"编辑" forState:UIControlStateNormal];

        
        //设置tableView不可编辑
        _tableView.editing = NO;
        
        
        
    }
       NSArray *visiable = [_tableView indexPathsForVisibleRows];
    //执行刷新操作
    [_tableView reloadRowsAtIndexPaths:visiable withRowAnimation:UITableViewRowAnimationFade];
    
}




-(void)createData
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
 
    
    [manager GET:[NSString stringWithFormat:TTXW,_page,_type] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *rootDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *secDic = [rootDic objectForKey:@"root"];
        
        NSArray *array = [secDic objectForKey:@"list"];
        if (_isPulling == YES)
        {
           [_dataArray removeAllObjects];

        }
        
        for (NSDictionary *dic in array)
        {
            BaseModel *model = [[BaseModel alloc]init];
            
            [model setValuesForKeysWithDictionary:dic];
            
            [_dataArray addObject:model];
            
            
        }
        
        
        if (_isPulling == YES)
        {
            [_tableView headerEndRefreshing];
        }else
        {
            [_tableView footerEndRefreshing];
        }

       
        [self createRefresh];
        
         [_tableView reloadData];
       
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
}
-(void)createRefresh
{
    [_tableView addHeaderWithTarget:self action:@selector(pulling)];
    
    [_tableView addFooterWithTarget:self action:@selector(pushing)];
    
    
}

-(void)pulling
{
    _isPulling = YES;
    
    _page = 0;
    
    [self createData];
}

-(void)pushing
{
    _page ++;
    
    _isPulling = NO;
    
    [self createData];
}

-(void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    
    _tableView.delegate = self;
    
    _tableView.dataSource = self;
    
    
    [self.view addSubview:_tableView];
    
    
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.title isEqualToString:@"收藏"])
    {
       
        return _selectArray.count;
        
    }else
    {
        return _dataArray.count;
    }

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell)
    {
        cell = [[MainTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    
    cell.celldelegate = self;

    
    
    if ([self.title isEqualToString:@"收藏"])
    {
        Video *video = _selectArray[indexPath.row];
        cell.collectButton.enabled = NO;
        
        [cell configWithVideo:video];
        
        
        
    }else
    {
         BaseModel *model = _dataArray[indexPath.row];
        
        cell.collectButton.enabled = YES;
        [cell configWithModel:model];
        
    }

    
   cell.playButton.tag = 100+indexPath.row;
    
    return cell;
}


-(void)playerPlayVideo:(UIButton *)button
{

    if ([self.title isEqualToString:@"收藏"])
    {
        Video *video = _selectArray[button.tag-100];
        
        [_videoPlayer setUrlString:video.name];
    }else
    {
        BaseModel *model = _dataArray[button.tag-100];
        
        [_videoPlayer setUrlString:model.videolink];
    }
    
    _videoPlayer.index = button.tag - 100;
    
    
    
   
    _videoPlayer.frame = CGRectMake(0, 285*_videoPlayer.index, SIZE.width, 210);
    
    [_tableView addSubview:_videoPlayer];
    
    _videoPlayer.contrainerViewController = self;
    
    [_videoPlayer.player play];
    
    [_videoPlayer showToolView:NO];
    
    _videoPlayer.playOrPauseBtn.selected = YES;
    
    _videoPlayer.hidden = NO;
}

-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _videoPlayer.index)
    {
        [_videoPlayer.player pause];
        
        _videoPlayer.hidden = YES;
    }
    
    
    
}

-(void)presentShare:(NSString *)url Img:(UIImage *)img
{
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"507fcab25270157b37000010"
                                      shareText:url
                                     shareImage:img
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToWechatSession,UMShareToQQ,UMShareToQzone,UMShareToDouban,UMShareToFacebook,nil]
                                       delegate:nil];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 285;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *url = [[NSString alloc]init];
    
    
    if ([self.title isEqualToString:@"收藏"])
    {
        Video *video = _selectArray[indexPath.row];
        url = video.name;
    }else
    {
        BaseModel *model = _dataArray[indexPath.row];
        
        url = model.videolink;
    }
    
    
    SecondViewController *second = [[SecondViewController alloc]init];
    
    second.videourl = url;
    
    [self.navigationController pushViewController:second animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    
    _videoPlayer.playOrPauseBtn.selected = NO;
    
    [_videoPlayer.player pause];

}

-(void)removePlayerView
{
   
}


-(void)changeTypeWithStrting:(NSString *)string AndTitle:(NSString *)title
{
    _type = string;
    
    self.title = title;
    
    _tableView.editing = NO;
    
    [_dataArray removeAllObjects];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:nil style:UIBarButtonItemStyleDone target:nil action:nil];
    
    [self createData];
    
    [_tableView reloadData];
    
    
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.title isEqualToString:@"收藏"])
    {
        return UITableViewCellEditingStyleDelete;
 
    }else
    {
        return UITableViewCellEditingStyleNone;
    }
    
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.title isEqualToString:@"收藏"])
    {
        Video *video = _selectArray[indexPath.row];
        [_selectArray removeObject:video];
        
        [[CoreDataShare shareinstance]deleteDataWithModel:video];
        
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        
        
    }
    
    
}




-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"取消收藏";
}

//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
//{
//    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
//            
//            interfaceOrientation == UIInterfaceOrientationLandscapeRight );
//}

-(void)videoplayViewSwitchOrientation:(BOOL)isFull
{
    _isPlaying = _videoPlayer.playOrPauseBtn.selected;
    
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    
    
    if (isFull)
    {
        delegate.allowRotation = YES;

        [self presentViewController:_fullVc animated:NO completion:^{
            [_fullVc.view addSubview:_videoPlayer];
            
            _videoPlayer.center = _fullVc.view.center;
            
            
            [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                 _videoPlayer.frame = _fullVc.view.bounds;
                
                if (_isPlaying)
                {
                    _videoPlayer.playOrPauseBtn.selected = YES;
                    
                    [_videoPlayer.player play];
                }else
                {

                    _videoPlayer.playOrPauseBtn.selected = NO;
                    
                    [_videoPlayer.player pause];
                    
                    _isPlaying = NO;
                    
                }

                
            } completion:nil];
            
            
            }];
        
    }else
    {
        delegate.allowRotation = NO;

        
        [_fullVc dismissViewControllerAnimated:NO completion:^{
            
            [_tableView addSubview:_videoPlayer];
            
            _videoPlayer.frame = CGRectMake(0, 285*_videoPlayer.index,SIZE.width, 210);
            
        }];
    }
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
