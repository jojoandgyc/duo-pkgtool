# duo-pkgtool
A simple pkg tool for duo to pack RT-Thread                 

## 准备工作
### 拉取duo-pkgtool工具
使用 ``` $ git clone git@github.com:koikky/duo-pkgtool.git ``` 可以拉取duo-pkgtool到本地目录。                  

### 配置环境
在使用duo-pkgtool工具之前，需要在~/.bashrc里声明这几个变量：```DPT_PATH```、```DPT_PATH_KERNEL```，参照如下：                  
```shell
## in ~/.bashrc
export DPT_PATH="/home/{username}/xxx/.../xxx/duo-pkgtool"
export DPT_PATH_KERNEL="/home/{username}/xxx/.../xxx/rt-thread/bsp/cvitek"
```
这里的DPT_PATH_KERNEL指向RT-Thread目录下的duo目录、DPT_PATH指向duo-pkgtool工具的根目录。这样的话无论duo-pkgtool和rt-thread目录在哪个位置，我们都能够找到，duo-pkgtool都能使用。              

## 开始使用
### 加载环境
每次使用前，需要加载duo-pkgtool/script/目录下的env.sh。因为我们前面在~/.bashrc里设置了DPT_PATH。                   
所以我们可以使用例如 ``` $ source ${DPT_PATH}/script/env.sh ```                              

同时，用户可以在终端里输入help获取更多信息。                                      
例如 ``` $ help ```                        

### 打包
当成功执行env.sh后，可以使用如下命令对大小核进行打包，打包为镜像文件，前提是用户需要先成功编译。                        
命令``` $ mkpkg ``` ---->默认只打包大核。                 
命令``` $ mkpkg -a ``` ---->若携带-a选项，则会同时打包大核和小核。                
####其他选项目前无效。             

## 注意
输出目录为duo-pkgtool/output/目录。      
目前，这个duo-pkgtool相对独立，还没有修改与清理RT-Thread仓库的bsp/cvitek目录。下一步可以进行bsp/cvitek目录的优化和清理工作或加入新功能完善rt-smart的部分。
