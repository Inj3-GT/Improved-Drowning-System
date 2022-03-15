--- Script By Inj3
--- Script By Inj3
--- Script By Inj3
---- https://steamcommunity.com/id/Inj3/

local improved_drowning_system_sec = 7 --- Time to drown / Délai avant la noyade
local improved_drowning_system_healthdamage = 7 --- Drowning damage (per second) / Dégât lors de la noyade (par seconde)
local improved_drowning_system_preventleave = 5 --- If the player gets out of the water, the time in seconds before the delay ("improved_drowning_system_sec") is reset, if the time is not reset, the player will instantly take damage again when he/she gets back into the water (fully submerged body)/Si le joueur sort de l'eau, le temps en secondes avant que le délai ("improved_drowning_system_sec") ne soit réinitialisé, si le temps n'est pas réinitialisé, le joueur reprendra instantanément des dégâts lorsqu'il replongera dans l'eau (corps totalement immergé).

do
     local improved_sound_sys = improved_sound_sys or {}
     local improved_sound_max, improved_caching_id = 2
     local math = math
 
     local function improved_clear_sound(id)
         if improved_sound_sys[id] then
             for i = 1, improved_sound_max do
                 improved_sound_sys[id][i]:Stop()
             end
 
             improved_sound_sys[id] = nil
         end
     end
 
     local function improved_drowning_system()
         local Improved_Class_Sys = ents.FindByClass("player")
 
         for _, v in ipairs (Improved_Class_Sys) do
             if (v:WaterLevel() >= 3) then
                 if v:Alive() then
                     v.Improved_PlayerWater = (v.Improved_PlayerWater or 0) + 1
 
                     if (v.Improved_PlayerWater <= improved_drowning_system_sec) then
                         v:EmitSound("player/pl_drown" ..math.random(1, 3).. ".wav", 75, 100, 1, CHAN_AUTO)
 
                     else
                         improved_caching_id = v:UserID()
 
                         if not improved_sound_sys[improved_caching_id] then
                             improved_sound_sys[improved_caching_id] = {}
 
                             for i = 1, improved_sound_max do
                                 improved_sound_sys[improved_caching_id][i] = i == 1 and CreateSound(v, "player/heartbeat1.wav") or i == 2 and CreateSound(v, "player/breathe1.wav")
                             end
                         else
                             if improved_sound_sys[improved_caching_id][2]:IsPlaying() then
                                 improved_sound_sys[improved_caching_id][2]:Stop()
                             end
                         end
 
                         v:EmitSound("player/pl_drown" ..math.random(1, 3).. ".wav", 35, math.random(5, 20), 1, CHAN_AUTO)
 
                         if v.PlayerInWaterCur and v.PlayerInWaterCur > 0 then
                             v.PlayerInWaterCur = 0
                         end
 
                         improved_sound_sys[improved_caching_id][1]:PlayEx(1, 100)
                         v:SetHealth( v:Health() - improved_drowning_system_healthdamage )
 
                         if (v:Health() <= 0) then
                             v:Kill()
 
                             v.Improved_PlayerWater  = nil
                             v.PlayerInWaterCur = nil
 
                             improved_clear_sound(improved_caching_id)
                         end
                     end
                 end
             else
                 if v.Improved_PlayerWater then
                     improved_caching_id = v:UserID()
 
                     if improved_sound_sys[improved_caching_id] then
                         improved_sound_sys[improved_caching_id][2]:PlayEx(1, 100)
                     end
 
                     v.PlayerInWaterCur = (v.PlayerInWaterCur or 0) + 1
 
                     if (v.PlayerInWaterCur >= improved_drowning_system_preventleave) then
                         v.Improved_PlayerWater  = nil
                         v.PlayerInWaterCur = nil
 
                         improved_clear_sound(improved_caching_id)
                     end
                 end
             end
         end
     end
     timer.Create("ImprovedDrowning_Sys", 1, 0, improved_drowning_system)
 end