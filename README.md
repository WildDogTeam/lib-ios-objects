WilddogObjects是一个回调，用几个类配合wilddog实现一个同步的NSDictionary；

用Wilddog保持一个同步的Dictionary；
-------------------------------------------------------------

    // 在viewDidLoad中
    self.wilddog = [[Wilddog alloc] initWithUrl:@"https://fake.wilddogio.com/stuff"];
    self.dictionary = [NSMutableDictionary dictionary];
    self.collection = [[WilddogCollection alloc] initWithNode:wilddog dictionary:dictionary type:[User class]];
    
    [self.collection didAddChild:^(User * user) {

        NSLog(@"New User %@", user);
        [self.tableView reloadData];
    }];
    
    User * me = [User new];
    me.name = @"me";
    [self.collection addObject:me];
    
###我们怎么去运行一个tableView呢

就是使用字典的所有数据去加载它。
    - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
    {
        return [self.dictionary.allValues count];
    }


### 关于对象类型初始化

告诉你什么类型的数据在集合中传递,另外,你能够使用'factory'初始化方法去创建WilddogCollection

    self.collection = [[WilddogCollection alloc] initWithNode:wilddog dictionary:dictionary factory:^(NSDictionary* value) {
        return [User new];
    }];
    
在你的对象中，wilddog内部会调用`setValuesForKeysWithDictionary`去设置值
### 实现`Objectable`
你的类应该实现 `Objectable`协议，以便`WilddogCollection`把它转化为字典
    -(NSDictionary*)toObject {
        return [self dictionaryWithValuesForKeys:@[@"name"]];
    }
    
###另外，移除和更新所有处理
当他们改变时使用`didAddChild`, `didRemoveChild` 和 `didUpdateChild`去修改

当链接改变时被修改
-------------------------------------------------------

    self.connection = [[WilddogConnection alloc] initWithWilddogName:@"mywilddogname" onConnect:^{
        [self connectToLobby];
    } onDisconnect:^{
        [self showDiconnectedScreen];
    }];























