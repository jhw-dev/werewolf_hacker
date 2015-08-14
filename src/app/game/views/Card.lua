--
-- @authors haibo
-- @email sean.ma@juhuiwan.cn
-- @date 2015-08-14 15:20:41
--
local Card = class("Card", function( ... )
	cc.Node:create()
end)

local CardModel = import("..models.CardModel")

function Card:ctor(roleId)
	-- 数据初始化
	self.cardModel_ = CardModel:create()

	self.filename_ = nil
	self.roleId_ = roleId
	self.rows_ = 2
	self.cols_ = 4

	self:initViews()

end

-- 初始化
function Card:initViews( ... )
	-- 初始化卡背
	local resouceNode = createResoueceNode("card.csb")
	self:addChild(resouceNode)

	-- self.cardBack_ = cc.Sprite:create(self.cardModel_:getCardBack())
	-- self:addChild(self.cardBack_)
	-- 创建身份牌
	-- self.roleSprite_ = cc.Sprite:create(self.filename_)
	-- self:addChild(self.roleSprite_)


	self.indexLabel_ = resouceNode:getChildByName("Text_1")

end


function Card:refreshCard(index)
	self.indexLabel_:setString(index.."号")
end

function Card:getRows( ... )
	return self.rows_
end

function Card:getCols( ... )
	return self.cols_
end

return Card