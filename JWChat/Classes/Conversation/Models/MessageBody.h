//
//  MessageBody.h
//  XunYiTongV2.0
//
//  Created by jerry on 16/10/17.
//  Copyright © 2016年 jerry. All rights reserved.
//WJ: 框架接口

#import <Foundation/Foundation.h>

/// 消息类型

typedef NS_ENUM(NSUInteger, MessageBodyType) {
    
    MessageBodyTypeText,        // 文本类型
    MessageBodyTypeImage,       // 图片类型
    MessageBodyTypeVoice,       // 语言类型
    MessageBodyTypeFile,        // 文件类型
    MessageBodyTypeLocation,    // 位置类型
};


@interface MessageBody : NSObject

/*!
 *  消息体类型
 */
@property (nonatomic, assign) MessageBodyType type;

// 构造方法
-(instancetype)initWithMessageBodyType:(MessageBodyType)type;
@end
