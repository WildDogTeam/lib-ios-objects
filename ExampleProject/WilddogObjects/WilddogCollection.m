//
//  WilddogCollection.m
//
//
//  Created by ImacLi on 9/23/15.
//  Copyright (c) 2015 The liwuyang. All rights reserved.
//

#import "WilddogCollection.h"

@interface WilddogCollection ()
@property (nonatomic, strong) WDGSyncReference * node;
@property (nonatomic, strong) NSMutableDictionary * objects;
@property (nonatomic, strong) NSMapTable * names;
@property (nonatomic, strong) Class type;
@property (nonatomic, strong) void(^addCb)(id);
@property (nonatomic, strong) void(^removeCb)(id);
@property (nonatomic, strong) void(^updateCb)(id);
@end

@implementation WilddogCollection

- (id)initWithNode:(WDGSyncReference*)node dictionary:(NSMutableDictionary *)dictionary type:(__unsafe_unretained Class)type {
    return [self initWithNode:node dictionary:dictionary factory:^(NSDictionary * value) {
        return [type new];
    }];
}

- (id)initWithNode:(WDGSyncReference*)node dictionary:(NSMutableDictionary*)dictionary factory:(id(^)(NSDictionary*))factory {
    self = [super init];
    if (self) {
        self.objects = dictionary;
        self.node = node;
        self.names = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsObjectPointerPersonality valueOptions:NSPointerFunctionsWeakMemory];
        
        self.addCb = ^(id obj) {};
        self.removeCb = ^(id obj) {};
        self.updateCb = ^(id obj) {};
        
        // find the correct object and update locally
        [self.node observeEventType:WDGDataEventTypeChildAdded withBlock:^(WDGDataSnapshot * _Nonnull snapshot) {
            id<Objectable> obj = [self.objects objectForKey:snapshot.key];
            if (!obj) {
                // add the object to the collection if it doesn't exist yet
                obj = factory(snapshot.value);
                [self addObjectLocally:obj name:snapshot.key];
            }
            // update the object with values from the server and notify the delegate
            [obj setValuesForKeysWithDictionary:snapshot.value];
            self.addCb(obj);
        }];
        [self.node observeEventType:WDGDataEventTypeChildRemoved withBlock:^(WDGDataSnapshot * _Nonnull snapshot) {
            id<Objectable> obj = [self.objects objectForKey:snapshot.key];
            if (!obj) return;
            [self.objects removeObjectForKey:snapshot.key];
            self.removeCb(obj);
        }];
        
        [self.node observeEventType:WDGDataEventTypeChildChanged withBlock:^(WDGDataSnapshot * _Nonnull snapshot) {
            id<Objectable> obj = [self.objects objectForKey:snapshot.key];
            if (!obj) {
                NSAssert(false, @"Object not found locally! %@", snapshot.key);
            }
            [obj setValuesForKeysWithDictionary:snapshot.value];
            self.updateCb(obj);
        }];
    }
    return self;
}

- (void)didAddChild:(void(^)(id))cb {
    self.addCb = cb;
}

- (void)didRemoveChild:(void(^)(id))cb {
    self.removeCb = cb;
}

- (void)didUpdateChild:(void(^)(id))cb {
    self.updateCb = cb;
}

- (void)removeObject:(id<Objectable>)object {
    [[self nodeForObject:object] removeValue];
}

- (void)addObject:(id<Objectable>)obj {
    [self addObject:obj onComplete:nil];
}

- (void)addObject:(id<Objectable>)obj withName:(NSString *)name {
    [self addObject:obj withName:name onComplete:nil];
}

- (void)addObject:(id<Objectable>)obj onComplete:(void (^)(NSError*))cb {
    [self addObject:obj withNode:[self.node childByAutoId] onComplete:cb];
}

- (void)addObject:(id<Objectable>)obj withName:(NSString *)name onComplete:(void (^)(NSError*))cb {
    [self addObject:obj withNode:[self.node child:name] onComplete:cb];
}

- (void)addObject:(id<Objectable>)obj withNode:(WDGSyncReference*)objnode onComplete:(void(^)(NSError*))cb {

    [objnode onDisconnectRemoveValue];
    
    [objnode setValue:obj.toObject withCompletionBlock:^(NSError * _Nullable error, WDGSyncReference * _Nonnull ref) {

    }];
    
    
    [self addObjectLocally:obj name:objnode.key];
}

- (void)addObjectLocally:(id)obj name:(NSString*)name {
    [self.names setObject:name forKey:obj];
    [self.objects setObject:obj forKey:name];
}

- (void)removeObjectLocally:(id)obj name:(NSString*)name {
    [self.names removeObjectForKey:obj];
    [self.objects removeObjectForKey:name];
}

- (void)updateObject:(id<Objectable>)obj {
    [[self nodeForObject:obj] setValue:obj.toObject];
}

- (WDGSyncReference*)nodeForObject:(id<Objectable>)obj {
    NSString * name = [self.names objectForKey:obj];
    WDGSyncReference* objnode = [self.node child:name];
    return objnode;
}

- (void)dealloc {
    [self.node removeAllObservers];
}

@end
