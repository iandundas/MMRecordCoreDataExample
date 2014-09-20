#import "IDArtist.h"
#import "NSDateFormatter+factory.h"


@interface IDArtist ()

// Private interface goes here.

@end


@implementation IDArtist

#pragma mark MMRecord:
+ (NSString *)keyPathForResponseObject {
    return @"resultsPage.results.artist";
}

+ (NSDateFormatter *)dateFormatter {
    return [NSDateFormatter yyyyMMddFormatterInstance];
}

@end
