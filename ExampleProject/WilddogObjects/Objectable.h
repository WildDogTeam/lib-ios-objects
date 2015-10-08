//
//  Objectable.h
//
//
//  Created by ImacLi on 9/23/15.
//  Copyright (c) 2015 The liwuyang. All rights reserved.
//

#import <Foundation/Foundation.h>

// Kind of a silly name. Means you can turn it into a raw dictionary
@protocol Objectable <NSObject>
-(NSDictionary*)toObject;
-(void)setValuesForKeysWithDictionary:(NSDictionary*)keyedValues;
@end
