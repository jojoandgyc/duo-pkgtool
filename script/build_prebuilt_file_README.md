## 运行命令

```
./duo-buildroot-sdk_patch.sh   参数1(可选)    参数2(可选)
```

参数1：duo-buildroot-sdk项目 的绝对路径

如果没填 参数1 , 自动下载duo-buildroot-sdk项目，在项目目录下

参数2：开发板名称 duo / duo256 / duos

如果没填 参数2 ， 默认 制作全部开发板 ， 支持 sd \ emmc \ spinand \ spinor 存储介质

duo-buildroot-sdk项目编译需要十分钟左右，运行结束，自动复制关键文件到 prebuit目录下
