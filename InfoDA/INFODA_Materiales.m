//
//  INFODA_Materiales.m
//  InfoAlumno
//
//  Created by Alejandro Iván on 07-06-13.
//  Copyright (c) 2013 iOS Devel. All rights reserved.
//

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

#import "INFODA_Materiales.h"
#import "INFODA_Conexion.h"


@implementation INFODA_Materiales
{
    id _delegateObject;
    SEL _delegateConexionCorrecta;
    SEL _delegateConexionErronea;
    INFODA_Conexion *connLogin;
}



/*
 * INICIO MÉTODOS DE CLASE
 */

+ (NSStringEncoding)encoding // Override para InfoAlumno en específico, que utiliza ASCII
{
//    return NSASCIIStringEncoding;
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
    
    if ( self = [super initWithDelegate:self success:@selector(gotHTML:) fail:@selector(noConnectionError:)] )
    {
        connLogin = [[INFODA_Conexion alloc] initSessionRestoreWithDelegate:self withSelector:@selector(loginSuccessful:) withErrorSelector:@selector(loginFailed:)];
    }
    return self;
}



- (void)loginSuccessful:(NSString *)response
{
    [self sendGET:[NSString stringWithFormat:@"http://infoda.udec.cl/INFODA_verMaterialAlumno.php?id=sub2&vdiv=sub2&cAsig=%d", 0]];
}


- (void)noConnectionError:(NSString *)error
{
    if ( _delegateConexionErronea && [_delegateObject respondsToSelector:_delegateConexionErronea] )
    {
        [_delegateObject performSelector:_delegateConexionErronea withObject:error];
    }
}


- (void)gotHTML:(NSString *)response
{
    //NSLog(@"%@", response);
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:response forKey:@"html"];
    [dict setValue:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] forKey:@"version"];
    
    Conexion *conn = [[Conexion alloc] initWithDelegate:self success:@selector(gotJSON:) fail:@selector(errorJSON:)];

    // Dirección para producción del WebService
    [conn sendPOST:@"http://infoalumno.iosdevel.cl/materiales.php" withDictionary:[dict copy]];
    
    // Dirección para desarrollo del WebService
    //[conn sendPOST:@"http://192.168.0.3/infoda/materiales.php" withDictionary:[dict copy]];
}

- (void)gotJSON:(NSString *)response
{
    //NSLog(@"JSON: %@", response);
    if ( _delegateConexionCorrecta && [_delegateObject respondsToSelector:_delegateConexionCorrecta] )
    {
        [_delegateObject performSelector:_delegateConexionCorrecta withObject:response];
    }
}

- (void)errorJSON:(NSString *)response
{
    //[_delegateObject performSelector:_delegateConexionErronea withObject:response];
}


/*
 * FIN MÉTODOS DE INSTANCIA
 */


@end

#pragma clang diagnostic pop
