--- Script By Inj3
--- Script By Inj3
--- Script By Inj3
----https://steamcommunity.com/id/Inj3/

local Improved_Drowning_System_Sec = 7 --- Délai avant la noyade.
local Improved_Drowning_System_HealthDamge = 10 --- Dégât lors de la noyade (par seconde).
local Improved_Drowning_System_PreventLeave = 5 --- Si le joueur sort de l'eau, le temps en secondes avant que le délai ("Improved_Drowning_System_Sec") ne soit réinitialisé, si le temps n'est pas réinitialisé, le joueur reprendra instantanément des dégâts lorsqu'il replongera dans l'eau (corps totalement immergé).

local math = math
local Improved_IdLoop
local function Improved_Drowning_System()
     local Improved_Class_Sys = ents.FindByClass("player")

     for _, v in ipairs (Improved_Class_Sys) do
          if (v:WaterLevel() >= 3) then
               if v:Alive() then
                    v.Improved_PlayerWater = (v.Improved_PlayerWater or 0) + 1

                    if (v.Improved_PlayerWater <= Improved_Drowning_System_Sec) then
                         v:EmitSound("player/pl_drown" ..math.random(1, 3).. ".wav", 100, math.random(60, 100))

                    else
                         Improved_IdLoop = v:StartLoopingSound( "player/heartbeat1.wav" )

                         v:EmitSound("player/pl_drown" ..math.random(1, 3).. ".wav", 100, math.random(60, 100))
                         v:SetHealth( v:Health() - Improved_Drowning_System_HealthDamge )

                         if (v:Health() <= 0) then
                              v:Kill()

                              v.Improved_PlayerWater  = nil
                              v.PlayerInWaterCur = nil
                              v:StopLoopingSound(Improved_IdLoop)
                         end
                    end
               end

          else
               if v.Improved_PlayerWater then
                    v.PlayerInWaterCur = (v.PlayerInWaterCur or 0) + 1

                    if v.PlayerInWaterCur >= Improved_Drowning_System_PreventLeave then
                         v.Improved_PlayerWater  = nil
                         v.PlayerInWaterCur = nil

                         if Improved_IdLoop then
                              v:StopLoopingSound(Improved_IdLoop)
                         end
                    end
               end
          end

     end
end

timer.Create("ImprovedDrowning_Sys", 1, 0, Improved_Drowning_System)
