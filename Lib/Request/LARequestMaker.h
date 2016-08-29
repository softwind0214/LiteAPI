//
//  LARequestMaker.h
//  LiteAPI
//
//  Created by Softwind Tang on 16/8/5.
//  Copyright © 2016年 Softwind. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LADictionary.h"
#import "LARequest.h"
#import "LADefine.h"
#import "LACallback.h"

/**
 *  if version exist: <host>/<version>/<path>,
 *  otherwise <host>/<path>
 */
@interface LARequestMaker : NSObject

#pragma mark - complex properties

/**
 *  HTTP Header
 */
@property (nonatomic, strong, readonly) LADictionary *head;

/**
 *  API Parameters
 */
@property (nonatomic, strong, readonly) LADictionary *param;

/**
 *  API Life cycle: before request is invoked. It receives an NSURLRequest and should returns an NSURLRequest for finally invoking.
 */
@property (nonatomic, strong, readonly) LACallback *willInvoke;

/**
 *  API Life cycle: after request is invoked. It receives an LAResponse for users.
 */
@property (nonatomic, strong, readonly) LACallback *afterInvoke;

#pragma mark - simple properties / chaining support

- (LARequestMaker *(^)(NSString *value))host;                       //!< host of your API reqest
- (LARequestMaker *(^)(NSString *value))version;                    //!< version of your API request
- (LARequestMaker *(^)(NSString *value))path;                       //!< path of your API request
- (LARequestMaker *(^)(LAMethod value))method;                      //!< HTTP method of your API request
- (LARequestMaker *(^)(LAPostStyle value))post;                     //!< Default LAPostStyleJSON. The format of the generated post body.
- (LARequestMaker *(^)(LAResponseStyle value))response;             //!< Default LAResponseStyleJSON. The format of API response data.

- (LARequestMaker *(^)(BOOL value))sync;                            //!< Default NO.

- (LARequestMaker *(^)(LAIdentifier identifier))import;             //!< Import a template with identifier you've registered before. Accourding to current API status.
- (LARequestMaker *(^)(LAIdentifier identifier, LAStatus status))certainImport;
- (LARequest *)make;                                                //!< export a request accourding to configurations above.

@end
