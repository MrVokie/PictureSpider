#import "BloomFilter.h"
#import "BitVector.h"
#import "MurmurHash3.h"

@implementation BloomFilter {
    u_int8_t murmurHash[16];
    BitVector *bits;
}

#pragma mark - Lifecycle

- (id)initWithExceptedNumberOfItems:(NSUInteger)expectedNumberOfItems falsePositiveRate:(double)falsePositiveRate seed:(uint32_t)seed {
    self = [super init];

    if(self) {
        _seed = seed;
        _expectedNumberOfItems = expectedNumberOfItems;
        _falsePositivePercentage = falsePositiveRate;

        _numberOfBits = (NSUInteger) ceil(-(_expectedNumberOfItems*log(_falsePositivePercentage) / pow(log(2.0), 2.0)));
        _numberHashes = (NSUInteger) ceil((_numberOfBits / _expectedNumberOfItems) * log(2.0));

        bits = [[BitVector alloc] initWithNumberOfBits:_numberOfBits];
    }
    return self;
}

- (id)initWithData:(NSData *) data exceptedNumberOfItems:(NSUInteger)expectedNumberOfItems falsePositivePercentage:(double)falsePositiveRate seed:(uint32_t)seed {
    self = [self initWithExceptedNumberOfItems:expectedNumberOfItems falsePositiveRate:falsePositiveRate seed:seed];

    if(self) {
        bits = [[BitVector alloc] initWithNumberOfBits:_numberOfBits andData:data];
    }

    return self;
}

#pragma mark - Public

- (void)addWithData:(NSData *)data {
    [MurmurHash3 hash128WithKey:data.bytes length:data.length seed:_seed out:murmurHash];

    uint64_t hash0 = ((uint64_t *)murmurHash)[0];
    uint64_t hash1 = ((uint64_t *)murmurHash)[1];

    // See "Less Hashing, Same Performance: Building a Better Bloom Filter"
    // Section "4.2 (Extended) Double Hashing Schemes",  f(i) = 0 (double hashing scheme)
    // https://www.eecs.harvard.edu/~michaelm/postscripts/tr-02-05.pdf
    for(u_int8_t i; i < _numberHashes; i++) {
        uint64_t hash = (hash0 + hash1 * i) % _numberOfBits;
        [bits setAtIndex:hash];
    }
}

- (BOOL)containsData:(NSData *)data {
    [MurmurHash3 hash128WithKey:data.bytes length:data.length seed:_seed out:murmurHash];

    uint64_t hash0 = ((uint64_t *)murmurHash)[0];
    uint64_t hash1 = ((uint64_t *)murmurHash)[1];

    for(u_int8_t i; i < _numberHashes; i++) {
        uint64_t hash = (hash0 + i * hash1) % _numberOfBits;

        if([bits testAtIndex:hash] == 0) {
            return NO;
        }
    }

    return YES;
}

- (void)addWithString:(NSString *)string {
    [self addWithData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}


- (BOOL)containsString:(NSString *)string {
    return [self containsData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

- (NSData*)data {
    return bits.data;
}

- (NSString *) description {
    return [NSString stringWithFormat:
        @"expectedNumberOfItems: %ld, falsePositivePercentage: %f, numberOfBits: %ld, numberOfHashes: %ld, seed: %d",
        _expectedNumberOfItems, _falsePositivePercentage, _numberOfBits, _numberHashes, _seed
    ];
}
@end
