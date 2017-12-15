/*
 * YfFFMoviePlayerController.h
 *
 * Copyright (c) 2013 Bilibili
 * Copyright (c) 2013 Zhang Rui <bbcallen@gmail.com>
 *
 * This file is part of ijkPlayer.
 *
 * ijkPlayer is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * ijkPlayer is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with ijkPlayer; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 */

#import "YfMediaPlayback.h"
#import "YfFFMonitor.h"
#import "YfFFOptions.h"

// media meta
#define k_YfM_KEY_FORMAT         @"format"
#define k_YfM_KEY_DURATION_US    @"duration_us"
#define k_YfM_KEY_START_US       @"start_us"
#define k_YfM_KEY_BITRATE        @"bitrate"

// stream meta
#define k_YfM_KEY_TYPE           @"type"
#define k_YfM_VAL_TYPE__VIDEO    @"video"
#define k_YfM_VAL_TYPE__AUDIO    @"audio"
#define k_YfM_VAL_TYPE__UNKNOWN  @"unknown"

#define k_YfM_KEY_CODEC_NAME      @"codec_name"
#define k_YfM_KEY_CODEC_PROFILE   @"codec_profile"
#define k_YfM_KEY_CODEC_LONG_NAME @"codec_long_name"

// stream: video
#define k_YfM_KEY_WIDTH          @"width"
#define k_YfM_KEY_HEIGHT         @"height"
#define k_YfM_KEY_FPS_NUM        @"fps_num"
#define k_YfM_KEY_FPS_DEN        @"fps_den"
#define k_YfM_KEY_TBR_NUM        @"tbr_num"
#define k_YfM_KEY_TBR_DEN        @"tbr_den"
#define k_YfM_KEY_SAR_NUM        @"sar_num"
#define k_YfM_KEY_SAR_DEN        @"sar_den"
// stream: audio
#define k_YfM_KEY_SAMPLE_RATE    @"sample_rate"
#define k_YfM_KEY_CHANNEL_LAYOUT @"channel_layout"

#define kk_YfM_KEY_STREAMS       @"streams"

typedef enum YfLogLevel {
    k_Yf_LOG_UNKNOWN = 0,
    k_Yf_LOG_DEFAULT = 1,

    k_Yf_LOG_VERBOSE = 2,
    k_Yf_LOG_DEBUG   = 3,
    k_Yf_LOG_INFO    = 4,
    k_Yf_LOG_WARN    = 5,
    k_Yf_LOG_ERROR   = 6,
    k_Yf_LOG_FATAL   = 7,
    k_Yf_LOG_SILENT  = 8,
} YfLogLevel;

@class YfFFMoviePlayerController;



@protocol YfFFMoviePlayerControllerDelegate <NSObject>

//回调视频数据
- (void)willOutputPlayerRenderbuffer:(CVPixelBufferRef)renderbuffer player:(YfFFMoviePlayerController *)player;

//回调播放器音频数据
- (void)senderOutAudioData:(NSData*)audioData size:(size_t)audioDataSize player:(YfFFMoviePlayerController *)player;

/**
 * 假如哪有开启自动播放 需要等此回调出来之后 调用play
 * 可以开始播放
 */
- (void)playerStatusCallBackLoadingCanReadyToPlay:(YfFFMoviePlayerController *)player;



/**
 * 播放器资源加载中；
 * 加载成功；
 */
- (void)playerStatusCallBackLoading:(YfFFMoviePlayerController *)player;
- (void)playerStatusCallBackLoadingSuccess:(YfFFMoviePlayerController *)player;


/**
 * 播放缓冲开始；
 * 缓冲结束
 */
- (void)playerStatusCallBackBufferingStart:(YfFFMoviePlayerController *)player;
- (void)playerStatusCallBackBufferingEnd:(YfFFMoviePlayerController *)player;

/**
 * 播放结束；
 * 播放出错
 */
- (void)playerStatusCallBackPlayerPlayEnd:(YfFFMoviePlayerController *)player;

- (void)playerStatusCallBackPlayerPlayErrorType:(YfPLAYER_MEDIA_ERROR)errorType httpErrorCode:(int)httpErrorCode player:(YfFFMoviePlayerController *)player;

@end



@interface YfFFMoviePlayerController : NSObject <YfMediaPlayback>

/*
 *param 参数解析
 *bufferTime:传 0 表示不追帧，>0 表示追帧缓存
 *display:是否需要显示播放画面
 *soundTouch:开启快慢速播放，可能会有抖动
*/
- (id)initWithContentURL:(NSURL *)aUrl
             withOptions:(YfFFOptions *)options useDns:(BOOL)availableDNS useSoftDecode:(BOOL)availableDecode DNSIpCallBack:(DNSIpCallBack)DNSIpCallBack appID:(const char *)appid refer:(const char *)refer bufferTime:(float)bufferTime display:(BOOL)display isOpenSoundTouch:(BOOL)soundTouch;



- (void)prepareToPlay;
- (void)play;
- (void)pause;
- (void)stop;
- (BOOL)isPlaying;
- (int64_t)trafficStatistic;
- (float)dropFrameRate;


- (void)setPauseInBackground:(BOOL)pause;
- (BOOL)isVideoToolboxOpen;

+ (void)setLogReport:(BOOL)preferLogReport;
+ (void)setLogLevel:(YfLogLevel)logLevel;
+ (BOOL)checkIfFFmpegVersionMatch:(BOOL)showAlert;
+ (BOOL)checkIfPlayerVersionMatch:(BOOL)showAlert
                            version:(NSString *)version;

@property(nonatomic, readonly) CGFloat fpsInMeta;
@property(nonatomic, readonly) CGFloat fpsAtOutput;
@property(nonatomic) BOOL shouldShowHudView;

- (void)setOptionValue:(NSString *)value
                forKey:(NSString *)key
            ofCategory:(YfFFOptionCategory)category;

- (void)setOptionIntValue:(int64_t)value
                   forKey:(NSString *)key
               ofCategory:(YfFFOptionCategory)category;



- (void)setFormatOptionValue:       (NSString *)value forKey:(NSString *)key;
- (void)setCodecOptionValue:        (NSString *)value forKey:(NSString *)key;
- (void)setSwsOptionValue:          (NSString *)value forKey:(NSString *)key;
- (void)setPlayerOptionValue:       (NSString *)value forKey:(NSString *)key;

- (void)setFormatOptionIntValue:    (int64_t)value forKey:(NSString *)key;
- (void)setCodecOptionIntValue:     (int64_t)value forKey:(NSString *)key;
- (void)setSwsOptionIntValue:       (int64_t)value forKey:(NSString *)key;
- (void)setPlayerOptionIntValue:    (int64_t)value forKey:(NSString *)key;


@property (nonatomic, retain) id<YfMediaUrlOpenDelegate> segmentOpenDelegate;
@property (nonatomic, retain) id<YfMediaUrlOpenDelegate> tcpOpenDelegate;
@property (nonatomic, retain) id<YfMediaUrlOpenDelegate> httpOpenDelegate;
@property (nonatomic, retain) id<YfMediaUrlOpenDelegate> liveOpenDelegate;


@property (nonatomic, weak) id<YfFFMoviePlayerControllerDelegate>delegate;

@property (nonatomic, retain) id<YfMediaNativeInvokeDelegate> nativeInvokeDelegate;

- (void)didShutdown;

#pragma mark KVO properties
@property (nonatomic, readonly) YfFFMonitor *monitor;

@end

#define Yf_FF_IO_TYPE_READ (1)
void YfFFIOStatDebugCallback(const char *url, int type, int bytes);
void YfFFIOStatRegister(void (*cb)(const char *url, int type, int bytes));

void YfFFIOStatCompleteDebugCallback(const char *url,
                                      int64_t read_bytes, int64_t total_size,
                                      int64_t elpased_time, int64_t total_duration);
void YfFFIOStatCompleteRegister(void (*cb)(const char *url,
                                            int64_t read_bytes, int64_t total_size,
                                            int64_t elpased_time, int64_t total_duration));
