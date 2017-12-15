//
//  PlayerViewController.m
//  IJKPlayer
//
//  Created by 张涛 on 2017/7/28.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "PlayerViewController.h"
#import <YfMediaPlayer/YfMediaPlayer.h>
#import "ControlView.h"
#import "KxMenu.h"

@interface PlayerViewController ()<YfFFMoviePlayerControllerDelegate,YfFFMoviePlayerControllerDelegate,ControlViewDelegate,YfFFMoviePlayerControllerDelegate>

@property (nonatomic,strong)id<YfMediaPlayback>player;

@end

@implementation PlayerViewController

{
    
       ControlView                  *controlView;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.isLocalFile){
        NSString *file = [[NSBundle mainBundle] pathForResource:@"play_test" ofType:@"mp4"];
        
        self.player = [[YfFFMoviePlayerController alloc] initWithContentURL:[NSURL fileURLWithPath:file] withOptions:NULL useDns:self.isDNS useSoftDecode:self.isSoftCode DNSIpCallBack:NULL appID:"" refer:"" bufferTime:self.bufferTime display:YES isOpenSoundTouch:NO];
    }else{
        self.player = [[YfFFMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:self.playUrl] withOptions:NULL useDns:self.isDNS useSoftDecode:self.isSoftCode DNSIpCallBack:NULL appID:"" refer:"" bufferTime:self.bufferTime display:YES isOpenSoundTouch:YES];
    }

    self.player.shouldAutoplay = YES;
    
    self.player.overalState = YfPLAYER_OVERAL_NORMAL;
    
    self.player.delegate = self;
    
    self.player.view.frame = self.view.bounds;
    
    self.player.scalingMode = YfMPMovieScalingModeAspectFit;
    
    [self.view addSubview:self.player.view];
    
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [self.player prepareToPlay];
    [self.player play];
    
    //controlView
    controlView = [[ControlView alloc] initWithFrame:self.view.bounds];
    controlView.delegate = self;
    controlView.player = self.player;
    [self.view addSubview:controlView];
    controlView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    
    // Do any additional setup after loading the view.
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    
    return UIInterfaceOrientationMaskLandscapeLeft | UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskPortrait;
}


- (void)willOutputPlayerRenderbuffer:(CVPixelBufferRef)renderbuffer player:(YfFFMoviePlayerController *)player
{
    
    //回调视频数据
    
}

- (void)senderOutAudioData:(NSData *)audioData size:(size_t)audioDataSize player:(YfFFMoviePlayerController *)player
{
    //回调音频数据
    
    
}


- (void)playerStatusCallBackLoadingCanReadyToPlay:(YfFFMoviePlayerController *)player
{
    
    /*
     *加载完成 异步
     *
     */
    
    
    NSLog(@"异步加载完成");
//    [self.player play];
    [controlView updatePlayTimeOnMainThread];
    
    
}

- (void)playerStatusCallBackLoading:(YfFFMoviePlayerController *)player
{
    
    NSLog(@"开始加载");
}

- (void)playerStatusCallBackLoadingSuccess:(YfFFMoviePlayerController *)player
{
    
    NSLog(@"加载成功");
    //此处可以seek
    
//    self.player.currentPlaybackTime = 14;
    //[player play];
    
}

- (void)playerStatusCallBackBufferingStart:(YfFFMoviePlayerController *)player
{
    
    NSLog(@"开始缓冲");
}

- (void)playerStatusCallBackBufferingEnd:(YfFFMoviePlayerController *)player
{
    
    NSLog(@"缓冲结束");
}

-(void)playerStatusCallBackPlayerPlayEnd:(YfFFMoviePlayerController *)player
{
    
    NSLog(@"播放结束");
    player.currentPlaybackTime = 0;
    [player play];
    //[controlView shutdownUpdatePlayTimeOnMainThread];
    
}

- (void)changePlay:(UIButton *)btn
{
    
    [self showMenu:btn];
    
    
}

- (void)onPlayBtn
{
    
    [controlView shutdownUpdatePlayTimeOnMainThread];
    
    if ([self.player isPlaying]) {
        
        [self.player pause];
        
    } else {
        
        [self.player play];
        
        [controlView updatePlayTimeOnMainThread];
    }
}



- (void)onBackBtn
{
    
    [controlView shutdownUpdatePlayTimeOnMainThread];
    [controlView removeFromSuperview];
    controlView = nil;
    
    [self.player shutdown];
    self.player = nil;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    

}

- (void)changePlayType:(UIButton *)btn
{
    
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"正常播放"
                     image:nil
                    target:self
                    action:@selector(normalPlay:)],
      
      [KxMenuItem menuItem:@"全景播放"
                     image:nil
                    target:self
                    action:@selector(overalPlay:)],
      
      [KxMenuItem menuItem:@"双屏播放"
                     image:nil
                    target:self
                    action:@selector(doubleScreen:)],
      

      
      ];
    
    KxMenuItem *first = menuItems[0];
    first.foreColor = [UIColor whiteColor];
    first.alignment = NSTextAlignmentCenter;
    
    [KxMenu showMenuInView:controlView
                  fromRect:btn.frame
                 menuItems:menuItems];
}

- (void)normalPlay:(UIButton *)btn
{
    
    self.player.overalState = YfPLAYER_OVERAL_NORMAL;
    
}

- (void)overalPlay:(UIButton *)btn
{
    
       self.player.overalState = YfPLAYER_OVERAL;
}

- (void)doubleScreen:(UIButton *)btn
{
      self.player.overalState = YfPLAYER_OVERAL_3D;
    
}


- (void)showMenu:(UIButton *)sender
{
    NSArray *menuItems =
    @[
      
      [KxMenuItem menuItem:@"极慢播放"
                     image:nil
                    target:self
                    action:@selector(ReallylowRatePlay:)],
      
      [KxMenuItem menuItem:@"慢速播放"
                     image:nil
                    target:self
                    action:@selector(lowRatePlay:)],
      
      [KxMenuItem menuItem:@"正常速度"
                     image:nil
                    target:self
                    action:@selector(NormalRatePlay:)],
      
      [KxMenuItem menuItem:@"快速"
                     image:nil
                    target:self
                    action:@selector(RatePlay:)],
      
      [KxMenuItem menuItem:@"极速播放"
                     image:nil
                    target:self
                    action:@selector(HighRatePlay:)],
      
      ];
    
    KxMenuItem *first = menuItems[0];
    first.foreColor = [UIColor whiteColor];
    first.alignment = NSTextAlignmentCenter;
    
    [KxMenu showMenuInView:controlView
                  fromRect:sender.frame
                 menuItems:menuItems];
}


- (void) ReallylowRatePlay:(id)sender
{
    
    self.player.playbackRate = 0.33;
}

- (void)lowRatePlay:(id)sender
{
    self.player.playbackRate = 0.66;
    
}

- (void)NormalRatePlay:(id)sender
{
    self.player.playbackRate = 1.0;
    
}

- (void)RatePlay:(id)sender

{
    self.player.playbackRate = 1.33;
    
    
}
- (void)HighRatePlay:(id)sender

{
    self.player.playbackRate = 1.66;
    
    
}
-(void)playerStatusCallBackPlayerPlayErrorType:(YfPLAYER_MEDIA_ERROR)errorType httpErrorCode:(int)httpErrorCode player:(YfFFMoviePlayerController *)player
{
    
    [controlView shutdownUpdatePlayTimeOnMainThread];
    NSLog(@"播放错误");
    [self.player clean];
    [self.player play:[NSURL URLWithString:self.playUrl] useDns:YES useSoftDecode:self.isSoftCode DNSIpCallBack:nil appID:"" refer:"" bufferTime:3];
    
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
