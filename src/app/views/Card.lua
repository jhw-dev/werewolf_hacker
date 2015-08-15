local Card=class("Card",cc.load("mvc").ViewBase)
Card.RESOURCE_FILENAME = "card.csb"
Card.RESOURCE_BINDING={bg={varname="bg"}}
function Card:onCreate()
    self.data = nil
end

function Card:setData(value)
    self.data = value
end

function Card:getContentSize()
    return self.bg:getContentSize()
end
return Card