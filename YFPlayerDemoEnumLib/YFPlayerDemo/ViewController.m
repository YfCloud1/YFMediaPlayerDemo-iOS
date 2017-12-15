//
//  ViewController.m
//  IJKPlayer
//
//  Created by 张涛 on 2017/7/26.
//  Copyright © 2017年 张涛. All rights reserved.
//

#import "ViewController.h"

#import "PlayerViewController.h"

@interface ViewController ()

{
    
    UIButton *btn;
    
}

@property (nonatomic, strong) PlayerViewController *playerView;
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) UILabel *softLabel;
@property (nonatomic, strong) UILabel *dnsLabel;
@property (nonatomic, strong) UILabel *bufferTime;
@property (nonatomic, strong) UISwitch *softSwitch;
@property (nonatomic, strong) UISwitch *dnsSwitch;
@property (nonatomic, strong) UITextField *bufferText;

@property (nonatomic, strong) UILabel *localLabel;
@property (nonatomic, strong) UISwitch *localSwitch;

@property (nonatomic, strong) UIImageView *imgView;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imgView.frame = self.view.bounds;
    
    btn = [[UIButton alloc] initWithFrame:CGRectMake(10, 280, 100, 40)];
    btn.center = self.view.center;
    [btn setTitle:@"播放" forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor colorWithRed:30/255.0 green:185/255.0 blue:255/255.0 alpha:1]];
    btn.layer.cornerRadius = 10;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(nexpage:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];

    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 30, self.view.bounds.size.width-20, 40)];
    self.textField.text = @"rtmp://rtmp-zk.yftest.yflive.net/live/test32";
//    self.textField.text = @"http://yf.ugc.v.cztv.com/cztv/vod/2017/08/07/0759fe0c846905356d38cef7fd992668/h264_000k_mp4.mp4";
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.textColor = [UIColor blackColor];
    [self.view addSubview:self.textField];
    
    self.softLabel.frame = CGRectMake(10, 80, 120, 40);
    self.softSwitch.frame = CGRectMake(150, 80, 120, 40);
    self.dnsLabel.frame = CGRectMake(10, 130, 120, 40);
    self.dnsSwitch.frame = CGRectMake(150, 130, 80, 40);
    self.bufferTime.frame = CGRectMake(10, 180, 120, 40);
    self.bufferText.frame = CGRectMake(150, 180, 120, 40);
    self.localLabel.frame = CGRectMake(10, 230, 140, 40);
    self.localSwitch.frame = CGRectMake(150, 230, 120, 40);
}

- (void)nexpage:(UIButton *)btn
{
    
    self.playerView = [[PlayerViewController alloc] init];
    self.playerView.playUrl = self.textField.text;
    self.playerView.isSoftCode = self.softSwitch.on;
    self.playerView.isDNS = self.dnsSwitch.on;
    self.playerView.bufferTime = [self.bufferText.text intValue];
    self.playerView.isLocalFile = self.localSwitch.on;
    [self presentViewController:_playerView animated:YES completion:NULL];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}


- (UILabel *)softLabel{
    if (!_softLabel) {
        _softLabel = [[UILabel alloc] init];
        _softLabel.text = @"软解";
        _softLabel.textColor = [UIColor whiteColor];
        _softLabel.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:_softLabel];
    }
    return _softLabel;
}

- (UILabel *)dnsLabel{
    if (!_dnsLabel) {
        _dnsLabel = [[UILabel alloc] init];
        _dnsLabel.text = @"DNS";
        _dnsLabel.textColor = [UIColor whiteColor];
        _dnsLabel.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:_dnsLabel];
    }
    return _dnsLabel;
}

- (UILabel *)bufferTime{
    if (!_bufferTime) {
        _bufferTime = [[UILabel alloc] init];
        _bufferTime.text = @"缓存大小:";
        _bufferTime.textColor = [UIColor whiteColor];
        _bufferTime.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:_bufferTime];
    }
    return _bufferTime;
}

- (UISwitch *)softSwitch{
    if (!_softSwitch) {
        _softSwitch = [[UISwitch alloc] init];
        [self.view addSubview:_softSwitch];
    }
    return _softSwitch;
}

- (UISwitch *)dnsSwitch{
    if (!_dnsSwitch) {
        _dnsSwitch = [[UISwitch alloc] init];
        _dnsSwitch.on = YES;
        [self.view addSubview:_dnsSwitch];
    }
    return _dnsSwitch;
}

- (UITextField *)bufferText{
    if (!_bufferText) {
        _bufferText = [[UITextField alloc] init];
        _bufferText.borderStyle = UITextBorderStyleRoundedRect;
        _bufferText.placeholder = @"请输入纯数字";
        _bufferText.keyboardType = UIKeyboardTypeNumberPad;
        _bufferText.textColor = [UIColor blackColor];
        _bufferText.text = @"3";
        [self.view addSubview:_bufferText];
    }
    return _bufferText;
}

- (UILabel *)localLabel{
    if (!_localLabel) {
        _localLabel = [[UILabel alloc] init];
        _localLabel.text = @"播放本地文件";
        _localLabel.textColor = [UIColor whiteColor];
        _localLabel.textAlignment = NSTextAlignmentLeft;
        [self.view addSubview:_localLabel];
    }
    return _localLabel;
}

- (UISwitch *)localSwitch{
    if (!_localSwitch) {
        _localSwitch = [[UISwitch alloc] init];
        _localSwitch.on = NO;
        [self.view addSubview:_localSwitch];
    }
    return _localSwitch;
}

- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"short-bg"]];
        [self.view addSubview:_imgView];
    }
    return _imgView;
}

@end
