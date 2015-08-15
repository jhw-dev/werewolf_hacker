-- GameModel.lua
-- by Charles.Sun
-- 2015-08-14
--

-- 游戏模型数据类
local GameModel = class("GameModel")

local userState = {
    death = 0,
    alive = 1,
    wait = 2,
}

local temps = {
    sheriffNumber = 0,
}

function GameModel:ctor()
    self.user_list={
        --testInfo
        userNumber = 8, userInfo = {    {roleId = 1, cardType = 5, isSheriff = false, state = 1},
                                        {roleId = 2, cardType = 1, isSheriff = false, state = 1},
                                        {roleId = 3, cardType = 2, isSheriff = false, state = 1},
                                        {roleId = 4, cardType = 4, isSheriff = false, state = 1},
                                        {roleId = 5, cardType = 1, isSheriff = false, state = 1},
                                        {roleId = 6, cardType = 3, isSheriff = false, state = 1},
                                        {roleId = 7, cardType = 5, isSheriff = false, state = 1},
                                        {roleId = 8, cardType = 1, isSheriff = false, state = 1},
                                    }

   -- userNumber = ?, userInfo = { ????}
        }
end

function GameModel:initUserList()
    --服务器获取数据初始化成表格式
end

-- 通过id获取玩家当前状态（0死掉：无法复活；1活着；2暂时死掉，可以复活）
function GameModel:reviveUserById(id)
    if self:isValidID(id) then
        for key, val in pairs(self:getUserInfo()) do
            if val.roleId == id then
                return val.state
            end
        end
    end
end


-- 通过id复活暂时被杀的玩家
function GameModel:reviveUserById(id)
    if self:isValidID(id) then
        for key, val in pairs(self:getUserInfo()) do
            if val.roleId == id then
                val.state = userState.alive
            end
        end
    end
end

-- 通过id暂时杀掉玩家（可以复活复活）
function GameModel:killingUserById(id)
    if self:isValidID(id) then
        for key, val in pairs(self:getUserInfo()) do
            if val.roleId == id then
                val.state = userState.wait
            end
        end
    end
end

-- 通过id杀掉玩家（永久杀掉无法复活）
function GameModel:killedUserById(id)
    if self:isValidID(id) then
        for key, val in pairs(self:getUserInfo()) do
            if val.roleId == id then
                val.state = userState.death
            end
        end
    end
end

-- 若已存在警长则无法设置成功
function GameModel:checkSheriffValid()
    for key, val in pairs(self:getUserInfo()) do
        if val.state ~= 0 and val.isSheriff == true then
            temps.sheriffNumber = temps.sheriffNumber + 1
        end
    end
    if temps.sheriffNumber == 0 then
        return true
    else
        printInfo("Sheriff is exit !!!")
        return false
    end
end

-- 通过玩家的号码设置为警长
function GameModel:setSheriffById(id)
    if self:isValidID(id) and self:checkSheriffValid() then
        for key, val in pairs(self:getUserInfo()) do
            if val.roleId == id then
                val.isSheriff = true
            end
        end
    end
end

-- 通过玩家的号码获取他是否为警长
function GameModel:isSheriffById(id)
    if self:isValidID(id) then
        for key, val in pairs(self:getUserInfo()) do
            if val.roleId == id then
                return val.isSheriff
            end
        end
    end
end

-- 通过玩家的号码获取他的职业
function GameModel:getTypeById(id)
    if self:isValidID(id) then
        for key, val in pairs(self:getUserInfo()) do
            if val.roleId == id then
                return val.cardType
            end
        end
    end
end

-- 判断是否为正确的userid
function GameModel:isValidID(id)
    if id <= 0 or id >= self:getUserNumber() then
        printInfo("error roleId !!!")
        return false
    else
        return true
    end
end

-- 获取玩家总表信息
function GameModel:getCardList()
    return self.user_list
end

-- 获取玩家总人数
function GameModel:getUserNumber()
    return self.user_list.userNumber
end

-- 获取玩家详细信息
function GameModel:getUserInfo()
    return self.user_list.userInfo
end

return GameModel