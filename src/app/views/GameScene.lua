local GameScene = class("GameScene",cc.load("mvc").ViewBase)
GameScene.RESOURCE_FILENAME = "GameScene.csb"
function GameScene:onCreate()
    self:resetSetSceneSize()
end

return GameScene