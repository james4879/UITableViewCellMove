//
//  JJViewController.m
//  UITableViewCellMove
//
//  Created by James on 3/18/15.
//  Copyright (c) 2015 James. All rights reserved.
//

#import "JJViewController.h"

@interface JJViewController () <UITableViewDataSource, UITableViewDelegate> {
    UITableViewCellEditingStyle _editingStyle;
}

@property (nonatomic, weak) UITableView *tableView;

/** 模拟数据 */
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation JJViewController

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    for (NSInteger index = 0; index < 20; index++) {
        NSString *str = [NSString stringWithFormat:@"Name-%ld", index];
        [self.dataArray addObject:str];
    }
    // 删除
    UIBarButtonItem *deleteBtn = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                  style:UIBarButtonItemStylePlain
                                                                 target:self
                                                                 action:@selector(edit)];
    self.navigationItem.rightBarButtonItem = deleteBtn;
}

/****************	Private method   ****************/

- (void)add
{
    NSLog(@"%s", __func__);
    _editingStyle = UITableViewCellEditingStyleInsert;
    BOOL isEditing = self.tableView.isEditing;
    [self.tableView setEditing:!isEditing animated:YES];
}

- (void)edit
{
    NSLog(@"%s", __func__);
    _editingStyle = UITableViewCellEditingStyleDelete;
    BOOL isEditing = self.tableView.isEditing;
    [self.tableView setEditing:!isEditing animated:YES];
}

/****************	Table view data source   ****************/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.detailTextLabel.text = @"Detail";
    }
    cell.textLabel.text = [self.dataArray objectAtIndex:indexPath.row];
    return cell;
}

/****************	Table view delegate   ****************/

/** 提交编辑模式 */
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [self.dataArray removeObjectAtIndex:indexPath.row];
//        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//    } else {
//        NSInteger row = indexPath.row;
//        [self.dataArray insertObject:@"New" atIndex:row];
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
//        [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
//    }
}

/** 移动cell */
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [self.dataArray exchangeObjectAtIndex:sourceIndexPath.row withObjectAtIndex:destinationIndexPath.row];
}

///** 编辑模式 */
//- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return _editingStyle;
//}

/** 开始编辑当前行 */
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                          title:@"Delete"
                                                                        handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [self edit];
        if (_editingStyle == UITableViewCellEditingStyleDelete) {
            [self.dataArray removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
    
    UITableViewRowAction *addAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault
                                                                         title:@"Add"
                                                                       handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        [self add];
        if (_editingStyle == UITableViewCellEditingStyleInsert) {
            NSInteger row = indexPath.row + 1;
            [self.dataArray insertObject:@"New" atIndex:row];
            NSIndexPath *indexPaths = [NSIndexPath indexPathForRow:row inSection:0];
            [self.tableView insertRowsAtIndexPaths:@[indexPaths] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }];
    addAction.backgroundColor = [UIColor grayColor];
    return @[editAction, addAction];
}

/** 点击cell */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中状态
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
