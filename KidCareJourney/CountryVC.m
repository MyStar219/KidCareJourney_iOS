//
//  CountryVC.m
//  KidCareJourney
//
//  Created by administrator on 3/29/17.
//  Copyright © 2017 Eddie. All rights reserved.
//

#import "CountryVC.h"
#import "CountryTableViewCell.h"
#import "ProfileVC.h"

@interface CountryVC ()
@property (weak, nonatomic) IBOutlet UITableView *countryTableView;
@property (strong, nonatomic) NSMutableArray *nameArray;
@end

@implementation CountryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.countryTableView.delegate=self;
    self.countryTableView.dataSource=self;
    // Do any additional setup after loading the view.
    
    // Get country array data from csv file
    NSMutableArray *countryName = [NSMutableArray array];
    NSString *resourceFileName = @"countryprovince";
    NSString *pathToFile =[[NSBundle mainBundle] pathForResource: resourceFileName ofType: @"csv"];
    NSError *error;
    NSString *fileString = [NSString stringWithContentsOfFile:pathToFile encoding:NSUTF8StringEncoding error:&error];
    NSArray *rows = [fileString componentsSeparatedByString:@"\r\n"];
    for (NSString *row in rows){
        NSArray* columns = [row componentsSeparatedByString:@","];
        [countryName addObject:columns[0]];
    }
    
    self.nameArray=[NSMutableArray new];
    for (int i=0; i<countryName.count; i++) {
        NSString *name=[countryName objectAtIndex:i];
        if (self.nameArray.count==0) {
            [self.nameArray addObject:name];
        } else {
            int k=0;
            for (int j=0; j<self.nameArray.count; j++) {
                if ([name isEqualToString:[self.nameArray objectAtIndex:j]]) {
                    k++;
                }
            }
            if (k==0) {
                [self.nameArray addObject:name];
            }
        }
    }
    NSLog(@"Country Parsing Success");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UITableViewDelegate, UITableViewDatasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.nameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CountryTableViewCell *cell=(CountryTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"countryCell" forIndexPath:indexPath];
    NSString *countryname =[self.nameArray objectAtIndex:indexPath.row];
    cell.countryNameLbl.text=countryname;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProfileVC *vc =(ProfileVC *)[storyboard instantiateViewControllerWithIdentifier:View_ProfileVC];
    vc.selectedCountry=[self.nameArray objectAtIndex:indexPath.row];
    vc.firstName=self.firstName;
    vc.lastName=self.lastName;
    vc.email=self.email;
    vc.phoneNumber=self.phoneNumber;
    vc.address1=self.address1;
    vc.address2=self.address2;
    vc.city=self.city;
    vc.password=self.password;
    vc.viewControl=self.viewControl;
    vc.addsignupcenterdaycare=self.addsignupcenterdaycare;
    vc.categoriesDetect=self.categoriesDetect;
    vc.profileImg=self.profileImg;
    NSLog(@"Selected Country : %@", vc.selectedCountry);
    [self.navigationController pushViewController:vc animated:YES];
}


@end
