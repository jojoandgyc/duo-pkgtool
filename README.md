# duo-pkgtool
A simple pkg tool for duo to pack RT-Thread.                 

## 1. 准备工作
- 首先需要拉取 `duo-pkgtool`工具到本地目录。示例如下：
	``` shell 
	$ git clone git@github.com:koikky/duo-pkgtool.git 
	```
                   
- 同时，在使用之前，我们需要安装一些额外的外部依赖，示例如下:                           	
	``` shell
	$ sudo apt update
	$ sudo apt install u-boot-tools
	```

## 2. 开始使用
### 2.1. 设置环境
- 每次使用前，需要加载 `duo-pkgtool/script/`目录下的 `env.sh`。示例如下：                                    
	``` shell
	$ source duo-pkgtool/script/env.sh 
	```  
                            
- 如果想要更改 `duo-pkgtool`的环境配置，可以使用 `change_config`命令。示例如下：
	``` shell
	$ change_config 
	```           
	Tips：用户可以根据自己的需要选择不同选项。                                    

- 同时，用户可以在终端里输入 `print_usage`命令获取使用提示,也可以输入 `print_env`命令获取当前 `duo-pkgtool`的环境信息。示例如下：                                      
	``` shell 
	$ print_usage
	$ print_env
	```                        

### 2.2. 打包
- 当成功运行 `env.sh`后，可以使用如下命令进行打包，打包结果为镜像文件。                        
	``` shell
	$ mkpkg
	```                             
	Tips：用户可以根据自己的需要选择不同选项。                               

## 3. 注意
本次采用了 prompt 提示交互，因为配置项少所以没有使用menuconfig。  
