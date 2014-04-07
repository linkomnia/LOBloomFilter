//
//  LOBloomFilter.m
//
//  Created by Roger So on 17/2/14.
//  Copyright (c) 2014 LinkOmnia. All rights reserved.
//

#import "LOBloomFilter.h"

#import "fnv/fnv.h"

@interface LOBloomFilter ()
@property (nonatomic, assign, getter = bits) NSUInteger nBits;
@property (nonatomic, assign) NSUInteger nHashes;
@end

@implementation LOBloomFilter {
    CFMutableBitVectorRef _bitVector;
}

- (id)initWithCapacity:(NSUInteger)bits
{
    self = [super init];
    if (self) {
        self.nBits = bits;
        self.nHashes = 3;

        _bitVector = CFBitVectorCreateMutable(NULL, bits);
        CFBitVectorSetCount(_bitVector, bits);
    }
    return self;
}

- (void)dealloc
{
    CFRelease(_bitVector);
}

- (void)addString:(NSString *)string
{
    const char *s = [string UTF8String];
    Fnv32_t hash = FNV1_32A_INIT;
    for (int i = 0; i < _nHashes; i++) {
        hash = fnv_32a_str((char *)s, hash);
        CFBitVectorSetBitAtIndex(_bitVector, (hash % _nBits), 1);
    }
}

- (BOOL)containsString:(NSString *)string
{
    const char *s = [string UTF8String];
    Fnv32_t hash = FNV1_32A_INIT;

    BOOL found = YES;
    for (int i = 0; i < _nHashes; i++) {
        hash = fnv_32a_str((char *)s, FNV1_32A_INIT);
        found = CFBitVectorGetBitAtIndex(_bitVector, (hash % _nBits));
        if (!found) {
            break;
        }
    }
    return found;
}

@end
