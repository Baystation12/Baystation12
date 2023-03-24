/mob/proc/changeling_spiders()
	set category = "Changeling"
	set name = "Spread spiders (30)"

	var/datum/changeling/changeling = changeling_power(30)
	if(!changeling)	return
	changeling.chem_charges -= 30

	var/turf = get_turf(src)
	for(var/I in 1 to 2)
		var/obj/effect/spider/spiderling/Sp = new(turf)
		Sp.amount_grown = 1
	return 1
