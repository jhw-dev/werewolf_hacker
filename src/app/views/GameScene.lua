local Card = import(".Card")
local Popu = import(".Popu")

local GameScene = class("GameScene",cc.load("mvc").ViewBase)

GameScene.RESOURCE_FILENAME = "GameScene.csb"
GameScene.RESOURCE_BINDING={card_layer={varname="card_layer"},
                            card_self={varname="card_self"},
    readyBtn={varname="readyBtn"},msg={varname="msg"},
    -- 守卫
    prototedBtn={varname="prototedBtn"},
    -- 预言家
    yuyanBtn={varname="yuyanBtn"},
    -- 狼人杀人
    killBtn={varname="killBtn"},
    -- 女巫
    duRenBtn={varname="duRenBtn"},
    jiuRenBtn={varname="jiuRenBtn"},
    -- 选警长
    xuanjinzhangBtn={varname="xuanjinzhangBtn"},}


GameScene.PROTECTED = "PROTECTED"
GameScene.YUYAN = "YUYAN"
GameScene.KILL = "KILL"
GameScene.DUREN = "DUREN"
GameScene.JIUREN = "JIUREN"
GameScene.XUANJIN = "XUANJIN"
GameScene.READY = "READY"

GameScene.CUNMIN = 1
GameScene.SHOUWEI = 2
GameScene.YUYANJIA = 3
GameScene.NVWU = 4
GameScene.LANGREN = 5

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

    -- self.btnList_ = {
    --     GameScene.PROTECTED = self.prototedBtn,
    --     GameScene.YUYAN = self.yuyanBtn,
    --     GameScene.KILL = self.killBtn,
    --     GameScene.DUREN = self.duRenBtn,
    --     GameScene.JIUREN = self.jiuRenBtn,
    --     GameScene.XUANJIN = self.xuanjinzhangBtn,
    --     GameScene.READY = self.readyBtn
    -- }

    self.btnList_ = {
        [GameScene.PROTECTED] = self.prototedBtn,
        [GameScene.YUYAN] = self.yuyanBtn,
        [GameScene.KILL] = self.killBtn,
        [GameScene.DUREN] = self.duRenBtn,
        [GameScene.JIUREN] = self.jiuRenBtn,
        [GameScene.XUANJIN] = self.xuanjinzhangBtn,
        [GameScene.READY] = self.readyBtn
    }

    
    self:resetSetSceneSize()
    self.card_lst = {}
    self.data=nil

    -- 初始化按钮
    self:hideBtns()

   local socket = self.app_:getSocket()
    socket:register(1003,function(data)
        --这里是开始播放天黑的场景拉
        -- printInfo("天黑拉！！！！")
        -- self:showPopu("天黑拉！！！！")
        self.msg:setString("天黑拉~~")
        self:showPopu("天黑拉~~")

        self:tianHei()

        local action=cc.Sequence:create({cc.DelayTime:create(6),cc.CallFunc:create(function()
            audio.playSound("music/shouweizhenyan.mp3",false)

            if self.Image_self.type == GameScene.SHOUWEI then
                self:shouwei()
            end
        end)})
        self:runAction(action)
        
        
       
   end);
   
    socket:register(1004,function(data)
        --这里是开始播放守卫下一步的语音
        printInfo("守卫守着的人")
        self.msg:setString("守卫已经守人了~~")

        self:showPopu("守卫已经守人了~~,守的人的id"..data.id)

        self:biYan(GameScene.PROTECTED)

        local action=cc.Sequence:create({cc.DelayTime:create(6),cc.CallFunc:create(function()
            audio.playSound("music/yuyanzhenyan.mp3",false)
        end)})
        

        if self.Image_self.type == GameScene.YUYANJIA then
            self:yanren()
        end
        
    end);


    socket:register(1005,function(data)
         --预言家预言结果
        printInfo("预言家")
        if self.Image_self.type == GameScene.YUYANJIA then
            local iden = self:getRoleByType(data.type)
            self:showPopu("被验人的身份是"..iden)

            self.popu:setOnEnsureCallback(function( ... )
               socket:send(1006)
               self:biYan(GameScene.YUYANJIA)
               self:closePopu()
            end)
        end
            
    end)

     socket:register(1006,function(data)

        audio.playSound("music/langrensharen.mp3",false)

        if self.Image_self.type == GameScene.LANGREN then
            self:killRen()
        end
    end)

    
    socket:register(1007,function(data)
        printInfo("狼人杀人结果")

        self:biYan(GameScene.LANGREN)

        local action=cc.Sequence:create({cc.DelayTime:create(6),cc.CallFunc:create(function()
            audio.playSound("music/nvwuzhenyan.mp3",false)
        end)})
        
        if self.Image_self.type == GameScene.NVWU then
            self:nvwu()
        end

    end)
    
    socket:register(1009,function(data)
        printInfo("死亡人数列表")
        self:biYan(GameScene.NVWU)
        self:showPopu(data.id.."死了，天亮了")
        self:xuanJin()
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
        printInfo("结算数据")

        local node = self.app_:createView("GameOverScene")
        node:setValue(data.id)
        local scene = display.newScene("GameOverScene")
        scene:addChild(node)
        local transition=cc.TransitionMoveInR:create(0.5,scene)
        cc.Director:getInstance():replaceScene(transition)
    end)
    socket:register(1015,function(data)
        printInfo("移交警长的结果")
        self:showPopu("移交给警长："..data.id)
    end)

    audio.playSound("music/ready.mp3",false)
end

-- 改变按钮状态
function GameScene:changeState(state)
    self:hideBtns()

    self.btnList_[state]:setVisible(true)
    self.btnList_[state]:setTouchEnabled(true)
end

function GameScene:tianHei( ... )
    audio.playMusic("music/tianheibiyan.mp3",false)
end

-- 某某角色闭眼
function GameScene:biYan(role)
    if role == GameScene.CUNMIN then

    elseif role == GameScene.SHOUWEI then
        audio.playMusic("music/shouweibiyan.mp3",false)
    elseif role == GameScene.YUYANJIA then
        audio.playMusic("music/yuyanjiabiyan.mp3",false)
    elseif role == GameScene.NVWU then
        audio.playMusic("music/mvwubiyan.mp3",false)
    elseif role == GameScene.LANGREN then
        audio.playMusic("music/langrenbiyan.mp3",false)
    end
end

-- 隐藏按钮
function GameScene:hideBtns(...)
    -- for k, v in pairs(...) do


    -- end
    for k, v in pairs(self.btnList_) do
        v:setVisible(false)
        v:setTouchEnabled(false)
    end
end

-- 判断是否有人死
function GameScene:checkIfDied(id)
    if id == 0 then
        return false
    end
    return true
end

function GameScene:getRoleByType(roleType)
    if roleType == GameScene.CUNMIN then
        return "村名"
    elseif roleType == GameScene.SHOUWEI then
        return "守卫"  
    elseif roleType == GameScene.YUYANJIA then
        return "预言家" 
    elseif roleType == GameScene.NVWU then
        return "女巫" 
    elseif roleType == GameScene.LANGREN then
        return "狼人"   
    end
end

-- 弹框提示
function GameScene:showPopu(txt)
    self.popu = Popu:create()
    self:addChild(self.popu)
    self:chgTips(txt)
end

function GameScene:closePopu( ... )
    if self.popu then
        self.popu:removeSelf()
    end
end

function GameScene:chgTips(txt)
    local tips = self.popu:getTipsTxt()
    tips:setString(txt)
end

-- 准备开始
function GameScene:ready( ... )
    self:changeState(GameScene.READY)
end

-- 守卫守人
function GameScene:shouwei()
    self:changeState(GameScene.PROTECTED)
    
end

-- 预言家验人
function GameScene:yanren( ... )
    self:changeState(GameScene.YUYAN)
    
end

-- 狼人杀人
function GameScene:killRen( ... )
    self:changeState(GameScene.KILL)
    
end

-- 女巫
function GameScene:nvwu( ... )
    self:hideBtns()

    self.jiuRenBtn:setVisible(true)
    self.jiuRenBtn:setTouchEnabled(true)

    self.duRenBtn:setTouchEnabled(true)
    self.duRenBtn:setVisible(true)

end

-- 选警长
function GameScene:xuanJin( ... )
    self:changeState(GameScene.XUANJIN)
    audio.playSound("music/jinxuanjinzhang.mp3",false)
end

function GameScene:initData(value)
    self.data = value
    self.selectId_ = 1001

    printInfo("number ::"..#self.data.roleList)

    self:sortTab(self.data.roleList)

    --listview设置
    self.ListView_user = self:getResourceNode():getChildByName("ListView_user")
    local defaultItem = self.ListView_user:getItem(0)
    self.ListView_user:setItemModel(defaultItem)
    self.ListView_user:removeAllItems()

    local itemNumber = 0
    local userNumber = 0

    if #self.data.roleList % 4 == 0 then
        itemNumber = #self.data.roleList / 4
    elseif #self.data.roleList % 4 ~= 0 then
        itemNumber = math.floor(#self.data.roleList / 4) + 1
    end
    userNumber = #self.data.roleList % 4


    printInfo("itemNumber::"..itemNumber)
    printInfo("userNumber::"..userNumber)


    for i = 1, itemNumber, 1 do
        self.ListView_user:pushBackDefaultItem()
    end

    if userNumber ~= 0 then
        for i = 4, userNumber + 1, -1 do
            printInfo("TEST  "..i)
            self.ListView_user:getItem(itemNumber - 1):getChildByName("Image_card"..i):setVisible(false)
        end
    end

    self.ListView_user:getItem(0):getChildByName("Image_card1"):getChildByName("Image_select"):setVisible(true)

    local function getCardInfoFunc(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            local index=1;
            local index2=0;
            for key, data in pairs(self.data.roleList) do



                self.ListView_user:getItem(index2):getChildByName("Image_card"..index):getChildByName("Image_select"):setVisible(false)

                index = index + 1
                if index == 5 then
                    index = 1
                    index2 = index2 + 1
                end


            end
            sender:getChildByName("Image_select"):setVisible(true)
        elseif eventType == ccui.TouchEventType.ended then
            printInfo("ID::"..sender.id)
            self.selectId_ = sender.id
            printInfo("NUMBER::"..sender.num)
            self.selectNum_ = sender.num
            printInfo("TYPE::"..sender.type)

            self.selectedType_ = sender.type

        end
    end




    local index=1;
    local index2=0;
    for key, data in pairs(self.data.roleList) do
        if data.id == self.data.id then
            self.ListView_user:getItem(index2):getChildByName("Image_card"..index):getChildByName("Image_myself"):setVisible(true)
        end

        self.ListView_user:getItem(index2):getChildByName("Image_card"..index):addTouchEventListener(getCardInfoFunc)
        self.ListView_user:getItem(index2):getChildByName("Image_card"..index).id = data.id
        self.ListView_user:getItem(index2):getChildByName("Image_card"..index).type = data.type
        self.ListView_user:getItem(index2):getChildByName("Image_card"..index).num = data.num
        self.ListView_user:getItem(index2):getChildByName("Image_card"..index):getChildByName("Text_number"):setString(data.num)

         printInfo("index2:"..index2.."index:"..index)
        index = index + 1
        if index == 5 then
            index = 1
            index2 = index2 + 1
        end
    end




    local pathcard = "ui/card_bg.png"
    self.Image_self = self:getResourceNode():getChildByName("Image_self")
    self.Image_self.id = self.data.id
    self.Image_self.num = self.data.num
    self.Image_self.type = self.data.type
    local function getSelfCardInfoFunc(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            local path = nil
            if sender.type == 1 then
                path = "ui/cunm.png"
            elseif sender.type == 2 then
                path = "ui/shouwei.png"
            elseif sender.type == 3 then
                path = "ui/yuyan.png"
            elseif sender.type == 4 then
                path = "ui/nvwu.png"
            elseif sender.type == 5 then
                path = "ui/langren.png"
            end
            sender:loadTexture(path)
        elseif eventType == ccui.TouchEventType.ended or  eventType == ccui.TouchEventType.canceled then
            printInfo("SELFID::"..sender.id)
            printInfo("SELFNUMBER::"..sender.num)
            printInfo("SELFTYPE::"..sender.type)
            sender:loadTexture(pathcard)
        end
    end
    self.Image_self:addTouchEventListener(getSelfCardInfoFunc)

--
--    local index=1;
--    for key, data in pairs(self.data.roleList) do
--
--        printInfo("key:::"..key.." "..data.type.."  "..data.id.."   "..data.num)
--        local card=  Card:create()
--        card:setData(data)
--        local size = card:getContentSize()
--        local row = (index-1)%4
--        local cos = math.ceil(index/4)-1
--        card:setPositionX(row*size.width)
--        card:setPositionY(cos*size.height)
--        self.card_layer:addChild(card)
--        index=index+1
--    end
    self.msg:setString("请准备~~")
    self:showPopu("请准备~~")
    self:ready()
    local socket = self:getApp():getSocket()
    --准备游戏请求
    self.readyBtn:addTouchEventListener(function(sender,type)
        if type==TOUCH_EVENT_ENDED then
            self.readyBtn:setTouchEnabled(false)
            self.readyBtn:setVisible(false)
             self.readyBtn:setTitleText("等待其他玩家准备!!!")
             socket:send(1003,{id=self.data.id})
        end
     end)

     
    self.prototedBtn:addTouchEventListener(function(sender,type)
        if type==TOUCH_EVENT_ENDED then
            self.prototedBtn:setTouchEnabled(false)
            self.prototedBtn:setVisible(false)
            local data={id=self.selectId_}
            socket:send(1004,data)
        end
     end)




    self.yuyanBtn:addTouchEventListener(function(sender,type)
        if type==TOUCH_EVENT_ENDED then
            self.yuyanBtn:setTouchEnabled(false)
            self.yuyanBtn:setVisible(false)
            local data={id=self.selectId_}
            socket:send(1005,data)
        end
     end)
    self.killBtn:addTouchEventListener(function(sender,type)
        if type==TOUCH_EVENT_ENDED then
            self.killBtn:setTouchEnabled(false)
            self.killBtn:setVisible(false)
            local data={id=self.selectId_}
            self.killedId_  = self.selectId_
            socket:send(1007,data)
        end
     end)
    self.duRenBtn:addTouchEventListener(function(sender,type)
        if type==TOUCH_EVENT_ENDED then
            self.duRenBtn:setTouchEnabled(false)
            self.duRenBtn:setVisible(false)
            local data={type=1, id=self.selectId_}
            socket:send(1008,data)
        end
     end)
    self.jiuRenBtn:addTouchEventListener(function(sender,type)
        if type==TOUCH_EVENT_ENDED then
            self.jiuRenBtn:setTouchEnabled(false)
            self.jiuRenBtn:setTouchEnabled(false)
            -- open duren
            -- self.duRenBtn:setTouchEnabled(true)
            local data={type=2, id=self.selectId_}
            socket:send(1008,data)
        end
     end)
    self.xuanjinzhangBtn:addTouchEventListener(function(sender,type)
        if type==TOUCH_EVENT_ENDED then
            self.xuanjinzhangBtn:setTouchEnabled(false)
            self.xuanjinzhangBtn:setVisible(false)
            local data={id=self.selectId_}
            socket:send(1011,data)
        end
     end)
end


function GameScene:cleanSheriffFlag()
    local index=1;
    local index2=0;
    for key, data in pairs(self.data.roleList) do
        self.ListView_user:getItem(index2):getChildByName("Image_card"..index):getChildByName("Image_jingzhang"):setVisible(false)

        index = index + 1
        if index == 5 then
            index = 1
            index2 = index2 + 1
        end
    end
end

function GameScene:setSheriffById(id)
    local index=1;
    local index2=0;
    for key, data in pairs(self.data.roleList) do
        if data.id == id then
            self.ListView_user:getItem(index2):getChildByName("Image_card"..index):getChildByName("Image_jingzhang"):setVisible(true)
        end
        printInfo("index2:"..index2.."index:"..index)
        index = index + 1
        if index == 5 then
            index = 1
            index2 = index2 + 1
        end
    end
end

function GameScene:setDeathById(id)
    local index=1;
    local index2=0;
    for key, data in pairs(self.data.roleList) do
        if data.id == id then
            self.ListView_user:getItem(index2):getChildByName("Image_card"..index):getChildByName("Image_death"):setVisible(true)
            self.ListView_user:getItem(index2):getChildByName("Image_card"..index):setTouchEnabled(false)
        end
        printInfo("index2:"..index2.."index:"..index)
        index = index + 1
        if index == 5 then
            index = 1
            index2 = index2 + 1
        end
    end
end

--按ID排序
function GameScene:sortTab(st)
    table.sort(st, function(v1,v2) return v1.num < v2.num end)
end

return GameScene