/spell/aoe_turf/smoke
	name = "Smoke"
	desc = "This spell spawns a cloud of choking smoke at your location and does not require wizard garb."
	feedback = "SM"
	school = "transmutation"
	charge_max = 120
	spell_flags = 0
	invocation = "none"
	invocation_type = SpI_NONE
	range = 1
	inner_radius = -1
	level_max = list(Sp_TOTAL = 3, Sp_SPEED = 3, Sp_POWER = 2)
	cooldown_min = 20 //25 deciseconds reduction per rank

	smoke_spread = 2
	smoke_amt = 5

	hud_state = "wiz_smoke"

/spell/aoe_turf/smoke/empower_spell()
	if(!..())
		return 0
	smoke_amt += 2

	return "[src] will now create more smoke."