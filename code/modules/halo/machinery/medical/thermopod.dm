#define LEPORAZINE /datum/reagent/leporazine
#define CRYOP /datum/reagent/cryoprethaline
#define HEXALINE /datum/reagent/hexaline
#define KETOPROF /datum/reagent/ketoprofen

/obj/machinery/thermopod
	name = "Thermal Regulator"
	desc = "A pod that uses a combination of drugs and heaters to maintain a normal human body temperature"
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "syndipod_0"
	density = 1
	anchored = 1
	clicksound = 'sound/machines/buttonbeep.ogg'
	clickvol = 30
	var/tmp/mob/living/carbon/human/occupant = null
	var/list/chems = list("Leporazine" = LEPORAZINE, "Cryoprethaline" = CRYOP, "Hexaline" = HEXALINE, "Ketoprofen" = KETOPROF)

	use_power = 1
	idle_power_usage = 15
	active_power_usage = 5000 //5kW. heater + autoinjectors

/obj/machinery/thermopod/Initialize()
	. = ..()
	update_icon()

/obj/machinery/thermopod/process()
	if(stat & (NOPOWER|BROKEN))
		return

	var/targetTemp = 310 //Default to 310K
	if(occupant)
		if(occupant.species.body_temperature)
			targetTemp = occupant.species.body_temperature
		var/bodytemp = occupant.bodytemperature
		if((bodytemp > targetTemp && bodytemp < (targetTemp + 40 * TEMPERATURE_DAMAGE_COEFFICIENT)) || (bodytemp < (targetTemp + 1) && bodytemp > (targetTemp - 40 * TEMPERATURE_DAMAGE_COEFFICIENT))) //Would leporazine work fast?
			if(occupant.reagents.get_reagent_amount(LEPORAZINE) < 10)
				var/amount = 10 - occupant.reagents.get_reagent_amount(LEPORAZINE)
				use_power(amount * CHEM_SYNTH_ENERGY)
				occupant.reagents.add_reagent(LEPORAZINE, amount) //Administer a small dose of leporazine

		//Low temp
		if(bodytemp < occupant.getSpeciesOrSynthTemp(COLD_LEVEL_1) && bodytemp > occupant.getSpeciesOrSynthTemp(COLD_LEVEL_2))
			if(occupant.reagents.get_reagent_amount(HEXALINE) < 5)
				var/amount = 5 - occupant.reagents.get_reagent_amount(HEXALINE)
				use_power(amount * CHEM_SYNTH_ENERGY)
				occupant.reagents.add_reagent(HEXALINE, amount) //Administer hexaline glycol
		else if (bodytemp < occupant.getSpeciesOrSynthTemp(COLD_LEVEL_2))
			if(occupant.reagents.get_reagent_amount(CRYOP) < 5)
				var/amount = 5 - occupant.reagents.get_reagent_amount(CRYOP)
				use_power(amount * CHEM_SYNTH_ENERGY)
				occupant.reagents.add_reagent(CRYOP, amount) //Administer cryoprethaline
		if (bodytemp < occupant.getSpeciesOrSynthTemp(COLD_LEVEL_3)) //Do an if so this is in addition to cryoprethaline
			use_power(HEAT_CAPACITY_HUMAN * 5)
			occupant.bodytemperature += 5 //Emergency heaters

		//High Temp. Doesn't do much since cryo already exists
		if(bodytemp > occupant.getSpeciesOrSynthTemp(HEAT_LEVEL_1))
			if(occupant.reagents.get_reagent_amount(KETOPROF) < 5)
				var/amount = 5 - occupant.reagents.get_reagent_amount(KETOPROF)
				use_power(amount * CHEM_SYNTH_ENERGY)
				occupant.reagents.add_reagent(KETOPROF, amount)

		//You won't sleep through this
		occupant.sleeping = 0

//Rip from sleeper code
/obj/machinery/thermopod/proc/go_in(var/mob/M, var/mob/user)
	if(!M)
		return
	if(stat & (BROKEN|NOPOWER))
		return
	if(occupant)
		to_chat(user, "<span class='warning'>\The [src] is already occupied.</span>")
		return

	if(M == user)
		visible_message("\The [user] starts climbing into \the [src].")
	else
		visible_message("\The [user] starts putting [M] into \the [src].")

	if(do_after(user, 20, src))
		if(occupant)
			to_chat(user, "<span class='warning'>\The [src] is already occupied.</span>")
			return
		M.stop_pulling()
		if(M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src
		M.forceMove(src)
		update_use_power(2)
		occupant = M
		update_icon()

//Rip from sleeper code
/obj/machinery/thermopod/proc/go_out()
	if(!occupant)
		return
	if(occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	occupant.dropInto(loc)
	occupant = null
	for(var/atom/movable/A in src) // In case an object was dropped inside or something
		A.dropInto(loc)
	update_use_power(1)
	update_icon()

//Rip from sleeper code
/obj/machinery/thermopod/MouseDrop_T(var/mob/target, var/mob/user)
	if(!CanMouseDrop(target, user))
		return
	if(!istype(target))
		return
	if(target.buckled)
		to_chat(user, "<span class='warning'>Unbuckle the subject before attempting to move them.</span>")
		return
	go_in(target, user)

//Sleeper code
/obj/machinery/thermopod/relaymove(var/mob/user)
	..()
	go_out()

//Sleeper code
/obj/machinery/thermopod/emp_act(var/severity)
	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return

	if(occupant)
		go_out()

	..(severity)

/obj/machinery/thermopod/attack_hand(var/mob/user)
	if(..())
		return 1

	ui_interact(user)

/obj/machinery/thermopod/attack_ai(var/mob/user)
	return attack_hand(user)


/obj/machinery/thermopod/ui_interact(var/mob/user, var/ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.outside_state)
	var/data[0]

	data["power"] = stat & (NOPOWER|BROKEN) ? 0 : 1

	var/list/reagents = list()
	for(var/T in chems)
		var/list/reagent = list()
		reagent["name"] = T
		if(occupant && occupant.reagents)
			reagent["amount"] = occupant.reagents.get_reagent_amount(chems[T])
		reagents += list(reagent)
	data["reagents"] = reagents.Copy()

	if(occupant)
		var/temp = occupant.bodytemperature
		data["occupant"] = "Body Temperature: [temp] K"
	else
		data["occupant"] = 0

	ui = GLOB.nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "thermopod.tmpl", "Thermal Regulator UI", 600, 600, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/obj/machinery/thermopod/Topic(href, href_list)
	if(..())
		return 1

	if(usr == occupant)
		to_chat(usr, "<span class='warning'>You can't reach the controls from the inside.</span>")
		return

	add_fingerprint(usr)

	if(href_list["eject"])
		go_out()

	return 1

/obj/machinery/thermopod/update_icon()
	icon_state = "syndipod_[occupant ? "1" : "0"]"

#undef LEPORAZINE
#undef CRYOP
#undef HEXALINE
#undef KETOPROF