--
-- @authors haibo
-- @email sean.ma@juhuiwan.cn
-- @date 2015-08-14 15:18:58
--

local GameLayer = class("GameLayer", function( ... )
	return cc.Layer:create()
end)

local Card = import(".Card")
-- local Conf = 

function GameLayer:ctor( ... )
	self.cards_ = {}
	self.winSize_ = cc.Director:getInstance():getWinSize()

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
	self.cardLayer_:setPosition(display.left+self.cardLayerMargin_, display.cy)

	local card
	card = Card:create()
	local cardMargin = self:calcuCardMargin(card)

	for i=1, 8 do
		card = Card:create(i)
		self.cardLayer_:addChild(card)
		self:paibanCards(card, i, cardMargin)
		table.insert(self.cards_, card)
	end
	self:addChild(self.cardLayer_)
end
 
function GameLayer:calcuCardMargin(card)
	local cardLayerWidth = self.winSize_.width - self.cardLayerMargin_*2
	local rows = card:getRows()
	local cols = card:getCols()
	local margin = (cardLayerWidth-card:getContentSize().width*cols)/3.0
	return margin
end

-- 排版
function GameLayer:paibanCards(card, index, cardMargin)
	local function calcuRow(v)
		local row = 1
		if v >= 5 then
			row = row+1
		end
		return row
	end
	local cardWidth = card:getContentSize().width
	local cardHeight = card:getContentSize().height
	local col = index-card:getCols()*math.floor(index/card:getCols())
	local row = calcuRow(index)
	local x = cardWidth / 2.0 + (col-1) * (cardWidth + cardMargin)
	local y = cardHeight/2.0+(row-1)*(cardHeight+cardMargin)
	card:setPosition(x, y)
end

return GameLayer