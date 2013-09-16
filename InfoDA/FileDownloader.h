//
//  FileDownloader.h
//  InfoAlumno
//
//  Created by Alejandro Iván on 10-06-13.
//  Copyright (c) 2013 iOS Devel. All rights reserved.
//


/*
 * Esta clase permite la descarga de archivos desde InfoAlumno, utilizando un script
 * del WebService como pasarela. El WebService inicia sesión con los datos suministrados,
 * genera el link correspondiente (usando la clave de encriptación que entrega InfoAlumno)
 * y redirige al archivo correspondiente. Luego esta clase obtiene la información de tal
 * archivo y la almacena en el directorio de Documentos.
 *
 * Primero debe instanciarse el objeto (initWithMaterial:withUsername:withPassword:withProfesor:),
 * luego setear la ruta destino (entregar el nombre del archivo a setDestinationFile:, él solo genera
 * el path correspondiente en el directorio de Documentos) y luego iniciar la descarga utilizando
 * downloadFileWithDelegate:withSuccess:withFailure:.
 *
 * En este último método, el delegate es la clase que llamó la descarga, success es el selector del
 * método que obtendrá respuesta correcta y failure el método que obtendrá respuesta de error.
 *
 * Además debe entregársele el puntero al diccionario con la información del material a descargar,
 * el que se utiliza en MaterialesViewController).
 */

#import <Foundation/Foundation.h>

@interface FileDownloader : NSObject

@property (weak, nonatomic) NSString *id_material;
@property (strong, nonatomic) NSDictionary *material;

- (id)initWithMaterial:(NSString *)id_material withUsername:(NSString *)username withPassword:(NSString *)password withProfesor:(NSString *)username_profesor;

- (void)setDestinationFile:(NSString *)filepath;
- (void)downloadFileWithDelegate:(id)delegate withSuccess:(SEL)success withFailure:(SEL)failure;
@end
