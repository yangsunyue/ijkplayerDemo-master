//
//  loginViewController.m
//  ijkplayerDemo
//
//  Created by Yang on 16/12/14.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "loginViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "ViewController.h"

@interface loginViewController ()
/** player */
@property (nonatomic, strong) IJKFFMoviePlayerController *player;
/** 快速通道 */
@property (nonatomic, strong) UIButton *quickBtn;
@end

@implementation loginViewController


#pragma mark - 懒加载


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
        NSLog(@"`````````````%@", NSStringFromCGRect(self.view.frame));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *path = arc4random_uniform(10) % 2 ? @"login_video" : @"loginmovie";
    IJKFFMoviePlayerController *player = [[IJKFFMoviePlayerController alloc] initWithContentURLString:[[NSBundle mainBundle] pathForResource:path ofType:@"mp4"] withOptions:[IJKFFOptions optionsByDefault]];
    // 设计player
    player.view.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HIGHT);
    
//    player.view.backgroundColor = [UIColor orangeColor];
    // 填充fill
    player.scalingMode = IJKMPMovieScalingModeAspectFill;
    
    [self initObserver];
    // 准备播放
    [player prepareToPlay];
    
    _player = player;
    
    
    [self.view addSubview:player.view];
    // 设置自动播放
    //        player.shouldAutoplay = NO;
    
    UIButton *btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(50, SCREEN_HIGHT - 100, SCREEN_WIDTH - 100, 40);
    btn.backgroundColor = [UIColor clearColor];
    btn.layer.cornerRadius = 7;
    btn.layer.borderWidth = 1;
    btn.layer.borderColor = [UIColor whiteColor].CGColor;
    [btn setTitle:@"小熊猫快速通道" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(loginSuccess) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    _quickBtn = btn;
}

#pragma mark - private method

- (void)initObserver
{
    // 监听视频是否播放完成
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinish) name:IJKMPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stateDidChange) name:IJKMPMoviePlayerLoadStateDidChangeNotification object:nil];
}


- (void)stateDidChange
{
    if ((self.player.loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        if (!self.player.isPlaying) {
//            self.coverView.frame = self.view.bounds;
//            [self.view insertSubview:self.coverView atIndex:0];
            [self.player play];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                self.thirdView.hidden = NO;
//                self.quickBtn.hidden = NO;
            });
        }
    }
}



- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.player shutdown];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.player.view removeFromSuperview];
    self.player = nil;
    
}

- (void)didFinish
{
    // 播放完之后, 继续重播
    [self.player play];
}

// 登录成功
- (void)loginSuccess
{
//    [self showHint:@"登录成功"];
    
    ViewController *presentVC = [[ViewController alloc] init];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self presentViewController:presentVC animated:YES completion:^{
            [self.player stop];
            [self.player.view removeFromSuperview];
            self.player = nil;
        }];
//    });
}

- (void)dealloc
{
    NSLog(@"%s", __FUNCTION__);
}




@end
