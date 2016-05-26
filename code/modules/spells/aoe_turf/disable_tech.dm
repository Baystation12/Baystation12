/spell/aoe_turf/disable_tech
	name = "Disable Tech"
	desc = "This spell disables all weapons, cameras and most other technology in range."
	feedback = "DT"
	charge_max = 400
	spell_flags = NEEDSCLOTHES
	invocation = "NEC CANTIO"
	invocation_type = SpI_SHOUT
	selection_type = "range"
	range = 0
	inner_radius = -1
	level_max = list(Sp_TOTAL = 2, Sp_SPEED = 2, Sp_POWER = 2)
	cooldown_min = 200 //50 deciseconds reduction per rank

	var/emp_heavy = 3
	var/emp_light = 5

	hud_state = "wiz_tech"

/spell/aoe_turf/disable_tech/cast(list/targets)

	for(var/turf/target in targets)
		empulse(get_turf(target), emp_heavy, emp_light)
	return

/spell/aoe_turf/disable_tech/empower_spell()
	if(!..())
		return 0
	emp_heavy += 2
	emp_light += 2

	return "You've increased the range of [src]."