--
-- @authors haibo
-- @email sean.ma@juhuiwan.cn
-- @date 2015-08-15 14:50:56
--

local Popu=class("Popu",cc.load("mvc").ViewBase)
Popu.RESOURCE_FILENAME = "PopuLayer.csb"
Popu.RESOURCE_BINDING={tipsMsg={varname="tipsMsg"}}
function Popu:onCreate()
    
end

function Popu:getTipsTxt( ... )
	return self.tipsMsg
end

return Popu