//
//  ViewController.m
//  Starwars API
//
//  Created by Walter Gonzalez Domenzain on 08/11/17.
//  Copyright © 2017 Boletomovil. All rights reserved.
//

#import "Home.h"

@interface Home ()
@property (strong, nonatomic) NSMutableArray *people;
@property (strong, nonatomic) SWObject *personAtIndex;
@property NSMutableArray *dataToSend;
@end

int indexPerson = 0;

@implementation Home

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _people = [[NSMutableArray alloc] init];
    //_personAtIndex = [[SWObject alloc] init];
    [self getPeople];
    [self getPerson];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//********************************************************************************************
#pragma mark                            Data methods
//********************************************************************************************
- (void)getPeople{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [WebServices getPeople:^(NSMutableArray<SWObject> *people) {
        
        if(people){
            [_people removeAllObjects];
            [_people addObjectsFromArray:people];
            
            SWObject *person = [people objectAtIndex:indexPerson];
            NSString *name = person.name;
            
            NSLog(@"print name : %@", name);
            self.lblName.text = name;
            self.lblName.adjustsFontSizeToFitWidth = YES;
            indexPerson++;
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}
- (void)getPerson{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [WebServices getPerson:@"1" completion:^(NSMutableArray<SWObject> *people) {
        
        if(people){
            [_people removeAllObjects];
            [_people addObjectsFromArray:people];
            
            SWObject *person = [people objectAtIndex:indexPerson];
            NSString *name = person.name;
            
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
}

- (SWObject *)getPersonAtIndex:(int) index{
    NSLog(@"··················· Entering method method");
    //__block SWObject *personIndex = [[SWObject alloc] init];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [WebServices getPeople:^(NSMutableArray<SWObject> *people) {
        
        if(people){
            [_people removeAllObjects];
            [_people addObjectsFromArray:people];
            
            self.personAtIndex = [people objectAtIndex:index];
            NSString *name = self.personAtIndex.name;
            
            NSLog(@"print name from method works: %@", name);
            
            //_personAtIndex = person;
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
    
    NSString *names = self.personAtIndex.name;
    NSLog(@"IM PRINTING: %@", self.personAtIndex.name);
    return self.personAtIndex;
}

/**********************************************************************************************/
#pragma mark - Table source and delegate methods
/**********************************************************************************************/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
//-------------------------------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //Get the number of characters after load the from API
    return self.people.count;
}
//-------------------------------------------------------------------------------
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64;
}
//-------------------------------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //Initialize cells
    cellMainTable *cell = (cellMainTable *)[tableView dequeueReusableCellWithIdentifier:@"cellMainTable"];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"cellMainTable" bundle:nil] forCellReuseIdentifier:@"cellMainTable"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"cellMainTable"];
    }
    //Fill cell with info from arrays

    cell.lblIndex.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row];
    
    SWObject *person = [_people objectAtIndex:indexPath.row];
    NSString *name = person.name;
    cell.lblName.text = name;
    
    return cell;
}
//-------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Get index number from the current cell
    cellMainTable *cell = (cellMainTable *)[tableView cellForRowAtIndexPath:indexPath];
    NSString *index = cell.lblIndex.text;
    
    //Call [getPersonAtIndex:NSString index] method to obtain and array with the person's details
    //SWObject *personAtIndex = [self getPersonAtIndex:index.intValue];
    //NSString *name = personAtIndex.name;
    //NSLog(@"////////////////////////////////////////////////////////////////////////print name at didSelecttedRowAtIndexPath: %@", name);
    
    SWObject *person = [_people objectAtIndex:index.intValue];
    NSString *name = person.name;
    NSString *gender = person.gender;
    NSString *hair_color = person.hair_color;
    NSString *height = person.height;
    NSString *skin_color = person.skin_color;
    NSString *mass = person.mass;
    
    self.dataToSend = [[NSMutableArray alloc]init];
    [self.dataToSend addObject:@{
                         @"name" :  name,
                         @"gender" : gender,
                         @"hair_color" : hair_color,
                         @"height" : height,
                         @"skin_color" : skin_color,
                         @"mass" : mass
                         }];
    
    NSDictionary *objectToSend = self.dataToSend[0];
    [self performSegueWithIdentifier:@"secondView" sender:objectToSend];
    NSLog(@"Item selected");
}
/**********************************************************************************************/
#pragma mark - Action methods
/**********************************************************************************************/
- (IBAction)btnUpdatePressed:(id)sender {
    [self getPeople];
    //Reload the table to fill it with the characters since at load time, the number of characters is 0
    [self.tbMain reloadData];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"secondView"])
    {
        Details *controller = [segue destinationViewController];
        controller.data = sender;
        NSLog(@"Segueado!!!!!");
        
    }
}
@end
