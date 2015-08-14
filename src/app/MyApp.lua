
local MyApp = class("MyApp", cc.load("mvc").AppBase)
local ServieceSocket = cc.load("mvc").ServieceSocket

function MyApp:onCreate()
    math.randomseed(os.time())
    self.socket_=ServieceSocket:create()
    self.socket_:conn("ws://127.0.0.1:8080",function()
        print("Connect Success")
        self.socket_:send(1001,{t="Hello"})
    end)
    self.socket_:register(1001,function(data)
        printInfo("ads")
    end)

end


function MyApp:getSocket()
    return self.socket_
end



return MyApp
