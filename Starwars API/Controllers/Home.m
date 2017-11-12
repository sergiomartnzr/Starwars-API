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

@end

int indexPerson = 0;

@implementation Home

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _people = [[NSMutableArray alloc] init];
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

- (NSString *)getName:(long) index{
    __block NSString *indexedName = @"";
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [WebServices getPerson:[NSString stringWithFormat:@"%ld", index] completion:^(NSMutableArray<SWObject> *people) {
        
        if(people){
            [_people removeAllObjects];
            [_people addObjectsFromArray:people];
            
            SWObject *person = [people objectAtIndex:indexPerson];
            NSString *name = person.name;
            indexedName = name;
            
        }
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    }];
    
    return indexedName;
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
    //cell.lblName.text = @"Luke";
    
    //SWObject *person = people objectAtIndex:indexPerson;
    //NSString *name = person.name;
    
    for (int i = 0; i < _people.count; i++) {
        SWObject *person = [_people objectAtIndex:i];
        NSString *name = person.name;
        NSLog(@"------------------- : %@", name);
    }
    
    SWObject *person = [_people objectAtIndex:indexPath.row];
    NSString *name = person.name;
    cell.lblName.text = name;
    
    return cell;
}
//-------------------------------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //Pending
}
/**********************************************************************************************/
#pragma mark - Action methods
/**********************************************************************************************/
- (IBAction)btnUpdatePressed:(id)sender {
    [self getPeople];
    [self.tbMain reloadData];
}






@end
