# Makefile six

.PHONY: docs clean start build setup certs

help:
	@echo "setup    - 安装基本依赖(初始化)"
	@echo "fetch    - 更新版本库最新代码"
	@echo "clean    - 清理编译垃圾数据"
	@echo "certs    - 构建服务器证书"
	@echo "build    - 编译所需镜像"
	@echo "start    - 开始项目容器"
	@echo "stop     - 停止项目容器"
	@echo "docs     - 构建在线文档"
	@echo "destry   - 销毁项目容器"
	@echo "restart  - 重启项目容器"

destry:
	docker-compose rm -a -f

clean:
	rm -rf project/app

fetch:
	rm -rf project/app && git clone https://github.com/bopo/mooquant.git project/app

build: 
	docker build compose/mooquant -t mooquant:0.2.6 
	docker build compose/notebook -t notebook:mooquant 

certs:
	openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout project/certs.pem -out project/certs.pem

docs: 
	cd project/app && mkdocs build && cd -

stop: 
	docker-compose stop

start: 
	docker-compose start

setup:
	docker-compose up -d
	docker-compose run --rm django python3 manage.py migrate
	docker-compose run --rm django python3 manage.py createsuperuser
	docker-compose run --rm django python3 manage.py collectstatic --no-input

restart: 
	docker-compose restart

# DO NOT DELETE
