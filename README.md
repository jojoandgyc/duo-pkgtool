# duo-sdk

A simple sdk for duo to build RT-Thread

## 准备工作

### 拉取duo-sdk

使用 ```$ git clone git@github.com:koikky/duo-sdk.git``` 可以拉取duo-sdk到本地目录。

### 拉取rt-thread

使用 ```$ git clone git@github.com:RT-Thread/rt-thread.git``` 可以拉取RT-Thread源码到本地目录。

### 检查

可以使用 ```$ ls -l``` 命令检查是否存在duo-sdk目录以及rt-thread目录。

### 配置环境

#### 编译工具

这个部分是用户自行配置，RT-Thread标准版的编译工具下载地址 https://occ-oss-prod.oss-cn-hangzhou.aliyuncs.com/resource//1705395512373/Xuantie-900-gcc-elf-newlib-x86_64-V2.8.1-20240115.tar.gz。

#### 执行环境

在使用duo-sdk之前，需要在~/.bashrc里声明这几个变量：```RTT_CC```、```RTT_EXEC_PATH```、```RTT_CC_PREFIX```、```RTT_ROOT```，参照如下（这里以标准版为例）：

```shell
### in ~/.bashrc
export RTT_CC="gcc"
export RTT_EXEC_PATH="/home/{username}/xxx/.../xxx/Xuantie-900-gcc-elf-newlib-x86_64-V2.8.1/bin/"
export RTT_CC_PREFIX="riscv64-unknown-elf-"
export PATH="$RTT_EXEC_PATH:$PATH"
export RTT_ROOT="/home/{username}/xxx/.../xxx/rt-thread"
```

！！这里的RTT_ROOT十分重要，这将决定duo-sdk服务于哪个RT-Thread目录 ！！

## 开始使用

### 加载环境

需要加载duo-sdk/script/目录下的env.sh。
例如可以使用 ```$ source duo-sdk/script/env.sh duo256m```
其中，后面的参数是配置当前环境的，第一个参数是duo的型号。

同时，可以在终端里输入help获取更多信息。
例如 ```$ help```

### 配置和编译

用户配置RT-Thread需要进入源码目录里自行配置，目前的duo-sdk只支持了大核risc-v版。
大核所在的risc-v目录。-----> ```bsp/cvitek/cv18xx_risc-v/```
小核所在的目录。----->``` bsp/cvitek/c906_little/```
使用的命令为```$ scons --menuconfig```

编译也是一样
使用的命令为```$ scons```

### 打包

当成功执行env.sh后，可以使用如下命令分别对大小核进行打包，打包为镜像文件。
大核使用命令```$ genbc_sd```
小核使用命令```$ gensc_fip```

## 注意

输出目录在duo-sdk/output/目录
