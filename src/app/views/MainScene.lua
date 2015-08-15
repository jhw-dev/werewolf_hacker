
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

MainScene.RESOURCE_FILENAME = "MainScene.csb"

function MainScene:onCreate()
    printf("resource node = %s", tostring(self:getResourceNode()))

    self:initViews()
end

function MainScene:initViews( ... )

	local startBtn = self:getResourceNode():getChildByName("start")
	local function touchEvent(sender,eventType)
        if eventType == ccui.TouchEventType.began then
            printInfo("Touch Down")
        elseif eventType == ccui.TouchEventType.moved then
            printInfo("Touch Move")
        elseif eventType == ccui.TouchEventType.ended then
            printInfo("Touch Up")
            self:getApp():enterScene("GameScene")
          

        elseif eventType == ccui.TouchEventType.canceled then
            printInfo("Touch Cancelled")
        end
    end
    --
    startBtn:addTouchEventListener(touchEvent)

    
   -- self.app_:getSocket():register(1001,function(data)
   --      printInfo("ads")
   --  end)
        
        
        
        
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
