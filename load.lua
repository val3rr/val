repeat wait() until game:IsLoaded() and game.Players.LocalPlayer
if _G.vel_running then return warn("vel's already running!") end
_G.vel_running = true

local list = {
    [123456789] = ""
}
if list[game.GameId] ~= nil then
    loadstring(list[tonumber(game.GameId)])()
else
    warn("vel doesnt support this game!")
end
