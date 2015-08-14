local Card=class("Card",cc.load("mvc").ViewBase)
Card.RESOURCE_FILENAME = "Card.csb"
Card.RESOURCE_BINDING={bg={varname="bg"}}
function Card:onCreate()
    
end

function Card:getContentSize()
    return self.bg:getContentSize()
end
return Card