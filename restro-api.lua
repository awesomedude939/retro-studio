local RESTRO = {}

function RESTRO.Create(Type, Parent)
    RVal = game:GetService("ReplicatedStorage").RemoteFunctions.CreateObject:InvokeServer(Type,Parent)
    return RVal
end

function RESTRO.ChangeProperties(Object, Property, Value)
    game:GetService("ReplicatedStorage").RemoteEvents.ObjectPropertyChangeRequested:FireServer(Object, Property, Value)
end

function RESTRO.ListProperties(Type)
    if type(Type) ~= "string" then error("string Expected, got "..type(Type)) end
    local HttpService = game:GetService("HttpService")
    local Properties = HttpService:JSONDecode(game:HttpGet("https://raw.githubusercontent.com/awesomedude939/retro-studio/main/json/properties.json"))
    return Properties[tostring(Type)]
end

function RESTRO:Destroy(Object)
    game:GetService("ReplicatedStorage").RemoteEvents.MiscObjectInteraction({Object}, "Destroy")
end
