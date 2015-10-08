//
//  User.m
//  ExampleProject
//
//  Created by ImacLi on 9/23/15.
//  Copyright (c) 2015 The liwuyang. All rights reserved.
//

#import "User.h"

@implementation User

-(NSDictionary*)toObject {
    return [self dictionaryWithValuesForKeys:@[@"name"]];
}

@end
