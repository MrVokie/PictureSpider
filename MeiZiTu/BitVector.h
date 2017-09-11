#import <Foundation/Foundation.h>

@interface BitVector : NSObject

@property (readonly) NSUInteger numberOfBits;

- (id)initWithNumberOfBits:(NSUInteger)numberOfBits;
- (id)initWithNumberOfBits:(NSUInteger)numberOfBits andData:(NSData *)data;

- (void) setAtIndex:(NSUInteger)i;
- (void) clearAtIndex:(NSUInteger)i;
- (BOOL) testAtIndex:(NSUInteger)i;
- (NSData *)data;

@end