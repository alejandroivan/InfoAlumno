//
//  CalificacionesDetalleViewController.m
//  InfoAlumno
//
//  Created by Alejandro Iván on 31-03-13.
//  Copyright (c) 2013 iOS Devel. All rights reserved.
//

#import "CalificacionesDetalleViewController.h"

@interface CalificacionesDetalleViewController ()

@end

@implementation CalificacionesDetalleViewController

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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.title = [self.detalleAsignatura objectForKey:@"nombre"];
    
    self.Label_codigoAsignatura.text = self.codigoAsignatura;
    self.Label_nombreAsignatura.text = [self.detalleAsignatura objectForKey:@"nombre"];
    self.Label_docenteAsignatura.text = [self.detalleAsignatura objectForKey:@"docente"];
    
    // Evaluación de Recuperación
    id temp_evRec = [self.detalleAsignatura objectForKey:@"evaluacion_recuperacion"];
    
    if ( [temp_evRec isKindOfClass:[NSDictionary class]] )
    {
        NSDictionary *evRec = temp_evRec;
        NSString *notaEvRec = [evRec objectForKey:@"nota"];
        NSString *fechaEvRec = [evRec objectForKey:@"fecha"];
        
        notaEvRec = [notaEvRec isEqualToString:@"0"] ? @"Sin nota" : notaEvRec;
        fechaEvRec = [fechaEvRec isEqualToString:@""] ? @"No ingresada" : fechaEvRec;
        
        self.Label_evaluacionRecuperacionAsignatura.text = notaEvRec;
        self.Label_fechaEvaluacionRecuperacionAsignatura.text = fechaEvRec;

    }
    else
    {
        self.Label_evaluacionRecuperacionAsignatura.text = @"Sin nota";
        self.Label_fechaEvaluacionRecuperacionAsignatura.text = @"No ingresada";
    }
    
        
    // Evaluación Final
    NSString *notaFinal = [self.detalleAsignatura objectForKey:@"evaluacion_final"];

    if ( [notaFinal isEqualToString:@"0"] || notaFinal.length == 0 )
    {
        notaFinal = @"No ingresada";
    }
    else
    {
        float nota = [notaFinal floatValue];
        
        if (nota >= 4.0) // Aprobada
        {
            notaFinal = [NSString stringWithFormat:@"%@ (%@)", notaFinal, @"APROBADA"];
            self.Label_notaFinalAsignatura.textColor = [UIColor colorWithRed:(0/255.0) green:(100/255.0) blue:(0/255.0) alpha:1];
        }
        else // Reprobada
        {
            notaFinal = [NSString stringWithFormat:@"%@ (%@)", notaFinal, @"REPROBADA"];
            self.Label_notaFinalAsignatura.textColor = [UIColor redColor];
        }
    }
    
    self.Label_notaFinalAsignatura.text = notaFinal;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cargarDetalle:(NSDictionary *)asignatura withCodigo:(NSString *)codigo
{
    self.detalleAsignatura = asignatura;
    self.codigoAsignatura = codigo;
}

- (void)viewDidUnload {
    [self setLabel_codigoAsignatura:nil];
    [self setLabel_nombreAsignatura:nil];
    [self setLabel_docenteAsignatura:nil];
    [self setLabel_evaluacionRecuperacionAsignatura:nil];
    [self setLabel_notaFinalAsignatura:nil];
    [self setLabel_fechaEvaluacionRecuperacionAsignatura:nil];
    [self setTableView:nil];
    [super viewDidUnload];
}










- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id calificaciones = [self.detalleAsignatura objectForKey:@"calificaciones"];
    unsigned int count = 1;
    
    if ( [calificaciones isKindOfClass:[NSDictionary class]] )
    {
        count = [(NSDictionary *)calificaciones count];
    }
    else if ( [ calificaciones isKindOfClass:[NSArray class]] )
    {
        count = [(NSArray *) calificaciones count];
    }

    return count == 0 ? 1 : count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NotaDetalleAsignatura";
    static NSString *EmptyCellIdentifier = @"SinNotaDetalleAsignatura";
    
    UITableViewCell *cell = nil;
    
    id calificaciones = [self.detalleAsignatura objectForKey:@"calificaciones"];

    if ( [calificaciones isKindOfClass:[NSArray class]] && [calificaciones count] > 0 ) // Notas ingresadas
    {
        NSArray *notas = calificaciones;
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        
        NSDictionary *notaDetail = [notas objectAtIndex:indexPath.row];
        
        NSString *titulo = [notaDetail objectForKey:@"titulo"];
        NSString *nota = [notaDetail objectForKey:@"nota"];
        
        cell.textLabel.text = titulo;
        cell.detailTextLabel.text = nota;
        
        /*
         * Setear color de la nota
         */
        if ( [nota floatValue] < 4.0 ) // Reprobada
        {
            cell.detailTextLabel.textColor = [UIColor redColor]; // Rojo
        }
        else if ( [nota floatValue] >= 4.0 ) // Aprobada
        {
            cell.detailTextLabel.textColor = [UIColor colorWithRed:(0/255.0) green:(100/255.0) blue:(0/255.0) alpha:1]; // Verde
        }
        else // Otros casos
        {
            if ( [nota isEqualToString:@"NCR"] ) // Reprobada
            {
                cell.detailTextLabel.textColor = [UIColor redColor];
            }
            else if ( [nota isEqualToString:@"PEN"] ) // Pendiente
            {
                cell.detailTextLabel.textColor = [UIColor colorWithRed:(255/255.0) green:(140/255.0) blue:(0/255.0) alpha:1]; // Naranjo
            }
            
            // Si no cumple cualquier caso, es especial y no se le asigna color
        }
        
    }
    else // Sin notas
    {
        cell = [self.tableView dequeueReusableCellWithIdentifier:EmptyCellIdentifier];
        
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EmptyCellIdentifier];
        }
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Calificaciones parciales";
}


@end
