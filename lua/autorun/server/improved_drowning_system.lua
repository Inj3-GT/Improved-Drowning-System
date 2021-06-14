--- Script By Inj3
--- Script By Inj3
--- Script By Inj3
----https://steamcommunity.com/id/Inj3/

local Improved_Drowning_System_Sec = 7 --- Délai avant la noyade.
local Improved_Drowning_System_HealthDamge = 7 --- Dégât lors de la noyade (par seconde).
local Improved_Drowning_System_PreventLeave = 5 --- Si le joueur sort de l'eau, le temps en secondes avant que le délai ("Improved_Drowning_System_Sec") ne soit réinitialisé, si le temps n'est pas réinitialisé, le joueur reprendra instantanément des dégâts lorsqu'il replongera dans l'eau (corps totalement immergé).

local Improved_Sound_Sys = Improved_Sound_Sys or {}
local Improved_Sound_Max = 2
local math = math

local function ImprovedClearSound(ply)
     if Improved_Sound_Sys[ply:UserID()] then
	 
          for i = 1, Improved_Sound_Max do
               Improved_Sound_Sys[ply:UserID()][i]:Stop()
          end

          Improved_Sound_Sys[ply:UserID()] = nil
     end
end

local function Improved_Drowning_System()
     local Improved_Class_Sys = ents.FindByClass("player")

     for _, v in ipairs (Improved_Class_Sys) do
          if (v:WaterLevel() >= 3) then
               if v:Alive() then
                    v.Improved_PlayerWater = (v.Improved_PlayerWater or 0) + 1

                    if (v.Improved_PlayerWater <= Improved_Drowning_System_Sec) then
                         v:EmitSound("player/pl_drown" ..math.random(1, 3).. ".wav", 75, 100, 1, CHAN_AUTO)

                    else
                         if not Improved_Sound_Sys[v:UserID()] then
                              Improved_Sound_Sys[v:UserID()] = {}

                              for i = 1, Improved_Sound_Max do
                                   Improved_Sound_Sys[v:UserID()][i] = i == 1 and CreateSound(v, "player/heartbeat1.wav") or i == 2 and CreateSound(v, "player/breathe1.wav")
                              end
                         else
                              if Improved_Sound_Sys[v:UserID()][2]:IsPlaying() then
                                   Improved_Sound_Sys[v:UserID()][2]:Stop()
                              end
                         end

                         if v.PlayerInWaterCur and v.PlayerInWaterCur > 0 then
                              v.PlayerInWaterCur = 0
                         end
                         v:EmitSound("player/pl_drown" ..math.random(1, 3).. ".wav", 35, math.random(5, 20), 1, CHAN_AUTO)

                         Improved_Sound_Sys[v:UserID()][1]:PlayEx(1, 100)
                         v:SetHealth( v:Health() - Improved_Drowning_System_HealthDamge )

                         if (v:Health() <= 0) then
                              v:Kill()

                              v.Improved_PlayerWater  = nil
                              v.PlayerInWaterCur = nil

                              ImprovedClearSound(v)
                         end
                    end
               end

          else
               if v.Improved_PlayerWater then
			   
                    if Improved_Sound_Sys[v:UserID()] then
                         Improved_Sound_Sys[v:UserID()][2]:PlayEx(1, 100)
                    end

                    v.PlayerInWaterCur = (v.PlayerInWaterCur or 0) + 1

                    if (v.PlayerInWaterCur >= Improved_Drowning_System_PreventLeave) then
                         v.Improved_PlayerWater  = nil
                         v.PlayerInWaterCur = nil

                         ImprovedClearSound(v)
                    end
               end
          end
     end
end

timer.Create("ImprovedDrowning_Sys", 1, 0, Improved_Drowning_System)
