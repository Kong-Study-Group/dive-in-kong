#!/bin/bash

# For CentOS Linux release 7.3.1611 (Core)
# install jekyll development environment

ROOT=$1

if [ $# -eq 0 ]; then
    echo "enter root dir"
    exit 1
fi

if [ ! -d "$ROOT" ]; then
    echo "$ROOT not exsit"
    exit 1
fi

cd $ROOT || exit 1

sudo yum -y install nodejs npm ntpdate
sudo yum -y install ruby ruby-devel gem
sudo yum -y install libffi-devel libffi
sudo yum -y groupinstall development tools
sudo npm install -g cnpm --registry=https://registry.npm.taobao.org

sudo ntpdate 133.100.11.8 || exit 1

gem sources --add https://gems.ruby-china.org/ --remove https://rubygems.org/
gem install bundler || exit 1
bundle config mirror.https://rubygems.org https://gems.ruby-china.org || exit 1

bundle add json --version=2.1.0
cnpm install
cnpm test
cnpm start
