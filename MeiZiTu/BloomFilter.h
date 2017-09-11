#import <Foundation/Foundation.h>

@interface BloomFilter : NSObject

@property (readonly) uint32_t seed;
@property (readonly) NSUInteger expectedNumberOfItems;
@property (readonly) double falsePositivePercentage;
@property (readonly) NSUInteger numberOfBits;
@property (readonly) NSUInteger numberHashes;

- (id)initWithExceptedNumberOfItems:(NSUInteger)expectedNumberOfItems falsePositiveRate:(double)falsePositiveRate seed:(uint32_t)seed;
- (id)initWithData:(NSData *) data exceptedNumberOfItems:(NSUInteger)expectedNumberOfItems falsePositivePercentage:(double)falsePositiveRate seed:(uint32_t)seed;

- (void)addWithData:(NSData *)data;
- (BOOL)containsData:(NSData *)data;

- (void)addWithString:(NSString *)string;
- (BOOL)containsString:(NSString *)string;

- (NSData *)data;

@end
