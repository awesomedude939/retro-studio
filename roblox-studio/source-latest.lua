--// Config \\--

Year = '2009'
AllowedInstances = {game.Workspace, game.Lighting, game.StarterGui, game.StarterPack, game.Debris, game.SoundService}

--// Main Script \\--

local HttpService = game:GetService("HttpService")

local Classes = HttpService:JSONDecode(HttpService:GetAsync("https://raw.githubusercontent.com/awesomedude939/retro-studio/main/json/classes.json"))
local Properties = HttpService:JSONDecode(HttpService:GetAsync("https://raw.githubusercontent.com/awesomedude939/retro-studio/main/json/properties.json"))
local FtoS = loadstring(HttpService:GetAsync("https://raw.githubusercontent.com/awesomedude939/roblox-scr/main/adv_spy/getdatatype.lua"))()

local Iteration
local CleanInstances = {}
local Script = "\n"

function CleanInstance(Self)
	if not table.find(CleanInstances,Self) then 
		table.insert(CleanInstances, Self)
	end
end

function WriteScript(str)
	Script = Script..str.."\n"
end

for i,v1 in pairs(AllowedInstances) do 
	for i,v2 in pairs(v1:GetDescendants()) do 
		for i,v3 in pairs(Classes) do 
			if string.match(string.split(v3," ")[1],v2.ClassName) then 
				CleanInstance(v2)
			end
		end
	end
end
WriteScript("local InstanceTable = {}")
for i1,v1 in pairs(CleanInstances) do 
	local sendTo = ""
	local needed = true
	sendTo = sendTo.."local InstanceV"
	sendTo = sendTo..tostring(i1)
	sendTo = sendTo.." = "
	sendTo = sendTo.."RESTRO.Create("
	sendTo = sendTo..getdatatype("string", v1.ClassName)
	sendTo = sendTo..", "
	for i3,v3 in pairs(CleanInstances) do 
		if v3 == v1.Parent then 
			sendTo = sendTo.."InstanceTable["
			sendTo = sendTo..tostring(i3)
			sendTo = sendTo.."]"
			needed = false
		end
	end
	if table.find(AllowedInstances, v1.Parent.Name) then 
		if needed then 
			sendTo = sendTo.."game."..v1.Name
		end
	else
		if needed then 
			sendTo = sendTo.."game."..v1.Parent:GetFullName()
		end 	
	end
	sendTo = sendTo..")"
	WriteScript(tostring(sendTo))
	WriteScript("table.insert(InstanceTable, ".."InstanceV"..i1..")")

	local prop = Properties[v1.ClassName]
	for i2,v2 in pairs(prop) do
		if v2 ~= "Parent" then
			local sendTo2 = ""
			sendTo2 = sendTo2.."RESTRO.ChangeProperties("
			sendTo2 = sendTo2.."InstanceTable["
			sendTo2 = sendTo2..i1
			sendTo2 = sendTo2.."]"
			sendTo2 = sendTo2..", "
			sendTo2 = sendTo2..getdatatype("string", tostring(v2))
			sendTo2 = sendTo2..", "
			s,e = pcall(function()
				sendTo2 = sendTo2..getdatatype(typeof(CleanInstances[i1][tostring(v2)]),CleanInstances[i1][tostring(v2)])..")"
				WriteScript(sendTo2)
			end)
		end
	end
end
print(Script)
