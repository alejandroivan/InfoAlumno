//
//  INFODA_Calificaciones.h
//  InfoAlumno
//
//  Created by Alejandro Iván on 21-01-13.
//  Copyright (c) 2013 iOS Devel. All rights reserved.
//

/*
 * Esta clase obtiene el HTML de las calificaciones desde InfoAlumno, para luego enviarlo
 * al WebService para que lo parsee y éste devuelve un JSON, el cual se entrega al delegate.
 *
 * Se utilizó este esquema para que sea el propio teléfono quien accede a esta sección de InfoAlumno,
 * dejando el WebService solo para parsear. Así se evitará que se banee la IP del WebService por
 * exceso de peticiones al servidor, como ocurre con otras app.
 *
 * initWithDelegate:success:fail:
 *
 * Delegate es el objeto que instanció la clase (puede ser otro, depende de la referencia entregada).
 * Success es el selector del método que recibirá el JSON.
 * Fail es el selector del método que se llamará en caso de error.
 */


#import "Conexion.h"

@interface INFODA_Calificaciones : Conexion

@end
