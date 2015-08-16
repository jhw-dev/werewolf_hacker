--
-- @authors haibo
-- @email sean.ma@juhuiwan.cn
-- @date 2015-08-15 14:50:56
--

local Popu=class("Popu",cc.load("mvc").ViewBase)
Popu.RESOURCE_FILENAME = "PopuLayer.csb"
Popu.RESOURCE_BINDING={tipsMsg={varname="tipsMsg"},
	ensureBtn={varname="ensureBtn"},
}

function Popu:onCreate()
    
    self.resourceNode_:setScale(0)
    self.resourceNode_:runAction(cc.EaseBackOut:create(cc.ScaleTo:create(0.5,1)));
    
    local winSize = cc.Director:getInstance():getVisibleSize();
    local colorLayer = cc.LayerColor:create(cc.c4b(0,0,0,125.0))
    
    colorLayer:setContentSize(winSize)
    self:addChild(colorLayer,-1);
    self.ensureBtn:addTouchEventListener(function(sender,type)
	    if type==TOUCH_EVENT_ENDED then
	           
	        local callback = self.ensureCallback_
            local action=cc.Sequence:create({cc.EaseBackOut:create(cc.ScaleTo:create(0.5,0)),cc.CallFunc:create(function()
                self:removeFromParentAndCleanup();
                if callback then
                    callback()
                end
            end)})
            self.resourceNode_:runAction(action);
            
	    end
    end)
end

function Popu:getTipsTxt( ... )
	return self.tipsMsg
end

function Popu:setOnEnsureCallback(callback)
	self.ensureCallback_ = callback
end

function Popu:setVisiableBtn(value)
    self.ensureBtn:setVisible(value)
    self.ensureBtn:setTouchEnabled(value)
--    self.ensureBtn:
    
end

return Popu