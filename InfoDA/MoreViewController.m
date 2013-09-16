//
//  MoreViewController.m
//  InfoAlumno
//
//  Created by Alejandro Iván on 24-04-13.
//  Copyright (c) 2013 iOS Devel. All rights reserved.
//

#import "MoreViewController.h"

@interface MoreViewController ()

@end

@implementation MoreViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    [super viewDidUnload];
}

- (IBAction)evaluarApp:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=624188106&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software"]];
}








- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"InformacionesCell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    unsigned int indice = (unsigned int) indexPath.row;
    
    switch(indice)
    {
        case 0:
            cell.textLabel.text = @"Ayuda";
            break;
        case 1:
            cell.textLabel.text = @"Contacto";
            break;
        case 2:
            cell.textLabel.text = @"Noticias";
            break;
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    unsigned int fila = (unsigned int) indexPath.row;
    NSString *url = nil;
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch(fila)
    {
        case 0:
            url = @"http://iosdevel.cl/ayuda.html";
            break;
        case 1:
            url = @"http://iosdevel.cl/contacto.html";
            break;
        case 2:
            url = @"http://iosdevel.cl/noticias.html";
            break;
    }
    
    if ( url && url.length > 0 )
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

@end
