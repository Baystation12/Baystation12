#define MARINE_OVERRIDE 'code/modules/halo/clothing/marine.dmi'
#define ITEM_INHAND 'code/modules/halo/clothing/marine_items.dmi'

/obj/item/weapon/storage/pocketstore/hardcase/flares
	name = "Tactical Hardcase (Flares)"
	icon_state = "hardcase_mags"
	storage_slots = 4
	can_hold = list(/obj/item/device/flashlight/flare)
	startswith = list(/obj/item/device/flashlight/flare/unsc = 4)

/obj/item/weapon/storage/box/flares
	name = "box of flares"
	icon_state = "flashbang"
	max_storage_space = 4
	w_class = 1
	startswith = list(/obj/item/device/flashlight/flare/unsc = 4)

/obj/item/device/flashlight/flare/unsc
	brightness_on = 4 //halved normal flare light

/datum/autolathe/recipe/unsc_flare
	name = "Flare"
	path = /obj/item/device/flashlight/flare/unsc
	category = "Arms and Ammunition"
	resources = list("steel" = 200)

/obj/item/clothing/head/helmet/achlys_marine //regular marine helmet lacking a flashlight and visor
	name = "Olive Camo CH251 Helmet"
	desc = "The standard issue combat helmet worn by the members of the UNSC Marine Corps, UNSC Army, and UNSC Air Force."
	icon = ITEM_INHAND
	icon_override = MARINE_OVERRIDE
	item_state = "CH252 Helmet"
	icon_state = "helmet_novisor"
	item_flags = THICKMATERIAL
	body_parts_covered = HEAD
	armor = list(melee = 50, bullet = 30, laser = 50,energy = 20, bomb = 25, bio = 0, rad = 0)
	flags_inv = HIDEEARS|HIDEEYES
	cold_protection = HEAD
	min_cold_protection_temperature = HELMET_MIN_COLD_PROTECTION_TEMPERATURE
	heat_protection = HEAD
	max_heat_protection_temperature = HELMET_MAX_HEAT_PROTECTION_TEMPERATURE
	siemens_coefficient = 0.7
	w_class = 3

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
	/obj/item/weapon/storage/pocketstore/hardcase/flares = 1,
	/obj/item/weapon/storage/box/MRE/Chicken/achlys = 1,
	/obj/item/weapon/material/knife/combat_knife = 1,
	/obj/item/ammo_magazine/m6d/m225 = 2,
	/obj/item/weapon/gun/projectile/m6d_magnum = 1,
	/obj/item/ammo_magazine/m7/m443 = 3,
	/obj/item/weapon/gun/projectile/m7_smg = 1,
	/obj/item/clothing/head/helmet/achlys_marine = 1,
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
	/obj/item/weapon/storage/pocketstore/hardcase/flares = 1,
	/obj/item/weapon/storage/box/MRE/Pizza/achlys = 1,
	/obj/item/weapon/material/knife/combat_knife = 1,
	/obj/item/ammo_magazine/m7/m443 = 3,
	/obj/item/weapon/gun/projectile/m7_smg = 1,
	/obj/item/weapon/grenade/frag/m9_hedp = 1,
	/obj/item/ammo_box/shotgun/slug = 2,
	/obj/item/ammo_box/shotgun = 2,
	/obj/item/weapon/gun/projectile/shotgun/pump/m90_ts = 1,
	/obj/item/clothing/head/helmet/achlys_marine = 1,
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
	/obj/item/weapon/storage/pocketstore/hardcase/flares = 1,
	/obj/item/clothing/head/helmet/achlys_marine = 1,
	/obj/item/clothing/mask/marine = 1,
	/obj/item/clothing/glasses/welding = 1,
	/obj/item/clothing/suit/storage/marine = 1,
	/obj/item/clothing/gloves/thick/unsc = 1,
	/obj/item/clothing/shoes/marine = 1,
	/obj/item/weapon/storage/belt/utility/marine_engineer = 1,
	/obj/item/weapon/storage/box/MRE/Chicken/achlys = 1,
	/obj/item/weapon/material/knife/combat_knife = 1,
	/obj/item/weapon/armor_patch = 2,
	/obj/item/ammo_magazine/m6d/m225 = 2,
	/obj/item/weapon/gun/projectile/m6d_magnum = 1,
	/obj/item/ammo_magazine/m7/m443 = 3,
	/obj/item/weapon/gun/projectile/m7_smg = 1,
	/obj/item/weapon/storage/pocketstore/hardcase/magazine = 1,
	/obj/item/clothing/glasses/hud/tactical = 1,
	/obj/item/weapon/plastique = 2,
	)

/obj/structure/closet/crate/marine/rifleman
	name = "standard rifleman equipment"
	desc = "Standard groundpounder gear."
	icon_state = "secgearcrate"
	icon_opened = "secgearcrateopen"
	icon_closed = "secgearcrate"

/obj/structure/closet/crate/marine/rifleman/WillContain()
	return list(
	/obj/item/weapon/storage/pocketstore/hardcase/flares = 1,
	/obj/item/weapon/storage/box/MRE/Spaghetti/achlys = 1,
	/obj/item/weapon/material/knife/combat_knife = 1,
	/obj/item/ammo_magazine/m6d/m225 = 3,
	/obj/item/weapon/gun/projectile/m6d_magnum = 1,
	/obj/item/ammo_magazine/ma5b/m118 = 4,
	/obj/item/weapon/gun/projectile/ma5b_ar = 1,
	/obj/item/weapon/grenade/frag/m9_hedp = 1,
	/obj/item/clothing/head/helmet/achlys_marine = 1,
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
	/obj/item/weapon/storage/pocketstore/hardcase/flares = 1,
	/obj/item/weapon/storage/box/MRE/Spaghetti/achlys = 1,
	/obj/item/weapon/material/knife/combat_knife = 1,
	/obj/item/ammo_magazine/m6d/m225 = 3,
	/obj/item/weapon/gun/projectile/m6d_magnum = 1,
	/obj/item/ammo_magazine/ma5b/m118 = 4,
	/obj/item/weapon/gun/projectile/ma5b_ar = 1,
	/obj/item/device/taperecorder = 1,
	/obj/item/squad_manager = 1,
	/obj/item/clothing/head/helmet/achlys_marine = 1,
	/obj/item/clothing/mask/marine = 1,
	/obj/item/clothing/glasses/hud/tactical = 1,
	/obj/item/clothing/suit/storage/marine = 1,
	/obj/item/clothing/gloves/thick/unsc = 1,
	/obj/item/clothing/shoes/marine = 1,
	/obj/item/weapon/storage/belt/marine_ammo = 1)

/obj/structure/closet/pilot_equipment
	name = "pilot equipment"
	desc = "For pelican pilots."
	req_access = list()

/obj/structure/closet/pilot_equipment/WillContain()
	return list(
	/obj/item/weapon/storage/pocketstore/hardcase/flares = 1,
	/obj/item/weapon/material/knife/combat_knife = 1,
	/obj/item/ammo_magazine/m6d/m225 = 4,
	/obj/item/weapon/storage/pocketstore/hardcase/magazine = 1,
	/obj/item/weapon/gun/projectile/m6d_magnum = 1,
	/obj/item/clothing/glasses/hud/tactical = 1,
	/obj/item/clothing/accessory/holster/thigh = 1,
	/obj/item/clothing/under/unsc/pilot = 1,
	/obj/item/clothing/shoes/dutyboots = 1,
	/obj/item/clothing/suit/armor/bulletproof/vest = 1,
	/obj/item/clothing/head/helmet/pilot = 1,
	)

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
	name = "Navigation Console"
	desc = "A robust system with it's own power supply that holds nav data on it's hard drive. This includes the location of the planet Earth. An exposed wire dangles precariously: Perhaps you could rip out a critical circuit to break this machine?"
	icon = 'code/modules/halo/overmap/nav_computer.dmi'
	icon_state = "nav_computer"
	light_power = 1
	light_range = 2
	light_color = "#ebf7fe"
	density = 1
	anchored = 1

/obj/structure/navconsole/attack_hand(var/mob/living/carbon/human/attacker)
	if(!istype(attacker))
		return
	visible_message("<span class = 'warning'>[attacker] starts to rummage through the wiring of \the [src]...</span>")
	if(!do_after(attacker,15 SECONDS,src,1,1,,1))
		return
	visible_message("<span class = 'warning'>[attacker] rips out a critical circuit in \the [src]'s electronics! </span>")
	qdel(src)

/obj/structure/navconsole/Del()
	new /obj/effect/decal/cleanable/blood/gibs/robot (loc)
	. = ..()

/obj/item/weapon/reference
	name = "gold coin"
	desc = "This coin isn't as soft as normal gold, and seems to be an improper size. Clearly a fraud."
	icon = 'icons/obj/items.dmi'
	icon_state = "coin_gold"
	w_class = 1

/obj/item/weapon/research //the red herring
	name = "research documents"
	desc = "Random useless papers documenting some kind of nerd experiments."
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "envelope_sealed"
	w_class = 1

/obj/item/weapon/research/sekrits //the mcguffin
	name = "strange documents"
	desc = "This folder is sealed shut and coated in way too many warnings. Definitely not safe to open. Must be useful to higher-ups, better take it back."

/obj/item/weapon/research/sekrits/New()
	. = ..()
	tag = "retrievethis"

/obj/item/weapon/card/id/the_gold
	name = "Gold Keycard"
	desc = "This keycard appears to belong to a bridge crewman. It's covered in some kind of mucus that is stubborn to remove but the chip seems exposed enough to open a door."
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
	desc = "This autolathe was dragged here and hacked together from other machine parts. The material input is jammed shut."
	stored_material =  list(DEFAULT_WALL_MATERIAL = 3500, "glass" = 0)
	storage_capacity = list(DEFAULT_WALL_MATERIAL = 0, "glass" = 0)
	machine_recipes = newlist(\
	/datum/autolathe/recipe/ma5b_m118,
	/datum/autolathe/recipe/m6d_m224,
	/datum/autolathe/recipe/m443_fmj,
	/datum/autolathe/recipe/shotgun_box,
	/datum/autolathe/recipe/shotgun_box/slugs,
	/datum/autolathe/recipe/unsc_flare
	)

/obj/item/weapon/paper/crumpled/orders
	info = "Office of Naval Intelligence Section 3<BR><BR>Any person that steps foot on the Achlys cannot leave the ship alive, but the overall mission must be accomplished. Exterminate with extreme prejudice.<BR><BR>Do not allow your identity to be compromised by any means. Failure to obey these orders will result in subject termination.<BR><BR>Operatives that expose themselves or their orders must be terminated. <BR><BR>You know what must be done."

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
	desc = "An airlock. Something strong pried it open. It could be cut apart with a welding tool."
	icon = 'icons/obj/doors/door_assembly.dmi'
	icon_state = "door_as_mai0"
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
	if(isliving(AM))
		if(istype(AM, /mob/living/simple_animal/hostile))
			var/mob/living/simple_animal/hostile/H = AM
			if(!H.assault_target && !H.target_mob && !H.ckey)
				return
		var/turf/T = get_step(AM, AM.dir)
		if(T.CanPass(AM, T))
			if(ismob(AM))
				var/mob/moving = AM
				moving.show_message("<span class='notice'>You start maneuvering through [src]...</span>")
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
			new /obj/item/salvage/metal(src.loc)
			new /obj/item/salvage/metal(src.loc)
			new /obj/item/salvage/metal(src.loc)
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

/obj/structure/false_light
	name = "light bulb"
	desc = "A broken light bulb. There is no power to light it."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "tube0"
	anchored = 1
	density = 0
	opacity = 0

/obj/vehicles/air/overmap/pelican/achlys/enter_as_position(var/mob/living/carbon/human/user,var/position = "passenger")
	if(!istype(user))
		to_chat(user,"<span class = 'notice'>You can't enter [src]!</span>")
		return
	. = ..()

/obj/item/weapon/storage/box/MRE/Chicken/achlys
	w_class = 1

/obj/item/weapon/storage/box/MRE/Pizza/achlys
	w_class = 1

/obj/item/weapon/storage/box/MRE/Spaghetti/achlys
	w_class = 1

/obj/item/weapon/gun/projectile/shotgun/pump/m45_ts/achlys
	name = "looted M45 TS tactical shotgun"
	desc = "A shotgun dug up from somewhere on the ship. Good luck finding more shells."

/obj/item/weapon/gun/projectile/shotgun/pump/m45_ts/police/achlys
	name = "looted M45 TS tactical shotgun"
	desc = "A shotgun dug up from somewhere on the ship. Good luck finding more shells."

/obj/item/weapon/material/hatchet/achlys
	name = "looted hatchet"
	desc = "A hatchet looted from Hydroponics. Not the most preferable of weapons but better than bare hands."
	force = 25

/obj/item/weapon/material/twohanded/baseballbat/achlys
	name = "cricket bat"
	desc = "Found somewhere on the ship. Possibly near the rec rooms?"

/obj/item/weapon/gun/projectile/ma37_ar/achlys
	name = "\improper looted MA37 Assault Rifle"
	desc = "Commonly found on infected flood wearing security outfits. Takes 7.62mm ammo."

/obj/item/weapon/gun/projectile/m6d_magnum/civilian/achlys
	desc = "A looted handgun found somewhere on the ship. The sidearm of the command staff on the ship."
	name = "\improper looted M6B Magnum"

/obj/item/weapon/gun/projectile/m6d_magnum/police/achlys
	name = "\improper looted M6B Magnum"
	desc = "A looted handgun found somewhere on the ship. The sidearm of the security guards posted to the ship."

/obj/item/weapon/scalpel/achlys
	force = 20
	name = "reinforced scalpel"
	desc = "A heavy duty scalpel that seems designed to cut through flesh thicker than what a human has."

/obj/structure/splish_splash //effectively a noisemaker
	density = 0				 //tons of copypasta from floodspawner structure. it works.
	mouse_opacity = 0
	opacity = 0
	icon = 'code/modules/halo/flood/flood_combat_human.dmi'
	icon_state = "splish_splash"
	var/time_to_splash //this is a timer to play a sound byte
	//var/list/splash_sound = list() //sounds to play when the timer runs out
	var/uses = 0
	invisibility = 101

/obj/structure/splish_splash/Initialize()
	. = ..()
	uses+= pick(0,1) //decides to either delete itself or spawn with one use
	if(uses)
		time_to_splash = world.time + rand(3 SECONDS,7 SECONDS)
	else return INITIALIZE_HINT_QDEL //deletes itself if there are no uses

/obj/structure/splish_splash/process()
	if(time_to_splash == 0 SECONDS)
		timer_end()

/obj/structure/splish_splash/proc/timer_end()
	//playsound(src.loc, splash_sound, 80, 1, 0) //sound played at src.loc
	src.loc.visible_message(pick("<span class='warning'>Something sloshes through the water in the darkness.</span>"),("<span class='warning'>A distant form splashes in the filthy water.</span>"),\
			("<span class='warning'>Something distant falls into the water.</span>"))
	for(var/i = 3 to 7)
		time_to_splash += i SECONDS

/obj/item/weapon/reagent_containers/food/snacks/liquidfood/floody
	desc = "A prepackaged grey slurry for all of the essential nutrients a soldier requires to survive. It is coated in some kind of mucus that seems to have gotten inside."
	trash = /obj/item/trash/liquidfood/floody
	var/clean = 0 //mucus overlay, this is dropped by flood forms

/obj/item/weapon/reagent_containers/food/snacks/liquidfood/floody/New()
	if(!reagents)
		reagents = new
	reagents.add_reagent(/datum/reagent/floodinfectiontoxin, 10) //don't take candy from strange alien monsters
	clean = pick(0,1)	//decide to be clean or have mucus
	if(!clean)			//if not clean, apply overlay
		update_icon()
	..() //continue as normal, inheriting our bitesize and iron reagent from parent

/obj/item/weapon/reagent_containers/food/snacks/liquidfood/floody/update_icon()
	if(!clean)  //if we're not clean, add a mucus overlay
		overlays.Cut()
		var/image/I = image('icons/effects/blood.dmi', icon_state="mucus")
		overlays += I
		return
	else return //else if we are clean, do nothing, especially runtime //this is redundant, BYOND is not predictable

/obj/item/weapon/reagent_containers/food/snacks/liquidfood/floody/On_Consume(var/mob/M)
	if(!clean)
		var/obj/item/trash/liquidfood/floody/F = trash
		(F.clean = 0) //if we're not clean, our trash shouldn't be either
		..()  //carry on as normal
	else ..() //don't runtime because we were clean

/obj/item/trash/liquidfood/floody
	var/clean = 0

/obj/item/trash/liquidfood/floody/New()
	if(!clean)
		update_icon()
	..()

/obj/item/trash/liquidfood/floody/update_icon()
	if(!clean)  //inherited from parent, copypasta
		overlays.Cut()
		var/image/I = image('icons/effects/blood.dmi', icon_state="mucus")
		overlays += I
		return
	else return

//Cov Armour

/obj/item/clothing/head/helmet/sangheili/minor/achlys
	name = "Sangheili Helmet (Minor, Stripped-Down)"
	desc = "Head armour, to be used with the Sangheili Combat Harness. It's had a number of components removed, under the armour itself."

/obj/item/clothing/suit/armor/special/combatharness/minor/achlys
	name = "Sangheili Combat Harness (Minor, Stripped-Down)"
	desc = "A Sangheili Combat Harness. It's had the shielding stripped out; Likely for research."
	specials = list()
	totalshields = 0

/obj/item/clothing/shoes/sangheili/minor/achlys
	name = "Sanghelli Leg Armour (Minor, Stripped-Down)"
	desc = "Leg armour, to be used with the Sangheili Combat Harness. It's had a number of components removed, under the armour itself."

/obj/item/clothing/gloves/thick/sangheili/minor/achlys
	name = "Sanghelli Combat Gauntlets (Minor, Stripped-Down)"
	desc = "Hand armour, to be used with the Sangheili Combat Harness. It's had a number of components removed, under the armour itself."


//Traps.

/obj/item/device/landmine/emp/active/low_range
	det_range = 3

/obj/item/device/landmine/flame/active/low_range
	det_range = 3

/obj/item/device/landmine/flash/active/low_range
	det_range = 3

/obj/item/weapon/beartrap/deployed
	icon_state = "beartrap1"
	deployed = 1
	anchored = 1