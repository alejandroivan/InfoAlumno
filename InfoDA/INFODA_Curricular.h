//
//  INFODA_Curricular.h
//  InfoAlumno
//
//  Created by Alejandro Iván on 02-02-13.
//  Copyright (c) 2013 iOS Devel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Conexion.h"

@interface INFODA_Curricular : Conexion

@property (strong, nonatomic) NSString *matricula;
@property (strong, nonatomic) NSString *programa;
@property (strong, nonatomic) NSString *llaveEncriptacion;
@end
