--
-- @authors haibo
-- @email sean.ma@juhuiwan.cn
-- @date 2015-08-14 15:20:41
--
local Card = class("Card", function( ... )
	cc.Node:create()
end)

function Card:ctor( ... )
	self.filename_ = nil
	self.roleId_ = 1
	self:initViews()
end

-- 初始化
function Card:initViews( ... )
	-- 创建身份牌
	self.roleSprite_ = cc.Sprite:create(self.filename_)
	self:addChild(self.roleSprite_)

	self.indexLabel_ = cc.Label:create()
	self.indexLabel_:setString(self.roleId_.."号")
	self.indexLabel_:setTextColor(cc.c3b(0,0,0))
	self.indexLabel_:setTitleSize(45)
	self:addChild(self.indexLabel_)

	self:adjustCardPos()
end

function Card:adjustCardPos( ... )
	local x,y
	x = self.roleSprite_:getContentSize().width/2.0
	y = self.roleSprite_:getContentSize().height/2.0
	self.indexLabel_:setPosition(x,y)
end

function Card:refreshCard(index)
	self.indexLabel_:setString(index.."号")
end

return Card