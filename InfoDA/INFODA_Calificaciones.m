//
//  INFODA_Calificaciones.m
//  InfoAlumno
//
//  Created by Alejandro Iván on 21-01-13.
//  Copyright (c) 2013 iOS Devel. All rights reserved.
//

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

#import "INFODA_Calificaciones.h"
#import "INFODA_Conexion.h"


@implementation INFODA_Calificaciones
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
    [self sendGET:[NSString stringWithFormat:@"http://infoda.udec.cl/INFODA_verCalificaciones2.php?id=&vdiv=&kEval=20&carr=0&cAsig=%d", 0]];
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
    // Response debería ser el HTML de la parte de calificaciones, para sea parseado en el WebService
    //NSLog(@"%@", response);
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setValue:response forKey:@"html"];

    Conexion *conn = [[Conexion alloc] initWithDelegate:self success:@selector(gotJSON:) fail:nil];
    

    // Dirección para desarrollo
    //[conn sendPOST:@"http://192.168.0.3/infoda/calificaciones.php" withDictionary:[dict copy]];

    // Dirección para producción
    [conn sendPOST:@"http://infoalumno.iosdevel.cl/calificaciones.php" withDictionary:[dict copy]];
}

- (void)gotJSON:(NSString *)response
{
    if ( _delegateConexionCorrecta && [_delegateObject respondsToSelector:_delegateConexionCorrecta] )
    {
        [_delegateObject performSelector:_delegateConexionCorrecta withObject:response];
    }
}



/*
 * FIN MÉTODOS DE INSTANCIA
 */


@end

#pragma clang diagnostic pop
