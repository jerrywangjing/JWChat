//
//  TextMessageBody.h
//  XunYiTongV2.0
//
//  Created by jerry on 16/10/17.
//  Copyright © 2016年 jerry. All rights reserved.
//WJ: 框架接口

#import "MessageBody.h"

@interface TextMessageBody : MessageBody

/*!
 *  文本内容
 */
@property (nonatomic,copy) NSString * text;
@property (nonatomic,copy) NSString * textUrl;

/*!
 *  初始化文本消息体
 */
- (instancetype)initWithText:(NSString *)aText;
@end
