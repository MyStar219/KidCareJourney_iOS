//
//  ProvinceVC.m
//  KidCareJourney
//
//  Created by administrator on 3/29/17.
//  Copyright © 2017 Eddie. All rights reserved.
//

#import "ProvinceVC.h"
#import "CountryVC.h"
#import "ProvinceTableViewCell.h"
#import "ProfileVC.h"

@interface ProvinceVC ()
@property (weak, nonatomic) IBOutlet UITableView *provinceTableView;
@property (strong, nonatomic) NSMutableArray *provinceArray;
@end

@implementation ProvinceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.provinceTableView.dataSource=self;
    self.provinceTableView.delegate=self;
    
    //Get Province data of selected country from csv file
    NSString *countryname=self.selectedCountry;
    NSMutableArray *countryName = [NSMutableArray array];
    NSMutableArray *provinceName = [NSMutableArray array];
    NSString *resourceFileName = @"countryprovince";
    NSString *pathToFile =[[NSBundle mainBundle] pathForResource: resourceFileName ofType: @"csv"];
    NSError *error;
    NSString *fileString = [NSString stringWithContentsOfFile:pathToFile encoding:NSUTF8StringEncoding error:&error];
    NSArray *rows = [fileString componentsSeparatedByString:@"\r\n"];
    
    for (NSString *row in rows){
        
        if ([row rangeOfString:@","].location != NSNotFound) {
            NSArray* columns = [row componentsSeparatedByString:@","];
            [countryName addObject:columns[0]];
            [provinceName addObject:columns[1]];
        } else {
            NSLog(@"===== %@", row);
        }
    }
    NSMutableArray *subprovinceName = [NSMutableArray array];
    for (int i=0; i<countryName.count; i++) {
        if ([countryname isEqualToString:[countryName objectAtIndex:i]]) {
            [subprovinceName addObject:[provinceName objectAtIndex:i]];
        }
    }
    self.provinceArray=[NSMutableArray new];
    for (int i=0; i<subprovinceName.count; i++) {
        NSString *name=[subprovinceName objectAtIndex:i];
        if (self.provinceArray.count==0) {
            [self.provinceArray addObject:name];
        } else {
            int k=0;
            for (int j=0; j<self.provinceArray.count; j++) {
                if ([name isEqualToString:[self.provinceArray objectAtIndex:j]]) {
                    k++;
                }
            }
            if (k==0) {
                [self.provinceArray addObject:name];
            }
        }
    }
    NSLog(@"Province Parsing Success");
    // Do any additional setup after loading the view.
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
    return self.provinceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProvinceTableViewCell *cell=(ProvinceTableViewCell *) [tableView dequeueReusableCellWithIdentifier:@"provinceCell" forIndexPath:indexPath];
    NSString *provincename =[self.provinceArray objectAtIndex:indexPath.row];
    cell.provinceNameLbl.text=provincename;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    ProfileVC *vc =(ProfileVC *)[storyboard instantiateViewControllerWithIdentifier:View_ProfileVC];
    vc.selectedProvince=[self.provinceArray objectAtIndex:indexPath.row];
    vc.firstName=self.firstName;
    vc.lastName=self.lastName;
    vc.email=self.email;
    vc.phoneNumber=self.phoneNumber;
    vc.address1=self.address1;
    vc.address2=self.address2;
    vc.selectedCountry=self.selectedCountry;
    vc.city=self.city;
    vc.password=self.password;
    vc.viewControl=self.viewControl;
    vc.addsignupcenterdaycare=self.addsignupcenterdaycare;
    vc.categoriesDetect=self.categoriesDetect;
    vc.profileImg=self.profileImg;
    NSLog(@"Selected Province : %@", vc.selectedProvince);
    [self.navigationController pushViewController:vc animated:YES];
}

@end
