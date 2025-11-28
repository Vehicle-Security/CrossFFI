### 测试用例1: 跨语言调用场景模拟   
1. curl封装一个HTTP客户端，模仿鸿蒙rcp库[ohos-rcp](https://developer.huawei.com/consumer/en/doc/harmonyos-references/remote-communication-rcp) 
2. 导出rcp为js接口
3. lua/python调用rcp库，获取json数据
4. lua/python过滤json，调用JS界面库显示一个列表，调用C++ print到console（或者集成Skia + SDL，做个简单鸿蒙列表界面？）