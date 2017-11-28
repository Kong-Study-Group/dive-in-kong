# kong的入口在哪里？

## nginx.conf
因为openresty的唯一入口是Nginx.conf，kong也不会例外

```lang=code
snippet-1

1   init_by_lua_block {
2     kong = require 'kong'
3     kong.init()
4    }
```

snippet-1#L2是最关键的代码。但是从源码中，并没有找到kong.lua。从种种迹象(NGINX.CONF引用的多个函数)是指向kong/init.lua，不合理呀~

再看看nginx.conf配置文件

```lang=code
snippet-2

1   lua_package_path '?/init.lua;./kong/?.lua;/root/resthub-edge/?.lua;;';
```

很明显，`require kong`命中了加载规则`?/init.lua`。

这样就解释了snippet-1#L2的合理性。

## kong.lua

如果你查看过kong的安装目录，就会发现kong.lua（/usr/local/share/lua/5.1/kong.lua）是存在的，这又是什么原因呢？

从源码安装kong的时候使用的是`make install`，那我们来看看Makefile文件吧

```lang=code
snippet-3

1   .PHONY: install dev lint test test-integration test-plugins test-all
2
3   install:
4       @luarocks make OPENSSL_DIR=$(OPENSSL_DIR)
```

从snippet-3#L4可以看出，lua代码是使用luarocks安装的，那我们看看它的配置文件`kong-0.11.1-0.rockspec`


```
 1 build = {
 2   type = "builtin",
 3   modules = {
 4     ["kong"] = "kong/init.lua",
 5     ["kong.meta"] = "kong/meta.lua",
 6     ["kong.constants"] = "kong/constants.lua",
 7     ["kong.singletons"] = "kong/singletons.lua",
 8     ["kong.conf_loader"] = "kong/conf_loader.lua",
```

从snippet-4#L4可以看出，luarocks在安装的时候，把init.lua改名为kong.lua，并且上移了一层目录。

why？我也不知道，只能去问问kong的社区问问了。

