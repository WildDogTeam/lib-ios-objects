//
//  WilddogConnection.h
//
//
//  Created by ImacLi on 9/23/15.
//  Copyright (c) 2015 The liwuyang. All rights reserved.
//

// helps you track presence and connection status

#import <Foundation/Foundation.h>

@interface WilddogConnection : NSObject
@property (nonatomic) BOOL connected;
-(id)initWithWilddogName:(NSString*)name onConnect:(void(^)(void))onConnect onDisconnect:(void(^)(void))onDisconnect;
@end
