AddCSLuaFile('gundealer/sh_items.lua')
AddCSLuaFile('gundealer/sh_config.lua')
include('gundealer/sh_items.lua')
include('gundealer/sh_config.lua')
if SERVER then
    include('gundealer/server.lua')
end
