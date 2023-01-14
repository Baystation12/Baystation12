
/datum/event/vent_clog
	announceWhen	= 1
	startWhen		= 5
	endWhen			= 35
	var/interval 	= 2
	var/list/vents  = list()
	var/list/gunk = list(
	/datum/reagent/water/boiling = 10,
	/datum/reagent/nutriment/flour = 3,
	/datum/reagent/toxin/serotrotium = 3,
	/datum/reagent/space_cleaner = 6,
	/datum/reagent/nutriment/protein/egg = 6,
	/datum/reagent/capsaicin/condensed = 2,
	/datum/reagent/drugs/mindbreaker = 3,
	/datum/reagent/drink/juice/berry = 3,
	/datum/reagent/drink/juice/banana = 3,
	/datum/reagent/drugs/hextro = 2,
	/datum/reagent/water/holywater = 3,
	/datum/reagent/ethanol/beer = 5,
	/datum/chemical_reaction/hot_coco = 5,
	/datum/reagent/acid/hydrochloric = 2,
	/datum/reagent/luminol = 2,
	/datum/reagent/crayon_dust = 1,
	/datum/reagent/hyperzine = 5
	)



/datum/event/vent_clog/setup()
	endWhen = rand(25, 100)
	for(var/obj/machinery/atmospherics/unary/vent_scrubber/temp_vent in SSmachines.processing)
		if(!temp_vent)
			continue
		if(isStationLevel(temp_vent.z))
			if(temp_vent.network && temp_vent.network.normal_members.len > 20)
				vents += temp_vent
	if(!vents.len)
		return kill()

/datum/event/vent_clog/tick()
	if(activeFor % interval == 0)
		var/obj/machinery/atmospherics/unary/vent_scrubber/vent = pick_n_take(vents)

		if(vent && vent.loc && !vent.welded)

			var/datum/reagent/chem = pickweight(gunk)
			var/reagent_amount = rand(2,5) * 5 //10 to 25 units
			var/datum/reagents/R = new/datum/reagents(reagent_amount, GLOB.temp_reagents_holder)
			R.my_atom = vent
			R.add_reagent(chem, reagent_amount)

			var/datum/effect/effect/system/smoke_spread/chem/smoke = new
			smoke.show_log = 0//This spams admin logs if not disabled.
			smoke.set_up(R, 10, 0, vent)
			playsound(vent.loc, 'sound/effects/smoke.ogg', 50, 1, -3)
			smoke.start()
			qdel(R)


/datum/event/vent_clog/announce()
	command_announcement.Announce("Система фильтрации воздуха находится под воздействием избыточного давления. Возможны утечки содержимого.", "Атмосферная тревога", zlevels = affecting_z)
