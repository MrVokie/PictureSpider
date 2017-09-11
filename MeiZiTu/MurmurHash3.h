#import <Foundation/Foundation.h>

@interface MurmurHash3 : NSObject

+(void)hash128WithKey:(const void *)key length:(uint64_t)len seed:(uint32_t)seed out:(const u_int8_t *)out;

@end