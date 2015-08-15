
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

MainScene.RESOURCE_FILENAME = "MainScene.csb"
MainScene.RESOURCE_BINDING={startBtn={varname="startBtn"}}

function MainScene:onCreate()
    printf("resource node = %s", tostring(self:getResourceNode()))

    self:initViews()
end

function MainScene:initViews( ... )

--	local startBtn = self:getResourceNode():getChildByName("start")
--	local function touchEvent(sender,eventType)
--        if eventType == ccui.TouchEventType.began then
--            printInfo("Touch Down")
--        elseif eventType == ccui.TouchEventType.moved then
--            printInfo("Touch Move")
--        elseif eventType == ccui.TouchEventType.ended then
--            printInfo("Touch Up")
--            self:getApp():enterScene("GameScene")
--
--
--        elseif eventType == ccui.TouchEventType.canceled then
--            printInfo("Touch Cancelled")
--        end
--    end
--    --
--    startBtn:addTouchEventListener(touchEvent)

    
   -- self.app_:getSocket():register(1001,function(data)
   --      printInfo("ads")
   --  end)
    self:resetSetSceneSize()
    
    local socket = self.app_:getSocket()
    socket:register(1002,function(data)
        -- 这里返回的是登录后的数据
        local node = self.app_:createView("GameScene")
        node:initData(data)
        local scene = display.newScene("GameScene")
        scene:addChild(node)
        local transition=cc.TransitionMoveInR:create(0.5,scene)
        cc.Director:getInstance():replaceScene(transition)
    end)
    
    local startBtn = self.startBtn
    self.startBtn:addTouchEventListener(function(sender,type)
        if type==TOUCH_EVENT_ENDED then
--          
--            startBtn:setTouchEnabled(false)
--            startBtn:setTitleText("正在等待其他成员的加入，请稍后!!!")
--            socket:send(1001)
            local node = self.app_:createView("GameScene")
            node:initData(data)
            local scene = display.newScene("GameScene")
            scene:addChild(node)
            local transition=cc.TransitionMoveInR:create(0.5,scene)
            cc.Director:getInstance():replaceScene(transition)
        end
    end)
    
    local str="{\"cmd\":1002,\"data\":{\"id\":1002,\"type\":1,\"num\":7,\"roleList\":[{\"id\":1001,\"type\":2,\"num\":0},{\"id\":1002,\"type\":1,\"num\":7}]}}"
    socket:recive(str)
     
    
   

        
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
