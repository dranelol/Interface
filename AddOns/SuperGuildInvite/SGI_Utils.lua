
function SGI:FormatTime(T)
	local R,S,M,H = ""
	T = floor(T)
	H = floor(T/3600)
	M = floor((T-3600*H)/60)
	S = T-(3600*H + 60*M)
		
	if T <= 0 then
		return L["less than 1 second"]
	end
		
	if H ~= 0 then
		R =  R..H..L[" hours "]
	end
	if M ~= 0 then
		R = R..M..L[" minutes "]
	end
	if S ~= 0 then
		R = R..S..L[" seconds"]
	end
	
	return R
end

function SGI:CountTable(T)
	local i = 0
	if type(T) ~= "table" then
		return i
	end
	for k,_ in pairs(T) do
		i = i + 1
	end
	return i
end

--[[
function SGI.

function SGI.

function SGI.

function SGI.

function SGI.
function SGI.

function SGI.

function SGI.
function SGI.
function SGI.
function SGI.
function SGI.
function SGI.
function SGI.
function SGI.
]]