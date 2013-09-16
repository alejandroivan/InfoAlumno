//
//  INFODA_Curricular.h
//  InfoAlumno
//
//  Created by Alejandro Iván on 02-02-13.
//  Copyright (c) 2013 iOS Devel. All rights reserved.
//

/*
 * Se conecta al WebService para que éste obtenga la información curricular del alumno (para esto
 * se le envían el usuario, password, matrícula del alumno y el área -solo PREGRADO por ahora-, los
 * cuales se usan en el WebService para obtener la información, parsearla y devolver JSON).
 *
 * No se hizo de la misma manera que las otras clases INFODA_, puesto que hubo problemas con la llave
 * de encriptación en este caso, por temas de codificación de caracteres. En PHP, por alguna extraña
 * razón, no da problemas. Al parecer la llave es una mezcla de caracteres ASCII y UTF-8, pero no he
 * encontrado una forma de que se consideren los dos al mismo tiempo en Obj-C: Si elijo ASCII y aparece
 * UTF-8, la llave queda con referencia a nulo, lo mismo para UTF-8 con caracteres ASCII.
 *
 * initWithDelegate:success:fail:
 *
 * Delegate es el objeto que instanció la clase (puede ser otro, depende de la referencia entregada).
 * Success es el selector del método que recibirá el JSON.
 * Fail es el selector del método que se llamará en caso de error.
 */

#import <Foundation/Foundation.h>
#import "Conexion.h"

@interface INFODA_Curricular : Conexion

@property (strong, nonatomic) NSString *matricula;
@property (strong, nonatomic) NSString *programa;
@property (strong, nonatomic) NSString *llaveEncriptacion;
@end
