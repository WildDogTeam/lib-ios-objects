//
//  WilddogCollection.h
//
//
//  Created by ImacLi on 9/23/15.
//  Copyright (c) 2015 The liwuyang. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <Wilddog/Wilddog.h>
#import "Objectable.h"

// Keeps a dictionary in sync with the remote node, and creates local objects of the correct type
@interface WilddogCollection : NSObject

- (id)initWithNode:(Wilddog*)node dictionary:(NSMutableDictionary*)dictionary type:(Class)type;
- (id)initWithNode:(Wilddog*)node dictionary:(NSMutableDictionary*)dictionary factory:(id(^)(NSDictionary*))factory;

- (void)didAddChild:(void(^)(id))cb;
- (void)didRemoveChild:(void(^)(id))cb;
- (void)didUpdateChild:(void(^)(id))cb;

// you call these instead of adding them to your dictionary by hand
- (void)addObject:(id<Objectable>)object;
- (void)addObject:(id<Objectable>)object onComplete:(void(^)(NSError*))cb;
- (void)addObject:(id<Objectable>)object withName:(NSString*)name;
- (void)addObject:(id<Objectable>)object withName:(NSString*)name onComplete:(void(^)(NSError*))cb;
- (void)removeObject:(id)object;
- (void)updateObject:(id<Objectable>)object;

- (Wilddog*)nodeForObject:(id<Objectable>)obj;

@end
