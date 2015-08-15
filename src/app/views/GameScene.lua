local Card = import(".Card")

local GameScene = class("GameScene",cc.load("mvc").ViewBase)

GameScene.RESOURCE_FILENAME = "GameScene.csb"
GameScene.RESOURCE_BINDING={card_layer={varname="card_layer"},
                            card_self={varname="card_self"},
    readyBtn={varname="readyBtn"},msg={varname="msg"},
    prototedBtn={varname="prototedBtn"}}

function GameScene:onCreate()
    self:resetSetSceneSize()
    self.card_lst = {}
    self.data=nil
   
   local socket = self.app_:getSocket()
    socket:register(1003,function(data)
        --这里是开始播放天黑的场景拉
        printInfo("天黑拉！！！！")
        self.msg:setString("天黑拉~~")
   end);
    
    
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
    self.msg:setString("请准备~~")
    local socket = self:getApp():getSocket()
    --准备游戏请求
    self.readyBtn:addTouchEventListener(function(sender,type)
        if type==TOUCH_EVENT_ENDED then
             self.readyBtn:setTouchEnabled(false)
             self.readyBtn:setTitleText("等待其他玩家准备!!!")
             socket:send(1003,{id=self.data.id})
        end
     end)
     
     self.prototedBtn:addTouchEventListener(function(sender,tyoe)
        if type==TOUCH_EVENT_ENDED then
            self.readyBtn:setTouchEnabled(false)
            self.readyBtn:setTitleText("等待其他玩家准备!!!")
            local data={id="被守人的id"}
            socket:send(1004,data)
        end
     end)
end

return GameScene