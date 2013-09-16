//
//  INFODA_Conexion.m
//  InfoDA
//
//  Created by Alejandro Iván on 12-01-13.
//  Copyright (c) 2013 iOS Devel. All rights reserved.
//

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

#import "INFODA_Conexion.h"

@implementation INFODA_Conexion
{
    id _delegateObject;
    SEL _delegateConexionCorrecta;
    SEL _delegateConexionErronea;
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

- (id)initWithUsername:(NSString *)username withPassword:(NSString *)password withDelegate:(id)delegate success:(SEL)success fail:(SEL)fail
{
    _delegateObject = delegate;
    _delegateConexionCorrecta = success;
    _delegateConexionErronea = fail;
    
    if ( self = [super initWithDelegate:self success:@selector(conexionEstablecida:) fail:@selector(conexionFallida:)] )
    {
        [self sendPOST:@"http://infoda.udec.cl/INFODA_ingreso.php" withString:[NSString stringWithFormat:@"username=%@&clave=%@", username, password]];
    }
    
    return self;
}

- (id)initSessionRestoreWithDelegate:(id)delegate withSelector:(SEL)selector
{
    return [self initSessionRestoreWithDelegate:delegate withSelector:selector withErrorSelector:nil];
}

- (id)initSessionRestoreWithDelegate:(id)delegate withSelector:(SEL)selector withErrorSelector:(SEL)errorSel
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *username = [prefs objectForKey:@"username"];
    NSString *password = [prefs objectForKey:@"password"];
    
    if ( self = [super initWithDelegate:self success:@selector(conexionEstablecida:) fail:nil] )
    {
        _delegateObject = delegate;
        _delegateConexionCorrecta = selector;
        _delegateConexionErronea = errorSel;
        
        [self sendPOST:@"http://infoda.udec.cl/INFODA_ingreso.php" withString:[NSString stringWithFormat:@"username=%@&clave=%@", username, password]];
    }
    
    return self;
}


- (void)conexionEstablecida:(NSString *)response
{
    NSString *sesionIniciada = @"NO";
    
    if ( [response rangeOfString:@"INFODA_entrar.php"].location != NSNotFound )
    {
        sesionIniciada = @"YES";

        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSDictionary *userData = [[NSMutableDictionary alloc] init];
        [userData setValue:[prefs objectForKey:@"username"] forKey:@"username"];
        [userData setValue:[prefs objectForKey:@"password"] forKey:@"password"];
        
        Conexion *registerLogin = [[Conexion alloc] initWithDelegate:self success:nil fail:nil];
        [registerLogin sendPOST:@"http://infoalumno.iosdevel.cl/login.php" withDictionary:[userData copy]];
    }

    
    
    if ( _delegateConexionCorrecta != nil && [_delegateObject respondsToSelector:_delegateConexionCorrecta])
    {
        [_delegateObject performSelector:_delegateConexionCorrecta withObject:sesionIniciada];
    }
}


- (void)conexionFallida:(NSString *)error
{
    if ( _delegateConexionErronea != nil && [_delegateObject respondsToSelector:_delegateConexionErronea])
    {
        [_delegateObject performSelector:_delegateConexionErronea withObject:@"Imposible conectar al servidor."];
    }
}


/*
 * FIN MÉTODOS DE INSTANCIA
 */


@end

#pragma clang diagnostic pop
