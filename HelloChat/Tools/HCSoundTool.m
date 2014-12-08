//
//  HCSoundTool.m
//  HelloChat
//
//  Created by 叶根长 on 14-11-29.
//  Copyright (c) 2014年 叶根长. All rights reserved.
//

#import "HCSoundTool.h"
#import "Singleton.h"
#import <AudioToolbox/AudioToolbox.h>
#import "PlayerManager.h"
@interface HCSoundTool ()<PlayingDelegate>
{
    SystemSoundID _newMsgId;//新消息提示音
}
@property (nonatomic, assign) BOOL isPlaying;
@end

@implementation HCSoundTool

singleton_implementation(HCSoundTool)

-(id)init
{
    if(self=[super init])
    {
        [self loadSoundFile];
    }
    return self;
}

#pragma mark 加载音效文件
-(void)loadSoundFile
{
    NSURL *msgsoundurl=[[NSBundle mainBundle] URLForResource:@"msgTritone.caf" withExtension:nil];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(msgsoundurl),&_newMsgId);
}

#pragma mark 新信息提示音
-(void)playNewMsgSound
{
    if(_newMsgId)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
              AudioServicesPlaySystemSound(_newMsgId);
        });
      
    }
}

#pragma marak 播放语音消息
-(void)playVoiceMsgWihtFilename:(NSString *)filename
{
    if ( ! self.isPlaying) {
        [PlayerManager sharedManager].delegate = nil;
        self.isPlaying = YES;
        [[PlayerManager sharedManager] playAudioWithFileName:[self getfullPahtWihtFilename:filename] delegate:self];
    }
    else {
        self.isPlaying = NO;
        [[PlayerManager sharedManager] stopPlaying];
    }
}

-(NSString *)getfullPahtWihtFilename:(NSString *)filename
{
    return [[kDocPath stringByAppendingPathComponent:@"voice"] stringByAppendingPathComponent:filename];
}

#pragma mark PlayingDelegate 代理 播放完成
-(void)playingStoped
{
    
}

@end
