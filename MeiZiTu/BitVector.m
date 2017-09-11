#import "BitVector.h"

typedef u_int8_t block_type;

@implementation BitVector {
    NSUInteger _bitsPerBlock;
    NSUInteger _bitShift;

    block_type *_data;
    NSUInteger _numberOfBytes;
}

#pragma mark - Lifecycle

- (id)initWithNumberOfBits:(NSUInteger)numberOfBits {
    return [self initWithNumberOfBits:numberOfBits andData:nil];
}

- (id)initWithNumberOfBits:(NSUInteger)numberOfBits andData:(NSData *)data {
    self = [super init];

    _bitsPerBlock = sizeof(block_type) * 8;
    _bitShift = (NSUInteger) log2(sizeof(block_type) * 8);

    NSUInteger numberOfBlocks = (NSUInteger) ceil(numberOfBits / (float)_bitsPerBlock);

    _numberOfBytes = (NSUInteger) ceil(numberOfBlocks * (_bitsPerBlock / 8.0f));

    if(self) {
        _numberOfBits = numberOfBits;

        if(data == nil) {
            _data = calloc(numberOfBlocks, sizeof(block_type));
        } else {
            NSAssert(_numberOfBytes == data.length, @"numberOfBits and data length do not match");
            _data = malloc(data.length);
            memcpy(_data, data.bytes, data.length);
        }
    }

    return self;
}

#pragma mark - Public

- (void) setAtIndex:(NSUInteger)i {
    _data[i >> _bitShift] |= 1 << (i % _bitsPerBlock);
}

- (void) clearAtIndex:(NSUInteger)i {
    _data[i >> _bitShift] &= ~(1 << (i % _bitsPerBlock));
}

- (BOOL) testAtIndex:(NSUInteger)i {
    return (_data[i >> _bitShift] & 1 << (i % _bitsPerBlock)) != 0;
}

- (NSData *)data {
    return [[NSData alloc] initWithBytes:_data length:_numberOfBytes];
}

@end