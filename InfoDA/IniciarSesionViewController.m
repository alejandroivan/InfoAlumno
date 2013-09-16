//
//  IniciarSesionViewController.m
//  InfoDA
//
//  Created by Alejandro Iván on 17-01-13.
//  Copyright (c) 2013 iOS Devel. All rights reserved.
//

#import "IniciarSesionViewController.h"
#import "MainViewController.h"

@interface IniciarSesionViewController ()
{
    NSUserDefaults *prefs;
}

@end

@implementation IniciarSesionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    prefs = [NSUserDefaults standardUserDefaults];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setUsernameTextField:nil];
    [self setPasswordTextField:nil];
    [self setKeepLogin:nil];
    [self setUsernameLabel:nil];
    [self setPasswordLabel:nil];
    [self setKeepLoginLabel:nil];
    [super viewDidUnload];
}


- (IBAction)iniciarSesionButton:(UIButton *)sender {
    UITextField *username = self.usernameTextField;
    UITextField *password = self.passwordTextField;
    
        if (password.text.length > 0 && username.text.length > 0)
        {
            [self iniciarSesionWithUsername:username.text withPassword:password.text];
        }
        else
        {
            [self resignFirstResponder];
            
            if (username.text.length == 0)
            {
                [password resignFirstResponder];
                [username becomeFirstResponder];
            }
            else
            {
                [username resignFirstResponder];
                [password becomeFirstResponder];
            }
        }
}

- (IBAction)iOSDevelButton:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://iosdevel.cl/"]];
}


// Detección de la tecla ENTER en los textfields
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UITextField *username = self.usernameTextField;
    UITextField *password = self.passwordTextField;
    
    [textField resignFirstResponder];
    
    if (textField == username)
    {
        if (password.text.length > 0)
        {
            [self iniciarSesionWithUsername:username.text withPassword:password.text];
        }
        else
        {
            [self resignFirstResponder];
            [password becomeFirstResponder];
        }

    }
    else if (textField == password)
    {
        if (username.text.length > 0)
        {
            [self iniciarSesionWithUsername:username.text withPassword:password.text];
        }
        else
        {
            [textField resignFirstResponder];
            [username becomeFirstResponder];
        }
    }
    
    return YES;
}

// Iniciar sesión utilizando los datos ingresados
- (void)iniciarSesionWithUsername:(NSString *)username withPassword:(NSString *)password
{
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    
    if ( self.usernameTextField.text.length > 0 && self.passwordTextField.text.length > 0)
    {
        self.conexion = [[INFODA_Conexion alloc] initWithUsername:username withPassword:password withDelegate:self success:@selector(conexionCorrecta:) fail:@selector(conexionErronea:)];
    }
    else
    {
        [self conexionErronea:@"Los datos de inicio de sesión son incorrectos."];
    }
}

// Se llega aquí con response siendo @"YES" o @"NO", indicando si el login fue correcto o no
- (void)conexionCorrecta:(NSString *)response
{
    if ( [response isEqualToString:@"YES"] ) // Login correcto
    {
        [prefs setBool:self.keepLogin.on forKey:@"keepLogin"];
        [prefs setObject:self.usernameTextField.text forKey:@"username"];
        [prefs setObject:self.passwordTextField.text forKey:@"password"];
        [prefs synchronize];

        [self allDataFetched];
    }
    else // Login incorrecto
    {
        [self conexionErronea:@"Los datos de inicio de sesión son incorrectos."];
    }
}


// Hubo un error al iniciar sesión, se muestra una alerta con el mensaje de error
- (void)conexionErronea:(NSString *)error
{
    UIAlertView *errorConexion = [[UIAlertView alloc] initWithTitle:@"Error de conexión" message:error delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Cerrar", nil];
    
    [errorConexion show];
}




// Al finalizar de obtener toda la información, se llama a este método
- (void)allDataFetched
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
 * Opciones de rotación
 */
- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

@end
