//
// Created by Ian Dundas on 21/05/2014.
//

#import <ObjectiveRecord/CoreDataManager.h>
#import "IDCoreDataWebService.h"
#import "IDRecordResponseSerializer.h"
#import "NSString+ObjectiveSugar.h"


@interface IDCoreDataWebService ()
- (IDRecordResponseSerializer *)responseSerializer;
@end

@implementation IDCoreDataWebService {

}


// for converting parsed response into a Core Data Managed Object
- (IDRecordResponseSerializer *)responseSerializer {

    // strange pattern. we provide a ResponseSerializer to the Session which maintains a 'pet' (child) ResponseSerializer:
    //  - the parent serializer is for producing MMRecord instances,
    //  - the pet is the actual consumer of HTTP responses, so can be XML, JSON, etc. Strange..

    if (!_responseSerializer) {

        // the [AFJSONResponseSerializer serializer] parameter is for converting raw HTTP response into a parsed response (i.e. NSDictionary)
        // whilst the serializer we're instantiating will be used to convert ('unserialize') the parsed response into a Managed Object
        _responseSerializer = [IDRecordResponseSerializer
                serializerWithManagedObjectContext:[[CoreDataManager sharedManager] managedObjectContext]
                          responseObjectSerializer:[AFJSONResponseSerializer serializer]
                                      entityMapper:self.serializationMapper];

        // Allow the Response Serializer to run response object past the serviceLevelErrorFromServiceResponse: method
        // and thus stay compatible with our Nice Web Services pattern.
        _responseSerializer.webserviceDelegate = self;
    }

    return _responseSerializer;
}

- (void)startWithCompletion:(TTWebServiceCompletionBlock)completionBlock {

    // Reassign our context because after a [AuthHandler wipeCoreDataStore] Logout it might have changed:
    [self.responseSerializer setContext:[[CoreDataManager sharedManager] managedObjectContext]];

    [super startWithCompletion:completionBlock];
}

// For mapping an endpoint URL to appropriate response object.
- (AFMMRecordResponseSerializationMapper *)serializationMapper {
    NSAssert(NO,
                    NSStringWithFormat (@"You must provide a serializationMapper implementation for %@", NSStringFromClass (self.class))
            );
    return nil;
}


// Used by IDRecordResponseSerializer to iron out any .. imperfections.. in response from network
// @override
- (id)preprocessJSON:(id)responseObject forNetworkResponse:(NSURLResponse *)response {
    return responseObject;
}

// MMRecord gives us an opportunity to fix any problems in the Network Response
// before we reach the AFNetworking success/failure block.
// See BRRecordResponseSerializer.m for usage
- (id)responseObjectFromNetworkResponse:(NSURLResponse *)response
                               withData:(NSData *)data
                  andResponseSerializer:(AFHTTPResponseSerializer *)httpResponseSerializer
                                  error:(NSError *__autoreleasing *)error {

    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
    int statusCode = [httpResponse statusCode];

    if (statusCode != 200) {
        NSString *errorString = [NSHTTPURLResponse localizedStringForStatusCode:statusCode];
        *error = [NSError
                errorWithDomain:IDNetworkErrorDomain
                           code:statusCode
                       userInfo:@{NSLocalizedDescriptionKey : errorString}
        ];
        return nil;
    }

    NSError *serializationError = nil;
    id responseObject = [httpResponseSerializer responseObjectForResponse:response
                                                                     data:data
                                                                    error:&serializationError];

    NSError *serviceLevelError = [self serviceLevelErrorFromServiceResponse:responseObject];
    if (serviceLevelError) {
        *error = serviceLevelError;
        return nil;
    }

    // iron out any network grossness (e.g. contains NSString when expecting NSNumber etc)
    id cleanedResponseObject = [self preprocessJSON:responseObject forNetworkResponse:response];
    if (!cleanedResponseObject) {
        *error = [NSError errorWithDomain:IDServiceErrorDomain
                                     code:500
                                 userInfo:@{NSLocalizedDescriptionKey : @"Could not parse response from server"}
        ];
        return nil;
    }

    if (!([cleanedResponseObject isKindOfClass:[NSDictionary class]] || [cleanedResponseObject isKindOfClass:[NSArray class]])) {
        *error = [NSError errorWithDomain:IDServiceErrorDomain
                                     code:500
                                 userInfo:@{NSLocalizedDescriptionKey : @"Received an invalid response from the server"}
        ];
        return nil;
    }

    return cleanedResponseObject;
}
@end