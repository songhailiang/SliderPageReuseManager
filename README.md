# SliderPageReuseManager
To make your slider page re-useable.
让你的多表滑动切换视图支持复用！

# 我能干什么
1. 实现简单的多表滑动切换功能：2种方式
2. 实现切换视图的复用：复用ViewController和复用UITableView，可解决tab页过多时内存飙升的问题
3. 可配置缓存池大小

## 复用ViewController

用于parentViewController+childController方式实现的滑动切换功能，将每一页的内容封装到独立的ViewController中，代码整洁易维护。个人比较推荐这种方式。

1. 支持自定义实例化ViewController：包括默认的init方式、通过storyboard实例化等
2. 支持单一ViewController的复用：tab页内容雷同，封装到一个ChildViewController中
3. 支持多个ViewController的复用：tab页内容封装到不同的ViewController中

## 复用UITableView

用于一个ViewController+多个TableView实现的滑动切换功能，这种方式需要在一个ViewController中维护不同的TableView数据源，如果界面较复杂，这种方式很容易造成代码混乱，不易维护。

# 效果
<img src='https://github.com/songhailiang/SliderPageReuseManager/blob/master/screenshot/screenshot1.gif' width=400 />
<img src='https://github.com/songhailiang/SliderPageReuseManager/blob/master/screenshot/screenshot2.gif' width=400 />

# 安装说明
复制SliderPageReuseManager文件夹里的所有文件到你的项目中（6个文件）

# 使用方式

1.实例化SliderPageReuseManager，并注册复用的ViewController（或者UITableView）
```objc
    _reuseManager = [[SliderPageReuseManager alloc] init];
    [_reuseManager registerClass:[CategoryController class] forReuseIdentifier:@"category"];
```
2.获取复用的ViewController（或者UITableView）
```objc
  CategoryController *cateVc = [self.reuseManager dequeueReuseableViewControllerWithIdentifier:@"category" forKey:[NSString stringWithFormat:@"%@",@(categoryId)]];
```
3.根据isReused属性可知道ViewController是否是经过复用的，如果是复用的，一般需要清除原来的数据，然后再加载新数据（如果有本地缓存，应该优先加载本地缓存，没有缓存再请求服务端数据，网易新闻、头条都是这么处理的）。清除原来的数据，可以在prepareForReuse方法里处理（复用ViewController时）
```objc
- (void)prepareForReuse {

    //清空原来的数据
    [self.datas removeAllObjects];
    [self.table reloadData];
}
```

# Demo说明
demo中使用pod加载了几个第三方库，如果需要运行，请打开.xcworkspace文件。
tab页切换使用的是[HMSegmentedControl] (https://github.com/HeshamMegid/HMSegmentedControl) ，个人非常喜欢的一个第三方库。
