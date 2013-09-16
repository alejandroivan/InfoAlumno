//
//  InformacionCurricularMatriculaViewController.h
//  InfoAlumno
//
//  Created by Alejandro Iván on 10-04-13.
//  Copyright (c) 2013 iOS Devel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InformacionCurricularMatriculaViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *matriculaTextField;
@property (strong, nonatomic) IBOutlet UIButton *buttonConfirmarMatricula;

- (IBAction)confirmarMatricula:(UIButton *)sender;
- (IBAction)cerrarSesion:(id)sender;

@end
