/obj/item/weapon/storage/box/flares
	name = "box of flares"
	icon_state = "flashbang"
	max_storage_space = 4
	w_class = 1
	startswith = list(/obj/item/device/flashlight/flare/unsc = 4)

/obj/item/device/flashlight/flare/unsc
	brightness_on = 4 //halved normal flare light

/obj/item/weapon/storage/belt/utility/marine_engineer
	can_hold = list(/obj/item/weapon/weldingtool,/obj/item/weapon/crowbar,/obj/item/ammo_magazine,/obj/item/ammo_box,/obj/item/weapon/grenade/frag/m9_hedp,/obj/item/weapon/grenade/smokebomb,/obj/item/weapon/grenade/chem_grenade/incendiary,/obj/item/weapon/armor_patch)

/obj/item/weapon/storage/belt/utility/marine_engineer/New()
	..()
	new /obj/item/weapon/weldingtool/mini(src)
	new /obj/item/weapon/crowbar/red(src)
	return

/obj/structure/closet/crate/marine/marine_medic
	name = "combat medic equipment"
	desc = "Has everything but spare blood bags."
	icon_state = "o2crate"
	icon_opened = "o2crateopen"
	icon_closed = "o2crate"

/obj/structure/closet/crate/marine/marine_medic/WillContain()
	return list(
	/obj/item/weapon/storage/box/MRE/Chicken = 1,
	/obj/item/weapon/material/knife/combat_knife = 1,
	/obj/item/ammo_magazine/m127_saphp = 2,
	/obj/item/weapon/gun/projectile/m6d_magnum = 1,
	/obj/item/ammo_magazine/m5 = 1,
	/obj/item/weapon/gun/projectile/m7_smg = 1,
	/obj/item/clothing/head/helmet/marine/medic = 1,
	/obj/item/clothing/mask/marine = 1,
	/obj/item/clothing/glasses/hud/tactical = 1,
	/obj/item/clothing/suit/storage/marine/medic = 1,
	/obj/item/clothing/gloves/thick/unsc = 1,
	/obj/item/clothing/shoes/marine = 1,
	/obj/item/weapon/storage/firstaid/unsc = 2,
	/obj/item/device/flashlight/unsc = 1,
	/obj/item/weapon/storage/belt/marine_medic = 1)

/obj/structure/closet/crate/marine/cqc
	name = "CQB equipment"
	desc = "Perfect for being up close and personal."
	icon_state = "secgearcrate"
	icon_opened = "secgearcrateopen"
	icon_closed = "secgearcrate"

/obj/structure/closet/crate/marine/cqc/WillContain()
	return list(
	/obj/item/weapon/storage/box/MRE/Pizza = 1,
	/obj/item/weapon/storage/box/flares = 1,
	/obj/item/weapon/material/knife/combat_knife = 1,
	/obj/item/ammo_magazine/m5 = 1,
	/obj/item/weapon/gun/projectile/m7_smg = 1,
	/obj/item/weapon/grenade/frag/m9_hedp = 1,
	/obj/item/ammo_box/shotgun/slug = 1,
	/obj/item/ammo_box/shotgun = 1,
	/obj/item/weapon/gun/projectile/shotgun/pump/m90_ts = 1,
	/obj/item/clothing/head/helmet/marine/visor = 1,
	/obj/item/clothing/mask/marine = 1,
	/obj/item/clothing/glasses/hud/tactical = 1,
	/obj/item/clothing/suit/storage/marine = 1,
	/obj/item/clothing/gloves/thick/unsc = 1,
	/obj/item/clothing/shoes/marine = 1,
	/obj/item/weapon/storage/belt/marine_ammo = 1)

/obj/structure/closet/crate/marine/engineer
	name = "combat engineer equipment"
	desc = "Engineer gear."
	icon_state = "secgearcrate"
	icon_opened = "secgearcrateopen"
	icon_closed = "secgearcrate"

/obj/structure/closet/crate/marine/engineer/WillContain()
	return list(
	/obj/item/clothing/head/helmet/marine/visor = 1,
	/obj/item/clothing/mask/marine = 1,
	/obj/item/clothing/glasses/welding = 1,
	/obj/item/clothing/suit/storage/marine = 1,
	/obj/item/clothing/gloves/thick/unsc = 1,
	/obj/item/clothing/shoes/marine = 1,
	/obj/item/weapon/storage/belt/utility/marine_engineer = 1,
	/obj/item/weapon/storage/box/MRE/Chicken = 1,
	/obj/item/weapon/material/knife/combat_knife = 1,
	/obj/item/weapon/armor_patch = 2,
	/obj/item/ammo_magazine/m127_saphe = 2,
	/obj/item/weapon/gun/projectile/m6d_magnum = 1,
	/obj/item/ammo_magazine/m762_ap/MA5B = 1,
	/obj/item/weapon/gun/projectile/ma5b_ar = 1,
	/obj/item/weapon/storage/box/flares = 1)

/obj/structure/closet/crate/marine/rifleman
	name = "standard rifleman equipment"
	desc = "Standard groundpounder gear."
	icon_state = "secgearcrate"
	icon_opened = "secgearcrateopen"
	icon_closed = "secgearcrate"

/obj/structure/closet/crate/marine/rifleman/WillContain()
	return list(
	/obj/item/weapon/storage/box/MRE/Spaghetti = 1,
	/obj/item/weapon/storage/box/flares = 2,
	/obj/item/weapon/material/knife/combat_knife = 1,
	/obj/item/ammo_magazine/m127_saphe = 1,
	/obj/item/weapon/gun/projectile/m6d_magnum = 1,
	/obj/item/ammo_magazine/m762_ap/MA5B = 2,
	/obj/item/weapon/gun/projectile/ma5b_ar = 1,
	/obj/item/weapon/grenade/frag/m9_hedp = 1,
	/obj/item/clothing/head/helmet/marine = 1,
	/obj/item/clothing/mask/marine = 1,
	/obj/item/clothing/glasses/hud/tactical = 1,
	/obj/item/clothing/suit/storage/marine = 1,
	/obj/item/clothing/gloves/thick/unsc = 1,
	/obj/item/clothing/shoes/marine = 1,
	/obj/item/weapon/storage/belt/marine_ammo = 1)

/obj/structure/closet/crate/secure/marine_squad_leader
	name = "squad leader equipment"
	desc = "Will only open to a Squad Leader."
	icon_state = "weaponcrate"
	icon_opened = "weaponcrateopen"
	icon_closed = "weaponcrate"
	req_access = list(143)

/obj/structure/closet/crate/secure/marine_squad_leader/WillContain()
	return list(
	/obj/item/weapon/storage/box/MRE/Spaghetti = 1,
	/obj/item/weapon/storage/box/flares = 1,
	/obj/item/weapon/material/knife/combat_knife = 1,
	/obj/item/ammo_magazine/m127_saphe = 1,
	/obj/item/weapon/gun/projectile/m6d_magnum = 1,
	/obj/item/ammo_magazine/m762_ap/MA5B = 1,
	/obj/item/weapon/gun/projectile/ma5b_ar = 1,
	/obj/item/device/taperecorder = 1,
	/obj/item/squad_manager = 1,
	/obj/item/clothing/head/helmet/marine = 1,
	/obj/item/clothing/mask/marine = 1,
	/obj/item/clothing/glasses/hud/tactical = 1,
	/obj/item/clothing/suit/storage/marine = 1,
	/obj/item/clothing/gloves/thick/unsc = 1,
	/obj/item/clothing/shoes/marine = 1,
	/obj/item/weapon/storage/belt/marine_ammo = 1)

/obj/machinery/vending/armory/achlys
	name = "Gear Vendor"
	desc = "A hastily stocked machine that takes a special card to access the inventory of."
	icon_state ="ironhammer"
	icon_deny = "ironhammer-deny"
	premium = list(/obj/structure/closet/crate/marine/rifleman = 10,
					/obj/structure/closet/crate/marine/cqc = 3,
					/obj/structure/closet/crate/marine/engineer = 1,
					/obj/structure/closet/crate/marine/marine_medic = 2,
					/obj/structure/closet/crate/secure/marine_squad_leader = 1) //there should only be 2 of these on the map so do multiplication

/obj/item/weapon/coin/gear_req
	name = "Requisition Card"
	desc = "Inserted into the Gear Vendor to get a loadout."
	icon = 'code/modules/halo/icons/objs/(Placeholder)card.dmi'
	icon_state = "id"
	item_state = "card-id"
	sides = 0

/obj/item/weapon/coin/gear_req/attack_self(mob/user as mob)
	return 0

/obj/machinery/vending/armory/attachment/achlys
	req_access = list(143)

/obj/structure/navconsole
	name = "Navagation Console"
	desc = "A robust system with it's own power supply that holds nav data on it's hard drive. This includes the location of the planet Earth."
	icon = 'code/modules/halo/overmap/nav_computer.dmi'
	icon_state = "nav_computer"
	var/health = 30
	light_range = 1
	light_color = "#ebf7fe"
	density = 1
	anchored = 1

/obj/structure/navconsole/attackby(atom/movable/AM as mob|obj)
	if(istype(AM, /mob/living/simple_animal/hostile/flood))
		return

/obj/structure/navconsole/proc/damage(var/damage)
	health -= damage
	if(health <= 0)
		qdel(src)

/obj/item/weapon/reference
	name = "gold coin"
	desc = "This coin isn't as soft as normal gold, and seems to be an improper size. Clearly a fraud."
	icon = 'icons/obj/items.dmi'
	icon_state = "coin_gold"

/obj/item/weapon/research //the red herring
	name = "research documents"
	desc = "Random useless papers documenting some kind of nerd experiments."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "envelope_sealed"

/obj/item/weapon/research/sekrits //the mcguffin
	name = "strange documents"
	desc = "This folder is sealed shut and coated in way too many warnings. Definitely not safe to open."

/obj/item/weapon/card/id/the_gold
	name = "Gold Keycard"
	desc = "This keycard appears to belong to a bridge crewman. How it got here and where it's owner is remains unknown."
	access = list(777)
	icon_state = "gold"
	item_state = "gold_id"

/obj/item/weapon/card/id/the_silver
	name = "Silver Keycard"
	desc = "This silver keycard seems to belong to someone important. What door it opens is a mystery."
	access = list(666)
	icon_state = "silver"
	item_state = "silver_id"

/obj/machinery/autolathe/ammo_fabricator/hacked
	name = "hacked autolathe"
	desc = "This autolathe was dragged here and hacked together from other machine parts."
	stored_material =  list(DEFAULT_WALL_MATERIAL = 3000, "glass" = 0)
	storage_capacity = list(DEFAULT_WALL_MATERIAL = 0, "glass" = 0)
	machine_recipes = newlist(/datum/autolathe/recipe/m118_ma5b,/datum/autolathe/recipe/m255_sap_hp,/datum/autolathe/recipe/m443_fmj)

/obj/item/weapon/paper/crumpled/orders
	info = "Office of Naval Intelligence Section 3<BR><BR>Any person that steps foot on the Achlys cannot leave the ship alive. Exterminate with extreme prejudice.<BR><BR>Do not allow your identity to be compromised by any means. Failure to obey these orders will result in subject termination.<BR><BR>Operatives that expose themselves or their orders must be terminated. <BR><BR>You know what must be done."

/obj/random/achlock //Large objects to block things off in maintenance
	name = "airlock randomization"
	desc = "This chooses between a broken passable airlock, a closed airlock, and a welded airlock."
	icon = 'icons/mob/screen1.dmi'
	icon_state = "x"

/obj/random/achlock/spawn_choices()
	return list(/obj/structure/doorwreckage,
				/obj/machinery/door/airlock/maintenance,
				/obj/machinery/door/airlock/maintenance/welded)

/obj/structure/doorwreckage
	name = "wrecked airlock"
	desc = "An airlock. Something strong pried it open."
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_as_0"
	density = 1
	opacity = 0
	throwpass = 1
	anchored = 1

/obj/structure/doorwreckage/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(air_group || (height==0))
		return 1
	if(istype(mover) && (mover.checkpass(PASSTABLE) || mover.elevation != elevation))
		return 1
	else
		return 0

/obj/structure/doorwreckage/Bumped(atom/movable/AM)
	if(isliving(AM) && AM:a_intent == I_HELP)
		if(istype(AM, /mob/living/simple_animal/))
			return
		if(istype(AM, /mob/living/simple_animal/hostile))
			var/mob/living/simple_animal/hostile/H = AM
			if(!H.assault_target && !H.target_mob)
				return
		var/turf/T = get_step(AM, AM.dir)
		if(T.CanPass(AM, T))
			if(ismob(AM))
				var/mob/moving = AM
				moving.show_message("<span class='notice'>You start maneuvring through [src]...</span>")
			spawn(0)
				if(do_after(AM, 30))
					src.visible_message("<span class='info'>[AM] slips through [src].</span>")
					AM.loc = T
		else if(ismob(AM))
			var/mob/moving = AM
			moving.show_message("<span class='warning'>Something is blocking you from maneuvering through [src].</span>")
	..()

/obj/structure/doorwreckage/attackby(obj/item/W as obj, mob/user as mob)
	user.visible_message("[user] begins cutting through the wrecked airlock.", "You start to slice through the wrecked airlock.")
	playsound(src.loc, 'sound/items/Welder2.ogg', 50, 1)
	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		if(do_after(user, 80) && WT.remove_fuel(5, user))
			playsound(src.loc, 'sound/items/Welder2.ogg', 50, 1)
			user.visible_message("<span class='info'>You slice through the wrecked airlock!</span>")
			new /obj/item/metalscrap(src.loc)
			new /obj/item/metalscrap(src.loc)
			new /obj/item/metalscrap(src.loc)
			new /obj/item/stack/cable_coil/cut(src.loc)
			new /obj/item/stack/cable_coil/cut(src.loc)
			qdel(src)
		else
			to_chat(user, "<span class='warning'>There is not enough fuel to slice through!</span>")
	else
		..()

/obj/machinery/door/airlock/maintenance/welded
	welded = 1

/obj/item/device/flashlight/pen/bright
	brightness_on = 3
	light_power = 2

/obj/structure/vent
	icon = 'icons/atmos/vent_pump.dmi'
	icon_state = "hoff"
	anchored = 1
	mouse_opacity = 0
	density = 0
	layer = 2

/datum/flood_spawner/achlys
	spawn_pool = list(\
	/mob/living/simple_animal/hostile/flood/combat_form/prisoner, \
	/mob/living/simple_animal/hostile/flood/combat_form/prisoner/guard, \
	/mob/living/simple_animal/hostile/flood/combat_form/prisoner/crew \
	)
