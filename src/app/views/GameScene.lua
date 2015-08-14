local Card = import(".Card")

local GameScene = class("GameScene",cc.load("mvc").ViewBase)

GameScene.RESOURCE_FILENAME = "GameScene.csb"
GameScene.RESOURCE_BINDING={card_layer={varname="card_layer"},
                            card_self={varname="card_self"}}

function GameScene:onCreate()
    self:resetSetSceneSize()
    self.card_lst = {}
    
    for var=1, 8 do
        local card=  Card:create()
        local size = card:getContentSize()
        local row = (var-1)%4
        local cos = math.ceil(var/4)-1
        card:setPositionX(row*size.width)
        card:setPositionY(cos*size.height)
        self.card_layer:addChild(card)
    end
    
    
end

return GameScene