
local GameScene = class("GameScene", cc.load("mvc").ViewBase)

GameScene.RESOURCE_FILENAME = "GameScene.csb"

local GameLayer = import(".GameLayer")

function GameScene:onCreate()
    printf("resource node = %s", tostring(self:getResourceNode()))
    -- self:createResoueceNode(GameScene.RESOURCE_FILENAME)

    self:initViews()
end

function GameScene:initViews( ... )
	local gameLayer = GameLayer:create()
	self:addChild(gameLayer)
end

return GameScene
