/obj/machinery/sleeper
	name = "Sleeper"
	desc = "A fancy bed with built-in injectors, a dialysis machine, and a limited health scanner."
	icon = 'icons/obj/Cryogenic2.dmi'
	icon_state = "sleeper_0"
	density = 1
	anchored = 1
	var/orient = "LEFT" // "RIGHT" changes the dir suffix to "-r"
	var/mob/living/carbon/human/occupant = null
	var/list/available_chemicals = list("inaprovaline" = "Inaprovaline", "stoxin" = "Soporific", "paracetamol" = "Paracetamol", "anti_toxin" = "Dylovene", "dexalin" = "Dexalin")
	var/obj/item/weapon/reagent_containers/glass/beaker = null
	var/filtering = 0

	use_power = 1
	idle_power_usage = 15
	active_power_usage = 200 //builtin health analyzer, dialysis machine, injectors.

/obj/machinery/sleeper/New()
	..()
	beaker = new /obj/item/weapon/reagent_containers/glass/beaker/large(src)
	spawn(5)
		update_icon()

/obj/machinery/sleeper/process()
	if(stat & (NOPOWER|BROKEN))
		return

	if(filtering > 0)
		if(beaker)
			if(beaker.reagents.total_volume < beaker.reagents.maximum_volume)
				var/pumped = 0
				for(var/datum/reagent/x in occupant.reagents.reagent_list)
					occupant.reagents.trans_to_obj(beaker, 3)
					pumped++
				if(ishuman(occupant))
					occupant.vessel.trans_to_obj(beaker, pumped + 1)
		else
			toggle_filter()

/obj/machinery/sleeper/update_icon()
	icon_state = "sleeper_[occupant ? "1" : "0"][orient == "RIGHT" ? "-r" : ""]"

/obj/machinery/sleeper/attack_hand(var/mob/user)
	if(..())
		return

	ui_interact(user)

/obj/machinery/sleeper/ui_interact(var/mob/user, var/ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = outside_state)
	var/data[0]

	data["power"] = stat & (NOPOWER|BROKEN) ? 0 : 1

	var/list/reagents = list()
	for(var/T in available_chemicals)
		var/list/reagent = list()
		reagent["id"] = T
		reagent["name"] = available_chemicals[T]
		if(occupant)
			reagent["amount"] = occupant.reagents.get_reagent_amount(T)
		reagents += list(reagent)
	data["reagents"] = reagents.Copy()

	if(occupant)
		data["occupant"] = 1
		switch(occupant.stat)
			if(CONSCIOUS)
				data["stat"] = "Conscious"
			if(UNCONSCIOUS)
				data["stat"] = "Unconscious"
			if(DEAD)
				data["stat"] = "<font color='red'>dead</font>"
		data["health"] = occupant.health
		if(iscarbon(occupant))
			var/mob/living/carbon/C = occupant
			data["pulse"] = C.get_pulse(GETPULSE_TOOL)
		data["brute"] = occupant.getBruteLoss()
		data["burn"] = occupant.getFireLoss()
		data["oxy"] = occupant.getOxyLoss()
		data["tox"] = occupant.getToxLoss()
	else
		data["occupant"] = 0
	if(beaker)
		data["beaker"] = beaker.reagents.get_free_space()
	else
		data["beaker"] = -1
	data["filtering"] = filtering

	ui = nanomanager.try_update_ui(user, src, ui_key, ui, data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "sleeper.tmpl", "Sleeper UI", 600, 600, state = state)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)

/*
[17:55]	GinjaNinja32	https://github.com/Baystation12/Baystation12/tree/dev-freeze/code/modules/nano/interaction
[17:55]	NanoTrasen_Inc	Ginja: Baystation12/code/modules/nano/interaction at dev-freeze · Baystation12/Baystation12 · GitHub
[17:55]	PsiOmegaDelta	Hmm
[17:55]	Kelenius	I suppose I could send a parameter to NanoUI and blank out the UI
[17:56]	GinjaNinja32	use a topic state
[17:56]	Kelenius	blinks cluelessly
[17:56]	GinjaNinja32	look at what I just linked
[17:57]	PsiOmegaDelta	What you probably want to do is extend nano/interaction/default.dm
[17:57]	PsiOmegaDelta	And override mob/living/default_can_use_topic()
[17:57]	PsiOmegaDelta	Have it first check if src is inside src_object, if so return STATUS_CLOSE
[17:58]	PsiOmegaDelta	Otherwise, return ..()
[17:57]	PsiOmegaDelta	What you probably want to do is extend nano/interaction/default.dm
[17:57]	PsiOmegaDelta	And override mob/living/default_can_use_topic()
[17:57]	PsiOmegaDelta	Have it first check if src is inside src_object, if so return STATUS_CLOSE
[17:58]	PsiOmegaDelta	Otherwise, return ..()
[17:58]	Azlier	if you dont what i say ill start quoting kurt vonnegut and the art of war
[17:59]	PsiOmegaDelta	Then, at your ui = new(...) line
[17:59]	PsiOmegaDelta	Add the argument: state = new your_new_state()
[17:59]	PsiOmegaDelta	You can make it global as with the other state handlers tho


[18:04]	Kelenius	So uh, I need return 1 at the end of Topic?
[18:04]	Kelenius	Or all returns in Topic must return 1?
[18:04]	GinjaNinja32	return 1 for any call that did something that requires a UI update
[18:04]	GinjaNinja32	well, anything that did something, really
[18:04]	Kelenius	Do I need to up nanomanager.update_uis(src) if I do return 1?
[18:04]	GinjaNinja32	no
[18:05]	Kelenius	Where do I need it?
[18:05]	GinjaNinja32	nowhere
[18:05]	Kelenius	How about process()?
[18:05]	GinjaNinja32	unless a change comes through that's not from Topic() that needs an update sent through
[18:05]	Kelenius	Because a sleeper needs to update every tick
[18:06]	GinjaNinja32	nanoui will call ui_interact() every tick
[18:06]	PsiOmegaDelta	If you've set ui.set_auto_update(1) it will update every tick
[18:06]	PsiOmegaDelta	Or as often as the NanoUI process runs anyway
[18:06]	Kelenius	Where do I need to set it? In UI creation?
[18:06]	Mloc	yes
[18:06]	Mloc	I told you this
[18:06]	Mloc	
[18:06]	PsiOmegaDelta	You basically have the lines
[18:06]	PsiOmegaDelta	ui = new(...)
[18:06]	PsiOmegaDelta	ui.set_initial_data(data)
[18:07]	PsiOmegaDelta	ui.open()
[18:07]	PsiOmegaDelta	ui.set_auto_update(1)
[18:07]	PsiOmegaDelta	Auto-refresh go
[18:07]	Mloc	with an if(!ui) first
*/

/obj/machinery/sleeper/Topic(href, href_list)
	if(..())
		return

	if(usr == occupant)
		usr << "<span class='warning'>You can't reach the controls from the inside.</span>"
		return

	add_fingerprint(usr)

	if(href_list["eject"])
		go_out()
	if(href_list["beaker"])
		remove_beaker()
	if(href_list["filter"])
		toggle_filter()
	if(href_list["chemical"] && href_list["amount"])
		if(occupant && occupant.stat != DEAD)
			if(href_list["chemical"] in available_chemicals) // Your hacks are bad and you should feel bad
				inject_chemical(usr, href_list["chemical"], text2num(href_list["amount"]))

	return 1

/obj/machinery/sleeper/attack_ai(var/mob/user)
	return attack_hand(user)

/obj/machinery/sleeper/attackby(var/obj/item/I, var/mob/user)
	add_fingerprint(user)
	if(istype(I, /obj/item/weapon/reagent_containers/glass))
		if(!beaker)
			beaker = I
			user.drop_item()
			I.loc = src
			user.visible_message("<span class='notice'>[user] adds \a [I] to \the [src].</span>", "<span class='notice'>You add \a [I] to \the [src].</span>")
		else
			user << "<span class='warning'>\The [src] has a beaker already.</span>"
		return

/obj/machinery/sleeper/MouseDrop_T(var/mob/target, var/mob/user)
	if(user.stat || user.lying || !Adjacent(user) || !target.Adjacent(user)|| !ishuman(target))
		return
	go_in(target, user)

/obj/machinery/sleeper/relaymove(var/mob/user)
	..()
	go_out()

/obj/machinery/sleeper/emp_act(var/severity)
	if(filtering)
		toggle_filter()

	if(stat & (BROKEN|NOPOWER))
		..(severity)
		return

	if(occupant)
		go_out()

	..(severity)

/obj/machinery/sleeper/proc/toggle_filter()
	if(!occupant || !beaker)
		filtering = 0
		return
	if(filtering)
		filtering = 0
	else
		filtering = 1

/obj/machinery/sleeper/proc/go_in(var/mob/M, var/mob/user)
	if(!M)
		return
	if(stat & (BROKEN|NOPOWER))
		return
	if(occupant)
		user << "<span class='warning'>The sleeper is already occupied.</span>"
		return

	if(M == user)
		visible_message("[user] starts climbing into \the [src].")
	else
		visible_message("[user] starts putting [M] into \the [src].")

	if(do_after(user, 20))
		if(occupant)
			user << "<span class='warning'>The sleeper is already occupied.</span>"
			return
		M.stop_pulling()
		if(M.client)
			M.client.perspective = EYE_PERSPECTIVE
			M.client.eye = src
		M.loc = src
		update_use_power(2)
		occupant = M
		update_icon()

/obj/machinery/sleeper/proc/go_out()
	if(!occupant)
		return
	if(occupant.client)
		occupant.client.eye = occupant.client.mob
		occupant.client.perspective = MOB_PERSPECTIVE
	occupant.loc = loc
	occupant = null
	for(var/atom/movable/A in src) // In case an object was dropped inside or something
		if(A == beaker)
			continue
		A.loc = loc
	update_use_power(1)
	update_icon()
	toggle_filter()

/obj/machinery/sleeper/proc/remove_beaker()
	if(beaker)
		beaker.loc = usr.loc
		beaker = null
		toggle_filter()

/obj/machinery/sleeper/proc/inject_chemical(var/mob/living/user, var/chemical, var/amount)
	if(stat & (BROKEN|NOPOWER))
		return

	if(occupant && occupant.reagents)
		if(occupant.reagents.get_reagent_amount(chemical) + amount <= 20)
			use_power(amount * CHEM_SYNTH_ENERGY)
			occupant.reagents.add_reagent(chemical, amount)
			user << "Occupant now has [occupant.reagents.get_reagent_amount(chemical)] units of [available_chemicals[chemical]] in their bloodstream."
		else
			user << "The subject has too many chemicals."
	else
		user << "There's no suitable occupant in the sleeper."
