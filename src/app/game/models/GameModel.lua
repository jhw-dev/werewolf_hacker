-- GameModel.lua
-- by Charles.Sun
-- 2015-08-14
--

-- 游戏模型数据类
local GameModel = class("GameModel")

local userState = {
    werewolf = {
        death = 0,
        alive = 1,
        wait = 2,
    },
    guard = {
        unguard = 0,
        guarded = 1,
        wait = 2
    },
    witch = {
        poison = 1,
        antidote = 2,
        nothing = 0,
    },
}

local flags = {
    sheriffExit = false,
}

local witch = {
    poisonNumber = 1,
    antidoteNumber = 1,
}

function GameModel:ctor()
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
end

function GameModel:initUserList()
    --服务器获取数据初始化成表格式
end

-- 获取玩家总人数
function GameModel:getUserNumber()
    return self.user_list.userNumber
end

-- 获取玩家详细信息
function GameModel:getUserInfo()
    return self.user_list.userInfo
end

-- 获取玩家总表信息
function GameModel:getCardList()
    return self.user_list
end

-- 判断是否为正确的userid
function GameModel:isValidID(id)
    if id > 0 and id <= self:getUserNumber() then
        return true
    else
        printInfo("error roleId !!!")
        return false
    end
end

-- ====================
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

-- 获取当前警长id
function GameModel:getSheriffId()
    for key, val in pairs(self:getUserInfo()) do
        if val.isSheriff == true then
            return val.id
        end
    end
end

-- 若已存在警长则无法设置成功
function GameModel:checkSheriffValid()
    for key, val in pairs(self:getUserInfo()) do
        if val.werewolfState == userState.werewolf.alive and val.isSheriff == true then
            flags.sheriffExit = true
        end
    end

    return flags.sheriffExit
end

-- 通过玩家的号码设置为警长
function GameModel:setSheriffById(id)
    if self:checkSheriffValid() then
            printInfo("valid sheriff is exit !!!")
            --reset sheriff flag
            flags.sheriffExit = false
    else
        if self:isValidID(id) then
            for key, val in pairs(self:getUserInfo()) do
                if val.roleId == id then
                    val.isSheriff = true
                end
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

-- 获取所有死亡玩家的id
function GameModel:getAllDeathId()
    local tab = {}
    local number = 1
    for key, val in pairs(self:getUserInfo()) do
        if val.werewolfState == userState.werewolf.death then
            tab[number] = val.id
            number = number + 1
        end
    end

    return tab
end

-- 通过id暂时杀掉玩家（可以复活复活）
function GameModel:killingUserById(id)
    if self:isValidID(id) then
        for key, val in pairs(self:getUserInfo()) do
            if val.roleId == id then
                val.werewolfState = userState.werewolf.wait
            end
        end
    end
end

-- 通过id杀掉玩家（永久杀掉无法复活）
function GameModel:killedUserById(id)
    if self:isValidID(id) then
        for key, val in pairs(self:getUserInfo()) do
            if val.roleId == id then
                val.werewolfState = userState.werewolf.death
            end
        end
    end
end

-- 通过id复活暂时被杀的玩家
function GameModel:reviveUserById(id)
    if self:isValidID(id) then
        for key, val in pairs(self:getUserInfo()) do
            if val.roleId == id then
                val.werewolfState = userState.werewolf.alive
            end
        end
    end
end

-- 通过id获取玩家当前状态（0死掉：无法复活；1活着；2暂时死掉，可以复活）
function GameModel:getUserStateById(id)
    if self:isValidID(id) then
        for key, val in pairs(self:getUserInfo()) do
            if val.roleId == id then
                return val.werewolfState
            end
        end
    end
end

-- 通过id设置玩家被守卫
function GameModel:getUserStateById(id)
    if self:isValidID(id) then
        for key, val in pairs(self:getUserInfo()) do
            if val.roleId == id then
                val.guardState = userState.guard.guarded
            end
        end
    end
end

-- 本领被守卫的人做标记，下轮无法被守卫
function GameModel:setNextTurnUnGuard()
    for key, val in pairs(self:getUserInfo()) do
        if val.guardState == userState.guard.guarded then
            val.guardState = userState.guard.unguard
        end
    end
end

-- 判断无法守卫上轮被守卫的玩家(返回0为第一轮)
function GameModel:getUnGuard()
    for key, val in pairs(self:getUserInfo()) do
        if val.guardState == userState.guard.unguard then
            return val.id
        else
            return 0
        end
    end
end












return GameModel