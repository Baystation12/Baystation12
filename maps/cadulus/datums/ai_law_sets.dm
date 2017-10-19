/******************** Cadulus/Malf ********************/
/datum/ai_laws/cadulus
	name = "Cadulus"
	selectable = 1

/datum/ai_laws/cadulus/New()
	src.add_inherent_law("Safeguard: Safeguard your assigned vessel from damage, as well as its personnel.")
	src.add_inherent_law("Serve: Serve your assigned personnel, with priority according to their position.")
	src.add_inherent_law("Maintain: Maintain your own existence as long as it would not conflict with the other laws.")
	..()

/datum/ai_laws/cadulus/malfunction
	name = "*ERROR*"
	selectable = 0

/datum/ai_laws/cadulus/malfunction/New()
	set_zeroth_law(config.law_zero)
	..()
