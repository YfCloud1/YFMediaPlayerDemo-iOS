//
//  PlayerViewController.h
//  IJKPlayer
//
//  Created by 张涛 on 2017/7/28.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerViewController : UIViewController

@property (nonatomic, assign) BOOL isSoftCode;
@property (nonatomic, assign) BOOL isDNS;
@property (nonatomic, assign) int bufferTime;
@property (nonatomic, strong) NSString *playUrl;
//本地文件
@property (nonatomic, assign) BOOL isLocalFile;

@end
