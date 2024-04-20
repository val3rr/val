repeat wait() until game:IsLoaded() and game.Players.LocalPlayer
if _G.vel then return warn("vel's already running!") end
_G.vel = true

local list = {
    [15532962292] = "https://raw.githubusercontent.com/velfvl/vel/main/sols.lua"
}
if list[game.GameId] ~= nil then
    loadstring(game:HttpGet(list[tonumber(game.GameId)]))()
else
    warn("vel doesnt support this game!")
end
