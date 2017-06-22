//
//  TestViewController.m
//  JWChat
//
//  Created by JerryWang on 2017/6/20.
//  Copyright © 2017年 JerryWang. All rights reserved.
//

#import "TestViewController.h"

@interface TestViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIScrollView *bottomScrollView;

@property (nonatomic,strong) NSArray *titleArr;
@property (nonatomic,strong) NSMutableArray *deleteArr;
@property (nonatomic,strong) NSMutableArray *deleteIndexPath;
@property (nonatomic,strong) NSMutableArray *dataSource;
@end

@implementation TestViewController

- (NSMutableArray *)deleteIndexPath{

    if (!_deleteIndexPath) {
        _deleteIndexPath = [NSMutableArray array];
        
    }
    return _deleteIndexPath;
}
- (NSMutableArray *)dataSource{

    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray *)deleteArr{

    if (!_deleteArr) {
        _deleteArr = [NSMutableArray array];
    }
    return _deleteArr;
}

-(NSArray *)titleArr{

    if (!_titleArr) {
        _titleArr = @[@"姓名",@"性别",@"出生日期",@"籍贯",@"诊断内容",@"来源",@"备注",@"按钮"];
    }
    return _titleArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // config navbar
    
    UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editBtnClick:)];
    UIBarButtonItem *delete = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(deleteClick:)];
    self.navigationItem.rightBarButtonItems = @[edit,delete];
    // tableView
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 1085, SCREEN_HEIGHT) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor whiteColor];

    // bottomScorllView
    
    _bottomScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _bottomScrollView.contentSize = CGSizeMake(_tableView.bounds.size.width, 0);

    [_bottomScrollView addSubview:_tableView];
    [self.view addSubview:_bottomScrollView];

    
    // init data
    
    self.dataSource  = @[@"ssss",@"ssddddd",@"eeee",@"xxxx",@"dfefef",@"xxfefd",@"egdfgdf",@"sdfsdf"].mutableCopy;
}

- (void)editBtnClick:(UIBarButtonItem *)edit{

    if (self.tableView.editing) {
        self.navigationItem.rightBarButtonItems[0].title = @"编辑";
        [self.tableView setEditing:NO animated:YES];
    }else{
    
        self.navigationItem.rightBarButtonItems[0].title = @"取消";
        [self.tableView setEditing:YES animated:YES];
    }
}

- (void)deleteClick:(UIBarButtonItem *)delete{

    [self.dataSource removeObjectsInArray:self.deleteArr];
    [self.tableView deleteRowsAtIndexPaths:self.deleteIndexPath withRowAnimation:UITableViewRowAnimationFade];
    
    [self.deleteArr removeAllObjects]; // 清空上传选中的索引
    [self.deleteIndexPath removeAllObjects];
}


#pragma mark - tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];

    }
    
    cell.textLabel.text = self.dataSource[indexPath.row];
    
    return cell;
}

// header 作为顶部的标题

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{

    UIView *titleView = [[UIView alloc] init];
    titleView.backgroundColor = [UIColor lightGrayColor];
    CGFloat titleW = 80;
    
    for (NSInteger i = 0; i<self.titleArr.count; i++) {
        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(i*titleW, 0, titleW, 40)];
        title.text = self.titleArr[i];
        title.font = [UIFont systemFontOfSize:16];
        title.textColor = [UIColor blackColor];
//        title.backgroundColor = [UIColor greenColor];
        title.textAlignment = NSTextAlignmentCenter;
        [titleView addSubview:title];
    }
    
    return titleView;
    
}

// 分割线顶齐

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsMake(0, -206.5, 0, -206.5)];
    }
    
    if([cell respondsToSelector:@selector(setLayoutMargins:)]){
        [cell setLayoutMargins:UIEdgeInsetsMake(0, -206.5, 0, -206.5)];
    }
}

- (void)viewDidLayoutSubviews{
    if([self.tableView respondsToSelector:@selector(setSeparatorInset:)]){
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if([self.tableView respondsToSelector:@selector(setLayoutMargins:)]){
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
    }
}


// 删除

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [self.dataSource removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"选中了：%ld",indexPath.row);
    if (tableView.editing) {
        [self.deleteArr addObject:[self.dataSource objectAtIndex:indexPath.row]];
        [self.deleteIndexPath addObject:indexPath];
    }
    
    NSLog(@"当前选中：%@",self.deleteArr);
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSLog(@"取消选中：%ld",indexPath.row);
    if (tableView.editing) {
         [self.deleteArr removeObject:[self.dataSource objectAtIndex:indexPath.row]];
        [self.deleteIndexPath removeObject:indexPath];
    }
   
    NSLog(@"当前选中：%@",self.deleteArr);
}

@end
