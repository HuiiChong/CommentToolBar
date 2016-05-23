//
//  ViewController.m
//  CommentToolBar
//
//  Created by apple on 16/5/23.
//  Copyright © 2016年 庄 春辉. All rights reserved.
//

#import "ViewController.h"
#import "CHCommentToolBar.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    // Do any additional setup after loading the view, typically from a nib.
    
    CHCommentToolBar *_toolBar = [[CHCommentToolBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-45, self.view.frame.size.width, 45)];
    [self.view addSubview:_toolBar];
    
    [_toolBar addKeyboardNotification];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
