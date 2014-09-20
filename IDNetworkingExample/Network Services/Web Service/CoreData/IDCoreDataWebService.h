//
// Created by Ian Dundas on 21/05/2014.
//

@import Foundation;
#import "IDBaseWebService.h"

@class IDRecordResponseSerializer;


@interface IDCoreDataWebService : IDBaseWebService {
@protected
    IDRecordResponseSerializer *_responseSerializer;
}

- (id)preprocessJSON:(id)responseObject forNetworkResponse:(NSURLResponse *)response;

- (id)responseObjectFromNetworkResponse:(NSURLResponse *)response withData:(NSData *)data andResponseSerializer:(AFHTTPResponseSerializer *)httpResponseSerializer error:(NSError *__autoreleasing *)error;
@end