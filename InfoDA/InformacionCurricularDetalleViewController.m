//
//  InformacionCurricularDetalleViewController.m
//  InfoAlumno
//
//  Created by Alejandro Iván on 06-02-13.
//  Copyright (c) 2013 iOS Devel. All rights reserved.
//

#import "InformacionCurricularDetalleViewController.h"

@interface InformacionCurricularDetalleViewController ()

@end

@implementation InformacionCurricularDetalleViewController

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
}

- (void)viewWillAppear:(BOOL)animated
{
    if (self.asignatura)
    {
        self.Label_NombreAsignatura.text = [self.asignatura objectForKey:@"nombre"];
        self.Label_CodigoAsignatura.text = [self.asignatura objectForKey:@"codigo"];
        self.Label_PeriodoAsignatura.text = [self.asignatura objectForKey:@"periodo"];
        self.Label_CreditosAsignatura.text = [NSString stringWithFormat:@"%@", [self.asignatura objectForKey:@"creditos"]];
        self.Label_NotaAsignatura.text = [NSString stringWithFormat:@"%@", [self.asignatura objectForKey:@"nota"]];

        
        NSString *estado = [self.asignatura objectForKey:@"estado"];
        self.Label_EstadoAsignatura.text = estado;
        
        if ([estado isEqualToString:@"APROBADA"] || [estado isEqualToString:@"CONVALIDADA"])
        {
            self.Label_EstadoAsignatura.textColor = [UIColor colorWithRed:(0/255.0) green:(100/255.0) blue:(0/255.0) alpha:1];
        }
        else if ([estado isEqualToString:@"REPROBADA"])
        {
            self.Label_EstadoAsignatura.textColor = [UIColor redColor];
        }
        else // Pendiente
        {
            self.Label_EstadoAsignatura.textColor = [UIColor colorWithRed:(255/255.0) green:(140/255.0) blue:(0/255.0) alpha:1];
        }
        
       /* NSLog(@"Período: %@", [self.asignatura objectForKey:@"periodo"]);
        NSLog(@"Código: %@", [self.asignatura objectForKey:@"codigo"]);
        NSLog(@"Nombre: %@", [self.asignatura objectForKey:@"nombre"]);
        NSLog(@"Créditos: %@", [self.asignatura objectForKey:@"creditos"]);
        NSLog(@"Nota: %@", [self.asignatura objectForKey:@"nota"]);
        NSLog(@"Estado: %@", [self.asignatura objectForKey:@"estado"]);*/
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)cargarDetalle:(NSDictionary *)asignatura
{
    self.asignatura = asignatura;
    self.title = [self.asignatura objectForKey:@"nombre"];
}

- (void)viewDidUnload {
    [self setLabel_NombreAsignatura:nil];
    [self setLabel_CreditosAsignatura:nil];
    [self setLabel_CodigoAsignatura:nil];
    [self setLabel_PeriodoAsignatura:nil];
    [self setLabel_NotaAsignatura:nil];
    [self setLabel_EstadoAsignatura:nil];
    [super viewDidUnload];
}

@end
