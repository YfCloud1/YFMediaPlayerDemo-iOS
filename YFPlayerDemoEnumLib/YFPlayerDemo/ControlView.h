//
//  ControlView.h
//  YfPlayer-Demo
//
//  Created by suntongmian.
//  Copyright © 2016年 YunFan. All rights reserved.
//

#import <UIKit/UIKit.h>


#import <YfMediaPlayer/YfMediaPlayer.h>



@class ControlView;

@protocol ControlViewDelegate <NSObject>

- (void)onBackBtn;
- (void)onPlayBtn;
- (void)chagetype;


//改变播放速度
- (void)changePlay:(UIButton *)btn;

//改变播放模式
- (void)changePlayType:(UIButton *)btn;

@end


@interface ControlView : UIView
{
    
     BOOL _isMediaSliderBeingDragged;
}

@property(atomic, assign) YfFFMoviePlayerController *player;

@property (nonatomic, assign) id<ControlViewDelegate> delegate;

@property (nonatomic, assign) NSInteger mediaDuration;
//
@property (nonatomic, strong) UIButton *playBtn;//播放，暂停按钮
@property (nonatomic, strong) UIButton *backBtn;//返回按钮


@property (nonatomic,strong) UIButton *ChangeButton;

@property (nonatomic,strong) UIButton *changePlay;

@property (nonatomic,strong) UIButton *replayState;

@property (nonatomic,strong) UIButton *lockBtn;

@property (nonatomic, strong) UISlider *progressBar;//播放进度条
//@property (nonatomic, strong) UIProgressView *loadProgressView;//缓存进度条
@property (nonatomic, strong) UILabel *playTime;//已播放时间
@property (nonatomic, strong) UILabel *playTotalTime;//总时间

@property (nonatomic, strong) UIView *playerHUDBottomView;
@property (nonatomic, strong) UIView *playerHUDTopView;

- (void)updatePlayTimeOnMainThread;
- (void)shutdownUpdatePlayTimeOnMainThread;



@end
