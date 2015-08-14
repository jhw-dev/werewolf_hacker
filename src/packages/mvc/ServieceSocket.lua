local ServiceSocket = class("ServeiceSocket")
local JSON = require("json")

ServiceSocket.CMD_PREFIX="cmd_"

function ServiceSocket:ctor()
    self.socket_ = nil
    self.command_list_ = {}
end

function ServiceSocket:conn(url,callback,close_callback,error_callback)
    self.socket_=cc.WebSocket:create(url)
    self.socket_:registerScriptHandler(function(value)
        printInfo("Open Socket Server:%s Success!!",url)
        if callback~=nil then
            callback(self)
        end

        --        local json=require("json")
        --        local t={t="test"}
        --        local send_data=json.encode(t)
        --        self.socket_:sendString(send_data)

    end,cc.WEBSOCKET_OPEN)
    
    self.socket_:registerScriptHandler(function(value)
        printInfo("Recviec Messgae:%s",value)
        local data = require("json").decode(value)
        local cmd=data.cmd
        local key=string.format("%s_%s",ServiceSocket.CMD_PREFIX,cmd)
        local callback= self.command_list_[key]
        if callback~=nil then
            callback(data.data)
        end
    end,cc.WEBSOCKET_MESSAGE)

    self.socket_:registerScriptHandler(function(VALUE)
        printInfo("Close")
        if close_callback~=nil then
            close_callback()
        end
    end,cc.WEBSOCKET_CLOSE)
    self.socket_:registerScriptHandler(function(value)
        printInfo("error")
        if error_callback~=nil then
            error_callback()
        end
    end,cc.WEBSOCKET_ERROR)
end

function ServiceSocket:send(command,data)
    local send_data={}
    send_data.cmd = command
    local tdata= {}
    if data~=nil then
        tdata=data
    end
    send_data.data = tdata
    local tmp_data=JSON.encode(send_data)
    self.socket_:sendString(tmp_data)
end


function ServiceSocket:register(cmd,callback)
    local key=string.format("%s_%s",ServiceSocket.CMD_PREFIX,cmd)
   self.command_list_[key] = callback
end


return ServiceSocket