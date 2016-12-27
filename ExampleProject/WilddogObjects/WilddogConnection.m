//
//  WilddogConnection.m
//
//
//  Created by ImacLi on 9/23/15.
//  Copyright (c) 2015 The liwuyang. All rights reserved.
//

#import "WilddogConnection.h"
#import <Wilddog/Wilddog.h>

@interface WilddogConnection ()
@property (strong, nonatomic) WDGSyncReference * connectionNode;

@end


@implementation WilddogConnection

-(id)initWithWilddogName:(NSString *)name onConnect:(void (^)(void))onConnect onDisconnect:(void (^)(void))onDisconnect {

    self = [super init];
    if (self) {
        self.connected = NO;
        //初始化 WDGApp
        WDGOptions *option = [[WDGOptions alloc] initWithSyncURL:@"https://testwild.wilddogio.com"];
        [WDGApp configureWithOptions:option];

        self.connectionNode = [[[WDGSync sync] reference] child:[NSString stringWithFormat:@"https://%@.wilddogio.com/.info/connected", name]];

        [self.connectionNode observeEventType:WDGDataEventTypeValue withBlock:^(WDGDataSnapshot * _Nonnull snapshot) {
            BOOL wasConnected = self.connected;
            self.connected = [snapshot.value boolValue];

            if (wasConnected && !self.connected) {
                if (onDisconnect) onDisconnect();
            }

            else if (!wasConnected && self.connected) {
                if (onConnect) onConnect();
            }

        }];
    }
    return self;
    
}

@end
