
local MainScene = class("MainScene", cc.load("mvc").ViewBase)
local PopLayer = import(".Popu")

MainScene.RESOURCE_FILENAME = "MainScene.csb"
MainScene.RESOURCE_BINDING={startBtn={varname="startBtn"}}

function MainScene:onCreate()
    printf("resource node = %s", tostring(self:getResourceNode()))
    self:resetSetSceneSize()
    -- audio.playMusic("music/bg1.mp3",true)
    
    local socket = self.app_:getSocket()
    socket:register(1016,function(data)
        local pop=PopLayer:create()
        pop:getTipsTxt():setString("有玩家掉线!")
        cc.Director:getInstance():getRunningScene():addChild(pop)
        pop:setVisiableBtn(false)

    end)
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
            startBtn:setTouchEnabled(false)
            local pop=PopLayer:create()
            pop:getTipsTxt():setString("等待其他玩家加入,请稍后!")
            cc.Director:getInstance():getRunningScene():addChild(pop)
            pop:setVisiableBtn(false)
            socket:send(1001)
-- local str="{\"cmd\":1002,\"data\":{\"id\":1007,\"type\":4,\"num\":8,\"roleList\":[ {\"id\":1001,\"type\":5,\"num\":7},{\"id\":1002,\"type\":1,\"num\":3},{\"id\":1005,\"type\":2,\"num\":4},{\"id\":1003,\"type\":1,\"num\":6},{\"id\":1006,\"type\":4,\"num\":5},{\"id\":1004,\"type\":1,\"num\":2},{\"id\":1007,\"type\":5,\"num\":8},{\"id\":1008,\"type\":3,\"num\":1}]}}"
-- socket:recive(str)
        end
    end)
    audio.playMusic("music/bg.mp3",true)
    audio.setMusicVolume(0.4)
    audio.playSound("music/juhuiwantips.mp3",false)

   
        
        
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
