
# preload动态选择select的字段

### 背景
在执行类似
```ruby
User.where(id: 1).includes([:introduction,{:organizations=> :products}, wife: [:father, :mother] ])
```
的过程中， 对应的Model的字段会被全部提取出来。 这个在数据量比较大的情况下是非常浪费资源的。

这个简单的demo通过一种方式实现只提取关联Model指定的字段。在某些场景下可用作性能优化。 具体的情景分析请看[这篇文章](https://ruby-china.org/topics/37245)。

### 使用方法

1. 将 preload_patch.rb 在 ```config/initializers``` 文件夹中, 文件可在本demo的```config/initializers``` 找到.

2. 具体示例见 ```app/services/selectable_columns/test.rb```

### Have a try

``` shell
cd this_demo_path
bundle install
rake db:migrate
rake data_creation:create_test_data
rails c
```

excute:
```pry
# prelod all associations data at once
SelectableColumn::Test.user_selectable

# preload in batchs
SelectableColumn::Test.user_selectable_batchs
```

And, you can see the results from the logs, if the development mode on.

### 局限

- 不能再进行懒加载了
- 在提取通过```through```定义的关联关系时，该机制不起作用，仍然会提取全部字段