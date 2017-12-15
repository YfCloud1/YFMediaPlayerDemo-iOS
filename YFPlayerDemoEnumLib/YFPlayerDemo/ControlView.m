//
//  ControlView.m
//  YfPlayer-Demo
//
//  Created by suntongmian.
//  Copyright © 2016年 YunFan. All rights reserved.
//

#import "ControlView.h"

@implementation ControlView
{
    BOOL                             viewIsShowing;
    
    CGRect                           oldPlayViewFrame;
    CGRect                           oldTmplayerFrame;
    
    NSTimer                         *updatePlayTimeTimer;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        oldPlayViewFrame = frame;
        oldTmplayerFrame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        
        [self initControlView];
        viewIsShowing = YES;
        
        // init frame
        [self initPortrait];
    }
    return self;
}

#pragma mark --
#pragma mark -- init all view objects Event
//初始化播放，进度条，时间等视图
-(void)initControlView
{
    
    self.lockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.lockBtn.selected = NO;
    
    [self.lockBtn setImage:[UIImage imageNamed:@"解锁"] forState:UIControlStateNormal];
    
    [self.lockBtn setImage:[UIImage imageNamed:@"上锁"] forState:UIControlStateSelected];
    
    [self.lockBtn addTarget:self action:@selector(relock:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_lockBtn];
    
    
    //上面的遮罩
    self.playerHUDTopView = [[UIView alloc] init];
    [self addSubview:self.playerHUDTopView];
    
    // 返回按钮
    self.backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backBtn addTarget:self action:@selector(onBackBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [self.playBtn setTintColor:[UIColor clearColor]];
    [self.playerHUDTopView addSubview:self.backBtn];
    
    
    self.ChangeButton = [UIButton buttonWithType:UIButtonTypeCustom];

    [self.ChangeButton setTitle:@"开启log" forState:UIControlStateSelected];
    
    [self.ChangeButton setTitle:@"关闭log" forState:UIControlStateNormal];
    
    self.ChangeButton.selected = YES;
    
    [self.ChangeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.ChangeButton addTarget:self action:@selector(TypeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.playerHUDTopView addSubview:self.ChangeButton];
    
    
    self.changePlay = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.changePlay setTitle:@"播放速度" forState:UIControlStateNormal];
    
    [self.changePlay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.changePlay addTarget:self action:@selector(PlayButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.playerHUDTopView addSubview:self.changePlay];
    
    
    
    
    self.replayState = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.replayState setTitle:@"切换模式" forState:UIControlStateNormal];
    
    [self.replayState setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.replayState addTarget:self action:@selector(rePlayButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.playerHUDTopView addSubview:self.replayState];
    
    
    
    //下面的遮罩
    self.playerHUDBottomView = [[UIView alloc] init];
    [self addSubview:self.playerHUDBottomView];
    
    //播放，暂停按钮
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.playBtn addTarget:self action:@selector(onPlayBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.playBtn setSelected:NO];
    [self.playBtn setTitle:@"暂停" forState:UIControlStateSelected];
    [self.playBtn setTitle:@"播放" forState:UIControlStateNormal];
    [self.playBtn setTintColor:[UIColor clearColor]];
    [self.playerHUDBottomView addSubview:self.playBtn];
    
//    //缓冲进度条
//    self.loadProgressView = [[UIProgressView alloc] init];
//    self.loadProgressView.progressViewStyle = UIProgressViewStyleBar;
//    self.loadProgressView.progressTintColor = [UIColor yellowColor];
//    self.loadProgressView.backgroundColor = [UIColor greenColor];
//    self.loadProgressView.progress = 0;
//    [self.playerHUDBottomView addSubview:self.loadProgressView];
    
    //播放进度条
    self.progressBar = [[UISlider alloc] init];
    [self.progressBar addTarget:self action:@selector(progressBarChanged:) forControlEvents:UIControlEventValueChanged];
    [self.progressBar addTarget:self action:@selector(progressBarChangeEnded:) forControlEvents:UIControlEventTouchUpInside];
    [self.playerHUDBottomView addSubview:self.progressBar];
    [self.progressBar setValue:0.0];

    //播放时间
    self.playTime = [[UILabel alloc] init];
    self.playTime.text = @"00:00:00/00:00:00";
    self.playTime.font = [UIFont systemFontOfSize:13];
    self.playTime.textAlignment = NSTextAlignmentLeft;
    self.playTime.textColor = [UIColor whiteColor];
    [self.playerHUDBottomView addSubview:self.playTime];
}

#pragma mark --
#pragma mark -- portrait / landscape Event
-(void)layoutSubviews
{
    [super layoutSubviews];
    UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
    if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
        [self initLandscape];
    }else{
        [self initPortrait];
    }
}




//initLandscape与initPortrait里面一样
-(void)initLandscape
{
    self.frame = [[UIScreen mainScreen] bounds];
    
    float frameWidth = self.frame.size.width;
    float frameHeight = self.frame.size.height;
    
    self.playerHUDTopView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.playerHUDTopView.frame = CGRectMake(0, 0, frameWidth, 60);
    self.backBtn.frame = CGRectMake(0, 0, 80, 60);
    
    
    self.ChangeButton.frame = CGRectMake(60, 0, 150, 60);
    
    self.replayState.frame = CGRectMake(220, 0, 80, 60);
    
    
    self.changePlay.frame = CGRectMake(100 + 165, 0, 150, 60);
    
    
    self.playerHUDBottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.playerHUDBottomView.frame = CGRectMake(0, frameHeight-60, frameWidth, 60);
    self.playBtn.frame = CGRectMake(0, 0, 80, 60);
    self.progressBar.frame = CGRectMake(90, 11, frameWidth-110, 20);
//    self.loadProgressView.frame = CGRectMake(92, 20, frameWidth-106, 20);
    self.playTime.frame = CGRectMake(90, 40, 220, 20);
}
//
-(void)initPortrait
{
    
    
    _lockBtn.hidden = YES;
    
    self.frame = oldPlayViewFrame;
    
    float frameWidth = self.frame.size.width;
    float frameHeight = self.frame.size.height;
    
    self.playerHUDTopView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.playerHUDTopView.frame = CGRectMake(0, 0, frameWidth, 60);
    self.backBtn.frame = CGRectMake(0, 0, 80, 60);
    
    self.ChangeButton.frame = CGRectMake(60, 0, 150, 60);
    
     self.replayState.frame = CGRectMake(220, 0, 80, 60);
    
    self.changePlay.frame = CGRectMake(100 + 165, 0, 150, 60);
    
    self.playerHUDBottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.playerHUDBottomView.frame = CGRectMake(0, frameHeight-60, frameWidth, 60);
    self.playBtn.frame = CGRectMake(0, 0, 80, 60);
    self.progressBar.frame = CGRectMake(90, 11, frameWidth-110, 20);
//    self.loadProgressView.frame = CGRectMake(92, 20, frameWidth-106, 20);
    self.playTime.frame = CGRectMake(90, 40, 220, 20);
}


#pragma mark --
#pragma mark -- touch Event
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [(UITouch *)[touches anyObject] locationInView:self];
    if (CGRectContainsPoint(self.frame, point)) {
        [self showHud:viewIsShowing];
    }
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    UITouch *touch = [touches anyObject];
    [self.player displayPoint:touch];
//    NSLog(@"touchesMoved");
}

-(void)showHud:(BOOL)showing
{
    __weak __typeof(self) weakself = self;
    if (showing) {//隐藏
        viewIsShowing = !showing;
        weakself.playerHUDTopView.hidden = YES;
        weakself.playerHUDBottomView.hidden = YES;
        
    }else{//显示
        viewIsShowing = !showing;
        weakself.playerHUDTopView.hidden = NO;
        weakself.playerHUDBottomView.hidden = NO;
        _lockBtn.hidden = NO;
    }
}


#pragma mark --
#pragma mark -- back Event
-(void)onBackBtnClicked:(UIButton *)sender
{
    [self.delegate onBackBtn];
}

- (void)TypeButtonClicked:(UIButton *)btn{
    
  //  [self.delegate chagetype];
    
    if (btn.selected) {
        
        self.player.shouldShowHudView = YES;
        btn.selected = NO;
    }else{
        
        self.player.shouldShowHudView = NO;
        btn.selected = YES;
    }
}

- (void)rePlayButtonClicked:(id)sender{
    
    if (self.player && [self.delegate respondsToSelector:@selector(changePlayType:)]) {
        

        [self.delegate changePlayType:(UIButton *)sender];


        
    }
}

- (void)PlayButtonClicked:(UIButton *)btn{
    
    [self.delegate changePlay:btn];
}

-(void)onPlayBtnClicked:(UIButton *)sender
{
    self.playBtn.selected = !self.playBtn.selected;
    [self.delegate onPlayBtn];
}

#pragma mark --
#pragma mark -- progress change Event
-(void)progressBarChanged:(UISlider *)sender
{
//    if (self.player.isPlaying) {
//        [self.player pause];
//    }
    
    self.player.currentPlaybackTime = self.progressBar.value;
}

-(void)progressBarChangeEnded:(UISlider *)sender
{
//    self.player.currentPlaybackTime = self.progressBar.value;
//    [self.player play];
}


#pragma mark --
#pragma mark -- updata play time Event
- (void)updatePlayTimeOnMainThread
{
    if (updatePlayTimeTimer.valid) {
        [updatePlayTimeTimer invalidate];
    }
    updatePlayTimeTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(updatePlayTime:) userInfo:nil repeats:YES];
    
    NSLog(@"thread == %@",[NSThread currentThread]);
}

-(void)updatePlayTime:(id)sender
{
    NSInteger total_time=0, cur_time=0;
    
    if (self.player.currentPlaybackTime >= self.player.duration) {
        
        [self shutdownUpdatePlayTimeOnMainThread];
    }
    
    total_time = self.player.duration;
    cur_time = self.player.currentPlaybackTime;
    
    self.progressBar.minimumValue = 0;
    self.progressBar.maximumValue = total_time;
    
    NSString *totalStr=[self stringFromTimeInterval:total_time];
    NSString *curStr = [self stringFromTimeInterval:cur_time];
    
    NSString *playTime= [[NSString alloc] initWithFormat:@"%@/%@", curStr, totalStr];
    
//    NSLog(@"playTime==>%@", playTime);
    
    [self.playTime performSelectorOnMainThread:@selector(setText:) withObject:playTime waitUntilDone:YES];
    
    //slider
    if(self.progressBar && self.progressBar.enabled)
        [self.progressBar setValue:cur_time animated:YES];
}

- (NSString *)stringFromTimeInterval:(CGFloat)time
{
    NSInteger seconds, minutes, hours;
    hours = time / 60 / 60;
    minutes = time / 60;
    time = time - (minutes * 60);
    seconds = time;
    
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld", (long)hours, (long)minutes, (long)seconds];
}

- (void)shutdownUpdatePlayTimeOnMainThread
{
    if (updatePlayTimeTimer) {
        [updatePlayTimeTimer invalidate];
    }
}



-(void)dealloc
{
    [self shutdownUpdatePlayTimeOnMainThread];
}


@end
