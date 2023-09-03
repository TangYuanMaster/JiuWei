<h1 align="center">
  <br>
  <img src="img/logo.jpg" alt="logo">
  <br>
  JiuWei | <a href="https://gitee.com/CNTangyuan/JiuWei-repository">JiuWei-repository</a>
  <br>
</h1>

<h3 align="center">一款高自定义化、国内化的类网安包管理集成项目.</h4>

<h3 align="center">
    <a href='https://gitee.com/CNTangyuan/JiuWei/stargazers'>
      <img src='https://gitee.com/CNTangyuan/JiuWei/badge/star.svg?theme=dark' alt='star'></img></a>
    <a href='https://gitee.com/CNTangyuan/JiuWei/members'>
      <img src='https://gitee.com/CNTangyuan/JiuWei/badge/fork.svg?theme=dark' alt='fork'></img></a>
  <a href="https://www.gnu.org/licenses/gpl-3.0.en.html">
      <img src="https://img.shields.io/badge/license-GPL3-_red.svg">
  <a href="https://www.gnu.org/software/bash/">
      <img src="https://img.shields.io/badge/language-Bash-blue.svg" alt="Bash">
  </a>
</p>

<h3 align="center" dir="auto">
  中文 | <a href="https://gitee.com/CNTangyuan/JiuWei/blob/master/README_EN.md">English</a>
</p>


## ⚠️ 免责声明

> 本项目及包含工具仅面向合法授权的企业安全建设行为，用户滥用造成的一切后果与作者无关，在使用本工具时，您应确保该行为符合当地的法律法规，并且已经取得了足够的授权。请勿对非授权目标进行扫描。

> 如您在使用本项目及包含工具的过程中存在任何非法行为，您需自行承担相应后果，我们将不承担任何法律及连带责任. 您的使用行为或者您以其他任何明示或者默示方式表示接受本协议的，即视为您已阅读并同意本协议的约束。


## 🏆 优势&特点

- 为世面上众多的安全工具提供安装、更新与卸载支持「*FOX包管理*」
- 提供PATH便捷调用工具「*快速便捷*」
- 支持增量拓展，安装更多工具「*快速安装*」
- 支持更多的Linux系统设备部署使用「*广泛支持*」
- 更多人性化设计等你体验噢～


## 🔖 使用对象

1. 针对性攻击与漏洞扫描「红队」
2. 本地防御与漏洞检查「蓝队」
3. 工具开发者［快速查找同类工具，借鉴优势，补齐短板」
4. 日常网安工作者「学习工具原理代码，方便日常挖洞」


## 🌲 目录结构

```
.
├── .bin #可执行&快捷命令文件存放
│   ├── Expand_JiuWei #拓展安装命令
│   ├── Remove_JiuWei #卸载命令
│   ├── fox #类包管理命令
│   └── jiuwei #信息&兼容性展示命令
├── .cache #fox文件下载缓存存放
│   └── sqlmap.fox #…
├── .foxindex #索引文件存放
│   └── FOXINDEX #FOX类包管理器的索引文件
├── .have_been_install #已安装软件包记录
├── .packages_info #软件包信息记录
├── .packages_name #软件包名称记录
├── .expand #拓展状态文件
└── config.list #配置文件
```


## 🌟 支持系统

- Kali
- Ubuntu
- Debian
- AlpineLinux
- Darwin
- CentOS
- RedHat
- ArchLinux
- Termux〔支持NoRoot〕


## 🔧 快速部署

初始化运行JiuWei-nano环境状态(・∀・)

```
wget "https://gitee.com/CNTangyuan/JiuWei/raw/master/Setup_JiuWei"
chmod +x Setup_JiuWei
./Setup_JiuWei
```

拓展增量至JiuWei-Expand环境状态((つ≧▽≦)つ

```
Expand_JiuWei
```

卸载JiuWei(ʘᗩʘ’)

```
Remove_JiuWei
```


## 🔆 配置文件    
      ~/JiuWei/config.list


## 📌 未来

- [ ] DOCKER-MODE模式支持
- [ ] 全工具无指定自动批量更新
- [ ] 重点工具标注「*快速选择优良工具使用*」
- [ ] 工具简介内容标签关键词化「*便于针对性工具查找*」


## 🚀 版本迭代记录

请参阅 [CHANGELOG](https://gitee.com/CNTangyuan/JiuWei/blob/master/CHANGE.log)


## 👀 参考

由衷感谢所有包管理工具提供的大致思路与各大工具集成类系统带来的灵感～


## 📄 版权

该项目签署了GPL-3.0授权许可

详情请参阅 [LICENSE](https://gitee.com/CNTangyuan/JiuWei/blob/master/LICENSE)


## 💡 贡献&联系

你可以向我告知新的工具及其简介，为我的项目编写工具fox文件，为我完善工具的简介或提供建议等等～
希望各位大师傅踊跃贡献噢((･ω･)つ⊂(･ω･)

1. [提交Gitee-iSSUES议题](https://gitee.com/CNTangyuan/JiuWei/issues)
2. [CSDN-TY汤圆](https://blog.csdn.net/qq_57851190)
3. [QQ交流群-【TYXC】](http://qm.qq.com/cgi-bin/qm/qr?_wv=1027&k=OVsNn-8iWP5HTTARzTNzfOcgCngXp3gH&authKey=03ZWzlYVvCH6Cpq2Pa7nIEqOFiXw2svp96C896bcZc4Rpg%2FTNk2c2F8asJ4U7tiK&noverify=0&group_code=751386568)
