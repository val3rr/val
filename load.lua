repeat wait() until game:IsLoaded() and game.Players.LocalPlayer
if _G.vel and not _G.testing then return warn("vel's already running!") end
_G.vel = true

local list = {
    [15532962292] = "https://raw.githubusercontent.com/velfvl/vel/main/sols.lua";
    [16481032741] = "https://raw.githubusercontent.com/velfvl/vel/main/zenith.lua";
    [9032150459] = "https://raw.githubusercontent.com/velfvl/vel/main/bcwo%20mine.lua";
    [8829364740] = "https://raw.githubusercontent.com/velfvl/vel/main/bcwo%20mine.lua"
}
if list[game.GameId] ~= nil then
    loadstring(game:HttpGet(list[tonumber(game.GameId)]))()
elseif list[game.PlaceId] ~= nil then
    loadstring(game:HttpGet(list[tonumber(game.PlaceId)]))()
else
    warn("vel doesnt support this game!")
end
