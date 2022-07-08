/obj/item/gun/energy/gun
	name = "energy gun"
	desc = "Another bestseller of Lawson Arms and the FTU, the LAEP90 Perun is a versatile energy based sidearm, capable of switching between low, medium and high power projectile settings. In other words: stun, shock or kill."
	icon = 'icons/obj/guns/energy_gun.dmi'
	icon_state = "energystun100"
	item_state = null	//so the human update icon uses the icon_state instead.
	max_shots = 10
	fire_delay = 10 // To balance for the fact that it is a pistol and can be used one-handed without penalty

	projectile_type = /obj/item/projectile/beam/stun
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 2)
	modifystate = "energystun"

	init_firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, modifystate="energystun"),
		list(mode_name="shock", projectile_type=/obj/item/projectile/beam/stun/shock, modifystate="energyshock"),
		list(mode_name="kill", projectile_type=/obj/item/projectile/beam, modifystate="energykill"),
		)

/obj/item/gun/energy/gun/skrell
	name = "skrellian handgun"
	desc = "A common Skrellian side-arm, the Xuxquu*'Voom-5, or XV-5, is a more traditional energy weapon, tuned to dispense beams in three different wavelengths."
	w_class = ITEM_SIZE_NORMAL
	slot_flags = SLOT_BELT|SLOT_HOLSTER
	icon = 'icons/obj/guns/skrell_pistol.dmi'
	icon_state = "skrell_pistol_stun_100"
	max_shots = 10
	fire_delay = 6
	one_hand_penalty = 1
	self_recharge = 1

	projectile_type = /obj/item/projectile/beam/stun
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_POWER = 3)
	modifystate = "skrell_pistol_stun"

	init_firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, modifystate="skrell_pistol_stun"),
		list(mode_name="shock", projectile_type=/obj/item/projectile/beam/stun/shock, modifystate="skrell_pistol_shock"),
		list(mode_name="kill", projectile_type=/obj/item/projectile/beam, modifystate="skrell_pistol_kill"),
		)

/obj/item/gun/energy/gun/small
	name = "small energy gun"
	desc = "A smaller model of the versatile LAEP90 Perun, the LAEP90-C packs considerable utility in a smaller package. Best used in situations where full-sized sidearms are inappropriate."
	icon = 'icons/obj/guns/small_egun.dmi'
	icon_state = "smallgunstun"
	max_shots = 6
	w_class = ITEM_SIZE_SMALL
	force = 2 //it's the size of a car key, what did you expect?
	modifystate = "smallgunstun"

	init_firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun, modifystate="smallgunstun"),
		list(mode_name="shock", projectile_type=/obj/item/projectile/beam/stun/shock, modifystate="smallgunshock"),
		list(mode_name="kill", projectile_type=/obj/item/projectile/beam/smalllaser, modifystate="smallgunkill"),
		)

/obj/item/gun/energy/gun/mounted
	name = "mounted energy gun"
	self_recharge = 1
	use_external_power = 1
	has_safety = FALSE

/obj/item/gun/energy/gun/nuclear
	name = "advanced energy gun"
	desc = "An energy gun with an experimental miniaturized reactor."
	icon = 'icons/obj/guns/adv_egun.dmi'
	icon_state = "nucgun"
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 5, TECH_POWER = 3)
	slot_flags = SLOT_BELT
	w_class = ITEM_SIZE_LARGE
	force = 8 //looks heavier than a pistol
	self_recharge = 1
	modifystate = null
	one_hand_penalty = 1 //bulkier than an e-gun, but not quite the size of a carbine

	init_firemodes = list(
		list(mode_name="stun", projectile_type=/obj/item/projectile/beam/stun),
		list(mode_name="shock", projectile_type=/obj/item/projectile/beam/stun/shock),
		list(mode_name="kill", projectile_type=/obj/item/projectile/beam),
		)

	var/fail_counter = 0

//override for failcheck behaviour
/obj/item/gun/energy/gun/nuclear/Process()
	if(fail_counter > 0)
		SSradiation.radiate(src, (fail_counter * 2))
		fail_counter--

	return ..()

/obj/item/gun/energy/gun/nuclear/emp_act(severity)
	..()
	switch(severity)
		if(EMP_ACT_HEAVY)
			fail_counter = max(fail_counter, 30)
			visible_message("\The [src]'s reactor overloads!")
		if(EMP_ACT_LIGHT)
			fail_counter = max(fail_counter, 10)
			if(ismob(loc))
				to_chat(loc, "<span class='warning'>\The [src] feels pleasantly warm.</span>")

/obj/item/gun/energy/gun/nuclear/proc/get_charge_overlay()
	var/ratio = power_supply.percent()
	ratio = round(ratio, 25)
	return "nucgun-[ratio]"

/obj/item/gun/energy/gun/nuclear/proc/get_reactor_overlay()
	if(fail_counter)
		return "nucgun-medium"
	if (power_supply.percent() <= 50)
		return "nucgun-light"
	return "nucgun-clean"

/obj/item/gun/energy/gun/nuclear/proc/get_mode_overlay()
	var/datum/firemode/current_mode = firemodes[sel_mode]
	switch(current_mode.name)
		if("stun") return "nucgun-stun"
		if("kill") return "nucgun-kill"

/obj/item/gun/energy/gun/nuclear/on_update_icon()
	var/list/new_overlays = list()

	new_overlays += get_charge_overlay()
	new_overlays += get_reactor_overlay()
	new_overlays += get_mode_overlay()

	overlays = new_overlays
