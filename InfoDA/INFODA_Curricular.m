//
//  INFODA_Curricular.m
//  InfoAlumno
//
//  Created by Alejandro Iván on 02-02-13.
//  Copyright (c) 2013 iOS Devel. All rights reserved.
//

#import "INFODA_Curricular.h"
#import "INFODA_Conexion.h"

#import "NSString+URLEncoding.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

@implementation INFODA_Curricular
{
    id _delegateObject;
    SEL _delegateConexionCorrecta;
    SEL _delegateConexionErronea;
    
    INFODA_Conexion *refreshSession;
}




/*
 * INICIO MÉTODOS DE CLASE
 */

+ (NSStringEncoding)encoding // Override para InfoAlumno en específico, que utiliza ASCII
{
    return NSASCIIStringEncoding;
}


/*
 * FIN MÉTODOS DE CLASE
 */









/*
 * INICIO MÉTODOS DE INSTANCIA
 */

- (id)initWithDelegate:(id)delegate success:(SEL)success fail:(SEL)fail
{
    _delegateObject = delegate;
    _delegateConexionCorrecta = success;
    _delegateConexionErronea = fail;
    
    if ( self = [super initWithDelegate:self success:@selector(gotHTML:) fail:nil] )
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *webServiceData = [NSString stringWithFormat:@"username=%@&password=%@&matricula=%@&area=%@", [prefs objectForKey:@"username"], [prefs objectForKey:@"password"], [prefs objectForKey:@"matricula"], @"PREGRADO"];
        
        Conexion *conn = [[Conexion alloc] initWithDelegate:self success:@selector(gotJSON:) fail:@selector(errorJSON:)];
        [conn sendPOST:@"http://infoalumno.iosdevel.cl/informacion_curricular.php" withString:webServiceData];
        
    }
    
    return self;
}

- (void)gotJSON:(NSString *)response
{
    if ( _delegateConexionCorrecta && [_delegateObject respondsToSelector:_delegateConexionCorrecta] )
    {
        [_delegateObject performSelector:_delegateConexionCorrecta withObject:response];
    }
}

- (void)errorJSON:(NSString *)response
{
    if ( _delegateConexionErronea && [_delegateObject respondsToSelector:_delegateConexionErronea] )
    {
        [_delegateObject performSelector:_delegateConexionErronea withObject:response];
    }
}

@end

#pragma clang diagnostic pop
