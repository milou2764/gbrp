AddCSLuaFile('climb-swep-2/cl_roll.lua')
AddCSLuaFile('climb-swep-2/cl_falleffect.lua')
if CLIENT then
    include('climb-swep-2/cl_roll.lua')
    include('climb-swep-2/cl_falleffect.lua')
end
