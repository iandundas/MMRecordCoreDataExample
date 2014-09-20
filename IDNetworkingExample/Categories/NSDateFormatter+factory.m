//
// Created by Ian Dundas on 03/02/2014.
//

#import "NSDateFormatter+factory.h"


@implementation NSDateFormatter (factory)


+ (NSDateFormatter *)ISO8601DateTimeFormatterInstance { // eg 2013-05-08T19:03:53+00:00
    static NSDateFormatter *_ISO8601DateTimeFormatter = nil;

    @synchronized (self) {
        if (_ISO8601DateTimeFormatter == nil) {
            _ISO8601DateTimeFormatter = [[self alloc] init];
            _ISO8601DateTimeFormatter.locale = [NSLocale autoupdatingCurrentLocale];
            _ISO8601DateTimeFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZZ";
        }
    }

    return _ISO8601DateTimeFormatter;
}


+ (NSDateFormatter *)ISO8601WithMillisecondsDateTimeFormatterInstance { // eg 2014-05-08T00:00:00.000+02:00
    static NSDateFormatter *_ISO8601WithMillisecondsDateTimeFormatter = nil;

    @synchronized (self) {
        if (_ISO8601WithMillisecondsDateTimeFormatter == nil) {
            _ISO8601WithMillisecondsDateTimeFormatter = [[self alloc] init];
            _ISO8601WithMillisecondsDateTimeFormatter.locale = [NSLocale autoupdatingCurrentLocale];
            _ISO8601WithMillisecondsDateTimeFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZ";
        }
    }

    return _ISO8601WithMillisecondsDateTimeFormatter;
}
+ (NSDateFormatter *)dutchDateTimeFormatterInstance {
    static NSDateFormatter *_dutchDateTimeFormatterInstance = nil;

    @synchronized (self) {
        if (_dutchDateTimeFormatterInstance == nil) {
            _dutchDateTimeFormatterInstance = [[self alloc] init];
            _dutchDateTimeFormatterInstance.locale= [NSLocale autoupdatingCurrentLocale];
            _dutchDateTimeFormatterInstance.dateFormat= @"dd-MM 'om' HH:mm";
        }
    }

    return _dutchDateTimeFormatterInstance;
}
+ (NSDateFormatter *)timeFormatterInstance {
    static NSDateFormatter *_dutchDateTimeFormatterInstance = nil;

    @synchronized (self) {
        if (_dutchDateTimeFormatterInstance == nil) {
            _dutchDateTimeFormatterInstance = [[self alloc] init];
            _dutchDateTimeFormatterInstance.locale= [NSLocale autoupdatingCurrentLocale];
            _dutchDateTimeFormatterInstance.dateFormat= @"HH:mm";
        }
    }

    return _dutchDateTimeFormatterInstance;
}

+ (NSDateFormatter *)ddMMyyFormatterInstance {
    static NSDateFormatter *_ddMMyyFormatterInstance = nil;

    @synchronized (self) {
        if (_ddMMyyFormatterInstance == nil) {
            _ddMMyyFormatterInstance = [[self alloc] init];
            _ddMMyyFormatterInstance.locale = [NSLocale autoupdatingCurrentLocale];
            _ddMMyyFormatterInstance.dateFormat = @"dd-MM-yy";
        }
    }

    return _ddMMyyFormatterInstance;
}
+ (NSDateFormatter *)ddMMyyyyFormatterInstance {
    static NSDateFormatter *_ddMMyyFormatterInstance = nil;

    @synchronized (self) {
        if (_ddMMyyFormatterInstance == nil) {
            _ddMMyyFormatterInstance = [[self alloc] init];
            _ddMMyyFormatterInstance.locale = [NSLocale autoupdatingCurrentLocale];
            _ddMMyyFormatterInstance.dateFormat = @"dd-MM-yyyy";
        }
    }

    return _ddMMyyFormatterInstance;
}

+ (NSDateFormatter *)yyyyMMddFormatterInstance { // i.e. 2014-02-02
    static NSDateFormatter *_yyyyMMddFormatterInstance = nil;

    @synchronized (self) {
        if (_yyyyMMddFormatterInstance == nil) {
            _yyyyMMddFormatterInstance = [[self alloc] init];
            _yyyyMMddFormatterInstance.locale = [NSLocale autoupdatingCurrentLocale];
            _yyyyMMddFormatterInstance.dateFormat = @"yyyy-MM-dd";
        }
    }

    return _yyyyMMddFormatterInstance;
}

@end