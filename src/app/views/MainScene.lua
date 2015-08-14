
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

MainScene.RESOURCE_FILENAME = "MainScene.csb"

function MainScene:onCreate()
    printf("resource node = %s", tostring(self:getResourceNode()))
    
    local socket = cc.WebSocket:create("ws://127.0.0.1:8080")
    socket:registerScriptHandler(function(value)
        printInfo("Open Socket Server Success!!")

        local json=require("json")
        local t={t="test"}
        local send_data=json.encode(t)
        socket:sendString(send_data)
        
    end,cc.WEBSOCKET_OPEN)
    socket:registerScriptHandler(function(value)
            local data = require("json").decode(value)
            printInfo("Recviec Messgae:%s",value)
        end,cc.WEBSOCKET_MESSAGE)
        
        socket:registerScriptHandler(function(VALUE)
            printInfo("Close")
        
        end,cc.WEBSOCKET_CLOSE)
        socket:registerScriptHandler(function(value)
            printInfo("error")
        end,cc.WEBSOCKET_ERROR)
        
        
        
        
--    socket:sendString("Test")
    
--    if nil ~= wsSendText then 
--        wsSendText:registerScriptHandler(wsSendTextOpen,cc.WEBSOCKET_OPEN) 
--        wsSendText:registerScriptHandler(wsSendTextMessage,cc.WEBSOCKET_MESSAGE) 
--        wsSendText:registerScriptHandler(wsSendTextClose,cc.WEBSOCKET_CLOSE) 
--        wsSendText:registerScriptHandler(wsSendTextError,cc.WEBSOCKET_ERROR) 
--    end 
--    socket:registerScriptHandler(handler,type)
end

return MainScene
