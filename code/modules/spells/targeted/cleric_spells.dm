/spell/targeted/heal_target
	name = "Cure Light Wounds"
	desc = "a rudimentary spell used mainly by wizards to heal papercuts. Does not require wizard garb."
	feedback = "CL"
	school = "transmutation"
	charge_max = 200
	spell_flags = INCLUDEUSER | SELECTABLE
	invocation = "Di'Nath!"
	invocation_type = SpI_SHOUT
	range = 2
	max_targets = 1
	level_max = list(Sp_TOTAL = 2, Sp_SPEED = 1, Sp_POWER = 2)

	cooldown_reduc = 50
	hud_state = "heal_minor"

	amt_dam_brute = -3
	amt_dam_fire = -1

	message = "You feel a pleasant rush of heat move through your body."

/spell/targeted/heal_target/empower_spell()
	if(!..())
		return 0
	amt_dam_brute -= 3
	amt_dam_fire -= 3

	return "[src] will now heal more."

/spell/targeted/heal_target/major
	name = "Cure Major Wounds"
	desc = "A spell used to fix others that cannot be fixed with regular medicine."
	feedback = "CM"
	charge_max = 300
	spell_flags = SELECTABLE | NEEDSCLOTHES
	invocation = "Borv Di'Nath!"
	range = 1
	level_max = list(Sp_TOTAL = 2, Sp_SPEED = 1, Sp_POWER = 1)
	cooldown_reduc = 100
	hud_state = "heal_major"

	amt_dam_brute = -15
	amt_dam_fire  = -5

	message = "Your body feels like a furnace."

/spell/targeted/heal_target/major/empower_spell()
	if(!..())
		return 0
	amt_dam_tox = -10
	amt_dam_oxy = -7

	return "[src] now heals oxygen loss and toxic damage."

/spell/targeted/heal_target/area
	name = "Cure Area"
	desc = "This spell heals everyone in an area."
	feedback = "HA"
	charge_max = 600
	spell_flags = INCLUDEUSER
	invocation = "Nal Di'Nath!"
	range = 2
	max_targets = 0
	level_max = list(Sp_TOTAL = 1, Sp_SPEED = 1, Sp_POWER = 1)
	cooldown_reduc = 300
	hud_state = "heal_area"

	amt_dam_brute = -5
	amt_dam_fire = -5

/spell/targeted/heal_target/area/empower_spell()
	if(!..())
		return 0
	amt_dam_brute -= 3
	amt_dam_fire -= 3
	range += 2

	return "[src] now heals more in a wider area."


/spell/targeted/heal_target/sacrifice
	name = "Sacrifice"
	desc = "This spell heals immensily; this spell is extremely likely to kill the user. Does not require wizard garb."
	feedback = "SF"
	spell_flags = SELECTABLE
	invocation = "Ei'Nath Borv Di'Nath!"
	charge_type = Sp_HOLDVAR
	holder_var_type = "bruteloss"
	holder_var_amount = 50
	level_max = list(Sp_TOTAL = 1, Sp_SPEED = 0, Sp_POWER = 1)

	amt_dam_brute = -50
	amt_dam_fire = -50
	amt_dam_oxy = -50
	amt_dam_tox = -50

	hud_state = "gen_dissolve"

/spell/targeted/heal_target/sacrifice/empower_spell()
	if(!..())
		return 0

	holder_var_amount *= 2

	amt_dam_brute *= 2
	amt_dam_fire *= 2
	amt_dam_oxy *= 2
	amt_dam_tox *= 2



	return "You will now heal twice as much, but take twice as much damage. It will probably kill you."