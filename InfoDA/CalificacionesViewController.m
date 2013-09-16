//
//  CalificacionesViewController.m
//  InfoAlumno
//
//  Created by Alejandro Iván on 21-01-13.
//  Copyright (c) 2013 iOS Devel. All rights reserved.
//

#import "CalificacionesViewController.h"
#import "CalificacionesAsignaturaCell.h"
#import "MainViewController.h"
#import "INFODA_Calificaciones.h"

@interface CalificacionesViewController ()

@end

@implementation CalificacionesViewController
{
    INFODA_Calificaciones *conexion_calificaciones;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self didBecomeActive];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)calificacionesObtenidas:(NSString *)response
{
//    NSLog(@"JSON: %@", response);
    NSData *jsonData = [response dataUsingEncoding:NSASCIIStringEncoding];
    self.calificaciones = [[NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil] copy];
    
    conexion_calificaciones = nil;
    [self allDataFetched];
}

- (void)calificacionesError:(NSString *)error
{
    self.calificaciones = nil;
    conexion_calificaciones = nil;

    [self allDataFetched];
}

- (void)allDataFetched
{
    [self.activityIndicator stopAnimating];
    [self.tableView reloadData];
}

- (void)noConnectionError:(NSString *)error
{
    [self calificacionesError:error];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {

    [[self tableView] setTableHeaderView:nil];
    [self setTableView:nil];
    
    [self setActivityIndicator:nil];
    [super viewDidUnload];
}







- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    return (self.calificaciones.count > 0) ? self.calificaciones.count : ( ![self.activityIndicator isAnimating] ? 1 : 0 );
    return (self.calificaciones.count > 0) ? self.calificaciones.count : 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AsignaturaCell";
    static NSString *EmptyCellIdentifier = @"AsignaturaEmptyCell";
    
    UITableViewCell *cell = nil;
    
    if ( [self.activityIndicator isAnimating] && self.calificaciones.count == 0 )
    {
        cell = [self.tableView dequeueReusableCellWithIdentifier:EmptyCellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EmptyCellIdentifier];
        }
        
        cell.textLabel.text = @"Cargando...";
    }
    else if ( self.calificaciones.count > 0 ) // Celda clásica de asignatura
    {
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        NSString *codigo = [[self.calificaciones allKeys] objectAtIndex:indexPath.row];
        NSString *nombre = [[self.calificaciones objectForKey:codigo] objectForKey:@"nombre"];
        
        
        ((CalificacionesAsignaturaCell *) cell).tituloLabel.text = nombre;
        ((CalificacionesAsignaturaCell *) cell).codigoLabel.text = codigo;
    }
    else // No hay asignaturas inscritas
    {
        cell = [self.tableView dequeueReusableCellWithIdentifier:EmptyCellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EmptyCellIdentifier];
        }
        
        cell.textLabel.text = @"No hay calificaciones ingresadas.";
    }
        
    return cell;
}

- (IBAction)cerrarSesion:(id)sender
{
    self.calificaciones = nil;
    [self.tableView reloadData];
    [self.navigationController.parentViewController performSelector:@selector(cerrarSesion:) withObject:[NSNumber numberWithBool:YES]];
}

- (void)didBecomeActive
{
    [self.activityIndicator startAnimating];
    [self.tableView reloadData];
    
    // Parsear información del JSON y armar el objeto
    conexion_calificaciones = [[INFODA_Calificaciones alloc] initWithDelegate:self success:@selector(calificacionesObtenidas:) fail:@selector(calificacionesError:)];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Pasar la información al view controller que aparecerá
    if ( [segue.identifier isEqualToString:@"DetalleCalificacionesSegue"] )
    {
        CalificacionesDetalleViewController *destino = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        UITableViewCell *celda = [self.tableView cellForRowAtIndexPath:indexPath];

        NSDictionary *notasDetalle = [self.calificaciones objectForKey:((CalificacionesAsignaturaCell *) celda).codigoLabel.text];
        
        if (notasDetalle)
        {
            [destino cargarDetalle:notasDetalle withCodigo:((CalificacionesAsignaturaCell *) celda).codigoLabel.text];
        }
    }
}
@end
