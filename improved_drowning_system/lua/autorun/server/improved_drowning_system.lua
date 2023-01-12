--- Script By Inj3
--- Script By Inj3
--- Script By Inj3
---- https://steamcommunity.com/id/Inj3/

--- // Configuration
local ipr_drowning_config = {
    sec = 7, --- Time to drown / Délai avant la noyade
    health_damage = 7, --- Drowning damage (per second) / Dégât lors de la noyade (par seconde)
    prevent_leave = 5, --- If the player gets out of the water, the time in seconds before the delay ("improved_drowning_sys_sec") is reset, if the time is not reset, the player will instantly take damage again when he/she gets back into the water (fully submerged body)/Si le joueur sort de l'eau, le temps en secondes avant que le délai ("improved_drowning_sys_sec") ne soit réinitialisé, si le temps n'est pas réinitialisé, le joueur reprendra instantanément des dégâts lorsqu'il replongera dans l'eau (corps totalement immergé).
    job_blacklist = { --- Jobs will not be affected by drowning / Les jobs ne seront pas affectés par la noyade.
        ["Chef Pizza"] = true,
    },
}
---

--- // Do not touch the code below
local ipr_sound_sys, ipr_cache_id = ipr_sound_sys or {}

local function ipr_clear_sound(id)
    if (ipr_sound_sys[id]) then
        for i = 1, 2 do
            ipr_sound_sys[id][i]:Stop()
        end

        ipr_sound_sys[id] = nil
    end
end

local function ipr_drowning_sys()
    local ipr_class_sys = ents.FindByClass("player")

    for _, v in ipairs (ipr_class_sys) do
        if (ipr_drowning_config.job_blacklist[team.GetName(v:Team())]) then
           continue
        end

        if (v:WaterLevel() >= 3) then
            if v:Alive() then
                v.ipr_player_water = (v.ipr_player_water or 0) + 1

                if (v.ipr_player_water <= ipr_drowning_config.sec) then
                    v:EmitSound("player/pl_drown" ..math.random(1, 3).. ".wav", 75, 100, 1, CHAN_AUTO)
                else
                    ipr_cache_id = v:UserID()

                    if not ipr_sound_sys[ipr_cache_id] then
                        ipr_sound_sys[ipr_cache_id] = {}

                        for i = 1, 2 do
                            ipr_sound_sys[ipr_cache_id][i] = (i == 1) and CreateSound(v, "player/heartbeat1.wav") or (i == 2) and CreateSound(v, "player/breathe1.wav")
                        end
                    else
                        if ipr_sound_sys[ipr_cache_id][2]:IsPlaying() then
                            ipr_sound_sys[ipr_cache_id][2]:Stop()
                        end
                    end
                    v:EmitSound("player/pl_drown" ..math.random(1, 3).. ".wav", 35, math.random(5, 20), 1, CHAN_AUTO)

                    if (v.ipr_inwater_cur and v.ipr_inwater_cur > 0) then
                        v.ipr_inwater_cur = 0
                    end

                    ipr_sound_sys[ipr_cache_id][1]:PlayEx(1, 100)
                    v:SetHealth(v:Health() - ipr_drowning_config.health_damage)

                    if (v:Health() <= 0) then
                        v:Kill()

                        v.ipr_player_water  = nil
                        v.ipr_inwater_cur = nil

                        ipr_clear_sound(ipr_cache_id)
                    end
                end
            end
        else
            if (v.ipr_player_water) then
                ipr_cache_id = v:UserID()

                if ipr_sound_sys[ipr_cache_id] then
                    ipr_sound_sys[ipr_cache_id][2]:PlayEx(1, 100)
                end
                v.ipr_inwater_cur = (v.ipr_inwater_cur or 0) + 1

                if (v.ipr_inwater_cur >= ipr_drowning_config.prevent_leave) then
                    v.ipr_player_water  = nil
                    v.ipr_inwater_cur = nil

                    ipr_clear_sound(ipr_cache_id)
                end
            end
        end
    end
end
timer.Create("ImprovedDrowning_Sys", 1, 0, ipr_drowning_sys)