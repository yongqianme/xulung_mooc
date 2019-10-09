诩阆（来自于德语`schulung`)是一个工业自动化相关的公益项目，目的在于为有强烈自学能力的自动化工程师，提供一个免费学习的地方，于2018年关闭。

这是我学习rails的时候写的第一个Rails项目，使用`ruby 2.1.5,rails 4.1.8`. 代码写的不好，请见谅。

## 源代码：
[https://github.com/brucebot/xulung_mooc](https://github.com/brucebot/xulung_mooc)

## 开发环境

```
Docker
ruby 2.1.5
rails 4.1.8
```
## 使用的主要gem模块

```bash
gem 'social-share-button'
gem 'mini_magick'
## Markdown editor
gem 'simditor',github: 'brucebot/simditor-rails'
#头像
gem 'letter_avatar',github: 'brucebot/letter_avatar'
gem 'friendly_id',github: 'brucebot/friendly_id'
gem 'chinese_pinyin'
#Markdown
gem 'redcarpet'
gem 'reverse_markdown','0.8.2'

#认证码
gem 'rucaptcha'
gem 'randomstring'

#mobile detector
gem 'browser'

#分页
gem 'kaminari'

#自载加载
gem 'jquery-infinite-pages'

#视频上传
gem 'videojs_rails'
gem 'carrierwave-video-thumbnailer'
gem 'streamio-ffmpeg'
gem 'carrierwave','0.6.2'

##pdf 处理
gem 'pdfjs_rails'
#认证
gem 'devise-i18n'
gem 'devise',           '~> 3.5.2'

# Server
gem "passenger"
```

## 如何使用
1. 安装Docker
2. 运行以下命令
```bash
docker build -t xulung . 
docker run -itP xulung
```
