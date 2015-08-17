
local MyApp = class("MyApp", cc.load("mvc").AppBase)
local ServieceSocket = cc.load("mvc").ServieceSocket
local Pop = import(".views.Popu")
function MyApp:onCreate()
    math.randomseed(os.time())
    self.socket_=ServieceSocket:create()
    self.stime= nil
    local timed =self.stime
self.socket_:conn("ws://192.168.3.62:8080",function()
        print("Connect Success")
--        self.socket_:send(1001,{t="Hello"})

        
    end,function()
        local pop =Pop:create()
        pop:getTipsTxt():setString("服务器关闭!!")
        local scene=cc.Director:getInstance():getRunningScene();
        scene:addChild(pop)
    end)
end


function MyApp:getSocket()
    return self.socket_
end



return MyApp
