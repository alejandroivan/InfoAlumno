//
//  Conexion.m
//  InfoDA
//
//  Created by Alejandro Iván on 12-01-13.
//  Copyright (c) 2013 iOS Devel. All rights reserved.
//

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"



#import "Conexion.h"
#import "NSString+URLEncoding.h"





@implementation Conexion

@synthesize delegate = _delegate;
@synthesize success = _success;
@synthesize fail = _fail;
@synthesize url = _url;
@synthesize request = _request;
@synthesize webData = _webData;
@synthesize connection = _connection;



/*
 * INICIO MÉTODOS DE CLASE
 */




// Devuelve la codificación por defecto que se utilizará
+ (NSStringEncoding)encoding
{
    return NSUTF8StringEncoding;
}




// Transforma diccionarios (key->value) en strings para pasar como datos de formulario HTML
+ (NSString *)stringWithDictionary:(NSDictionary *)dictionary
{
    // Transformar al formato key1=value1&key2=value2&...&
    NSMutableString *mutableString = [[NSMutableString alloc] init];
    for (NSString *key in dictionary)
    {
        NSString *val = [[dictionary objectForKey:key] urlEncodeUsingEncoding:[self.class encoding]];
        
        [mutableString appendFormat:@"%@=%@&", key, val];
    }

    // Remover el último "&" de la cadena (rtrim de "&")
    NSString *result = [mutableString length] > 0 ? [mutableString substringToIndex:mutableString.length - 1] : mutableString;
    
    return result;
}


/*
 * FIN MÉTODOS DE CLASE
 */





























/*
 * INICIO MÉTODOS DE INSTANCIA
 */


// Constructor de las instancias
- (id)initWithDelegate:(id)delegate success:(SEL)success fail:(SEL)fail
{
    if (!self)
    {
        self = [super init];
    }
    
    self.delegate = (delegate != nil) ? delegate : nil;
    self.success = (success != nil) ? success : nil;
    self.fail = (fail != nil) ? fail : nil;
    
    return self;
}



// Enviar información (realizar conexión real) utilizando GET.
// El string getData es de la forma key1=value1&key2=value2&...
// Si getData es nil, se llama a la URL sin pasar información por GET
- (void)sendGETToURL:(NSString *)url withString:(NSString *)getString
{
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    if (getString)
    {
        self.url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", url, getString]];
    }
    else
    {
        self.url = [NSURL URLWithString:url];
    }
    
    self.request = [[NSMutableURLRequest alloc] initWithURL:self.url];
    self.connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self];
    
    if (self.connection)
    {
        self.webData = [[NSMutableData alloc] init];
    }
    else
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (self.fail != nil && [self.delegate respondsToSelector:self.fail])
        {
            [self.delegate performSelector:self.fail withObject:@"Error al intentar conectar."];
        }
    }
}



// Enviar información (realizar conexión real) utilizando POST.
// El string postData es de la forma key1=value1&key2=value2&...
// Si postData es nil, se llama a la URL sin pasar información por POST
- (void)sendPOSTToURL:(NSString *)url withString:(NSString *)postString
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    NSString *postDataLength = [NSString stringWithFormat:@"%d", postString.length];
    
    self.url = [NSURL URLWithString:url];
    self.request = [[NSMutableURLRequest alloc] initWithURL:self.url];
    
    [self.request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [self.request setValue:postDataLength forHTTPHeaderField:@"Content-Length"];
    [self.request setHTTPMethod:@"POST"];
    [self.request setHTTPBody:[postString dataUsingEncoding:[self.class encoding]]];
    
    self.connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self];
    
    if (self.connection)
    {
        self.webData = [[NSMutableData alloc] init];
    }
    else
    {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (self.fail != nil && [self.delegate respondsToSelector:self.fail])
        {
            [self.delegate performSelector:self.fail withObject:@"Error al intentar conectar."];
        }
    }
}


/*
 * Wrappers para sendGETString
 */

// sendGET sin parámetros
- (void)sendGET:(NSString *)url
{
    [self sendGETToURL:url withString:nil];
}

// sendGET con diccionario
- (void)sendGET:(NSString *)url withDictionary:(NSDictionary *)dictionary
{
    NSString *getString = [self.class stringWithDictionary:dictionary];
    [self sendGETToURL:url withString:getString];
}

// sendGET con string
- (void)sendGET:(NSString *)url withString:(NSString *)getString
{
    [self sendGETToURL:url withString:getString];
}




// sendPOST con diccionario
- (void)sendPOST:(NSString *)url withDictionary:(NSDictionary *)dictionary
{
    NSString *postString = [self.class stringWithDictionary:dictionary];
    [self sendPOSTToURL:url withString:postString];
}

// sendPOST con string
- (void)sendPOST:(NSString *)url withString:(NSString *)postString
{
    [self sendPOSTToURL:url withString:postString];
}


/*
 * FIN MÉTODOS DE INSTANCIA
 */


















/*
 * IMPLEMENTACIONES ADICIONALES (DELEGATES)
 */
// Métodos para manejar la conexión
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // Inicializar el objeto para almacenar información
    [self.webData setLength:0];
    
    // Almacenar cookies, para mantener sesión activa
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;

    NSArray *allCookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[httpResponse allHeaderFields] forURL:[response URL]];
    
    
    if ([allCookies count]) {
       // [connection cancel];
        
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:allCookies forURL:[response URL] mainDocumentURL:nil];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.webData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.fail != nil && [self.delegate respondsToSelector:self.fail])
    {
        [self.delegate performSelector:self.fail withObject:[error localizedDescription]];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *response = [[NSString alloc] initWithData:self.webData encoding:[self.class encoding]];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
    if (
        self.success != nil
        &&
        [self.delegate respondsToSelector:self.success]
        )
    {
        [self.delegate performSelector:self.success withObject:response];
    }
    else if (
             self.fail != nil
             &&
             [self.delegate respondsToSelector:self.fail]
             )
    {
        [self.delegate performSelector:self.fail withObject:response];
    }
}

@end

#pragma clang diagnostic pop

