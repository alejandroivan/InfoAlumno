//
//  MainViewController.m
//  InfoDA
//
//  Created by Alejandro Iván on 17-01-13.
//  Copyright (c) 2013 iOS Devel. All rights reserved.
//

#import "MainViewController.h"
#import "IniciarSesionViewController.h"
#import "INFODA_Conexion.h"

@interface MainViewController ()
{
    IniciarSesionViewController *loginScreen;
    INFODA_Conexion *conexion;
    
    NSUserDefaults *prefs;
    BOOL keepLogin;
    BOOL firstLoad;
}

@end

@implementation MainViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        // Custom initialization
        NSLog(@"Versión: %@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]);
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    

    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationWillResign)
     name:UIApplicationWillResignActiveNotification
     object:nil];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(applicationDidBecomeActive)
     name:UIApplicationWillEnterForegroundNotification
     object:nil];

        
    prefs = [NSUserDefaults standardUserDefaults];
    firstLoad = YES; // Determina si la aplicación se está recién abriendo
    
    loginScreen = [self.storyboard instantiateViewControllerWithIdentifier:@"Login"];
    loginScreen.mainViewController = self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    keepLogin = [prefs boolForKey:@"keepLogin"];
    
    if (firstLoad) // Si la aplicación estaba cerrada y se abre...
    {
        
        if (!keepLogin) // Si no se mantiene la sesión abierta...
        {
            if (self.presentedViewController != loginScreen)
            {
                [self presentViewController:loginScreen animated:NO completion:nil];
            }
        }
        else // La sesión se quiso mantener abierta, reiniciar sesión
        {
            [self keepSessionAlive];
        }
        
        // Marcar que la app está abierta (este valor se mantiene cuando está suspendida, pero no
        // cuando se cierra la app en la barra de multitasking)
        firstLoad = NO;
    }
    else // La aplicación estaba abierta, solo se vuelve a mostrar en primer plano
    {
        if (keepLogin) // Si se quiso mantener la sesión abierta, reiniciar sesión
        {
            [self keepSessionAlive];
        }
    
    }
}

- (void)applicationWillResign
{
    keepLogin = [prefs boolForKey:@"keepLogin"];
    
    if ( !keepLogin && [self presentedViewController] != loginScreen )
    {
        //[self cerrarSesion:NO];
    }
}


- (void)applicationDidBecomeActive
{
    keepLogin = [prefs boolForKey:@"keepLogin"];
    
    if (keepLogin)
    {
        [self keepSessionAlive];
        
        // Avisar a las subviews (del TabBar) que la aplicación ha vuelto a abrirse, así dejamos que implementen sus propios métodos para recargar información
        UINavigationController *navigationController = (UINavigationController *) self.selectedViewController;
        UIViewController *activeViewController = [navigationController visibleViewController];
        
        if ( [activeViewController respondsToSelector:@selector(didBecomeActive)] )
        {
            [activeViewController performSelector:@selector(didBecomeActive)];
        }
    }
}

- (void)keepSessionAlive
{
    NSString *username = [prefs objectForKey:@"username"];
    NSString *password = [prefs objectForKey:@"password"];
    
    conexion = [[INFODA_Conexion alloc] initWithUsername:username withPassword:password withDelegate:self success:@selector(comprobarConexion:) fail:@selector(conexionFallida:)];
}

- (void)comprobarConexion:(NSString *)response
{
    if (![response isEqualToString:@"YES"])
    {
        UIAlertView *errorConexion = [[UIAlertView alloc] initWithTitle:@"Error de conexión" message:@"Los datos almacenados son incorrectos. Inicia sesión nuevamente." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Cerrar", nil];
        
        [errorConexion show];
        [self cerrarSesion:YES];
    }
}

- (void)conexionFallida:(NSString *)error
{
    UIAlertView *errorConexion = [[UIAlertView alloc] initWithTitle:@"Error de conexión" message:@"Imposible conectar al servidor. Intenta más tarde." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Cerrar", nil];
    
    [errorConexion show];
    
    // Avisar a los ViewControllers presentados que hubo un error de conexión
    UINavigationController *navigationController = (UINavigationController *) self.selectedViewController;
    UIViewController *activeViewController = [navigationController visibleViewController];
    
    if ( [activeViewController respondsToSelector:@selector(noConnectionError:)] )
    {
        [activeViewController performSelector:@selector(noConnectionError:)
                                   withObject:@""];
    }
}

- (void)cerrarSesion:(BOOL)animated
{
    keepLogin = NO;
    
    if (animated) [prefs removeObjectForKey:@"username"];
    [prefs removeObjectForKey:@"password"];
    [prefs removeObjectForKey:@"keepLogin"];
    [prefs removeObjectForKey:@"last_time_refreshed"];
    [prefs removeObjectForKey:@"login_time"];
    [prefs removeObjectForKey:@"matricula"];
    [prefs synchronize];
    
    if (animated) loginScreen.usernameTextField.text = @"";
    loginScreen.passwordTextField.text = @"";
    loginScreen.keepLogin.on = YES;
    
    [self presentViewController:loginScreen animated:animated completion:nil];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Lo siguiente debería ser para internacionalización. Debería buscar otra forma de hacerlo que no dependa del orden específico de las tab.
    
    /*
    NSUInteger index = 0;
    for (UITabBarItem *item in self.tabBar.items)
    {
        
        switch(index)
        {
            case 0: // Calificaciones
                item.title = NSLocalizedString(@"TabBar_Calificaciones", nil);
                break;
            
            case 1: // Información curricular
                item.title = NSLocalizedString(@"TabBar_InformacionCurricular", nil);
                break;
            
            default:
                break;
        }
        
        index++;
    }
     */
}


/*
 * Habilitar rotación
 */

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    // Por defecto todas las orientaciones excepto teléfono invertido
    NSUInteger orientacion = UIInterfaceOrientationMaskAllButUpsideDown;
    return orientacion;
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
}
@end
