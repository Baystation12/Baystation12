/spell/aoe_turf/knock
	name = "Knock"
	desc = "This spell opens nearby doors and does not require wizard garb."
	feedback = "KN"
	school = "transmutation"
	charge_max = 100
	spell_flags = 0
	invocation = "Aulie Oxin Fiera."
	invocation_type = SpI_WHISPER
	range = 3
	level_max = list(Sp_TOTAL = 4, Sp_SPEED = 4, Sp_POWER = 1)
	cooldown_min = 20 //20 deciseconds reduction per rank

	hud_state = "wiz_knock"

/spell/aoe_turf/knock/cast(list/targets)
	for(var/turf/T in targets)
		for(var/obj/machinery/door/door in T.contents)
			spawn(1)
				if(istype(door,/obj/machinery/door/airlock))
					var/obj/machinery/door/airlock/AL = door //casting is important
					AL.locked = 0
				door.open()
	return


/spell/aoe_turf/knock/empower_spell()
	if(!..())
		return 0
	range *= 2

	return "You've doubled the range of [src]."