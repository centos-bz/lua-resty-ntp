-- Copyright (C) Maohai Zhu (admin@centos.bz).

local struct = require("struct")
local ngx_socket_udp = ngx.socket.udp
local table_concat = table.concat

local function connect(ntp_server, timeout)
    -- set timeout
    local sock = ngx_socket_udp()

    -- connect ntp server
    sock:settimeout(timeout)
    local ok, err = sock:setpeername(ntp_server, 123)
    if not ok then
        return nil, table_concat({"failed to connect to ntp: ", err})
    end

    -- pack and send data to ntp server
    local data = struct.pack("<IIIIIIIIIIII",0x23,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0)
    sock:settimeout(timeout)
    local ok, err = sock:send(data)
    if not ok then
        return nil, "failed to send."
    end

    -- receive data
    sock:settimeout(timeout)
    local data, err = sock:receive()
    if not data then    
        return nil, table_concat({"failed to read a packet: ", err})
    end
    sock:close()

    -- unpack data
    local _,_,_,_,_,_,_,_,time = struct.unpack(">IIIIIIIII",data)
    local utc_time = time - 2208988800
    return utc_time, err

end

local function utctime(ntp_server, retry, timeout)
    -- check the parameter
    if not ntp_server then
        return nil, "ntp_server is nil"
    end
    
    if not retry then
        return nil, "retry is nil"
    end

    if not timeout then
        return nil, "timeout is nil"
    end

    local utc_time, err

    for i=1,retry do
        utc_time, err = connect(ntp_server, timeout)
        if utc_time then
            break
        end    
    end
    return utc_time, err
    
end

return {
    utctime = utctime
}