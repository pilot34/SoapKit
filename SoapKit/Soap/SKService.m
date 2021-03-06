//
//  SKService.m
//  SoapKit
//
//  Created by Hannes Tribus on 02/09/14.
//  Copyright (c) 2014 3Bus. All rights reserved.
//

#import "SKService.h"
#import "SKRequest.h"
#import "SKData.h"
#import "GDataXMLNode.h"
#import "SKData+Private.h"

#define kSoapEnvelopeNamespace @"http://schemas.xmlsoap.org/soap/envelope/"

@interface SKService()<NSURLSessionDelegate>
@property (strong, nonatomic, readwrite) NSOperationQueue *backgroundQueue;
@property (strong, nonatomic, readwrite) NSURLSession *session;
@end

@implementation SKService

    - (NSURLSession *)session {
        if(!_session) {
            NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
            if (self.timeoutIntervalForRequest > 0) {
                config.timeoutIntervalForRequest = self.timeoutIntervalForRequest;
            }
            _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:self.backgroundQueue];
        }

        return _session;
    }

    - (NSOperationQueue *)backgroundQueue {
        if (!_backgroundQueue) {
            _backgroundQueue = [[NSOperationQueue alloc] init];
            _backgroundQueue.maxConcurrentOperationCount = 4;
        }
        return _backgroundQueue;
    }
    
    - (NSURLSessionTask *)performRequest:(SKRequest *)soapRequest
                               onSuccess:(void (^)(SKService *soapService, SKData *data))success
                               onFailure:(void (^)(SKService *soapService, NSError *error))failure {
        soapRequest.username = self.username;
        soapRequest.password = self.password;

        NSURLSessionDataTask *task = [self.session dataTaskWithRequest:soapRequest.request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if(error) {
                failure(self, error);
                return;
            }

            NSHTTPURLResponse *httpResponse = [response isKindOfClass:NSHTTPURLResponse.class] ? (id)response : nil;
            if(httpResponse && httpResponse.statusCode != 200) {
                failure(self, [NSError errorWithDomain:NSURLErrorDomain code:httpResponse.statusCode userInfo:nil]);
                return;
            }

            NSArray *result = [self parseOutput:data SoapReaquest:soapRequest];
            if(!result) {
                failure(self, [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorCannotParseResponse userInfo:nil]);
            } else {
                if (result.count > 1) {
                    success(self, [SKData dataWithName:[NSString stringWithFormat:@"%@Response", soapRequest.operation] andChildren:result]);
                } else {
                    success(self, result.firstObject );
                }
            }
        }];
        [task resume];
        return task;
    }

    - (NSArray *)parseOutput:(NSData *)response SoapReaquest:(SKRequest *)soapRequest {

        DLog(@"response: %@", [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding]);
        GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:response options:0 error:nil];
        if(!doc)
            return nil;

        NSDictionary *namespaces = @{@"soap":kSoapEnvelopeNamespace,
                                     @"service":[soapRequest.namespaceURL absoluteString]};

        NSString *query = [NSString stringWithFormat:@"/soap:Envelope/soap:Body/service:%@Response/*", soapRequest.operation];
        NSArray *nodes = [doc nodesForXPath:query namespaces:namespaces error:nil];
        if (nodes.count > 0) {

            NSMutableArray *output = [[NSMutableArray alloc] initWithCapacity:nodes.count];
            for(GDataXMLElement *node in nodes)
                [output addObject:[SKData dataWithXMLElement:[node copy]]];

            return output;
        }

        NSString *faultQuery = @"/soap:Envelope/soap:Body/soap:Fault/faultstring";
        NSError *error;
        nodes = [doc nodesForXPath:faultQuery namespaces:namespaces error:&error];

        if (nodes.count > 0) {
            return @[ [SKData dataWithXMLElement:[nodes.firstObject copy]] ];
        }

        return nil;
    }

#pragma mark - NSURLSessionDelegate

    - (void)URLSession:(NSURLSession *)session
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable)) completionHandler {

    if (challenge.previousFailureCount > 5) {
        completionHandler(NSURLSessionAuthChallengeCancelAuthenticationChallenge, nil);
        return;
    }

    NSURLCredential *c = [[NSURLCredential alloc] initWithUser:self.username
                                                      password:self.password
                                                   persistence:NSURLCredentialPersistenceForSession];

    completionHandler(NSURLSessionAuthChallengeUseCredential, c);
}

    @end
