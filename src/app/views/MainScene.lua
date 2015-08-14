
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

MainScene.RESOURCE_FILENAME = "MainScene.csb"

function MainScene:onCreate()
    printf("resource node = %s", tostring(self:getResourceNode()))
    
   
        
        
        
        
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
