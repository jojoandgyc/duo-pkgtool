# duo-pkgtool
A simple pkg tool for duo to pack RT-Thread                 

## 准备工作
- 使用 ``` $ git clone git@github.com:koikky/duo-pkgtool.git ``` 可以拉取duo-pkgtool到本地目录。                   
- 同时，在使用之前，我们需要安装一些额外的外部依赖，示例如下:                           
``` shell
$ sudo apt update
$ sudo apt install u-boot-tools
```

## 开始使用
### 设置环境
每次使用前，需要加载duo-pkgtool/script/目录下的env.sh。示例如下：                                    
 ``` shell
$ source duo-pkgtool/script/env.sh 
```  
                            
如果想要更改duo-pkgtool的环境配置，可以使用change_config命令。示例如下：
 ``` shell
$ change_config 
```           
Tips：用户可以根据自己的需要进行选择。                                    

同时，用户可以在终端里输入print_usage命令获取提示,也可以输入print_env命令获取当前duo-pkgtool的环境信息。示例如下：                                      
 ``` shell 
$ print_usage
$ print_env
 ```                        

### 打包
当成功运行env.sh后，可以使用如下命令进行打包，打包结果为镜像文件。                        
 ``` shell
$ mkpkg
```                             
Tips：用户可以根据自己的需要进行选择。                               

## 注意
