//
//  LOBloomFilter.h
//
//  Created by Roger So on 17/2/14.
//  Copyright (c) 2014 LinkOmnia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LOBloomFilter : NSObject
@property (nonatomic, readonly, assign) NSUInteger bits;

- (id)initWithCapacity:(NSUInteger)bits;

- (void)addString:(NSString *)string;
- (BOOL)containsString:(NSString *)string;

@end
