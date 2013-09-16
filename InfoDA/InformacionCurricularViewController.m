//
//  InformacionCurricularViewController.m
//  InfoAlumno
//
//  Created by Alejandro Iván on 20-01-13.
//  Copyright (c) 2013 iOS Devel. All rights reserved.
//

#import "InformacionCurricularViewController.h"
#import "InformacionCurricularDetalleViewController.h"
#import "IniciarSesionViewController.h"

#import "Conexion.h"
#import "INFODA_Conexion.h"
#import "INFODA_Curricular.h"

@interface InformacionCurricularViewController ()
{
    INFODA_Curricular *conn;
    IniciarSesionViewController *loginScreen;
}

@end

@implementation InformacionCurricularViewController

@synthesize informacionCurricular = _informacionCurricular, asignaturas = _asignaturas;

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

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setTotalAsignaturas:nil];
    [self setPromedioPonderado:nil];
    [self setCreditosAprobados:nil];
    [self setCreditosReprobados:nil];
    [self setCarrera:nil];
    [self setSituacionActual:nil];
    [self setActivityIndicator:nil];
    [self setInformacionCurricular:nil];
    [self setAsignaturas:nil];
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self didBecomeActive];
}











- (void)informacionCurricularObtenida:(NSString *)response
{
    NSString *nullResponse = @"{\"carrera\":null,\"situacion_actual\":\"\",\"promedio_ponderado\":0,\"creditos_aprobados\":0,\"creditos_reprobados\":0,\"asignaturas\":[],\"total_asignaturas\":0}";
    
    if ( [response isEqualToString:nullResponse] )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Matrícula incorrecta" message:@"La matrícula ingresada no es correcta." delegate:self cancelButtonTitle:@"Cerrar" otherButtonTitles:nil];
        [alert show];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs removeObjectForKey:@"matricula"];
        [prefs synchronize];

        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];
        self.informacionCurricular = [[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil] copy];
        self.asignaturas = [self.informacionCurricular objectForKey:@"asignaturas"];
    
        // Obtener información relevante
        NSString *carreraString = [self.informacionCurricular objectForKey:@"carrera"];
        NSString *situacionActual = [self.informacionCurricular objectForKey:@"situacion_actual"];

        NSNumber *promedioPonderado = [self.informacionCurricular objectForKey:@"promedio_ponderado"];
        NSNumber *creditosAprobados = [self.informacionCurricular objectForKey:@"creditos_aprobados"];
        NSNumber *creditosReprobados = [self.informacionCurricular objectForKey:@"creditos_reprobados"];
        NSNumber *totalAsignaturas = [self.informacionCurricular objectForKey:@"total_asignaturas"];
    
        // Formatear números
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setMaximumFractionDigits:1];
        [numberFormatter setMinimumFractionDigits:1];
    
    
        // Llenar información en la vista
        self.totalAsignaturas.text = [NSString stringWithFormat:@"%u", [totalAsignaturas integerValue]];
        self.promedioPonderado.text = [numberFormatter stringFromNumber:promedioPonderado];
        self.creditosAprobados.text = [NSString stringWithFormat:@"%d", [creditosAprobados integerValue]];
        self.creditosReprobados.text = [NSString stringWithFormat:@"%d", [creditosReprobados integerValue]];
        self.carrera.text = carreraString;
        self.situacionActual.text = situacionActual;
    
        [self.tableView reloadData];
        [self.activityIndicator stopAnimating];
    }
}










- (IBAction)cerrarSesion:(id)sender
{
    [self.navigationController.parentViewController performSelector:@selector(cerrarSesion:) withObject:[NSNumber numberWithBool:YES]];
    [self.navigationController popToRootViewControllerAnimated:NO];
}









- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (self.asignaturas.count > 0) ? self.asignaturas.count : 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CurricularCell";
    static NSString *CargandoCellIdentifier = @"CargandoCell";
    static NSString *EmptyCellIdentifier = @"CurricularEmptyCell";
    
    UITableViewCell *cell = nil;
    
    if ( self.asignaturas.count > 0 ) // Celda clásica
    {
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        NSDictionary *asignatura = [self.asignaturas objectAtIndex:indexPath.row];
        
        NSString *codigo = [asignatura objectForKey:@"codigo"];
        NSString *nombre = [asignatura objectForKey:@"nombre"];
        NSString *estado = [asignatura objectForKey:@"estado"];
        
        cell.textLabel.text = nombre;
        cell.detailTextLabel.text = codigo;
        
        cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", estado]];
    }
    else if ( [self.activityIndicator isAnimating] ) // No se obtuvo asignaturas
    {
        cell = [self.tableView dequeueReusableCellWithIdentifier:CargandoCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CargandoCellIdentifier];
        }
    }
    else // Cargando asignaturas
    {
        cell = [self.tableView dequeueReusableCellWithIdentifier:EmptyCellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EmptyCellIdentifier];
        }
    }
    
    return cell;
}









- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Pasar la información al view controller que aparecerá
    if ( [segue.identifier isEqualToString:@"DetalleCurricularSegue"] )
    {
        InformacionCurricularDetalleViewController *destino = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        [destino cargarDetalle:[self.asignaturas objectAtIndex:indexPath.row]];
    }
}


- (void)didBecomeActive
{
    // Pedir datos al WebService
    [self.activityIndicator startAnimating];
    conn = [[INFODA_Curricular alloc] initWithDelegate:self success:@selector(informacionCurricularObtenida:) fail:nil];
    
    [self.tableView reloadData];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
}

@end
