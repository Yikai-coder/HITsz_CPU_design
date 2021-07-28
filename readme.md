哈尔滨工业大学（深圳）2021夏季学期计算机设计与实践课程代码。

课程要求设计基于MiniRV指令集的单周期CPU与流水线CPU，至少完成24条基础指令。流水线CPU还要处理数据冒险与控制冒险。

工程代码要求能够通过虚拟机当中的trace比对以及烧录到开发板上进行测试。

文件目录如下：
```
├─pipeline                           流水线CPU代码
│  ├─forward                       前递解决数据冒险代码
│  │  ├─onBoard 			    开发板运行代码
│  │  └─trace                        trace比对代码
│  └─suspend                      暂停解决数据冒险代码
│      ├─onBoard                  开发板运行代码
│      └─trace                         trace比对代码
└─single_cycle                      单周期CPU代码
    ├─obBoard                       开发板运行代码
    └─trace                              trace比对代码

```
