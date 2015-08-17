--
-- @authors haibo
-- @email sean.ma@juhuiwan.cn
-- @date 2015-08-15 11:29:04
--
local GameOverScene = class("GameOverScene",cc.load("mvc").ViewBase)
GameOverScene.RESOURCE_FILENAME = "GameOverScene.csb"
GameOverScene.RESOURCE_BINDING={continueBtn={varname="continueBtn"},
	tips = {varname="tips"}, ListView_fupan = {varname="ListView_fupan"}}
function GameOverScene:onCreate( ... )
    
    self:resetSetSceneSize()
    
	self.continueBtn:addTouchEventListener(function(sender,type)
        if type==TOUCH_EVENT_ENDED then
            local node = self.app_:createView("MainScene")
            local scene = display.newScene("MainScene")
            scene:addChild(node)
            local transition=cc.TransitionMoveInL:create(0.3,scene)
            cc.Director:getInstance():replaceScene(transition)
        end
    end)
	
	-- self.tips:
end


function GameOverScene:setValue(val)
    local str = "狼人获胜！！"
    if val==2 then
        str = "平民和神获胜！！"
    end
    self.tips:setString(str)
end

function GameOverScene:fupan(datalist, myid)


    local defaultItem = self.ListView_fupan:getItem(0)
    self.ListView_fupan:setItemModel(defaultItem)
    self.ListView_fupan:removeAllItems()

    local itemNumber = 0
    local userNumber = 0

    if #datalist % 4 == 0 then
        itemNumber = #datalist / 4
    elseif #datalist % 4 ~= 0 then
        itemNumber = math.floor(#datalist / 4) + 1
    end
    userNumber = #datalist % 4



    for i = 1, itemNumber, 1 do
        self.ListView_fupan:pushBackDefaultItem()
    end

    if userNumber ~= 0 then
        for i = 4, userNumber + 1, -1 do
            printInfo("TEST  "..i)
            self.ListView_fupan:getItem(itemNumber - 1):getChildByName("Image_card"..i):setVisible(false)
        end
    end

    local index=1
    local index2=0
    for key, data in pairs(datalist) do
        if tonumber(data.id) == tonumber(myid) then
            self.ListView_fupan:getItem(index2):getChildByName("Image_card"..index):getChildByName("Image_myself"):setVisible(true)
        end

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
        self.ListView_fupan:getItem(index2):getChildByName("Image_card"..index):getChildByName("Text_number"):setString(data.num)

        index = index + 1
        if index == 5 then
            index = 1
            index2 = index2 + 1
        end
    end


    self:setResultImage(datalist)
end


return GameOverScene

