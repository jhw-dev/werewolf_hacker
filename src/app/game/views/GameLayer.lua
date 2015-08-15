--
-- @authors haibo
-- @email sean.ma@juhuiwan.cn
-- @date 2015-08-14 15:18:58
--

local GameLayer = class("GameLayer", function( ... )
	return cc.Layer:create()
end)

local Card = import(".Card")
GameLayer.CARD_NUM = 8
-- local Conf = 

function GameLayer:ctor( ... )
	self.cards_ = {}
	self.winSize_ = cc.Director:getInstance():getWinSize()
	self.cardNum_ = GameLayer.CARD_NUM

	self:initCards()
end

-- 生成背景
function GameLayer:genBg(filename)
	local bg = cc.Sprite:create(filename)
	self:addChild(bg)
end

-- 初始化卡牌
function GameLayer:initCards( ... )
	-- 创建卡牌层
	self.cardLayer_ = cc.Layer:create()
	self.cardLayerMargin_ = 50
	self.cardLayer_:setPosition(self.cardLayerMargin_, display.cy)

	local card
	card = Card:create(1)
	local cardMargin = self:calcuCardMargin(card)

	for i=1, self.cardNum_ do
		card = Card:create(i)
		self:paibanCards(card, i, cardMargin)
		self.cardLayer_:addChild(card)
		
		table.insert(self.cards_, card)
	end
	self:addChild(self.cardLayer_)
end
 
function GameLayer:calcuCardMargin(card)
	local cardLayerWidth = self.winSize_.width - self.cardLayerMargin_*2
	local rows = card:getRows()
	local cols = card:getCols()
	local margin = (cardLayerWidth-card:getContentSize().width*cols)/3.0
	printf("margin is %s",margin)
	return margin
end

-- 排版
function GameLayer:paibanCards(card, index, cardMargin)
	local row = 1
	if index > 4 then
		row = row+1
		index = index-4
	end

	local cardWidth = card:getContentSize().width
	local cardHeight = card:getContentSize().height
	local x = cardWidth / 2.0 + (index-1) * (cardWidth + cardMargin)
	local y = cardHeight/2.0+(row-1)*(cardHeight+cardMargin)
	card:setPosition(x, y)
end

return GameLayer