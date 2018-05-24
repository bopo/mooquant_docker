# -*- coding: utf-8 -*-

import os
import time

from fabric.api import cd, env, local, run, task
from fabric.context_managers import prefix
from fabric.contrib import django, project
from fabric.contrib.console import prompt

env.roledefs = {
    'dev': ['root@10.7.7.22'],
    'pre': ['root@121.42.154.8'],
}

env.excludes = (
    "*.pyc", "*.db", ".DS_Store", ".coverage", ".git", ".hg", ".tox", ".idea/",
    'assets/',  'runtime/','db.sqlite3', 'tests', 'docs', '__pycache__', 
    'config', 'env.docker', 'env.server', 'docs')

env.remote_dir = '/home/passport/docker'
env.local_dir = './project/app/'

@task
def init():
  '''远程初始化 docker 部署'''
  run('make build')
  run('make setup')
  run('make docs')

@task
def unix():
    '''文本文件 windows 格式转 unix 格式'''
    local('find ./compose "*.yaml" | xargs dos2unix')
    local('find ./compose "*.yml" | xargs dos2unix')
    local('find . "Makefile" | xargs dos2unix')
    local('find . "Dockerfile" | xargs dos2unix')

@task
def pull():
    '''更新源码文件'''
    local('rm -rf project/app && git clone ssh://git@10.7.7.22:10022/sector3/passport.git project/app')

@task
def stat():
    '''更新静态文件'''
    with cd(env.remote_dir):
        run('docker-compose run --rm django python3 manage.py collectstatic --noinput')


@task
def sync():
    '''同步服务器代码'''
    project.rsync_project(
        remote_dir=env.remote_dir + '/project/app/', 
        local_dir=env.local_dir, 
        exclude=env.excludes, 
        delete=False
    )

@task
def migr():
    '''合并数据文件'''    
    with cd(env.remote_dir):
        run('''docker-compose run --rm django python3 manage.py migrate''')

@task
def docs():
    '''合并数据文件'''    
    with cd(env.remote_dir + '/project/app/'):
        run('''/root/.pyenv/shims/mkdocs build''')

@task()
def init():
    '''初始化服务'''
    local_dir = os.getcwd() + os.sep
    project.rsync_project(
        remote_dir=env.remote_dir, 
        local_dir=local_dir, 
        exclude=env.excludes, 
        delete=True
    )
    
    with cd(env.remote_dir):
        run('docker-compose up -d')

@task()
def rest():
    '''重启服务'''    
    with cd(env.remote_dir):
        run('docker-compose restart')


@task
def stop():
    '''停止服务'''    
    with cd(env.remote_dir):
        run('docker-compose stop')

@task
def pack(time=None):
    '''文件打包'''    
    local('tar zcfv ./pack.tgz '
          '--exclude=.git '
          '--exclude=.tox '
          '--exclude=.svn '
          '--exclude=.idea '
          '--exclude=*.tgz '
          '--exclude=*.pyc '
          '--exclude=.vagrant '
          '--exclude=tests '
          '--exclude=storage '
          '--exclude=database '
          '--exclude=.DS_Store '
          '--exclude=.phpintel '
          '--exclude=.template '
          '--exclude=db.sqlite3 '
          '--exclude=Vagrantfile .')


