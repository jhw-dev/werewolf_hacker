local Card = import(".Card")
local Popu = import(".Popu")

local GameScene = class("GameScene",cc.load("mvc").ViewBase)

GameScene.RESOURCE_FILENAME = "GameScene.csb"
GameScene.RESOURCE_BINDING={card_layer={varname="card_layer"},
                            card_self={varname="card_self"},
    readyBtn={varname="readyBtn"},msg={varname="msg"},
    prototedBtn={varname="prototedBtn"}}



function GameScene:onCreate()
printInfo("INFOMES CHARLES!!")
printInfo("天黑拉！！！！")
    self.user_list={
        --testInfo
        userNumber = 8, userInfo = {
            {roleId = 1, cardType = 5, isSheriff = false, werewolfState = 1, guardState = 0, witchState = 0},
            {roleId = 2, cardType = 1, isSheriff = false, werewolfState = 1, guardState = 0, witchState = 0},
            {roleId = 3, cardType = 2, isSheriff = false, werewolfState = 1, guardState = 0, witchState = 0},
            {roleId = 4, cardType = 4, isSheriff = false, werewolfState = 1, guardState = 0, witchState = 0},
            {roleId = 5, cardType = 1, isSheriff = false, werewolfState = 1, guardState = 0, witchState = 0},
            {roleId = 6, cardType = 3, isSheriff = false, werewolfState = 1, guardState = 0, witchState = 0},
            {roleId = 7, cardType = 5, isSheriff = false, werewolfState = 1, guardState = 0, witchState = 0},
            {roleId = 8, cardType = 1, isSheriff = false, werewolfState = 1, guardState = 0, witchState = 0},
        }

        -- userNumber = ?, userInfo = { ????}
    }



    self:resetSetSceneSize()
    self.card_lst = {}
    self.data=nil

   local socket = self.app_:getSocket()
    socket:register(1003,function(data)
        --这里是开始播放天黑的场景拉
        -- printInfo("天黑拉！！！！")
        -- self:showPopu("天黑拉！！！！")
        self.msg:setString("天黑拉~~")
        self:showPopu("天黑拉~~")
   end);
   
    socket:register(1004,function(data)
        --这里是开始播放守卫下一步的语音
        printInfo("守卫守着的人")
        self.msg:setString("守卫已经守人了~~")

        self:showPopu("守卫已经守人了~~,守的人的id"..data.id)
    end);


    
    
    socket:register(1005,function(data)
         --预言家预言结果
         printInfo("预言家")
         self:showPopu("被验人的id为"..data.id)
         
            
    end)
    socket:register(1007,function(data)
        printInfo("狼人杀人结果")
        self:showPopu(data.id.."号玩家被杀")
    end)
    
    socket:register(1009,function(data)
        printInfo("死亡人数列表")
        self:showPopu(data.id.."死了，天亮了")
    end)
    
    socket:register(1011,function(data)
        self:showPopu("开始选警长")
        printInfo("广播选警长")
    end)
    socket:register(1012,function(data)
        self:showPopu("选警长结果："..data.id)
            printInfo("选警长的结果")
    end)
    socket:register(1013,function(data)
        if self:checkIfDied(data.id) then
            self:showPopu(data.id.."玩家死了")
        else
            self:showPopu("今天晚上平安夜")
        end
        printInfo("投票杀人结果")
    end)
    socket:register(1014,function(data)
        if data.id == 1 then
        else
            
        end
        printInfo("结算数据")
    end)
    socket:register(1015,function(data)
        printInfo("移交警长的结果")
    end)

    
end

-- 判断是否有人死
function GameScene:checkIfDied(id)
    if id == 0 then
        return false
    end
    return true
end

-- 弹框提示
function GameScene:showPopu(txt)
    self.popu = Popu:create()
    self:addChild(self.popu)
    self:chgTips(txt)
end

function GameScene:chgTips(txt)
    local tips = self.popu:getTipsTxt()
--    tips:setString(txt)
end

function GameScene:initData(value)
    self.data = value

    local index=1;
    for key, data in pairs(self.data.roleList) do

        printInfo("key:::"..key.." "..data.type.."  "..data.id.."   "..data.num)
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
    self:showPopu("请准备~~")
    local socket = self:getApp():getSocket()
    --准备游戏请求
    self.readyBtn:addTouchEventListener(function(sender,type)
        if type==TOUCH_EVENT_ENDED then
             self.readyBtn:setTouchEnabled(false)
             self.readyBtn:setTitleText("等待其他玩家准备!!!")
             socket:send(1003,{id=self.data.id})
        end
     end)
     
    self.prototedBtn:addTouchEventListener(function(sender,type)
        if type==TOUCH_EVENT_ENDED then
            self.prototedBtn:setTouchEnabled(false)
            local data={id=1001}
            socket:send(1004,data)
        end
     end)
end




return GameScene