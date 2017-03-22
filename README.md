Name
====

lua-resty-ntp - Get utc time from ntp server for ngx_lua and LuaJIT

Table of Contents
=================

* [Name](#name)
* [Description](#description)
* [Synopsis](#synopsis)
* [Author](#author)
* [See Also](#see-also)



Description
===========

This library requires the [ngx_lua module](http://wiki.nginx.org/HttpLuaModule), and [LuaJIT 2.0](http://luajit.org/luajit.html).

Synopsis
========

```lua
    # nginx.conf:

    lua_package_path "/path/to/lua-resty-string/lib/?.lua;;";

    server {
        location = /test {
            content_by_lua_block {
                local ntp = require "ntp"
                -- ntp.utctime(ntp_server, retry , timeout)
                local utctime,err =  ntp.utctime("pool.ntp.org", 3, 1000)
                if utctime then
                    ngx.say("utctime:",utctime)
                else
                    ngx.say("failed to get utctime: ",err)
                end           
            }
        }
    }

```

Author
======

Jason zhu (朱茂海) <admin@centos.bz>

See Also
========
* the ngx_lua module: http://wiki.nginx.org/HttpLuaModule