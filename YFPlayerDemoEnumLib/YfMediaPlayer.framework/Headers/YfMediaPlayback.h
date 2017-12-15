/*
 * YfMediaPlayback.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@protocol YfFFMoviePlayerControllerDelegate;


typedef NS_ENUM(NSInteger,YfPLAYER_MEDIA_ERROR){
    // 0xx
    YfPLAYER_MEDIA_ERROR_UNKNOWN = 1,
    // 1xx
    YfPLAYER_MEDIA_ERROR_SERVER_DIED = 100,
    // 2xx
    YfPLAYER_MEDIA_ERROR_NOT_VALID_FOR_PROGRESSIVE_PLAYBACK = 200,
    // 3xx
    
    // -xx
    YfPLAYER_MEDIA_ERROR_IO          = -1004,
    YfPLAYER_MEDIA_ERROR_MALFORMED   = -1007,
    YfPLAYER_MEDIA_ERROR_UNSUPPORTED = -1010,
    YfPLAYER_MEDIA_ERROR_TIMED_OUT   = -110,
    
    YfPLAYER_MEDIA_ERROR_BADSTREAM	= -2000,
    
    YfPLAYER_MEDIA_ERROR_Yf_PLAYER  = -10000,
};


typedef NS_ENUM(NSInteger, YfMPMovieScalingMode) {
    YfMPMovieScalingModeNone,       // No scaling
    YfMPMovieScalingModeAspectFit,  // Uniform scale until one dimension fits
    YfMPMovieScalingModeAspectFill, // Uniform scale until the movie fills the visible bounds. One dimension may have clipped contents
    YfMPMovieScalingModeFill        // Non-uniform scale. Both render dimensions will exactly match the visible bounds
};

typedef NS_ENUM(NSInteger, YfMPMoviePlaybackState) {
    YfMPMoviePlaybackStateStopped,
    YfMPMoviePlaybackStatePlaying,
    YfMPMoviePlaybackStatePaused,
    YfMPMoviePlaybackStateInterrupted,
    YfMPMoviePlaybackStateSeekingForward,
    YfMPMoviePlaybackStateSeekingBackward
};

typedef NS_OPTIONS(NSUInteger, YfMPMovieLoadState) {
    YfMPMovieLoadStateUnknown        = 0,
    YfMPMovieLoadStatePlayable       = 1 << 0,
    YfMPMovieLoadStatePlaythroughOK  = 1 << 1, // Playback will be automatically started in this state when shouldAutoplay is YES
    YfMPMovieLoadStateStalled        = 1 << 2, // Playback will be automatically paused in this state, if started
};

typedef NS_ENUM(NSInteger, YfMPMovieFinishReason) {
    YfMPMovieFinishReasonPlaybackEnded,
    YfMPMovieFinishReasonPlaybackError,
    YfMPMovieFinishReasonUserExited
};

// -----------------------------------------------------------------------------
// Thumbnails

typedef NS_ENUM(NSInteger, YfMPMovieTimeOption) {
    YfMPMovieTimeOptionNearestKeyFrame,
    YfMPMovieTimeOptionExact
};


typedef NS_ENUM(NSInteger,YfMPOveralState)
{
    YfPLAYER_OVERAL_NORMAL  = 0,      //正常播放
    YfPLAYER_OVERAL   = 1,            //全景播放，
    YfPLAYER_OVERAL_3D  = 2,          //全景虚拟3d播放
};


@protocol YfMediaPlayback;

typedef void(^DNSIpCallBack)(NSString *ip);

#pragma mark YfMediaPlayback

@protocol YfMediaPlayback <NSObject>

- (void)prepareToPlay;
- (void)play;
- (void)pause;
- (void)stop;
- (BOOL)isPlaying;
- (void)shutdown;
- (void)setPauseInBackground:(BOOL)pause;

- (void)clean;
- (void)play:(NSURL *)url useDns:(BOOL)availableDNS useSoftDecode:(BOOL)availableDecode DNSIpCallBack:(DNSIpCallBack)DNSIpCallBack appID:(const char *)appid refer:(const char *)refer bufferTime:(float)bufferTime;


//进度条时间 重复动作
- (void)repeat_video:(double)startSec;

//进度条时间 慢动作
- (void)slow_video:(double)startSec;



@property(nonatomic, readonly)  UIView *view;
@property(nonatomic)            NSTimeInterval currentPlaybackTime;
@property(nonatomic, readonly)  NSTimeInterval duration;
@property(nonatomic, readonly)  NSTimeInterval playableDuration;
@property(nonatomic, readonly)  NSInteger bufferingProgress;

@property(nonatomic, readonly)  BOOL isPreparedToPlay;
@property(nonatomic, readonly)  YfMPMoviePlaybackState playbackState;
@property(nonatomic, readonly)  YfMPMovieLoadState loadState;

@property(nonatomic, readonly) int64_t numberOfBytesTransferred;

@property(nonatomic, readonly) CGSize naturalSize;
@property(nonatomic) YfMPMovieScalingMode scalingMode;
@property(nonatomic) BOOL shouldAutoplay;

@property (nonatomic) BOOL allowsMediaAirPlay;
@property (nonatomic) BOOL isDanmakuMediaAirPlay;
@property (nonatomic, readonly) BOOL airPlayMediaActive;

@property (nonatomic) float playbackRate;
@property (nonatomic) float playbackVolume;

- (UIImage *)thumbnailImageAtCurrentTime;


//设置播放全景模式
@property (nonatomic,readwrite) YfMPOveralState overalState;
//播放器是否渲染
@property (nonatomic,assign)BOOL display;

- (void)displayPoint:(UITouch *)point;

- (void)setPlayerVideoZoom:(float)ZoomScale;

- (void)startDeviceMotion;

- (void)stopDeviceMotion;

@property (nonatomic, weak) id<YfFFMoviePlayerControllerDelegate>delegate;



#pragma mark Notifications

#ifdef __cplusplus
#define Yf_EXTERN extern "C" __attribute__((visibility ("default")))
#else
#define Yf_EXTERN extern __attribute__((visibility ("default")))
#endif

// -----------------------------------------------------------------------------
//  MPMediaPlayback.h

// Posted when the prepared state changes of an object conforming to the MPMediaPlayback protocol changes.
// This supersedes MPMoviePlayerContentPreloadDidFinishNotification.
Yf_EXTERN NSString *const YfMPMediaPlaybackIsPreparedToPlayDidChangeNotification;

// -----------------------------------------------------------------------------
//  MPMoviePlayerController.h
//  Movie Player Notifications

// Posted when the scaling mode changes.
Yf_EXTERN NSString* const YfMPMoviePlayerScalingModeDidChangeNotification;

// Posted when movie playback ends or a user exits playback.
Yf_EXTERN NSString* const YfMPMoviePlayerPlaybackDidFinishNotification;
Yf_EXTERN NSString* const YfMPMoviePlayerPlaybackDidFinishReasonUserInfoKey; // NSNumber (YfMPMovieFinishReason)

// Posted when the playback state changes, either programatically or by the user.
Yf_EXTERN NSString* const YfMPMoviePlayerPlaybackStateDidChangeNotification;

// Posted when the network load state changes.
Yf_EXTERN NSString* const YfMPMoviePlayerLoadStateDidChangeNotification;

// Posted when the movie player begins or ends playing video via AirPlay.
Yf_EXTERN NSString* const YfMPMoviePlayerIsAirPlayVideoActiveDidChangeNotification;

// -----------------------------------------------------------------------------
// Movie Property Notifications

// Calling -prepareToPlay on the movie player will begin determining movie properties asynchronously.
// These notifications are posted when the associated movie property becomes available.
Yf_EXTERN NSString* const YfMPMovieNaturalSizeAvailableNotification;

// -----------------------------------------------------------------------------
//  Extend Notifications

Yf_EXTERN NSString *const YfMPMoviePlayerVideoDecoderOpenNotification;
Yf_EXTERN NSString *const YfMPMoviePlayerFirstVideoFrameRenderedNotification;
Yf_EXTERN NSString *const YfMPMoviePlayerFirstAudioFrameRenderedNotification;

Yf_EXTERN NSString *const YfMPMoviePlayerDidSeekCompleteNotification;
Yf_EXTERN NSString *const YfMPMoviePlayerDidSeekCompleteTargetKey;
Yf_EXTERN NSString *const YfMPMoviePlayerDidSeekCompleteErrorKey;
Yf_EXTERN NSString *const YfMPMoviePlayerDidAccurateSeekCompleteCurPos;
Yf_EXTERN NSString *const YfMPMoviePlayerAccurateSeekCompleteNotification;

@end

#pragma mark YfMediaUrlOpenDelegate

// Must equal to the defination in ijkavformat/ijkavformat.h
typedef NS_ENUM(NSInteger, YfMediaEvent) {

    // Notify Events
    YfMediaEvent_WillHttpOpen         = 1,       // attr: url
    YfMediaEvent_DidHttpOpen          = 2,       // attr: url, error, http_code
    YfMediaEvent_WillHttpSeek         = 3,       // attr: url, offset
    YfMediaEvent_DidHttpSeek          = 4,       // attr: url, offset, error, http_code
    // Control Message
    YfMediaCtrl_WillTcpOpen           = 0x20001, // YfMediaUrlOpenData: no args
    YfMediaCtrl_DidTcpOpen            = 0x20002, // YfMediaUrlOpenData: error, family, ip, port, fd
    YfMediaCtrl_WillHttpOpen          = 0x20003, // YfMediaUrlOpenData: url, segmentIndex, retryCounter
    YfMediaCtrl_WillLiveOpen          = 0x20005, // YfMediaUrlOpenData: url, retryCounter
    YfMediaCtrl_WillConcatSegmentOpen = 0x20007, // YfMediaUrlOpenData: url, segmentIndex, retryCounter
};

#define YfMediaEventAttrKey_url            @"url"
#define YfMediaEventAttrKey_host           @"host"
#define YfMediaEventAttrKey_error          @"error"
#define YfMediaEventAttrKey_time_of_event  @"time_of_event"
#define YfMediaEventAttrKey_http_code      @"http_code"
#define YfMediaEventAttrKey_offset         @"offset"

// event of YfMediaUrlOpenEvent_xxx
@interface YfMediaUrlOpenData: NSObject

- (id)initWithUrl:(NSString *)url
            event:(YfMediaEvent)event
     segmentIndex:(int)segmentIndex
     retryCounter:(int)retryCounter;

@property(nonatomic, readonly) YfMediaEvent event;
@property(nonatomic, readonly) int segmentIndex;
@property(nonatomic, readonly) int retryCounter;

@property(nonatomic, retain) NSString *url;
@property(nonatomic, assign) int fd;
@property(nonatomic, strong) NSString *msg;
@property(nonatomic) int error; // set a negative value to indicate an error has occured.
@property(nonatomic, getter=isHandled)    BOOL handled;     // auto set to YES if url changed
@property(nonatomic, getter=isUrlChanged) BOOL urlChanged;  // auto set to YES by url changed

@end

@protocol YfMediaUrlOpenDelegate <NSObject>

- (void)willOpenUrl:(YfMediaUrlOpenData*) urlOpenData;

@end

@protocol YfMediaNativeInvokeDelegate <NSObject>

- (int)invoke:(YfMediaEvent)event attributes:(NSDictionary *)attributes;

@end
