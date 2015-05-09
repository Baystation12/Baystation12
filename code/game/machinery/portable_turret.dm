/*		Portable Turrets:
		Constructed from metal, a gun of choice, and a prox sensor.
		This code is slightly more documented than normal, as requested by XSI on IRC.
*/

/obj/machinery/porta_turret
	name = "turret"
	icon = 'icons/obj/turrets.dmi'
	icon_state = "grey_target_prism"
	anchored = 1
	layer = 3
	invisibility = INVISIBILITY_LEVEL_TWO	//the turret is invisible if it's inside its cover
	density = 1
	use_power = 1				//this turret uses and requires power
	idle_power_usage = 50		//when inactive, this turret takes up constant 50 Equipment power
	active_power_usage = 300	//when active, this turret takes up constant 300 Equipment power
	req_access = null
	req_one_access = list(access_security, access_heads)
	power_channel = EQUIP	//drains power from the EQUIPMENT channel

	var/raised = 0			//if the turret cover is "open" and the turret is raised
	var/raising= 0			//if the turret is currently opening or closing its cover
	var/health = 80			//the turret's health
	var/locked = 1			//if the turret's behaviour control access is locked
	var/controllock = 0		//if the turret responds to control panels

	var/installation = /obj/item/weapon/gun/energy/gun		//the type of weapon installed
	var/gun_charge = 0		//the charge of the gun inserted
	var/projectile = null	//holder for bullettype
	var/eprojectile = null	//holder for the shot when emagged
	var/reqpower = 500		//holder for power needed
	var/iconholder = null	//holder for the icon_state. 1 for orange sprite, null for blue.
	var/egun = null			//holder to handle certain guns switching bullettypes

	var/obj/machinery/porta_turret_cover/cover = null	//the cover that is covering this turret
	var/last_fired = 0		//1: if the turret is cooling down from a shot, 0: turret is ready to fire
	var/shot_delay = 15		//1.5 seconds between each shot

	var/check_arrest = 1	//checks if the perp is set to arrest
	var/check_records = 1	//checks if a security record exists at all
	var/check_weapons = 0	//checks if it can shoot people that have a weapon they aren't authorized to have
	var/check_access = 1	//if this is active, the turret shoots everything that does not meet the access requirements
	var/check_anomalies = 1	//checks if it can shoot at unidentified lifeforms (ie xenos)
	var/check_synth	 = 0 	//if active, will shoot at anything not an AI or cyborg
	var/ailock = 0 			// AI cannot use this

	var/attacked = 0		//if set to 1, the turret gets pissed off and shoots at people nearby (unless they have sec access!)

	var/on = 1				//determines if the turret is on
	var/lethal = 0			//whether in lethal or stun mode
	var/disabled = 0

	var/shot_sound 			//what sound should play when the turret fires
	var/eshot_sound			//what sound should play when the emagged turret fires

	var/datum/effect/effect/system/spark_spread/spark_system	//the spark system, used for generating... sparks?

	var/wrenching = 0

/obj/machinery/porta_turret/stationary
	lethal = 1
	installation = /obj/item/weapon/gun/energy/laser

/obj/machinery/porta_turret/New()
	..()
	icon_state = "grey_target_prism"
	//Sets up a spark system
	spark_system = new /datum/effect/effect/system/spark_spread
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

	cover = new /obj/machinery/porta_turret_cover(loc)
	cover.Parent_Turret = src
	setup()

/obj/machinery/porta_turret/proc/setup()
	var/obj/item/weapon/gun/energy/E = installation	//All energy-based weapons are applicable
	//var/obj/item/ammo_casing/shottype = E.projectile_type

	projectile = initial(E.projectile_type)
	eprojectile = projectile
	shot_sound = initial(E.fire_sound)
	eshot_sound = shot_sound

	weapon_setup(installation)

/obj/machinery/porta_turret/proc/weapon_setup(var/guntype)
	switch(guntype)
		if(/obj/item/weapon/gun/energy/laser/practice)
			iconholder = 1
			eprojectile = /obj/item/projectile/beam

//			if(/obj/item/weapon/gun/energy/laser/practice/sc_laser)
//				iconholder = 1
//				eprojectile = /obj/item/projectile/beam

		if(/obj/item/weapon/gun/energy/retro)
			iconholder = 1

//			if(/obj/item/weapon/gun/energy/retro/sc_retro)
//				iconholder = 1

		if(/obj/item/weapon/gun/energy/captain)
			iconholder = 1

		if(/obj/item/weapon/gun/energy/lasercannon)
			iconholder = 1

		if(/obj/item/weapon/gun/energy/taser)
			eprojectile = /obj/item/projectile/beam
			eshot_sound = 'sound/weapons/Laser.ogg'

		if(/obj/item/weapon/gun/energy/stunrevolver)
			eprojectile = /obj/item/projectile/beam
			eshot_sound = 'sound/weapons/Laser.ogg'

		if(/obj/item/weapon/gun/energy/gun)
			eprojectile = /obj/item/projectile/beam	//If it has, going to kill mode
			eshot_sound = 'sound/weapons/Laser.ogg'
			egun = 1

		if(/obj/item/weapon/gun/energy/gun/nuclear)
			eprojectile = /obj/item/projectile/beam	//If it has, going to kill mode
			eshot_sound = 'sound/weapons/Laser.ogg'
			egun = 1

/obj/machinery/porta_turret/update_icon()
	if(!anchored)
		icon_state = "turretCover"
		return
	if(stat & BROKEN)
		icon_state = "destroyed_target_prism"
	else
		if(powered())
			if(on)
				if(iconholder)
					//lasers have a orange icon
					icon_state = "orange_target_prism"
				else
					//almost everything has a blue icon
					icon_state = "target_prism"
			else
				icon_state = "grey_target_prism"
		else
			icon_state = "grey_target_prism"

/obj/machinery/porta_turret/Del()
	//deletes its own cover with it
	del(cover) // qdel
	..()

/obj/machinery/porta_turret/proc/can_use(mob/user)
	if(ailock && issilicon(user))
		user << "<span class='notice'>There seems to be a firewall preventing you from accessing this device.</span>"
		return 0

	if (get_dist(src, user) > 1 && !issilicon(user))
		user << "<span class='notice'>You are too far away.</span>"
		user.unset_machine()
		user << browse(null, "window=turretid")
		return 0

	if(locked && !issilicon(user))
		user << "<span class='notice'>Access denied.</span>"
		return 0

	return 1

/obj/machinery/porta_turret/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/porta_turret/attack_hand(mob/user)
	if(..())
		return 1
	if(!can_use(user))
		return 1
	interact(user)

/obj/machinery/porta_turret/interact(mob/user)
	var/dat = text({"
				<TT><B>Automatic Portable Turret Installation</B></TT><BR><BR>
				Status: []<BR>
				Behaviour controls are [locked ? "locked" : "unlocked"]"},
				"<A href='?src=\ref[src];power=1'>[on ? "On" : "Off"]</A>" )

	if(!locked || issilicon(user))
		dat += text({"<BR><BR>
					Lethal Mode: []<BR>
					Neutralize All Non-Synthetics: []<BR>"},

					"<A href='?src=\ref[src];operation=togglelethal'>[lethal ? "Enabled" : "Disabled"]</A>",
					"<A href='?src=\ref[src];operation=toggleai'>[check_synth ? "Yes" : "No"]</A>")
		if(!check_synth)
			dat += text({"Check for Weapon Authorization: []<BR>
					Check Security Records: []<BR>
					Check Arrest Status: []<BR>
					Neutralize All Non-Authorized Personnel: []<BR>
					Neutralize All Unidentified Life Signs: []<BR>"},

					"<A href='?src=\ref[src];operation=authweapon'>[check_weapons ? "Yes" : "No"]</A>",
					"<A href='?src=\ref[src];operation=checkrecords'>[check_records ? "Yes" : "No"]</A>",
					"<A href='?src=\ref[src];operation=checkarrest'>[check_arrest ? "Yes" : "No"]</A>",
					"<A href='?src=\ref[src];operation=checkaccess'>[check_access ? "Yes" : "No"]</A>",
					"<A href='?src=\ref[src];operation=checkxenos'>[check_anomalies ? "Yes" : "No"]</A>" )
	else
		dat += "<div class='notice icon'>Swipe ID card to unlock interface</div>"

	user << browse("<HEAD><TITLE>Automatic Portable Turret Installation</TITLE></HEAD>[dat]", "window=autosec")
	onclose(user, "autosec")
	return

/obj/machinery/porta_turret/proc/HasController()
	var/area/A = get_area(src)
	return A && A.turret_controls.len > 0

/obj/machinery/porta_turret/Topic(href, href_list)
	if(..())
		return 1
	if(!can_use(usr))
		return 1

	if(HasController())
		usr << "<span class='notice'>Turrets can only be controlled using the assigned turret controller.</span>"
		return

	usr.set_machine(src)
	if(href_list["power"])
		if(anchored)	//you can't turn a turret on/off if it's not anchored/secured
			on = !on	//toggle on/off
		else
			usr << "<span class='notice'>It has to be secured first!</span>"

		attack_hand(usr)
		return

	switch(href_list["operation"])	//toggles customizable behavioural protocols
		if("togglelethal")
			if(!controllock)
				lethal = !lethal
		if("toggleai")
			check_synth = !check_synth
		if("authweapon")
			check_weapons = !check_weapons
		if("checkrecords")
			check_records = !check_records
		if("checkarrests")
			check_arrest = !check_arrest
		if("checkaccess")
			check_access = !check_access
		if("checkxenos")
			check_anomalies = !check_anomalies
	attack_hand(usr)


/obj/machinery/porta_turret/power_change()
	if(powered())
		stat &= ~NOPOWER
		update_icon()
	else
		spawn(rand(0, 15))
			stat |= NOPOWER
			update_icon()


/obj/machinery/porta_turret/attackby(obj/item/I, mob/user)
	if(stat & BROKEN)
		if(istype(I, /obj/item/weapon/crowbar))
			//If the turret is destroyed, you can remove it with a crowbar to
			//try and salvage its components
			user << "<span class='notice'>You begin prying the metal coverings off.</span>"
			if(do_after(user, 20))
				if(prob(70))
					user << "<span class='notice'>You remove the turret and salvage some components.</span>"
					if(installation)
						var/obj/item/weapon/gun/energy/Gun = new installation(loc)
						Gun.power_supply.charge = gun_charge
						Gun.update_icon()
					if(prob(50))
						new /obj/item/stack/sheet/metal(loc, rand(1,4))
					if(prob(50))
						new /obj/item/device/assembly/prox_sensor(loc)
				else
					user << "<span class='notice'>You remove the turret but did not manage to salvage anything.</span>"
				del(src) // qdel

	if(istype(I, /obj/item/weapon/card/emag) && !emagged)
		//Emagging the turret makes it go bonkers and stun everyone. It also makes
		//the turret shoot much, much faster.
		user << "<span class='warning'>You short out [src]'s threat assessment circuits.</span>"
		visible_message("[src] hums oddly...")
		emagged = 1
		iconholder = 1
		controllock = 1
		on = 0 //turns off the turret temporarily
		sleep(60) //6 seconds for the traitor to gtfo of the area before the turret decides to ruin his shit
		on = 1 //turns it back on. The cover popUp() popDown() are automatically called in process(), no need to define it here

	else if((istype(I, /obj/item/weapon/wrench)))
		if(on || raised)
			user << "<span class='warning'>You cannot unsecure an active turret!</span>"
			return
		if(wrenching)
			user << "<span class='warning'>Someone is already [anchored ? "un" : ""]securing the turret!</span>"
			return
		if(!anchored && isinspace())
			user << "<span class='warning'>Cannot secure turrets in space!</span>"
			return

		user.visible_message( \
				"<span class='warning'>[user] begins [anchored ? "un" : ""]securing the turret.</span>", \
				"<span class='notice'>You begin [anchored ? "un" : ""]securing the turret.</span>" \
			)

		wrenching = 1
		if(do_after(user, 50))
			//This code handles moving the turret around. After all, it's a portable turret!
			if(!anchored)
				playsound(loc, 'sound/items/Ratchet.ogg', 100, 1)
				anchored = 1
				invisibility = INVISIBILITY_LEVEL_TWO
				update_icon()
				user << "<span class='notice'>You secure the exterior bolts on the turret.</span>"
				create_cover()
			else if(anchored)
				playsound(loc, 'sound/items/Ratchet.ogg', 100, 1)
				anchored = 0
				user << "<span class='notice'>You unsecure the exterior bolts on the turret.</span>"
				invisibility = 0
				update_icon()
				del(cover) //deletes the cover, and the turret instance itself becomes its own cover. - qdel
		wrenching = 0

	else if(istype(I, /obj/item/weapon/card/id)||istype(I, /obj/item/device/pda))
		//Behavior lock/unlock mangement
		if(allowed(user))
			locked = !locked
			user << "<span class='notice'>Controls are now [locked ? "locked" : "unlocked"].</span>"
			updateUsrDialog()
		else
			user << "<span class='notice'>Access denied.</span>"

	else
		//if the turret was attacked with the intention of harming it:
		user.changeNext_move(CLICK_CD_MELEE)
		take_damage(I.force * 0.5)
		if(I.force * 0.5 > 1) //if the force of impact dealt at least 1 damage, the turret gets pissed off
			if(!attacked && !emagged)
				attacked = 1
				spawn()
					sleep(60)
					attacked = 0
		..()

/obj/machinery/porta_turret/proc/take_damage(var/force)
	health -= force
	if (force > 5 && prob(45))
		spark_system.start()
	if(health <= 0)
		die()	//the death process :(

/obj/machinery/porta_turret/bullet_act(obj/item/projectile/Proj)

	if(Proj.damage_type == HALLOSS)
		return

	if(on)
		if(!attacked && !emagged)
			attacked = 1
			spawn()
				sleep(60)
				attacked = 0

	..()

	if((Proj.damage_type == BRUTE || Proj.damage_type == BURN))
		take_damage(Proj.damage)

/obj/machinery/porta_turret/emp_act(severity)
	if(on)
		//if the turret is on, the EMP no matter how severe disables the turret for a while
		//and scrambles its settings, with a slight chance of having an emag effect
		check_arrest = prob(50)
		check_records = prob(50)
		check_weapons = prob(50)
		check_access = prob(20)	// check_access is a pretty big deal, so it's least likely to get turned on
		check_anomalies = prob(50)
		if(prob(5))
			emagged = 1

		on=0
		sleep(rand(60,600))
		if(!on)
			on=1

	..()

/obj/machinery/porta_turret/ex_act(severity)
	switch (severity)
		if (1)
			del(src)
		if (2)
			if (prob(25))
				del(src)
			else
				take_damage(150) //should instakill most turrets
		if (3)
			take_damage(50)

/obj/machinery/porta_turret/proc/die()	//called when the turret dies, ie, health <= 0
	health = 0
	density = 0
	stat |= BROKEN	//enables the BROKEN bit
	invisibility = 0
	spark_system.start()	//creates some sparks because they look cool
	density = 1
	update_icon()
	del(cover)	//deletes the cover - no need on keeping it there! - del

/obj/machinery/porta_turret/proc/create_cover()
	if(cover == null && anchored)
		cover = new /obj/machinery/porta_turret_cover(loc)	//if the turret has no cover and is anchored, give it a cover
		cover.Parent_Turret = src	//assign the cover its Parent_Turret, which would be this (src)

/obj/machinery/porta_turret/process()
	//the main machinery process

	set background = BACKGROUND_ENABLED

	if(cover == null && anchored)	//if it has no cover and is anchored
		if(stat & BROKEN)	//if the turret is borked
			del(cover)	//delete its cover, assuming it has one. Workaround for a pesky little bug - qdel
		else
			create_cover()

	if(stat & (NOPOWER|BROKEN))
		//if the turret has no power or is broken, make the turret pop down if it hasn't already
		popDown()
		return

	if(!on)
		//if the turret is off, make it pop down
		popDown()
		return

	var/list/targets = list()			//list of primary targets
	var/list/secondarytargets = list()	//targets that are least important

	for(var/obj/mecha/ME in view(7,src))
		assess_and_assign(ME.occupant, targets, secondarytargets)

	for(var/obj/vehicle/train/T in view(7,src))
		assess_and_assign(T.load, targets, secondarytargets)

	for(var/mob/living/C in view(7,src))	//loops through all living lifeforms in view
		assess_and_assign(C, targets, secondarytargets)

	if(!tryToShootAt(targets))
		if(!tryToShootAt(secondarytargets)) // if no valid targets, go for secondary targets
			spawn()
				popDown() // no valid targets, close the cover

/obj/machinery/porta_turret/proc/assess_and_assign(var/mob/living/L, var/list/targets, var/list/secondarytargets)
	switch(assess_living(L))
		if(TURRET_PRIORITY_TARGET)
			targets += L
		if(TURRET_SECONDARY_TARGET)
			secondarytargets += L

/obj/machinery/porta_turret/proc/assess_living(var/mob/living/L)
	if(!istype(L))
		return TURRET_NOT_TARGET

	if(L.invisibility >= INVISIBILITY_LEVEL_ONE) // Cannot see him. see_invisible is a mob-var
		return TURRET_NOT_TARGET

	if(!L)
		return TURRET_NOT_TARGET

	// If emagged not even the dead get a rest
	if(emagged)
		return L.stat ? TURRET_SECONDARY_TARGET : TURRET_PRIORITY_TARGET

	if(issilicon(L))	// Don't target silica
		return TURRET_NOT_TARGET

	if(L.stat)		//if the perp is dead/dying, no need to bother really
		return TURRET_NOT_TARGET	//move onto next potential victim!

	var/dst = get_dist(src, L)	//if it's too far away, why bother?
	if(dst > 7)
		return 0

	if(check_synth)	//If it's set to attack all non-silicons, target them!
		if(L.lying)
			return lethal ? TURRET_SECONDARY_TARGET : TURRET_NOT_TARGET
		return TURRET_PRIORITY_TARGET

	if(iscuffed(L)) // If the target is handcuffed, leave it alone
		return TURRET_NOT_TARGET

	if(isanimal(L) || ismonkey(L)) // Animals are not so dangerous
		return check_anomalies ? TURRET_SECONDARY_TARGET : TURRET_NOT_TARGET
	if(isxenomorph(L) || isalien(L)) // Xenos are dangerous
		return check_anomalies ? TURRET_PRIORITY_TARGET	: TURRET_NOT_TARGET

	if(ishuman(L))	//if the target is a human, analyze threat level
		if(assess_perp(L, check_weapons, check_records, check_arrest) < 4)
			return TURRET_NOT_TARGET	//if threat level < 4, keep going

	if(L.lying)		//if the perp is lying down, it's still a target but a less-important target
		return lethal ? TURRET_SECONDARY_TARGET : TURRET_NOT_TARGET

	return TURRET_PRIORITY_TARGET	//if the perp has passed all previous tests, congrats, it is now a "shoot-me!" nominee

/obj/machinery/porta_turret/proc/tryToShootAt(var/list/mob/living/targets)
	while(targets.len > 0)
		var/mob/living/M = pick(targets)
		targets -= M
		if(target(M))
			return 1


/obj/machinery/porta_turret/proc/popUp()	//pops the turret up
	if(disabled)
		return
	if(raising || raised)
		return
	if(stat & BROKEN)
		return
	invisibility = 0
	raising = 1
	flick("popup", cover)
	sleep(10)
	raising = 0
	cover.icon_state = "openTurretCover"
	raised = 1
	layer = 4
	update_icon()

/obj/machinery/porta_turret/proc/popDown()	//pops the turret down
	if(disabled)
		return
	if(raising || !raised)
		return
	if(stat & BROKEN)
		return
	layer = 3
	raising = 1
	flick("popdown", cover)
	sleep(10)
	raising = 0
	cover.icon_state = "turretCover"
	raised = 0
	invisibility = INVISIBILITY_LEVEL_TWO
	update_icon()


/obj/machinery/porta_turret/on_assess_perp(mob/living/carbon/human/perp)
	if((check_access || attacked) && !allowed(perp))
		//if the turret has been attacked or is angry, target all non-authorized personnel, see req_access
		return 10

	return ..()


/obj/machinery/porta_turret/proc/target(var/mob/living/target)
	if(disabled)
		return
	if(target && (target.stat != DEAD) && (!(target.lying) || emagged))
		spawn()
			popUp()				//pop the turret up if it's not already up.
		set_dir(get_dir(src, target))	//even if you can't shoot, follow the target
		spawn()
			shootAt(target)
		return 1
	return

/obj/machinery/porta_turret/proc/shootAt(var/mob/living/target)
	//any emagged turrets will shoot extremely fast! This not only is deadly, but drains a lot power!
	if(!(emagged || lethal))	//if it hasn't been emagged, it has to obey a cooldown rate
		if(last_fired || !raised)	//prevents rapid-fire shooting, unless it's been emagged
			return
		last_fired = 1
		spawn()
			sleep(shot_delay)
			last_fired = 0

	var/turf/T = get_turf(src)
	var/turf/U = get_turf(target)
	if(!istype(T) || !istype(U))
		return

	if(!raised) //the turret has to be raised in order to fire - makes sense, right?
		return


	update_icon()
	var/obj/item/projectile/A
	if(emagged || lethal)
		A = new eprojectile(loc)
		playsound(loc, eshot_sound, 75, 1)
	else
		A = new projectile(loc)
		playsound(loc, shot_sound, 75, 1)
	A.original = target
	if(!(emagged || lethal))
		use_power(reqpower)
	else
		use_power(reqpower * 2)
		//Shooting Code:
	A.current = T
	A.yo = U.y - T.y
	A.xo = U.x - T.x
	spawn(1)
		A.process()

/datum/turret_checks
	var/on
	var/lethal
	var/check_synth
	var/check_access
	var/check_records
	var/check_arrest
	var/check_weapons
	var/check_anomalies
	var/ailock

/obj/machinery/porta_turret/proc/setState(var/datum/turret_checks/TC)
	if(controllock)
		return
	src.on = TC.on
	src.lethal = TC.lethal
	src.iconholder = TC.lethal

	check_synth = TC.check_synth
	check_access = TC.check_access
	check_records = TC.check_records
	check_arrest = TC.check_arrest
	check_weapons = TC.check_weapons
	check_anomalies = TC.check_anomalies
	ailock = TC.ailock

	src.power_change()

/*
		Portable turret constructions
		Known as "turret frame"s
*/

/obj/machinery/porta_turret_construct
	name = "turret frame"
	icon = 'icons/obj/turrets.dmi'
	icon_state = "turret_frame"
	density=1
	var/target_type = /obj/machinery/porta_turret	// The type we intend to build
	var/build_step = 0			//the current step in the building process
	var/finish_name="turret"	//the name applied to the product turret
	var/installation = null		//the gun type installed
	var/gun_charge = 0			//the gun charge of the gun type installed


/obj/machinery/porta_turret_construct/attackby(obj/item/I, mob/user)
	//this is a bit unwieldy but self-explanatory
	switch(build_step)
		if(0)	//first step
			if(istype(I, /obj/item/weapon/wrench) && !anchored)
				playsound(loc, 'sound/items/Ratchet.ogg', 100, 1)
				user << "<span class='notice'>You secure the external bolts.</span>"
				anchored = 1
				build_step = 1
				return

			else if(istype(I, /obj/item/weapon/crowbar) && !anchored)
				playsound(loc, 'sound/items/Crowbar.ogg', 75, 1)
				user << "<span class='notice'>You dismantle the turret construction.</span>"
				new /obj/item/stack/sheet/metal( loc, 5)
				del(src) // qdel
				return

		if(1)
			if(istype(I, /obj/item/stack/sheet/metal))
				var/obj/item/stack/sheet/metal/M = I
				if(M.use(2))
					user << "<span class='notice'>You add some metal armor to the interior frame.</span>"
					build_step = 2
					icon_state = "turret_frame2"
				else
					user << "<span class='warning'>You need two sheets of metal to continue construction.</span>"
				return

			else if(istype(I, /obj/item/weapon/wrench))
				playsound(loc, 'sound/items/Ratchet.ogg', 75, 1)
				user << "<span class='notice'>You unfasten the external bolts.</span>"
				anchored = 0
				build_step = 0
				return


		if(2)
			if(istype(I, /obj/item/weapon/wrench))
				playsound(loc, 'sound/items/Ratchet.ogg', 100, 1)
				user << "<span class='notice'>You bolt the metal armor into place.</span>"
				build_step = 3
				return

			else if(istype(I, /obj/item/weapon/weldingtool))
				var/obj/item/weapon/weldingtool/WT = I
				if(!WT.isOn())
					return
				if(WT.get_fuel() < 5) //uses up 5 fuel.
					user << "<span class='notice'>You need more fuel to complete this task.</span>"
					return

				playsound(loc, pick('sound/items/Welder.ogg', 'sound/items/Welder2.ogg'), 50, 1)
				if(do_after(user, 20))
					if(!src || !WT.remove_fuel(5, user)) return
					build_step = 1
					user << "You remove the turret's interior metal armor."
					new /obj/item/stack/sheet/metal( loc, 2)
					return


		if(3)
			if(istype(I, /obj/item/weapon/gun/energy)) //the gun installation part

				if(isrobot(user))
					return
				var/obj/item/weapon/gun/energy/E = I //typecasts the item to an energy gun
				if(!user.unEquip(I))
					user << "<span class='notice'>\the [I] is stuck to your hand, you cannot put it in \the [src]</span>"
					return
				installation = I.type //installation becomes I.type
				gun_charge = E.power_supply.charge //the gun's charge is stored in gun_charge
				user << "<span class='notice'>You add [I] to the turret.</span>"

				if(istype(installation, /obj/item/weapon/gun/energy/lasertag/blue) || istype(installation, /obj/item/weapon/gun/energy/lasertag/red))
					target_type = /obj/machinery/porta_turret/tag
				else
					target_type = /obj/machinery/porta_turret

				build_step = 4
				del(I) //delete the gun :( qdel
				return

			else if(istype(I, /obj/item/weapon/wrench))
				playsound(loc, 'sound/items/Ratchet.ogg', 100, 1)
				user << "<span class='notice'>You remove the turret's metal armor bolts.</span>"
				build_step = 2
				return

		if(4)
			if(isprox(I))
				build_step = 5
				if(!user.unEquip(I))
					user << "<span class='notice'>\the [I] is stuck to your hand, you cannot put it in \the [src]</span>"
					return
				user << "<span class='notice'>You add the prox sensor to the turret.</span>"
				del(I) // qdel
				return

			//attack_hand() removes the gun

		if(5)
			if(istype(I, /obj/item/weapon/screwdriver))
				playsound(loc, 'sound/items/Screwdriver.ogg', 100, 1)
				build_step = 6
				user << "<span class='notice'>You close the internal access hatch.</span>"
				return

			//attack_hand() removes the prox sensor

		if(6)
			if(istype(I, /obj/item/stack/sheet/metal))
				var/obj/item/stack/sheet/metal/M = I
				if(M.use(2))
					user << "<span class='notice'>You add some metal armor to the exterior frame.</span>"
					build_step = 7
				else
					user << "<span class='warning'>You need two sheets of metal to continue construction.</span>"
				return

			else if(istype(I, /obj/item/weapon/screwdriver))
				playsound(loc, 'sound/items/Screwdriver.ogg', 100, 1)
				build_step = 5
				user << "<span class='notice'>You open the internal access hatch.</span>"
				return

		if(7)
			if(istype(I, /obj/item/weapon/weldingtool))
				var/obj/item/weapon/weldingtool/WT = I
				if(!WT.isOn()) return
				if(WT.get_fuel() < 5)
					user << "<span class='notice'>You need more fuel to complete this task.</span>"

				playsound(loc, pick('sound/items/Welder.ogg', 'sound/items/Welder2.ogg'), 50, 1)
				if(do_after(user, 30))
					if(!src || !WT.remove_fuel(5, user))
						return
					build_step = 8
					user << "<span class='notice'>You weld the turret's armor down.</span>"

					//The final step: create a full turret
					var/obj/machinery/porta_turret/Turret = new target_type(loc)
					Turret.name = finish_name
					Turret.installation = installation
					Turret.gun_charge = gun_charge
					Turret.on = 0
					Turret.setup()

//					Turret.cover=new/obj/machinery/porta_turret_cover(loc)
//					Turret.cover.Parent_Turret=Turret
//					Turret.cover.name = finish_name
					del(src) // qdel

			else if(istype(I, /obj/item/weapon/crowbar))
				playsound(loc, 'sound/items/Crowbar.ogg', 75, 1)
				user << "<span class='notice'>You pry off the turret's exterior armor.</span>"
				new /obj/item/stack/sheet/metal(loc, 2)
				build_step = 6
				return

	if(istype(I, /obj/item/weapon/pen))	//you can rename turrets like bots!
		var/t = input(user, "Enter new turret name", name, finish_name) as text
		t = sanitize(copytext(t, 1, MAX_MESSAGE_LEN))
		if(!t)
			return
		if(!in_range(src, usr) && loc != usr)
			return

		finish_name = t
		return
	..()


/obj/machinery/porta_turret_construct/attack_hand(mob/user)
	switch(build_step)
		if(4)
			if(!installation)
				return
			build_step = 3

			var/obj/item/weapon/gun/energy/Gun = new installation(loc)
			Gun.power_supply.charge = gun_charge
			Gun.update_icon()
			installation = null
			gun_charge = 0
			user << "<span class='notice'>You remove [Gun] from the turret frame.</span>"

		if(5)
			user << "<span class='notice'>You remove the prox sensor from the turret frame.</span>"
			new /obj/item/device/assembly/prox_sensor(loc)
			build_step = 4

/obj/machinery/porta_turret_construct/attack_ai()
	return


/************************
* PORTABLE TURRET COVER *
************************/

/obj/machinery/porta_turret_cover
	name = "turret"
	icon = 'icons/obj/turrets.dmi'
	icon_state = "turretCover"
	anchored = 1
	layer = 3.5
	density = 0
	var/obj/machinery/porta_turret/Parent_Turret = null

/obj/machinery/porta_turret_cover/attack_ai(mob/user)
	return attack_hand(user)

/obj/machinery/porta_turret_cover/attack_hand(mob/user)
	return Parent_Turret.attack_hand(user)

/obj/machinery/porta_turret_cover/Topic(href, href_list)
	Parent_Turret.Topic(href, href_list, 1)	// Calling another object's Topic requires that we claim to not have a window, otherwise BYOND's base proc will runtime.

/obj/machinery/porta_turret_cover/attackby(obj/item/I, mob/user)
	Parent_Turret.attackby(I, user)
