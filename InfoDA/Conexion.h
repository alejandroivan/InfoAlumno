//
//  Conexion.h
//  InfoDA
//
//  Created by Alejandro Iván on 12-01-13.
//  Copyright (c) 2013 iOS Devel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Conexion : NSObject <NSURLConnectionDataDelegate>
{
@private
    id _delegate;
    SEL _success;
    SEL _fail;
    
    NSURL *_url;
    NSMutableURLRequest *_request;
    NSMutableData *_webData;
    NSURLConnection *_connection;

}

@property (strong, nonatomic) id delegate;
@property (nonatomic) SEL success;
@property (nonatomic) SEL fail;

@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) NSMutableURLRequest *request;
@property (strong, nonatomic) NSMutableData *webData;
@property (strong, nonatomic) NSURLConnection *connection;



+ (NSStringEncoding)encoding;
+ (NSString *)stringWithDictionary:(NSDictionary *)dictionary;

- (id)initWithDelegate:(id)delegate success:(SEL)success fail:(SEL)fail;


- (void)sendGETToURL:(NSString *)url withString:(NSString *)getString;
- (void)sendPOSTToURL:(NSString *)url withString:(NSString *)postString;

- (void)sendGET:(NSString *)url;

- (void)sendGET:(NSString *)url
 withDictionary:(NSDictionary *)dictionary;

- (void)sendGET:(NSString *)url
     withString:(NSString *)getString;



- (void)sendPOST:(NSString *)url
  withDictionary:(NSDictionary *)dictionary;

- (void)sendPOST:(NSString *)url
      withString:(NSString *)postString;

@end
