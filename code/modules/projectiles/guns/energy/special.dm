/obj/item/weapon/gun/energy/ionrifle
	name = "ion rifle"
	desc = "A man portable anti-armor weapon designed to disable mechanical threats"
	icon_state = "ionrifle"
	item_state = "ionrifle"
	fire_sound = 'sound/weapons/Laser.ogg'
	origin_tech = "combat=2;magnets=4"
	w_class = 4
	force = 10
	flags =  CONDUCT
	slot_flags = SLOT_BACK
	charge_cost = 100
	projectile_type = /obj/item/projectile/ion

/obj/item/weapon/gun/energy/ionrifle/emp_act(severity)
	..(max(severity, 2)) //so it doesn't EMP itself, I guess

/obj/item/weapon/gun/energy/ionrifle/update_icon()
	..()
	if(power_supply.charge < charge_cost)
		item_state = "ionrifle-empty"
	else
		item_state = initial(item_state)

/obj/item/weapon/gun/energy/decloner
	name = "biological demolecularisor"
	desc = "A gun that discharges high amounts of controlled radiation to slowly break a target into component elements."
	icon_state = "decloner"
	item_state = "decloner"
	fire_sound = 'sound/weapons/pulse3.ogg'
	origin_tech = "combat=5;materials=4;powerstorage=3"
	charge_cost = 100
	projectile_type = /obj/item/projectile/energy/declone

/obj/item/weapon/gun/energy/floragun
	name = "floral somatoray"
	desc = "A tool that discharges controlled radiation which induces mutation in plant cells."
	icon_state = "floramut100"
	item_state = "floramut"
	fire_sound = 'sound/effects/stealthoff.ogg'
	charge_cost = 100
	projectile_type = /obj/item/projectile/energy/floramut
	origin_tech = "materials=2;biotech=3;powerstorage=3"
	modifystate = "floramut"
	self_recharge = 1
	var/mode = 0 //0 = mutate, 1 = yield boost

/obj/item/weapon/gun/energy/floragun/attack_self(mob/living/user as mob)
	switch(mode)
		if(0)
			mode = 1
			charge_cost = 100
			user << "<span class='warning'>The [src.name] is now set to increase yield.</span>"
			projectile_type = /obj/item/projectile/energy/florayield
			modifystate = "florayield"
		if(1)
			mode = 0
			charge_cost = 100
			user << "<span class='warning'>The [src.name] is now set to induce mutations.</span>"
			projectile_type = /obj/item/projectile/energy/floramut
			modifystate = "floramut"
	update_icon()
	update_held_icon()

/obj/item/weapon/gun/energy/floragun/afterattack(obj/target, mob/user, adjacent_flag)
	//allow shooting into adjacent hydrotrays regardless of intent
	if(adjacent_flag && istype(target,/obj/machinery/portable_atmospherics/hydroponics))
		user.visible_message("<span class='danger'>\The [user] fires \the [src] into \the [target]!</span>")
		Fire(target,user)
		return
	..()

/obj/item/weapon/gun/energy/meteorgun
	name = "meteor gun"
	desc = "For the love of god, make sure you're aiming this the right way!"
	icon_state = "riotgun"
	item_state = "c20r"
	slot_flags = SLOT_BELT|SLOT_BACK
	w_class = 4
	projectile_type = /obj/item/projectile/meteor
	charge_cost = 100
	cell_type = /obj/item/weapon/cell/potato
	self_recharge = 1
	recharge_time = 5 //Time it takes for shots to recharge (in ticks)
	charge_meter = 0

/obj/item/weapon/gun/energy/meteorgun/pen
	name = "meteor pen"
	desc = "The pen is mightier than the sword."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "pen"
	item_state = "pen"
	w_class = 1
	slot_flags = SLOT_BELT


/obj/item/weapon/gun/energy/mindflayer
	name = "mind flayer"
	desc = "A prototype weapon recovered from the ruins of Research-Station Epsilon."
	icon_state = "xray"
	projectile_type = /obj/item/projectile/beam/mindflayer
	fire_sound = 'sound/weapons/Laser.ogg'

/obj/item/weapon/gun/energy/toxgun
	name = "phoron pistol"
	desc = "A specialized firearm designed to fire lethal bolts of phoron."
	icon_state = "toxgun"
	fire_sound = 'sound/effects/stealthoff.ogg'
	w_class = 3.0
	origin_tech = "combat=5;phorontech=4"
	projectile_type = /obj/item/projectile/energy/phoron

/* Staves */

/obj/item/weapon/gun/energy/staff
	name = "staff of change"
	desc = "An artefact that spits bolts of coruscating energy which cause the target's very form to reshape itself"
	icon = 'icons/obj/gun.dmi'
	item_icons = null
	icon_state = "staffofchange"
	item_state = "staffofchange"
	fire_sound = 'sound/weapons/emitter.ogg'
	flags =  CONDUCT
	slot_flags = SLOT_BACK
	w_class = 4.0
	charge_cost = 200
	projectile_type = /obj/item/projectile/change
	origin_tech = null
	self_recharge = 1
	charge_meter = 0

/obj/item/weapon/gun/energy/staff/handle_click_empty(mob/user = null)
	if (user)
		user.visible_message("*fizzle*", "<span class='danger'>*fizzle*</span>")
	else
		src.visible_message("*fizzle*")
	playsound(src.loc, 'sound/effects/sparks1.ogg', 100, 1)

/obj/item/weapon/gun/energy/staff/animate
	name = "staff of animation"
	desc = "An artefact that spits bolts of life-force which causes objects which are hit by it to animate and come to life! This magic doesn't affect machines."
	projectile_type = /obj/item/projectile/animate
	charge_cost = 100

obj/item/weapon/gun/energy/staff/focus
	name = "mental focus"
	desc = "An artefact that channels the will of the user into destructive bolts of force. If you aren't careful with it, you might poke someone's brain out."
	icon = 'icons/obj/wizard.dmi'
	icon_state = "focus"
	item_state = "focus"
	slot_flags = SLOT_BACK
	projectile_type = /obj/item/projectile/forcebolt
	/*
	attack_self(mob/living/user as mob)
		if(projectile_type == "/obj/item/projectile/forcebolt")
			charge_cost = 200
			user << "<span class='warning'>The [src.name] will now strike a small area.</span>"
			projectile_type = "/obj/item/projectile/forcebolt/strong"
		else
			charge_cost = 100
			user << "<span class='warning'>The [src.name] will now strike only a single person.</span>"
			projectile_type = "/obj/item/projectile/forcebolt"
	*/

/* Adminbus guns */

// Serves as a target spotter for the Icarus.
/obj/item/weapon/gun/energy/icarus
	name = "rubber ducky"
	desc = "It's a cute rubber duck.  With an evil gleam in it's eye."
	projectile_type = /obj/item/projectile/icarus/pointdefense
	icon = 'icons/obj/watercloset.dmi'
	item_icons = null
	icon_state = "rubberducky"
	item_state = "rubberducky"
	charge_cost = 0
	silenced = 1

/obj/item/weapon/gun/energy/icarus/attack_self(mob/living/user as mob)
	if(projectile_type == /obj/item/projectile/icarus/pointdefense)
		projectile_type = /obj/item/projectile/icarus/guns
		user << "You inform the Icarus to switch to the main guns."
	else
		projectile_type = /obj/item/projectile/icarus/pointdefense
		user << "You inform the Icarus to switch to the point-defense lasers."

	. = ..()

/obj/item/weapon/gun/energy/icarus/update_icon()
	return

/obj/item/weapon/gun/energy/icarus/verb/SetIcarusAngle()
	set src in usr
	set name = "Set Firing Angle"
	set desc = "Sets the angle from which the icarus will fire."
	set category = "Object"

	Icarus_SetPosition(usr)


/obj/item/weapon/gun/energy/variable
	name = "abstract weapon"
	desc = "It seems to shift and flow as you watch."
	charge_cost = 0
	silenced = 1

/obj/item/weapon/gun/energy/variable/update_icon()
	return

/obj/item/weapon/gun/energy/variable/attack_self(mob/living/user as mob)
	var/type = input(user,"What projectile type?","Projectile", null) as null|anything in typesof(/obj/item/projectile)
	if(!type)
		return ..()
	projectile_type = type
	. = ..()
