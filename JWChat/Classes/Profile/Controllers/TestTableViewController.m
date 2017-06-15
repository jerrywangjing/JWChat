//
//  TestTableViewController.m
//  JWChat
//
//  Created by JerryWang on 2017/6/15.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "TestTableViewController.h"

@interface TestTableViewController ()
@property (nonatomic,strong) NSArray *sourceData;

@end

@implementation TestTableViewController

- (NSArray *)sourceData{

    if (!_sourceData) {
        _sourceData = [NSArray array];
    }
    return _sourceData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    [self initData];
}

- (void)initData{

    self.sourceData = @[
                        @{
                            @"title" : @"支付金额",
                            @"subTitle" : @"￥50",
                            },
                        @{
                            @"title" : @"支付状态",
                            @"subTitle" : @"已支付",
                            },
                        
                        @{
                            @"title" : @"支付金额",
                            @"subTitle" : @"￥50",
                            },
                        @{
                            @"title" : @"支付状态",
                            @"subTitle" : @"已支付",
                            },
                        @{
                            @"title" : @"支付金额",
                            @"subTitle" : @"￥50",
                            },
                        @{
                            @"title" : @"支付状态",
                            @"subTitle" : @"已支付",
                            },
                        @{
                            @"title" : @"支付金额",
                            @"subTitle" : @"￥50",
                            },
                        @{
                            @"title" : @"支付状态",
                            @"subTitle" : @"已支付",
                            },
                        @{
                            @"title" : @"支付金额",
                            @"subTitle" : @"￥50",
                            },
                        @{
                            @"title" : @"支付状态",
                            @"subTitle" : @"已支付",
                            },
                        ];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.sourceData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"cellId";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
        
    }
    
    NSDictionary *data = self.sourceData[indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = data[@"title"];
    cell.detailTextLabel.text = data[@"subTitle"];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
