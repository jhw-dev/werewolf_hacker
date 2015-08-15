--
-- @authors haibo
-- @email sean.ma@juhuiwan.cn
-- @date 2015-08-15 14:50:56
--

local Popu=class("Popu",cc.load("mvc").ViewBase)
Popu.RESOURCE_FILENAME = "PopuLayer.csb"
Popu.RESOURCE_BINDING={tips={varname="tips"}}
function Popu:onCreate()
    
end

function Popu:getTipsTxt( ... )
	return self.tips
end

return Popu