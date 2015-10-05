require('Inspired')

PrintChat("ADC MAIN | Tristana loaded.")
PrintChat("by Noddy")

mainMenu = Menu("ADC MAIN | Tristana", "Tristana")
mainMenu:SubMenu("Combo", "Combo")
mainMenu.Combo:Boolean("useQ", "Use Q in combo", true)
mainMenu.Combo:Boolean("useE", "Use E in combo", true)
mainMenu.Combo:Boolean("useR", "Use R in combo", true)
mainMenu.Combo:Key("Combo1", "Combo", string.byte(" "))
-------------------------------------------
mainMenu:SubMenu("Killsteal", "Killsteal")
mainMenu.Killsteal:Boolean("ksR", "Use R - KS", true)
mainMenu.Killsteal:Boolean("ERKS", "Use R if E can kill", true)
-------------------------------------------
mainMenu:SubMenu("Drawings", "Drawings")
mainMenu.Drawings:Boolean("drawR","Draw R damage", true)
-------------------------------------------
mainMenu:SubMenu("Items", "Items")
mainMenu.Items:Boolean("useCut", "Bilgewater Cutlass", true)
mainMenu.Items:Boolean("useBork", "Blade of the Ruined King", true)
mainMenu.Items:Boolean("useGhost", "Youmuu's Ghostblade", true)
mainMenu.Items:Boolean("useRedPot", "Elixir of Wrath", true)

eDMG = 0

OnLoop ( function (myHero)

local myHeroPos = GetOrigin(myHero)
local target = GetCurrentTarget()

-- Items
local CutBlade = GetItemSlot(myHero,3144)
local bork = GetItemSlot(myHero,3153)
local ghost = GetItemSlot(myHero,3142)
local redpot = GetItemSlot(myHero,2140)

-- Use Items
if mainMenu.Combo.Combo1:Value() then
	if CutBlade >= 1 and GoS:ValidTarget(target,GetCastRange(myHero,_R)) and mainMenu.Items.useCut:Value() then
		if CanUseSpell(myHero,GetItemSlot(myHero,3144)) == READY then
			CastTargetSpell(target, GetItemSlot(myHero,3144))
		end	
	elseif bork >= 1 and GoS:ValidTarget(target,GetCastRange(myHero,_R)) and (GetMaxHP(myHero) / GetCurrentHP(myHero)) >= 1.25 and mainMenu.Items.useBork:Value() then 
		if CanUseSpell(myHero,GetItemSlot(myHero,3153)) == READY then
			CastTargetSpell(target,GetItemSlot(myHero,3153))
		end
	end

	if ghost >= 1 and GoS:ValidTarget(target,GetCastRange(myHero,_R)) and mainMenu.Items.useGhost:Value() then
		if CanUseSpell(myHero,GetItemSlot(myHero,3142)) == READY then
			CastSpell(GetItemSlot(myHero,3142))
		end
	end
	
	if redpot >= 1 and GoS:ValidTarget(target,GetCastRange(myHero,_R)) and mainMenu.Items.useRedPot:Value() then
		if CanUseSpell(myHero,GetItemSlot(myHero,2140)) == READY then
			CastSpell(GetItemSlot(myHero,2140))
		end
	end
end

KSR()

for i,enemy in pairs(GoS:GetEnemyHeroes()) do
if CanUseSpell(myHero,_R) == READY then
if GotBuff(enemy,"tristanaechargesound") == 1 then
eDMG = GoS:CalcDamage(myHero, enemy, (10*GetCastLevel(myHero,_E)+50+((0.15*(GetCastLevel(myHero,_E))+0.35)*(GetBaseDamage(myHero) + GetBonusDmg(myHero)))+(0.5*GetBonusAP(myHero))) + ((GotBuff(enemy,"tristanaecharge")-1)*(3*GetCastLevel(myHero,_E)+15+((0.045*(GetCastLevel(myHero,_E))+0.105)*(GetBaseDamage(myHero) + GetBonusDmg(myHero)))+(0.15*GetBonusAP(myHero)))), 0 )
elseif GotBuff(enemy,"tristanaechargesound") == 0 then
eDMG = 0
end

if CanUseSpell(myHero,_R) == READY then	
	drRDMG = GoS:CalcDamage(myHero, enemy, 0, 100*GetCastLevel(myHero,_R)+ 200 + (1.0*GetBonusAP(myHero)))
elseif CanUseSpell(myHero,_R) == NOTAVAILABLE then
	drRDMG = 0
end

if GoS:ValidTarget(enemy,2000) then
	if mainMenu.Drawings.drawR:Value() and GoS:ValidTarget(enemy,2000) and CanUseSpell(myHero,_R) == READY then
		DrawDmgOverHpBar(enemy,GetCurrentHP(enemy),eDMG + GoS:CalcDamage(myHero, enemy, 0, 100*GetCastLevel(myHero,_R)+ 200 + (1.0*GetBonusAP(myHero))),0,0xff00ff00)
	end
end

else

if GotBuff(enemy,"tristanaechargesound") == 1 then
eDMG = GoS:CalcDamage(myHero, enemy, (10*GetCastLevel(myHero,_E)+50+((0.15*(GetCastLevel(myHero,_E))+0.35)*(GetBaseDamage(myHero) + GetBonusDmg(myHero)))+(0.5*GetBonusAP(myHero))) + ((GotBuff(enemy,"tristanaecharge")-1)*(3*GetCastLevel(myHero,_E)+15+((0.045*(GetCastLevel(myHero,_E))+0.105)*(GetBaseDamage(myHero) + GetBonusDmg(myHero)))+(0.15*GetBonusAP(myHero)))), 0 )
elseif GotBuff(enemy,"tristanaechargesound") == 0 then
eDMG = 0
end
	
	DrawDmgOverHpBar(enemy,GetCurrentHP(enemy),eDMG,0,0xff00ff00)
end
end

if mainMenu.Combo.Combo1:Value() then

	if CanUseSpell(myHero,_E) == READY and mainMenu.Combo.useE:Value() and GoS:ValidTarget(target,GetCastRange(myHero,_R) + 20) then
		CastTargetSpell(target,_E)
	end
	if CanUseSpell(myHero,_Q) == READY and GoS:ValidTarget(target,850) and mainMenu.Combo.useQ:Value() then
		CastSpell(_Q)
	end
	if CanUseSpell(myHero,_R) == READY and GoS:ValidTarget(target,GetCastRange(myHero,_R)) and mainMenu.Combo.useR:Value() and GetCurrentHP(target) < GoS:CalcDamage(myHero, target, 0, 100*GetCastLevel(myHero,_R)+ 200 + (1.0*GetBonusAP(myHero))) then
		CastTargetSpell(target,_R)
	end	
end
end)

function KSR()
for i,enemy in pairs(GoS:GetEnemyHeroes()) do

if mainMenu.Killsteal.ERKS:Value() then
if GotBuff(enemy,"tristanaechargesound") == 1 then
eDMG = GoS:CalcDamage(myHero, enemy, (10*GetCastLevel(myHero,_E)+40+((0.15*(GetCastLevel(myHero,_E))+0.35)*(GetBaseDamage(myHero) + GetBonusDmg(myHero)))+(0.5*GetBonusAP(myHero))) + ((GotBuff(enemy,"tristanaecharge")-1)*(3*GetCastLevel(myHero,_E)+15+((0.045*(GetCastLevel(myHero,_E))+0.105)*(GetBaseDamage(myHero) + GetBonusDmg(myHero)))+(0.15*GetBonusAP(myHero)))), 0 ) - GetHPRegen(enemy)*4
elseif GotBuff(enemy,"tristanaechargesound") == 0 then
eDMG = 0
end
end
	if CanUseSpell(myHero,_R) == READY and mainMenu.Killsteal.ksR:Value() and GoS:ValidTarget(enemy,GetCastRange(myHero,_R)) then
		rDMG = GoS:CalcDamage(myHero, enemy, 0, 100*GetCastLevel(myHero,_R)+ 200 + (1.0*GetBonusAP(myHero)))
			if GetCurrentHP(enemy) < rDMG+eDMG then
				CastTargetSpell(enemy,_R)
			end	
	end		
end
end
