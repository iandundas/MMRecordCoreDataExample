#import "IDEvent.h"
#import "NSDateFormatter+factory.h"


@interface IDEvent ()

// Private interface goes here.

@end


@implementation IDEvent

#pragma mark MMRecord:
+ (NSString *)keyPathForResponseObject {
    return @"resultsPage.results.event";
}

+ (NSDateFormatter *)dateFormatter {
    return [NSDateFormatter yyyyMMddFormatterInstance];
}

@end
