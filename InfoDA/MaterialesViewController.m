//
//  MaterialesViewController.m
//  InfoAlumno
//
//  Created by Alejandro Iván on 11-05-13.
//  Copyright (c) 2013 iOS Devel. All rights reserved.
//

#import "MaterialesViewController.h"
#import "MaterialesCell.h"

#import "INFODA_Materiales.h"
#import "FileDownloader.h"

@interface MaterialesViewController ()
{
    NSArray *_products;
}

@property (strong, nonatomic) UIDocumentInteractionController *interactionController;

@end

@implementation MaterialesViewController
{
    INFODA_Materiales *conexion_materiales;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        
        self.descargas = [[NSMutableArray alloc] init];
        
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

- (IBAction)cerrarSesion:(id)sender
{
    self.materiales = nil;
    [self.tableView reloadData];
    
    [self.navigationController.parentViewController performSelector:@selector(cerrarSesion:) withObject:[NSNumber numberWithBool:YES]];
}

- (void)didBecomeActive
{
    [self.activityIndicator startAnimating];
    [self.tableView reloadData];
    
    // Parsear información del JSON y armar el objeto
    conexion_materiales = [[INFODA_Materiales alloc] initWithDelegate:self success:@selector(materialesObtenidos:) fail:@selector(materialesError:)];
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
}



- (void)materialesObtenidos:(NSString *)response
{
    //NSLog(@"%@", response);

    NSData *jsonData = [response dataUsingEncoding:NSASCIIStringEncoding];
    id json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
    
    if ( [json isKindOfClass:[NSArray class]] ) // Respuesta es array
    {
        NSArray *jsonArray = (NSArray *)json;
        if ( jsonArray.count > 0 ) self.materiales = [json copy];
    }
    else if ( [json isKindOfClass:[NSDictionary class]] )
    {
        NSDictionary *jsonDict = (NSDictionary *)json;
        
        if ( [jsonDict objectForKey:@"error"] )
        {
            self.materiales = nil;
            [self materialesError:[jsonDict objectForKey:@"error"]];
        }
    }
    
    conexion_materiales = nil;
    [self allDataFetched];
}



- (void)materialesError:(NSString *)error
{
    UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"Cerrar" otherButtonTitles:@"App Store", nil];
    alerta.delegate = self;
    [alerta show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ( buttonIndex == 1 ) // Ir a la App Store
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.com/apps/InfoAlumno"]];
    }
}

- (void)allDataFetched
{
    [self.activityIndicator stopAnimating];
    [self.tableView reloadData];
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    unsigned int total_secciones = self.materiales.count;
    return total_secciones > 0 ? total_secciones : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    unsigned int total_secciones = self.materiales.count;
    
    unsigned int total_celdas = total_secciones > 0 ? [[[self.materiales objectAtIndex:section] objectForKey:@"materiales"] count] : 0;
    
    return (total_celdas > 0) ? total_celdas : 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *nombre = [[self.materiales objectAtIndex:section] objectForKey:@"nombre"];
    return nombre;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MaterialCell";
    static NSString *EmptyCellIdentifier = @"MaterialEmptyCell";
    
    UITableViewCell *cell = nil;
    NSString *estado;
    
    if ( conexion_materiales && self.materiales.count == 0 )
    {
        cell = [self.tableView dequeueReusableCellWithIdentifier:EmptyCellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EmptyCellIdentifier];
        }
        
        cell.textLabel.text = @"Cargando...";
    }
    else if ( self.materiales.count > 0 && [[[self.materiales objectAtIndex:indexPath.section] objectForKey:@"materiales"] count] > 0 )
    {
        cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        NSDictionary *material = [[[self.materiales objectAtIndex:indexPath.section] objectForKey:@"materiales"] objectAtIndex:indexPath.row];
        NSString *titulo = [material objectForKey:@"nombre_archivo"];
        

        // Comprobar si el material se está descargando o no
        BOOL descargando = NO;
        for (NSString *id_material in self.descargas)
        {
            if ( [id_material isEqualToString:[material objectForKey:@"id_material"]] )
            {
                descargando = YES;
                break;
            }
        }
        
        
        
        if (descargando) // Archivo actualmente en descarga
        {
            estado = @"Descargando...";
            
            [((MaterialesCell *) cell).activityIndicator startAnimating];
            [((MaterialesCell *) cell).imagenDescarga setHidden:YES];
            [((MaterialesCell *) cell).imagenCheck setHidden:YES];
            
        }
        else // Archivo no descargando actualmente, verificar otros estados
        {
            
            // Comprobar si el archivo ya ha sido descargado
            BOOL file_exists = NO;
            
            NSString *username_profesor = [material objectForKey:@"username_profesor"];
            NSString *nombre_archivo_destino = [NSString stringWithFormat:@"%@ - %@", username_profesor, titulo];
            
            NSString *documentsPath = [ NSHomeDirectory() stringByAppendingPathComponent:@"Documents" ];
            
            NSString *ruta_destino = [documentsPath stringByAppendingPathComponent:nombre_archivo_destino];
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            file_exists = [fileManager fileExistsAtPath:ruta_destino];
            
            
            // Setear estado de la celda
            estado = [NSString stringWithFormat:@"Publicado por %@", username_profesor];
            
            if (!file_exists) // Si el archivo no ha sido descargado
            {
                [((MaterialesCell *) cell).activityIndicator stopAnimating];
                [((MaterialesCell *) cell).imagenDescarga setHidden:NO];
                [((MaterialesCell *) cell).imagenCheck setHidden:YES];
            }
            else // Archivo ya descargado
            {
                [((MaterialesCell *) cell).activityIndicator stopAnimating];
                [((MaterialesCell *) cell).imagenDescarga setHidden:YES];
                [((MaterialesCell *) cell).imagenCheck setHidden:NO];
            }
            
        }
        
        // Setear estado y título del material
        ((MaterialesCell *) cell).titulo.text = titulo;
        ((MaterialesCell *) cell).subtitulo.text = estado;
        
        // Pasar información del material a la celda para que lo almacene
        ((MaterialesCell *) cell).material = material;
    }
    else
    {
        cell = [self.tableView dequeueReusableCellWithIdentifier:EmptyCellIdentifier];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:EmptyCellIdentifier];
        }
        
        cell.textLabel.text = @"No hay materiales publicados.";

    }

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MaterialesCell *celda = (MaterialesCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *material = celda.material;
    
    
    
    // Comprobar si el archivo ya se está descargando.
    BOOL descargando = NO;
    BOOL file_exists = NO;
    
    for (NSString *id_mat in self.descargas)
    {
        if ( [id_mat isEqualToString:[material objectForKey:@"id_material"]] )
        {
            descargando = YES;
            break;
        }
    }
    
    // Comprobar si el archivo ya existe (solo si no se está descargando).
    if (!descargando)
    {
        // Comprobar si el archivo ya ha sido descargado
        NSString *username_profesor = [material objectForKey:@"username_profesor"];
        NSString *titulo = [material objectForKey:@"nombre_archivo"];
        NSString *nombre_archivo_destino = [NSString stringWithFormat:@"%@ - %@", username_profesor, titulo];
        
        NSString *documentsPath = [ NSHomeDirectory() stringByAppendingPathComponent:@"Documents" ];
        
        NSString *ruta_destino = [documentsPath stringByAppendingPathComponent:nombre_archivo_destino];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        file_exists = [fileManager fileExistsAtPath:ruta_destino];
    }
    
    
    if (!descargando && !file_exists) // Si no existe archivo y no se está descargando, descargarlo.
    {
        // Obtener ID del material, username del profesor y nombre del archivo original
        NSString *id_material = [material objectForKey:@"id_material"];
        NSString *username_profesor = [material objectForKey:@"username_profesor"];
        NSString *nombre_archivo = [material objectForKey:@"nombre_archivo"];
        
        // Obtener username/password del usuario
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *username = [prefs objectForKey:@"username"];
        NSString *password = [prefs objectForKey:@"password"];
        
        
        // Setear descarga
        NSString *archivo_final = [NSString stringWithFormat:@"%@ - %@", username_profesor, nombre_archivo];
        
        FileDownloader *dl = [[FileDownloader alloc] initWithMaterial:id_material withUsername:username withPassword:password withProfesor:username_profesor];
        
        
        [self.descargas addObject:id_material];
        dl.id_material = id_material;
        dl.material = material;
        
        [celda.imagenDescarga setHidden:YES];
        [celda.activityIndicator startAnimating];
        celda.subtitulo.text = @"Descargando...";
        
        [dl setDestinationFile:archivo_final];
        [self performSelectorInBackground:@selector(descargarArchivo:) withObject:dl];
    }
    else if (file_exists) // Archivo existe, abrirlo.
    {
        //NSLog(@"Abriendo archivo: %@", [material objectForKey:@"nombre_archivo"] );
        
        // Obtener ID del material, username del profesor y nombre del archivo original
        NSString *username_profesor = [material objectForKey:@"username_profesor"];
        NSString *nombre_archivo = [material objectForKey:@"nombre_archivo"];
        
        // Setear ruta del archivo
        NSString *archivo_final = [NSString stringWithFormat:@"%@ - %@", username_profesor, nombre_archivo];
        NSString *documentsPath = [ NSHomeDirectory() stringByAppendingPathComponent:@"Documents" ];
        NSString *ruta_destino = [documentsPath stringByAppendingPathComponent:archivo_final];
        
        
        NSURL *fileURL = [NSURL fileURLWithPath:ruta_destino];
        
        self.interactionController = [UIDocumentInteractionController interactionControllerWithURL:fileURL];
        self.interactionController.delegate = self;
        
        BOOL archivoAbierto = [self.interactionController presentPreviewAnimated:YES];
        
        if ( !archivoAbierto )
        {
            BOOL abrirEn = [self.interactionController presentOpenInMenuFromRect:CGRectMake(0, 0, 0, 0) inView:self.view animated:YES];
            
            if ( !abrirEn )
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Archivo incompatible" message:@"No hay visores compatibles para este formato de archivo." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Cerrar", nil];
                [alertView show];
            }
        }
    }
    
}

- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self.navigationController;
}


- (void)descargarArchivo:(FileDownloader *)dl
{
    [dl downloadFileWithDelegate:self withSuccess:@selector(downloadSuccess:) withFailure:@selector(downloadError:)];
}

- (void)downloadSuccess:(NSDictionary *)material
{
    NSString *id_material = [material objectForKey:@"id_material"];
    [self.descargas removeObject:id_material];
    [self.tableView reloadData];
}

- (void)downloadError:(NSDictionary *)material
{
    NSString *mensaje = [NSString stringWithFormat:@"Error al descargar el archivo %@", [material objectForKey:@"nombre_archivo"]];
    
    UIAlertView *alerta = [[UIAlertView alloc] initWithTitle:@"Error al descargar" message:mensaje delegate:self cancelButtonTitle:@"Cerrar" otherButtonTitles:nil];
    [alerta show];
    
    [self.descargas removeObject:[material objectForKey:@"id_material"]];
    [self.tableView reloadData];
}


- (void)viewDidUnload {
    [self setMateriales:nil];
    [self setDescargas:nil];

    [[self tableView] setTableHeaderView:nil];
    [self setTableView:nil];
    
    [self setActivityIndicator:nil];
    [super viewDidUnload];
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    MaterialesCell *cell = (MaterialesCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *material = cell.material;
    
    
    // Eliminar el archivo
    // Comprobar si el archivo ya ha sido descargado
    NSString *username_profesor = [material objectForKey:@"username_profesor"];
    NSString *titulo = [material objectForKey:@"nombre_archivo"];
    NSString *nombre_archivo_destino = [NSString stringWithFormat:@"%@ - %@", username_profesor, titulo];
    
    NSString *documentsPath = [ NSHomeDirectory() stringByAppendingPathComponent:@"Documents" ];
    
    NSString *ruta_destino = [documentsPath stringByAppendingPathComponent:nombre_archivo_destino];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ( [fileManager fileExistsAtPath:ruta_destino] )
    {
        [fileManager removeItemAtPath:ruta_destino error:nil]; // Eliminar   
    }
    
    // Refrescar celda
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MaterialesCell *cell = (MaterialesCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *material = cell.material;
    NSString *id_material = [material objectForKey:@"id_material"];
    
    // Revisar si está descargando
    BOOL descargando = NO;
    BOOL file_exists = NO;
    
    for (NSString *id_mat in self.descargas)
    {
        if ( [id_mat isEqualToString:id_material] )
        {
            descargando = YES;
            break;
        }
    }
    
    if (!descargando) // Si no está descargando, revisar si el archivo existe
    {
        NSString *username_profesor = [material objectForKey:@"username_profesor"];
        NSString *titulo = [material objectForKey:@"nombre_archivo"];
        NSString *nombre_archivo_destino = [NSString stringWithFormat:@"%@ - %@", username_profesor, titulo];
        
        NSString *documentsPath = [ NSHomeDirectory() stringByAppendingPathComponent:@"Documents" ];
        
        NSString *ruta_destino = [documentsPath stringByAppendingPathComponent:nombre_archivo_destino];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        file_exists = [fileManager fileExistsAtPath:ruta_destino];
    }
    
    // Retornar el botón "Eliminar" solo si ha terminado de descargar y archivo existe
    return !file_exists || descargando ? UITableViewCellEditingStyleNone : UITableViewCellEditingStyleDelete;
}

@end
