#!/bin/bash
echo "enter into roboticsfaq.com"
cd /home/brucebot/public_html/schulung
echo "restart thin now...."
bundle exec thin restart -C ~/xulung.yml

#sudo /etc/init.d/memcached restart
sudo /etc/init.d/nginx restart

# Source for Roboticsfaq.com
=======
# 安装文档

## 运行环境

Linux、BSD 或 Mac OS X
Ruby 2.1.5
Nginx + Thin
MySQL 或 PostgreSQL
Node.js



sudo apt-get install ffmpegthumbnailer

### 安装所需Gem

执行以下命令:

`bundle install --without development test`

这可能需要4 ~ 5分钟时间，耐心等待

### 拷贝database.yml,setting.yml,public文件夹
`copy oldversion/config/database.yml newversion/config/database.yml`

`copy oldversion/config/setting.yml newversion/config/setting.yml`

`copy -R oldversion/public newversion/`

## 配置MySQL数据库
执行以下命令:

`cp config/database.yml.mysql config/database.yml`

然后用编辑器(vim)打开 config/database.yml，会看到如下内容:

 	 default: &default
  	adapter: mysql2
  	encoding: utf8
  	reconnect: false
  	pool: 5
  	username: root
  	password:
  	socket: /tmp/mysql.sock

其中 username 和 password 就是连接 MySQL 数据库使用的用户名和密码，分别填入相应信息即可。
另外，需要把配置中的 socket，修改为命令 mysql_config --socket 所对应的输出。

例如，在我的系统上，mysql_config --socket 的输出为:

`/var/run/mysqld/mysqld.sock`

那么这里的 socket: /tmp/mysql.sock 就应该修改成:

`socket: /var/run/mysqld/mysqld.sock`

### 加载数据库结构
执行以下命令:

`RAILS_ENV=production bundle exec rake db:setup`

### 预编译assets
执行以下命令:

`RAILS_ENV=production bundle exec rake assets:precompile`

### 更新数据库
`RAILS_ENV=production bundle exec rake db:migrate`


### 使用solr

启动solr

`RAILS_ENV=production bundle exec rake sunspot:solr:start`

重建solr索引

`RAILS_ENV=production bundle exec rake sunspot:solr:reindex`

## 生成sitemap

`RAILS_ENV=production bundle exec rake sitemap:generate`

## 使用 Nginx + Thin 部署roboticsfaq
### 安装 Thin
执行以下命令:

`gem install thin`

### 生成 Thin 配置文件
执行以下命令:

`thin config -C ~/roboticsfaq.yml -s1 -e production -p 3000 -a 127.0.0.1`

### 启动 Thin
执行以下命令:

`bundle exec thin start -C ~/roboticsfaq.yml`

### 配置 Nginx

`/etc/nginx/site-aviable/roboticsfaq.com`


```

server {
	server_name www.roboticsfaq.com;
	rewrite ^(.*) http://roboticsfaq.com$1 permanent;
}
server {
    server_name  video.roboticsfaq.com;
    rewrite ^(.*) http://roboticsfaq.com/video permanent;
}
upstream thin {
  server 127.0.0.1:3001;
 #server unix:/tmp/thin.0.sock fail_timeout=0;
}
server {
	listen 80;
	server_name roboticsfaq.com;
	access_log /var/log/nginx/roboticsfaq.com.access.log;
	error_log /var/log/nginx/roboticsfaq.com.error.log debug;
	root /home/brucebot/public_html/roboticsfaq.com/public;
	index index.html;
	location / {
		try_files $uri @roboticsfaq;
	}
	location @roboticsfaq {
		proxy_set_header X-Real-IP $remote_addr;
		proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
		proxy_set_header Host $http_host;
		proxy_redirect off;
		client_max_body_size 4M;
		client_body_buffer_size 128K;
		proxy_pass http://thin;
	}
	# redirect server error pages to the static page /50x.html
	error_page   500 502 503 504  /50x.html;
	location = /50x.html {
		root   html;
	}
}
```

如果网站样式没有显示，应该是目录权限的问题，执行一下命令即可:

`chmod -R a+x /home/ubuntu/roboticsfaq`


