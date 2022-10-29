function fireworkAllPlayers (type, args) 
    players = getElementsByType("player")
    for _,player in pairs (players) do
        if player ~= client then
        triggerClientEvent(player,"FireClientFirework",player, type, args)
        end
    end
end
addEvent("showFireworkGlobal", true)
addEventHandler("showFireworkGlobal", root , fireworkAllPlayers)