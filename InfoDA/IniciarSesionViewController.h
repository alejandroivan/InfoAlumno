//
//  IniciarSesionViewController.h
//  InfoDA
//
//  Created by Alejandro Iván on 17-01-13.
//  Copyright (c) 2013 iOS Devel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "MainViewController.h"
#import "INFODA_Conexion.h"
#import "INFODA_Calificaciones.h"

@interface IniciarSesionViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) MainViewController *mainViewController;

@property (strong, nonatomic) IBOutlet UITextField *usernameTextField;
@property (strong, nonatomic) IBOutlet UITextField *passwordTextField;
@property (strong, nonatomic) IBOutlet UISwitch *keepLogin;

@property (strong, nonatomic) INFODA_Conexion *conexion;
@property (strong, nonatomic) INFODA_Calificaciones *calificaciones_conexion;

@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *passwordLabel;
@property (strong, nonatomic) IBOutlet UILabel *keepLoginLabel;

- (IBAction)iniciarSesionButton:(UIButton *)sender;
- (IBAction)iOSDevelButton:(id)sender;
@end
