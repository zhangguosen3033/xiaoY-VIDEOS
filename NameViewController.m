//
//  NameViewController.m
//  Video
//
//  Created by MS on 16-1-4.
//  Copyright (c) 2016年 杨志远. All rights reserved.
//

#import "NameViewController.h"

@interface NameViewController ()
{
    UITextField *_nameField;
}
@end

@implementation NameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"修改昵称";
    
    _nameField = [[UITextField alloc]initWithFrame:CGRectMake((self.view.frame.size.width-300)/2, 100, 300, 40)];
    _nameField.borderStyle = UITextBorderStyleRoundedRect;
    
    _nameField.placeholder = @"请输入昵称";
    
    [self.view addSubview:_nameField];
    
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveName)];
    
}

-(void)saveName
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"name" object:_nameField.text];
    
    [self.navigationController popViewControllerAnimated:YES];
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
