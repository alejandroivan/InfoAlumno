//
//  FileDownloader.m
//  InfoAlumno
//
//  Created by Alejandro Iván on 10-06-13.
//  Copyright (c) 2013 iOS Devel. All rights reserved.
//

#import "FileDownloader.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"


@interface FileDownloader ()

@property (strong, nonatomic) NSString *urlDescarga;

@property (strong, nonatomic) NSFileManager *fileManager;
@property (strong, nonatomic) NSString *documentsPath;
@property (strong, nonatomic) NSString *destinationFilePath;

@end

@implementation FileDownloader
{
    BOOL isDownloading;
}

- (id)initWithMaterial:(NSString *)id_material withUsername:(NSString *)username withPassword:(NSString *)password withProfesor:(NSString *)username_profesor
{
    self = [super init];
    
    if (self)
    {
        // Valores iniciales de estado
        isDownloading = NO;
        self.fileManager = [NSFileManager defaultManager];
        
        
        
        // Obtener información del directorio destino
        self.documentsPath = [ NSHomeDirectory() stringByAppendingPathComponent:@"Documents" ];
        
        
        // Generar link de descarga
        self.urlDescarga = [NSString stringWithFormat:@"http://infoalumno.iosdevel.cl/materiales_encriptacion.php?username=%@&password=%@&username_profesor=%@&id_material=%@", username, password, username_profesor, id_material];
        
        self.id_material = id_material;
    }
    
    return self;
}

- (void)setDestinationFile:(NSString *)filepath
{
    self.destinationFilePath = [self.documentsPath stringByAppendingPathComponent:filepath];
}

- (void)downloadFileWithDelegate:(id)_delegate withSuccess:(SEL)_success withFailure:(SEL)_failure
{
    NSData *urlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.urlDescarga]];
    
    if (urlData)
    {
        [self.fileManager createFileAtPath:self.destinationFilePath contents:urlData attributes:nil];
        
        if ( [ _delegate respondsToSelector:_success ] )
        {
            [_delegate performSelector:_success withObject:self.material];
        }
        else if ( [ _delegate respondsToSelector:_failure ] )
        {
            [_delegate performSelector:_failure withObject:self.material];
        }
        else
        {
            NSLog(@"File download delegate doesn't respond to selector sent.");
        }
    }
    
}

@end

#pragma clang diagnostic pop