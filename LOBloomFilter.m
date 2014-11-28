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
    uint8_t *_bitstring;
}

- (instancetype)initWithCapacity:(NSUInteger)bits
{
    self = [super init];
    if (self) {
        self.nBits = bits;
        self.nHashes = 3;

        size_t nBytes = (bits + 7)/8;
        _bitstring = malloc(nBytes);
        memset(_bitstring, 0, nBytes);
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        _nBits = [decoder decodeInt32ForKey:@"bits"];
        _nHashes = [decoder decodeInt32ForKey:@"deg"];
        NSUInteger numBytes = (_nBits + 7)/8, readBytes = 0;
        _bitstring = malloc(numBytes);
        const uint8_t *bitstring = [decoder decodeBytesForKey:@"data" returnedLength:&readBytes];
        if (readBytes == numBytes) {
            memcpy(_bitstring, bitstring, numBytes);
        } else {
            memset(_bitstring, 0, numBytes);
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeInt32:_nBits forKey:@"bits"];
    [coder encodeInt32:_nHashes forKey:@"deg"];
    [coder encodeBytes:_bitstring length:(_nBits + 7)/8 forKey:@"data"];
}

- (void)dealloc
{
    free(_bitstring);
}

static inline void __setBitAtIndex(uint8_t *bitstring, size_t idx, bool value)
{
    size_t byteIdx = idx / 8;
    size_t bitOfByte = idx & (8 - 1);
    if (value) {
        bitstring[byteIdx] |= (1 << (8 - 1 - bitOfByte));
    } else {
        bitstring[byteIdx] &= ~(1 << (8 - 1 - bitOfByte));
    }
}

static inline bool __getBitAtIndex(uint8_t *bitstring, size_t idx)
{
    size_t byteIdx = idx / 8;
    size_t bitOfByte = idx & (8 - 1);
    return (bitstring[byteIdx] >> (8 - 1 - bitOfByte)) & 0x1;
}

- (void)addString:(NSString *)string
{
    const char *s = [string UTF8String];
    Fnv32_t hash = FNV1_32A_INIT;
    for (int i = 0; i < _nHashes; i++) {
        hash = fnv_32a_str((char *)s, hash);
        __setBitAtIndex(_bitstring, hash % _nBits, 1);
    }
}

- (BOOL)containsString:(NSString *)string
{
    const char *s = [string UTF8String];
    Fnv32_t hash = FNV1_32A_INIT;

    BOOL found = YES;
    for (int i = 0; i < _nHashes; i++) {
        hash = fnv_32a_str((char *)s, FNV1_32A_INIT);
        found = __getBitAtIndex(_bitstring, hash % _nBits);
        if (!found) {
            break;
        }
    }
    return found;
}

@end
