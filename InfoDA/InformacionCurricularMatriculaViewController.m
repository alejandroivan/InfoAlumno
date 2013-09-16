//
//  InformacionCurricularMatriculaViewController.m
//  InfoAlumno
//
//  Created by Alejandro Iván on 10-04-13.
//  Copyright (c) 2013 iOS Devel. All rights reserved.
//

#import "InformacionCurricularMatriculaViewController.h"

@interface InformacionCurricularMatriculaViewController ()

@end

@implementation InformacionCurricularMatriculaViewController

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
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateRecognized)
    {
        [self.matriculaTextField resignFirstResponder];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    self.matriculaTextField.text = @"";
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *matricula = [prefs objectForKey:@"matricula"];
    
    if ( matricula && [matricula length] > 0 )
    {
        self.matriculaTextField.text = matricula;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setMatriculaTextField:nil];
    [self setButtonConfirmarMatricula:nil];
    [super viewDidUnload];
}

- (IBAction)confirmarMatricula:(UIButton *)sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setValue:self.matriculaTextField.text forKey:@"matricula"];
    [prefs synchronize];
    
    [self.matriculaTextField resignFirstResponder];
    [self performSegueWithIdentifier:@"ICMatricula" sender:sender];
}

- (IBAction)cerrarSesion:(id)sender {
    [self.navigationController.parentViewController performSelector:@selector(cerrarSesion:) withObject:[NSNumber numberWithBool:YES]];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

@end
