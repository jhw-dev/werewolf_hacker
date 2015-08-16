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
    xuanjinzhangBtn={varname="xuanjinzhangBtn"},
    -- 投票
    piaoBtn = {varname="piaoBtn"},
    -- 取消
    cancelBtn={varname="cancelBtn"}
}


local nvwu = {
    duyaonum = true,
    jieyaonum = true,
}

GameScene.PROTECTED = "PROTECTED"
GameScene.YUYAN = "YUYAN"
GameScene.KILL = "KILL"
GameScene.DUREN = "DUREN"
GameScene.JIUREN = "JIUREN"
GameScene.XUANJIN = "XUANJIN"
GameScene.READY = "READY"
GameScene.PIAO = "piao"
GameScene.CANCEL = "cancel"

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
        [GameScene.READY] = self.readyBtn,
        [GameScene.PIAO] = self.piaoBtn,
        [GameScene.CANCEL] = self.cancelBtn
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
        self.msg:setString("天黑拉~~")


        self:tianHei()

        local action=cc.Sequence:create({cc.DelayTime:create(6),cc.CallFunc:create(function()
            audio.playSound("music/shouweizhenyan.mp3",false)

            if self.Image_self.type == GameScene.SHOUWEI then
                self:resetSelectId()
                self:shouwei()
            end
        end)})
        self:runAction(action)
        
       
   end);
   
    socket:register(1004,function(data)
        --这里是开始播放守卫下一步的语音
        printInfo("守卫守着的人")
        self.msg:setString("守卫已经守人了~~")


       -- self:showPopu("守卫已经守人了~~,守的人的id"..data.id)
        self.curUnguideId = data.id
        self:clearUnguide()
        self:biYan(GameScene.SHOUWEI)

        local action=cc.Sequence:create({cc.DelayTime:create(6),cc.CallFunc:create(function()
            audio.playSound("music/yuyanzhenyan.mp3",false)
        end)})
        self:runAction(action)

        if self.Image_self.type == GameScene.YUYANJIA then
            self:resetSelectId()
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
            
                
                -- 预言家闭眼音乐播放
               self:biYan(GameScene.YUYANJIA)
                    local action=cc.Sequence:create({cc.DelayTime:create(4),cc.CallFunc:create(function()
                        socket:send(1006)
                    end)})
                    self:runAction(action)
               
            end)
        end
            
    end)

     socket:register(1006,function(data)

        audio.playSound("music/langrensharen.mp3",false)

        if self.Image_self.type == GameScene.LANGREN then
            self:resetSelectId()
            self:killRen()
        end
    end)

    
    socket:register(1007,function(data)
        printInfo("狼人杀人结果")
        local result = 0
        local killId

        result = data.result
        killId = data.deadRole
        self.curKillId = killId
        if result == 0 then
            -- 播放狼人请统一意见音效

            -- 显示狼人杀人角色
            self:setDeathById(killId)

        elseif result == 1 then
            --女巫玩家显示
        --    self:saveDeathPersonDis()


            -- 禁用按钮
            self.killBtn:setTouchEnabled(false)
            self.killBtn:setVisible(false)

            self:biYan(GameScene.LANGREN)
            local action=cc.Sequence:create({cc.DelayTime:create(6),cc.CallFunc:create(function()
                audio.playSound("music/nvwuzhenyan.mp3",false)
            end)})
            self:runAction(action)
            
            if self.Image_self.type == GameScene.NVWU then
                -- 先救人,2
                self:setBlackById()
                self:nvwu(2)
            end
        end

    end)
    
    socket:register(1009,function(data)
        printInfo("死亡人数列表")
        audio.playSound("music/tianliang.mp3",false)

        self.deadList = data.roles
        if #data.roles ==0 then
            printInfo("平安夜")
            return
        end
        for k, v in pairs(data.roles) do
                if v.id == self.Image_self.id then
               
                -- 播放遗言
                self:showPopu("你死了，请说遗言")
                
                
                local pop = self.popu

                    local resNode = self:getResourceNode()
                    pop:setOnEnsureCallback(function( ... )
                        -- 遗言确认
                        -- 弹出死亡蒙板

                        resNode:getChildByName("Panel_black"):setVisible(true)
                        socket:send(1010)

                    end)
                    
                local action=cc.Sequence:create({cc.DelayTime:create(6),cc.CallFunc:create(function(pop)
                         audio.playSound("music/yiyan.mp3",false)
                end)})


                self:runAction(action)
            end
            self:setDeathById(v.id)
        end

        
        
    end)
    
    socket:register(1011,function(data)
        
        -- 广播
        local result = data.result
        if  self.Image_self.isdeath==false then 
        -- 选警长
                if  result then
                    self:resetSelectId()
                    self:showPopu("开始选警长")
                    audio.playSound("music/jinxuanjinzhang.mp3",false)
                    self:xuanJin()

            else
                -- 直接投票
                self:votePeople()
            end
        end
            
       
    end)
    socket:register(1012,function(data)
     --   self:showPopu("选警长结果："..data.roleID)
        printInfo("选警长的结果")
        self:cleanSheriffFlag()

        self:setSheriffById(data.roleID)
        self:votePeople()
        self:resetSelectId()
    end)

    socket:register(1013,function(data)
        if data.result ==0 then
            self:showPopu("今天晚上平安夜")
        elseif data.result == 1 then
            self:showPopu(data.roleID.."玩家死了")
            self:setDeathById(data.roleID)
        end
        self:ready()
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
     --   self:showPopu("移交给警长："..data.id)
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
    
    local function cancel( ... )
        local socket = self:getApp():getSocket()
        local data={id=nil}
        socket:send(1004,data)
        self.prototedBtn:setVisible(false)
        self.prototedBtn:setTouchEnabled(false)
    end
    self:setCancelEvent(cancel)
    -- cancel
    self.cancelBtn:setTouchEnabled(true)
    self.cancelBtn:setVisible(true)
end

function GameScene:setCancelEvent(callback)   
    self.cancelCallback = callback
end

-- 预言家验人
function GameScene:yanren( ... )
    self:changeState(GameScene.YUYAN)

    local function cancel( ... )
        local socket = self:getApp():getSocket()
        local data={id=nil}
        socket:send(1005,data)
        self.yuyanBtn:setVisible(false)
        self.yuyanBtn:setTouchEnabled(false)
    end
    self:setCancelEvent(cancel)
    -- cancel
    self.cancelBtn:setTouchEnabled(true)
    self.cancelBtn:setVisible(true)
end

-- 狼人杀人
function GameScene:killRen( ... )
    self:changeState(GameScene.KILL)

    local function cancel( ... )
        local socket = self:getApp():getSocket()
        local data={id=nil}
        socket:send(1007,data)
        self.killBtn:setVisible(false)
        self.killBtn:setTouchEnabled(false)
    end
    self:setCancelEvent(cancel)
    -- cancel
    self.cancelBtn:setTouchEnabled(true)
    self.cancelBtn:setVisible(true)
end

-- 女巫
function GameScene:nvwu(caozuo)
    self:hideBtns()

    if caozuo == 1 and nvwu.duyaonum == true then
        self.duRenBtn:setTouchEnabled(true)
        self.duRenBtn:setVisible(true)
        local function cancel( ... )
            local socket = self:getApp():getSocket()
            local data={type=caozuo, id=nil}
            socket:send(1008,data)
            self.duRenBtn:setVisible(false)
            self.duRenBtn:setTouchEnabled(false)
        end
        self:setCancelEvent(cancel)

        -- cancel
        self.cancelBtn:setTouchEnabled(true)
        self.cancelBtn:setVisible(true)


    elseif caozuo == 2 and nvwu.jieyaonum == true then
        self.jiuRenBtn:setVisible(true)
        self.jiuRenBtn:setTouchEnabled(true)

        local function cancel( ... )
            local socket = self:getApp():getSocket()
            local data={type=caozuo, id=nil}
            socket:send(1008,data)
            self.jiuRenBtn:setVisible(false)
            self.jiuRenBtn:setTouchEnabled(false)
        end
        self:setCancelEvent(cancel)
        -- cancel
        self.cancelBtn:setTouchEnabled(true)
        self.cancelBtn:setVisible(true)
    end
end

-- 选警长
function GameScene:xuanJin( ... )
    self:changeState(GameScene.XUANJIN)

    local function cancel( ... )
        local socket = self:getApp():getSocket()
        local data={id=nil}
        socket:send(1012,data)
        self.xuanjinzhangBtn:setVisible(false)
        self.xuanjinzhangBtn:setTouchEnabled(false)
    end
        self:setCancelEvent(cancel)
    -- cancel
    self.cancelBtn:setTouchEnabled(true)
    self.cancelBtn:setVisible(true)
    
end

-- 投票杀人
function GameScene:votePeople( ... )
    self:changeState(GameScene.PIAO)

    local function cancel( ... )
        local socket = self:getApp():getSocket()
        local data={id=nil}
        socket:send(1013,data)
        self.piaoBtn:setVisible(false)
        self.piaoBtn:setTouchEnabled(false)
    end
    self:setCancelEvent(cancel)
    -- cancel
    self.cancelBtn:setTouchEnabled(true)
    self.cancelBtn:setVisible(true)
end

-- 取消
function GameScene:cancelEvent()
    if self.cancelCallback then
        self.cancelCallback()
    end
end

function GameScene:initData(value)
    self.data = value

    self.curUnguideId = nil
   

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



    local function getCardInfoFunc(sender, eventType)
        if eventType == ccui.TouchEventType.began then
            local index=1
            local index2=0
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
            self:setSelectId(sender.id)
            printInfo("NUMBER::"..sender.num)
            self.selectNum_ = sender.num
            printInfo("TYPE::"..sender.type)

            self.selectedType_ = sender.type

        end
    end




    local index=1
    local index2=0
    for key, data in pairs(self.data.roleList) do
        if data.id == self.data.id then
            self.ListView_user:getItem(index2):getChildByName("Image_card"..index):getChildByName("Image_myself"):setVisible(true)
        end

        self.ListView_user:getItem(index2):getChildByName("Image_card"..index):addTouchEventListener(getCardInfoFunc)
        self.ListView_user:getItem(index2):getChildByName("Image_card"..index).id = data.id
        self.ListView_user:getItem(index2):getChildByName("Image_card"..index).type = data.type
        self.ListView_user:getItem(index2):getChildByName("Image_card"..index).num = data.num
        self.ListView_user:getItem(index2):getChildByName("Image_card"..index).isdeath = false
        self.ListView_user:getItem(index2):getChildByName("Image_card"..index).issheriff = false
        self.ListView_user:getItem(index2):getChildByName("Image_card"..index):getChildByName("Text_number"):setString(data.num)

         printInfo("index2:"..index2.."index:"..index)
        index = index + 1
        if index == 5 then
            index = 1
            index2 = index2 + 1
        end
    end
    self:resetSelectId()



    local pathcard = "ui/card_bg.png"
    self.Image_self = self:getResourceNode():getChildByName("Image_self")
    self.Image_self:getChildByName("Text_numberself"):setString(self.data.num)
    self.Image_self.id = self.data.id
    self.Image_self.num = self.data.num
    self.Image_self.type = self.data.type
    self.Image_self.isdeath = false

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
--    local index=1
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

     -- 守卫守人
    self.prototedBtn:addTouchEventListener(function(sender,type)
        if type==TOUCH_EVENT_ENDED then
            self.prototedBtn:setTouchEnabled(false)
            self.prototedBtn:setVisible(false)

            self.cancelBtn:setTouchEnabled(false)
            self.cancelBtn:setVisible(false)

            if self.curUnguideId ~= nil then
                self:setUnguideById()
            end
            if self:isSelectIdNil() then
                local data={id=self:getSelectId()}
                socket:send(1004,data)
            else
                self:showPopu("请选择一个玩家")
            end
        end
     end)

    -- 预言家验人
    self.yuyanBtn:addTouchEventListener(function(sender,type)
        if type==TOUCH_EVENT_ENDED then
            self.yuyanBtn:setVisible(false)
            self.yuyanBtn:setTouchEnabled(false)
            self.cancelBtn:setTouchEnabled(false)
            self.cancelBtn:setVisible(false)

            if self:isSelectIdNil() then
                local data={id=self:getSelectId()}
                socket:send(1005,data)
            else
                self:showPopu("请选择一个玩家")
            end
        end
     end)
    -- 狼人杀人
    self.killBtn:addTouchEventListener(function(sender,type)
        if type==TOUCH_EVENT_ENDED then
            self.killBtn:setTouchEnabled(false)
            self.killBtn:setVisible(false)
            self.cancelBtn:setTouchEnabled(false)
            self.cancelBtn:setVisible(false)
            if self:isSelectIdNil() then
                local data={id=self:getSelectId()}
                self.killedId_  = self:getSelectId()
                socket:send(1007,data)
            else
                self:showPopu("请选择一个玩家")
            end
        end
     end)
    -- 女巫救人
    self.jiuRenBtn:addTouchEventListener(function(sender,type)
        if type==TOUCH_EVENT_ENDED then
            -- cancel disabled
            self.cancelBtn:setTouchEnabled(false)
            self.cancelBtn:setVisible(false)
            -- 女巫毒人
            self:nvwu(1)
            self:biYan(GameScene.NVWU)

            self:clearBlack()
            self:setBlackById2()
            nvwu.jieyaonum = false
            if self:isSelectIdNil() then
                local data={type=2, id=self:getSelectId()}
                socket:send(1008,data)
            else
                self:showPopu("请选择一个玩家")
            end
        end
     end)
    -- 女巫毒人
    self.duRenBtn:addTouchEventListener(function(sender,type)
        if type==TOUCH_EVENT_ENDED then
            self.duRenBtn:setTouchEnabled(false)
            self.duRenBtn:setVisible(false)
            -- cancel
            self.cancelBtn:setTouchEnabled(false)
            self.cancelBtn:setVisible(false)

            self:clearBlack()
            if self:isSelectIdNil() then
                nvwu.duyaonum = false
                local data={type=1, id=self:getSelectId()}
                socket:send(1008,data)
            else
                self:showPopu("请选择一个玩家")
            end
        end
     end)
    
    -- 竞选警长
    self.xuanjinzhangBtn:addTouchEventListener(function(sender,type)
        if type==TOUCH_EVENT_ENDED then
            self.xuanjinzhangBtn:setTouchEnabled(false)
            self.xuanjinzhangBtn:setVisible(false)
            self.cancelBtn:setTouchEnabled(false)
            self.cancelBtn:setVisible(false)
            if self:isSelectIdNil() then
                local data={id=self:getSelectId()}
                socket:send(1012,data)
            else
                self:showPopu("请选择一个玩家")
            end
        end
     end)
    -- 投票杀人
    self.piaoBtn:addTouchEventListener(function(sender,type)
        if type==TOUCH_EVENT_ENDED then
            self.piaoBtn:setTouchEnabled(false)
            self.piaoBtn:setVisible(false)
            self.cancelBtn:setTouchEnabled(false)
            self.cancelBtn:setVisible(false)
            if self:isSelectIdNil() then
                local data={id=self:getSelectId()}
                socket:send(1013,data)
            else
                self:showPopu("请选择一个玩家")
            end
        end
     end)

    -- 取消
    self.cancelBtn:addTouchEventListener(function(sender,type)
        if type==TOUCH_EVENT_ENDED then
            self.cancelBtn:setTouchEnabled(false)
            self.cancelBtn:setVisible(false)
            self:cancelEvent()
        end
    end)
    
    
--    local str= "{\"cmd\":1009,\"data\":{\"roles\":[{\"id\":1001,\"type\":1,\"num\":4,\"isDead\":true},{\"id\":1005,\"type\":3,\"num\":5,\"isDead\":true}]}}"
--    socket:recive(str)
end


function GameScene:cleanSheriffFlag()
    local index=1
    local index2=0
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
    printInfo("选警长1？？？")
    printInfo(id)
    local index=1
    local index2=0
    for key, data in pairs(self.data.roleList) do
        if data.id == id then
             printInfo("选警长2？？？")
                print(id)
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
    printInfo("id1 is %d", id)
    local index=1
    local index2=0
    if id == self.Image_self.id then
        self.Image_self.isdeath = true
        -- self:getResourceNode():getChildByName("Panel_black"):setVisible(true)
    end
    for key, data in pairs(self.data.roleList) do
        if data.id == id then
            printInfo("id2 is %d", id)
            self.ListView_user:getItem(index2):getChildByName("Image_card"..index):getChildByName("Image_death"):setVisible(true)
            self.ListView_user:getItem(index2):getChildByName("Image_card"..index):setTouchEnabled(false)
            self.ListView_user:getItem(index2):getChildByName("Image_card"..index).isdeath = true
        end

        printInfo("index2:"..index2.."index:"..index)
        index = index + 1
        if index == 5 then
            index = 1
            index2 = index2 + 1
        end
    end
end

function GameScene:setBlackById()
    local index=1
    local index2=0
    for key, data in pairs(self.data.roleList) do
        if data.id ~= self.curKillId then
            self.ListView_user:getItem(index2):getChildByName("Image_card"..index):getChildByName("Image_black"):setVisible(true)
        end
        printInfo("index2:"..index2.."index:"..index)
        index = index + 1
        if index == 5 then
            index = 1
            index2 = index2 + 1
        end
    end
end

function GameScene:setBlackById2()
    local index=1
    local index2=0
    for key, data in pairs(self.data.roleList) do
        if data.id == self.curKillId then
            self.ListView_user:getItem(index2):getChildByName("Image_card"..index):getChildByName("Image_black"):setVisible(true)
        end
        printInfo("index2:"..index2.."index:"..index)
        index = index + 1
        if index == 5 then
            index = 1
            index2 = index2 + 1
        end
    end
end

function GameScene:clearBlack()
    local index=1
    local index2=0
    for key, data in pairs(self.data.roleList) do
        self.ListView_user:getItem(index2):getChildByName("Image_card"..index):getChildByName("Image_black"):setVisible(false)
        printInfo("index2:"..index2.."index:"..index)
        index = index + 1
        if index == 5 then
            index = 1
            index2 = index2 + 1
        end
    end
end

function GameScene:setUnguideById()
    local index=1;
    local index2=0;
    for key, data in pairs(self.data.roleList) do
        if data.id == self.curUnguideId then
            self.ListView_user:getItem(index2):getChildByName("Image_card"..index):getChildByName("Image_unguide"):setVisible(true)
        end
        printInfo("index2:"..index2.."index:"..index)
        index = index + 1
        if index == 5 then
            index = 1
            index2 = index2 + 1
        end
    end
end

function GameScene:clearUnguide()
    local index=1
    local index2=0
    for key, data in pairs(self.data.roleList) do
        self.ListView_user:getItem(index2):getChildByName("Image_card"..index):getChildByName("Image_unguide"):setVisible(false)
        printInfo("index2:"..index2.."index:"..index)
        index = index + 1
        if index == 5 then
            index = 1
            index2 = index2 + 1
        end
    end
end

--function GameScene:setDefaultSelectId()
--    local index=1
--    local index2=0
--    for key, data in pairs(self.data.roleList) do
--        if self.ListView_user:getItem(index2):getChildByName("Image_card"..index).isdeath == false then
--            self.selectId_ = self.ListView_user:getItem(index2):getChildByName("Image_card"..index).id
--            self.ListView_user:getItem(index2):getChildByName("Image_card"..index):getChildByName("Image_select"):setVisible(true)
--            break
--        end
--        index = index + 1
--        if index == 5 then
--            index = 1
--            index2 = index2 + 1
--        end
--    end
--end

function GameScene:resetSelectId()
    self.selectId_ = nil
end

function GameScene:isSelectIdNil()
    if self.selectId_ == nil then
        return false
    else
        return true
    end
end


function GameScene:setSelectId(id)
    self.selectId_ = id
end

function GameScene:getSelectId()
    return self.selectId_
end

function GameScene:setResultImage()

    local index=1
    local index2=0
    for key, data in pairs(self.data.roleList) do

        local path = nil
        if self.ListView_user:getItem(index2):getChildByName("Image_card"..index).type == 1 then
            path = "ui/cunm.png"
        elseif self.ListView_user:getItem(index2):getChildByName("Image_card"..index).type == 2 then
            path = "ui/shouwei.png"
        elseif self.ListView_user:getItem(index2):getChildByName("Image_card"..index).type == 3 then
            path = "ui/yuyan.png"
        elseif self.ListView_user:getItem(index2):getChildByName("Image_card"..index).type == 4 then
            path = "ui/nvwu.png"
        elseif self.ListView_user:getItem(index2):getChildByName("Image_card"..index).type == 5 then
            path = "ui/langren.png"
        end
        self.ListView_user:getItem(index2):getChildByName("Image_card"..index):loadTexture(path)

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