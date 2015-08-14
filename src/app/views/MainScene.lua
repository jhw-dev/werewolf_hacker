
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

MainScene.RESOURCE_FILENAME = "MainScene.csb"
MainScene.RESOURCE_BINDING={startBtn={varname="startBtn"}}

function MainScene:onCreate()
    printf("resource node = %s", tostring(self:getResourceNode()))
    self:resetSetSceneSize()
    self.startBtn:addTouchEventListener(function(sender,type)
        if type==TOUCH_EVENT_ENDED then
--            self.app_:getSocket():register(1001,function(data)
--                printInfo("ads")
--            end)
            local node = self.app_:createView("GameScene")
            local scene = display.newScene("GameScene")
            scene:addChild(node)
            local transition=cc.TransitionMoveInR:create(0.5,scene)
            cc.Director:getInstance():replaceScene(transition)
        end
    end)
    
    
   
        
        
--        for var=1, 8 do
--        local Card = new Card("res/Node.csb")
--        addChild(card)
--        end
       
        
        
        
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
