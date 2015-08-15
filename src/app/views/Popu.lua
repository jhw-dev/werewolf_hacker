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
    self.ensureBtn:addTouchEventListener(function(sender,type)
	    if type==TOUCH_EVENT_ENDED then

			if self.ensureCallback_ then
				self.ensureCallback_()
			end
	    end
    end)
end

function Popu:getTipsTxt( ... )
	return self.tipsMsg
end

function Popu:setOnEnsureCallback(callback)
	self.ensureCallback_ = callback
end

return Popu