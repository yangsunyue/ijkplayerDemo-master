//
//  LiveViewController.m
//  ijkplayerDemo
//
//  Created by Yang on 16/12/12.
//  Copyright © 2016年 wanglei. All rights reserved.
//

#import "LiveViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>

@interface LiveViewController ()
@property (atomic, strong) NSURL *url;
@property (atomic, retain) IJKFFMoviePlayerController* player;
@property (weak, nonatomic) UIView *PlayerView;
@property(nonatomic, strong)UIButton *sendLoveBtn;
@property(nonatomic, strong)UIButton *sendSnowBtn;
@property (nonatomic, strong) CAEmitterLayer *snowEmitterLayer;
//snowEmitterLayer
@end

@implementation LiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self prepareMovieUI];
    
    [self addbackBtn];
}



- (void)addbackBtn{
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(30, 30, 40, 40);
    [button setBackgroundImage:[UIImage imageNamed:@"goback"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void)prepareMovieUI{
    
//
    self.url = [NSURL URLWithString:_model.stream_addr];
        NSLog(@"%@",  _model.creator.portrait);
    
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    
    [options setPlayerOptionIntValue:1  forKey:@"videotoolbox"];
    // 帧速率(fps) （可以改，确认非标准桢率会导致音画不同步，所以只能设定为15或者29.97）
    [options setPlayerOptionIntValue:29.97 forKey:@"r"];
    // -vol——设置音量大小，256为标准音量。（要设置成两倍音量时则输入512，依此类推
    [options setPlayerOptionIntValue:512 forKey:@"vol"];
    
    
    _player = [[IJKFFMoviePlayerController alloc] initWithContentURL:self.url withOptions:options];
    
    //    _player.shouldAutoplay = NO;
    //
//        _player.shouldShowHudView = YES;
    
    UIView *playerView = [self.player view];
    
    UIView *displayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    self.PlayerView = displayView;
    
    self.PlayerView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.PlayerView];
    
    playerView.frame = self.PlayerView.bounds;
    playerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.PlayerView insertSubview:playerView atIndex:1];
    [self.player prepareToPlay];
    [_player setScalingMode:IJKMPMovieScalingModeAspectFill];
    [self installMovieNotificationObservers];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
//    [self sendLoveAnimation];
    
    _sendLoveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendLoveBtn.frame = CGRectMake(self.player.view.frame.size.width - 70,self.player.view.frame.size.height - 100, 40, 40);
//    _sendLoveBtn.backgroundColor = [UIColor orangeColor];
    [_sendLoveBtn setBackgroundImage:[UIImage imageNamed:@"loveStar"] forState:UIControlStateNormal];
    [_sendLoveBtn setBackgroundImage:[UIImage imageNamed:@"loveStar"] forState:UIControlStateHighlighted];
    [_sendLoveBtn addTarget:self action:@selector(sendLoveAnimation) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sendLoveBtn];
    
    _sendSnowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendSnowBtn.frame = CGRectMake(50,self.player.view.frame.size.height - 100, 40, 40);
    //    _sendLoveBtn.backgroundColor = [UIColor orangeColor];
    [_sendSnowBtn setBackgroundImage:[UIImage imageNamed:@"loveStar"] forState:UIControlStateNormal];
    [_sendSnowBtn setBackgroundImage:[UIImage imageNamed:@"loveStar"] forState:UIControlStateHighlighted];
    [_sendSnowBtn addTarget:self action:@selector(sendSnow) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_sendSnowBtn];
}

#pragma Selector func

- (void)loadStateDidChange:(NSNotification*)notification {
    IJKMPMovieLoadState loadState = _player.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        NSLog(@"LoadStateDidChange: IJKMovieLoadStatePlayThroughOK: %d\n",(int)loadState);
    }else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}

- (void)moviePlayBackFinish:(NSNotification*)notification {
    int reason =[[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    switch (reason) {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            break;
            
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification {
    NSLog(@"mediaIsPrepareToPlayDidChange\n");
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification {
    switch (_player.playbackState) {
        case IJKMPMoviePlaybackStateStopped:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStatePlaying:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStatePaused:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStateInterrupted:
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            break;
            
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            break;
        }
            
        default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            break;
        }
    }
}

#pragma Install Notifiacation

- (void)installMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
    
}

- (void)removeMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                  object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                                  object:_player];
}

- (void)sendLoveAnimation{
//    [self boomAnimatewithBtn:_sendLoveBtn];
    [self showTheApplauseInView:self.view belowView:self.sendLoveBtn];
}

- (void)sendSnow{
//    [self boomAnimatewithBtn:_sendSnowBtn];
    [self snow];
}


// 显示爱心动画
- (void)showTheApplauseInView:(UIView *)view belowView:(UIButton *)btn{
    NSInteger index = arc4random_uniform(10) + 1; //取随机图片
    NSString *image = [NSString stringWithFormat:@"good%zd_30x30",index];
    UIImageView *applauseView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width-15-50, self.view.frame.size.height - 100, 30, 30)];//增大y值可隐藏弹出动画
    [view insertSubview:applauseView belowSubview:btn];
    applauseView.image = [UIImage imageNamed:image];
    
    CGFloat AnimH = 350; //动画路径高度,
    applauseView.transform = CGAffineTransformMakeScale(0, 0);
    applauseView.alpha = 0;
    
    //弹出动画
    [UIView animateWithDuration:0.2 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.8 options:UIViewAnimationOptionCurveEaseOut animations:^{
        applauseView.transform = CGAffineTransformIdentity;
        applauseView.alpha = 0.9;
    } completion:NULL];
    
    //随机偏转角度
    NSInteger i = arc4random_uniform(2);
    NSInteger rotationDirection = 1- (2*i);// -1 OR 1,随机方向
    NSInteger rotationFraction = arc4random_uniform(10); //随机角度
    //图片在上升过程中旋转
    [UIView animateWithDuration:4 animations:^{
        applauseView.transform = CGAffineTransformMakeRotation(rotationDirection * M_PI/(4 + rotationFraction*0.2));
    } completion:NULL];
    
    //动画路径
    UIBezierPath *heartTravelPath = [UIBezierPath bezierPath];
    [heartTravelPath moveToPoint:applauseView.center];
    
    //随机终点
    CGFloat ViewX = applauseView.center.x;
    CGFloat ViewY = applauseView.center.y;
    CGPoint endPoint = CGPointMake(ViewX + rotationDirection*10, ViewY - AnimH);
    
    //随机control点
    NSInteger j = arc4random_uniform(2);
    NSInteger travelDirection = 1- (2*j);//随机放向 -1 OR 1
    
    NSInteger m1 = ViewX + travelDirection*(arc4random_uniform(20) + 50);
    NSInteger n1 = ViewY - 60 + travelDirection*arc4random_uniform(20);
    NSInteger m2 = ViewX - travelDirection*(arc4random_uniform(20) + 50);
    NSInteger n2 = ViewY - 90 + travelDirection*arc4random_uniform(20);
    CGPoint controlPoint1 = CGPointMake(m1, n1);//control根据自己动画想要的效果做灵活的调整
    CGPoint controlPoint2 = CGPointMake(m2, n2);
    //根据贝塞尔曲线添加动画
    [heartTravelPath addCurveToPoint:endPoint controlPoint1:controlPoint1 controlPoint2:controlPoint2];
    
    //关键帧动画,实现整体图片位移
    CAKeyframeAnimation *keyFrameAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    keyFrameAnimation.path = heartTravelPath.CGPath;
    keyFrameAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
    keyFrameAnimation.duration = 3 ;//往上飘动画时长,可控制速度
    [applauseView.layer addAnimation:keyFrameAnimation forKey:@"positionOnPath"];
    
    //消失动画
    [UIView animateWithDuration:3 animations:^{
        applauseView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [applauseView removeFromSuperview];
    }];
}

- (void)snow{
    if (!_snowEmitterLayer) {
        // =================== 樱花飘落 ====================
        _snowEmitterLayer = [CAEmitterLayer layer];
        _snowEmitterLayer.emitterPosition = CGPointMake(100, -30);
        _snowEmitterLayer.emitterSize = CGSizeMake(self.view.bounds.size.width * 2, 0);
        _snowEmitterLayer.emitterMode = kCAEmitterLayerOutline;
        _snowEmitterLayer.emitterShape = kCAEmitterLayerLine;
        //    snowEmitterLayer.renderMode = kCAEmitterLayerAdditive;
        
        CAEmitterCell * snowCell = [CAEmitterCell emitterCell];
        snowCell.contents = (__bridge id)[UIImage imageNamed:@"樱花瓣2"].CGImage;
        
        // 花瓣缩放比例
        snowCell.scale = 0.02;
        snowCell.scaleRange = 0.5;
        
        // 每秒产生的花瓣数量
        snowCell.birthRate = 7;
        snowCell.lifetime = 80;
        
        // 每秒花瓣变透明的速度
        snowCell.alphaSpeed = -0.01;
        
        // 秒速“五”厘米～～
        snowCell.velocity = 40;
        snowCell.velocityRange = 60;
        
        // 花瓣掉落的角度范围
        snowCell.emissionRange = M_PI;
        
        // 花瓣旋转的速度
        snowCell.spin = M_PI_4;
        
        // 每个cell的颜色
        //    snowCell.color = [[UIColor redColor] CGColor];
        
        // 阴影的 不透明 度
        _snowEmitterLayer.shadowOpacity = 1;
        // 阴影化开的程度（就像墨水滴在宣纸上化开那样）
        _snowEmitterLayer.shadowRadius = 8;
        // 阴影的偏移量
        _snowEmitterLayer.shadowOffset = CGSizeMake(3, 3);
        // 阴影的颜色
        _snowEmitterLayer.shadowColor = [[UIColor whiteColor] CGColor];
        
        _snowEmitterLayer.emitterCells = [NSArray arrayWithObject:snowCell];
        
        [self.view.layer addSublayer:_snowEmitterLayer];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:2.0 animations:^{
                [_snowEmitterLayer removeFromSuperlayer];
                _snowEmitterLayer = nil;
            }];
        });
    }
    
}


-(UIImage*) createImageWithColor:(UIColor*) color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [self circleImage:theImage];;
}

-(UIImage*) circleImage:(UIImage*) image{
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor orangeColor].CGColor);
    CGRect rect = CGRectMake(0, 0, image.size.width , image.size.height );
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

- (void)boomAnimatewithBtn:(UIButton *)btn{
    
    CAEmitterLayer *emitter = [CAEmitterLayer layer];
    
    [emitter setEmitterSize:CGSizeMake(CGRectGetWidth(btn.frame), CGRectGetHeight(btn.frame))];
    emitter.emitterPosition = CGPointMake(btn.frame.size.width /2.0, btn.frame.size.height / 2.0);
    emitter.emitterShape = kCAEmitterLayerCircle;
    emitter.emitterMode = kCAEmitterLayerOutline;
    [btn.layer addSublayer:emitter];
    
    CAEmitterCell *cell = [[CAEmitterCell alloc] init];
    [cell setName:@"zanShape"];
    
    cell.contents = (__bridge id _Nullable)([self createImageWithColor:[UIColor blackColor]].CGImage);
    cell.birthRate = 0;
    cell.lifetime = 0.4;
    cell.alphaSpeed = -2;
    
    cell.velocity = 20;
    cell.velocityRange = 20;
    emitter.emitterCells = @[cell];
    
    CABasicAnimation *effectLayerAnimation=[CABasicAnimation animationWithKeyPath:@"emitterCells.zanShape.birthRate"];
    [effectLayerAnimation setFromValue:[NSNumber numberWithFloat:1500]];
    [effectLayerAnimation setToValue:[NSNumber numberWithFloat:0]];
    [effectLayerAnimation setDuration:0.0f];
    [effectLayerAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    [emitter addAnimation:effectLayerAnimation forKey:@"ZanCount"];
}

- (void)viewWillDisappear:(BOOL)animated{
    if (_snowEmitterLayer) {
        [_snowEmitterLayer removeFromSuperlayer];
        _snowEmitterLayer = nil;
    }
}


- (void)backClick:(UIButton *)btn{
    
    if (_player) {
        
        [_player shutdown];
        
        _player = nil;

        [self removeMovieNotificationObservers];
    }

    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
