--
-- @authors haibo
-- @email sean.ma@juhuiwan.cn
-- @date 2015-08-14 16:35:43
--

local CardModel = class("CardModel")

local Conf = import("..Conf")

function CardModel:ctor( ... )
	-- body
end

function CardModel:getCardBack( ... )
	return Conf.RES.card_back
end

return CardModel