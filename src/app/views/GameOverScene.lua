--
-- @authors haibo
-- @email sean.ma@juhuiwan.cn
-- @date 2015-08-15 11:29:04
--
local GameOverScene = class("GameOverScene",cc.load("mvc").ViewBase)
GameOverScene.RESOURCE_FILENAME = "GameOverScene.csb"
GameOverScene.RESOURCE_BINDING={continueBtn={varname="continueBtn"},
	tips = {varname="tips"}}
function GameOverScene:onCreate( ... )
    
    self:resetSetSceneSize()
    
	self.continueBtn:addTouchEventListener(function(sender,type)
        if type==TOUCH_EVENT_ENDED then
            local node = self.app_:createView("MainScene")
            local scene = display.newScene("MainScene")
            scene:addChild(node)
            local transition=cc.TransitionMoveInL:create(0.5,scene)
            cc.Director:getInstance():replaceScene(transition)
        end
    end)
	
	-- self.tips:
end


function GameOverScene:setValue(val)
    local str = "狼人获胜！！"
    if val==2 then
        str = "平民和神获胜！！"
    end
    self.tips:setString(str)
end


return GameOverScene