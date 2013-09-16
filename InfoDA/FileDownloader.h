//
//  FileDownloader.h
//  InfoAlumno
//
//  Created by Alejandro Iván on 10-06-13.
//  Copyright (c) 2013 iOS Devel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileDownloader : NSObject

@property (weak, nonatomic) NSString *id_material;
@property (strong, nonatomic) NSDictionary *material;

- (id)initWithMaterial:(NSString *)id_material withUsername:(NSString *)username withPassword:(NSString *)password withProfesor:(NSString *)username_profesor;

- (void)setDestinationFile:(NSString *)filepath;
- (void)downloadFileWithDelegate:(id)delegate withSuccess:(SEL)success withFailure:(SEL)failure;
@end
