--- Script By Inj3
--- Script By Inj3
--- Script By Inj3
---- https://steamcommunity.com/id/Inj3/

local improved_drowning_sys_sec = 7 --- Time to drown / Délai avant la noyade
local improved_drowning_sys_healthdamage = 7 --- Drowning damage (per second) / Dégât lors de la noyade (par seconde)
local improved_drowning_sys_preventleave = 5 --- If the player gets out of the water, the time in seconds before the delay ("improved_drowning_sys_sec") is reset, if the time is not reset, the player will instantly take damage again when he/she gets back into the water (fully submerged body)/Si le joueur sort de l'eau, le temps en secondes avant que le délai ("improved_drowning_sys_sec") ne soit réinitialisé, si le temps n'est pas réinitialisé, le joueur reprendra instantanément des dégâts lorsqu'il replongera dans l'eau (corps totalement immergé).

do
    local improved_sound_sys = improved_sound_sys or {}
    local improved_sound_max, improved_caching_id = 2
    
    local function improved_clear_sound(id)
        if improved_sound_sys[id] then
            for i = 1, improved_sound_max do
                improved_sound_sys[id][i]:Stop()
            end
            improved_sound_sys[id] = nil
        end
    end
    local function improved_drowning_system()
        local improved_class_sys = ents.FindByClass("player")

        for _, v in ipairs (improved_class_sys) do
            if (v:WaterLevel() >= 3) then
                if v:Alive() then
                    v.improved_player_water = (v.improved_player_water or 0) + 1
                    
                    if (v.improved_player_water <= improved_drowning_sys_sec) then
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

                        if (v.player_inwater_cur and v.player_inwater_cur > 0) then
                            v.player_inwater_cur = 0
                        end 
                        
                        improved_sound_sys[improved_caching_id][1]:PlayEx(1, 100)                        
                        v:SetHealth(v:Health() - improved_drowning_sys_healthdamage)
                        
                        if (v:Health() <= 0) then
                            v:Kill()
                            v.improved_player_water  = nil
                            v.player_inwater_cur = nil
                            improved_clear_sound(improved_caching_id)
                        end
                    end
                end
            else
                if v.improved_player_water then
                    improved_caching_id = v:UserID()
                    if improved_sound_sys[improved_caching_id] then
                        improved_sound_sys[improved_caching_id][2]:PlayEx(1, 100)
                    end
                    v.player_inwater_cur = (v.player_inwater_cur or 0) + 1
                    
                    if (v.player_inwater_cur >= improved_drowning_sys_preventleave) then
                        v.improved_player_water  = nil
                        v.player_inwater_cur = nil
                        improved_clear_sound(improved_caching_id)
                    end
                end
            end
        end
    end
    timer.Create("ImprovedDrowning_Sys", 1, 0, improved_drowning_system)
end
