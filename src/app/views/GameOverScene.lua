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

	self.continueBtn:addTouchEventListener(function(sender,type)
        if type==TOUCH_EVENT_ENDED then
--          
            self:getApp():enterScene("GameScene")
        end
    end)
	
	-- self.tips:
end



return GameOverScene