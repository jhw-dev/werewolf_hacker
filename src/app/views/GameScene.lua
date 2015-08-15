local Card = import(".Card")

local GameScene = class("GameScene",cc.load("mvc").ViewBase)

GameScene.RESOURCE_FILENAME = "GameScene.csb"
GameScene.RESOURCE_BINDING={card_layer={varname="card_layer"},
                            card_self={varname="card_self"}}

function GameScene:onCreate()
    self:resetSetSceneSize()
    self.card_lst = {}
    self.data=nil
   
    
    
end


function GameScene:initData(value)
    self.data = value
    local index=1;
    for key, data in pairs(self.data.roleList) do
        local card=  Card:create()
        card:setData(data)
        local size = card:getContentSize()
        local row = (index-1)%4
        local cos = math.ceil(index/4)-1
        card:setPositionX(row*size.width)
        card:setPositionY(cos*size.height)
        self.card_layer:addChild(card)
        index=index+1
    end
end

return GameScene