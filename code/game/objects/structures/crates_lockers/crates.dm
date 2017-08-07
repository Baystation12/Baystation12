//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

/obj/structure/closet/crate
	name = "crate"
	desc = "A rectangular steel crate."
	icon = 'icons/obj/storage.dmi'
	icon_state = "crate"
	icon_opened = "crateopen"
	icon_closed = "crate"
	flags = OBJ_CLIMBABLE
	setup = 0
	var/points_per_crate = 5
	var/rigged = 0

/obj/structure/closet/crate/open()
	if(flags & OBJ_CLIMBABLE && !opened && can_open())
		object_shaken()
	. = ..()
	if(.)
		if(rigged)
			visible_message("<span class='danger'>There are wires attached to the lid of [src]...</span>")
			for(var/obj/item/device/assembly_holder/H in src)
				H.process_activation(usr)
			for(var/obj/item/device/assembly/A in src)
				A.activate()

/obj/structure/closet/crate/examine(mob/user)
	..()
	if(rigged && opened)
		var/list/devices = list()
		for(var/obj/item/device/assembly_holder/H in src)
			devices += H
		for(var/obj/item/device/assembly/A in src)
			devices += A
		to_chat(user,"There are some wires attached to the lid, connected to [english_list(devices)].")

/obj/structure/closet/crate/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(opened)
		return ..()
	else if(istype(W, /obj/item/weapon/packageWrap))
		return
	else if(istype(W, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/C = W
		if(rigged)
			to_chat(user, "<span class='notice'>[src] is already rigged!</span>")
			return
		if (C.use(1))
			to_chat(user, "<span class='notice'>You rig [src].</span>")
			rigged = 1
			return
	else if(istype(W, /obj/item/device/assembly_holder) || istype(W, /obj/item/device/assembly))
		if(rigged)
			to_chat(user, "<span class='notice'>You attach [W] to [src].</span>")
			user.drop_item()
			W.forceMove(src)
			return
	else if(istype(W, /obj/item/weapon/wirecutters))
		if(rigged)
			to_chat(user, "<span class='notice'>You cut away the wiring.</span>")
			playsound(loc, 'sound/items/Wirecutter.ogg', 100, 1)
			rigged = 0
			return
	else
		return attack_hand(user)

/obj/structure/closet/crate/secure
	desc = "A secure crate."
	name = "Secure crate"
	icon_state = "securecrate"
	icon_opened = "securecrateopen"
	icon_closed = "securecrate"
	var/redlight = "securecrater"
	var/greenlight = "securecrateg"
	var/sparks = "securecratesparks"
	var/emag = "securecrateemag"

	setup = CLOSET_HAS_LOCK

/obj/structure/closet/crate/secure/Initialize()
	. = ..()
	update_icon()

/obj/structure/closet/crate/secure/update_icon()
	..()
	if(broken)
		overlays += redlight
	else if(locked)
		overlays += emag
	else
		overlays += greenlight

/obj/structure/closet/crate/plastic
	name = "plastic crate"
	desc = "A rectangular plastic crate."
	icon_state = "plasticcrate"
	icon_opened = "plasticcrateopen"
	icon_closed = "plasticcrate"
	points_per_crate = 1

/obj/structure/closet/crate/internals
	name = "internals crate"
	desc = "A internals crate."
	icon_state = "o2crate"
	icon_opened = "o2crateopen"
	icon_closed = "o2crate"

/obj/structure/closet/crate/trashcart
	name = "trash cart"
	desc = "A heavy, metal trashcart with wheels."
	icon_state = "trashcart"
	icon_opened = "trashcartopen"
	icon_closed = "trashcart"

/*these aren't needed anymore
/obj/structure/closet/crate/hat
	desc = "A crate filled with Valuable Collector's Hats!."
	name = "Hat Crate"
	icon_state = "crate"
	icon_opened = "crateopen"
	icon_closed = "crate"

/obj/structure/closet/crate/contraband
	name = "Poster crate"
	desc = "A random assortment of posters manufactured by providers NOT listed under Nanotrasen's whitelist."
	icon_state = "crate"
	icon_opened = "crateopen"
	icon_closed = "crate"
*/

/obj/structure/closet/crate/medical
	name = "medical crate"
	desc = "A medical crate."
	icon_state = "medicalcrate"
	icon_opened = "medicalcrateopen"
	icon_closed = "medicalcrate"

/obj/structure/closet/crate/rcd
	name = "\improper RCD crate"
	desc = "A crate with rapid construction device."
	icon_state = "crate"
	icon_opened = "crateopen"
	icon_closed = "crate"

/obj/structure/closet/crate/rcd/New()
	..()
	new /obj/item/weapon/rcd_ammo(src)
	new /obj/item/weapon/rcd_ammo(src)
	new /obj/item/weapon/rcd_ammo(src)
	new /obj/item/weapon/rcd(src)

/obj/structure/closet/crate/solar
	name = "solar pack crate"

/obj/structure/closet/crate/solar/New()
	..()
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/weapon/circuitboard/solar_control(src)
	new /obj/item/weapon/tracker_electronics(src)
	new /obj/item/weapon/paper/solar(src)

/obj/structure/closet/crate/solar_assembly
	name = "solar assembly crate"

/obj/structure/closet/crate/solar_assembly/New()
	..()
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)
	new /obj/item/solar_assembly(src)

/obj/structure/closet/crate/freezer
	name = "freezer"
	desc = "A freezer."
	icon_state = "freezer"
	icon_opened = "freezeropen"
	icon_closed = "freezer"
	var/target_temp = T0C - 40
	var/cooling_power = 40

	return_air()
		var/datum/gas_mixture/gas = (..())
		if(!gas)	return null
		var/datum/gas_mixture/newgas = new/datum/gas_mixture()
		newgas.copy_from(gas)
		if(newgas.temperature <= target_temp)	return

		if((newgas.temperature - cooling_power) > target_temp)
			newgas.temperature -= cooling_power
		else
			newgas.temperature = target_temp
		return newgas

/obj/structure/closet/crate/freezer/rations //Fpr use in the escape shuttle
	name = "emergency rations"
	desc = "A crate of emergency rations."


/obj/structure/closet/crate/freezer/rations/New()
	..()
	new /obj/item/weapon/reagent_containers/food/snacks/liquidfood(src)
	new /obj/item/weapon/reagent_containers/food/snacks/liquidfood(src)
	new /obj/item/weapon/reagent_containers/food/snacks/liquidfood(src)
	new /obj/item/weapon/reagent_containers/food/snacks/liquidfood(src)

/obj/structure/closet/crate/bin
	name = "large bin"
	desc = "A large bin."
	icon_state = "largebin"
	icon_opened = "largebinopen"
	icon_closed = "largebin"

/obj/structure/closet/crate/radiation
	name = "radioactive gear crate"
	desc = "A crate with a radiation sign on it."
	icon_state = "radiation"
	icon_opened = "radiationopen"
	icon_closed = "radiation"

/obj/structure/closet/crate/radiation/New()
	..()
	new /obj/item/clothing/suit/radiation(src)
	new /obj/item/clothing/head/radiation(src)
	new /obj/item/clothing/suit/radiation(src)
	new /obj/item/clothing/head/radiation(src)
	new /obj/item/clothing/suit/radiation(src)
	new /obj/item/clothing/head/radiation(src)
	new /obj/item/clothing/suit/radiation(src)
	new /obj/item/clothing/head/radiation(src)

/obj/structure/closet/crate/secure/weapon
	name = "weapons crate"
	desc = "A secure weapons crate."
	icon_state = "weaponcrate"
	icon_opened = "weaponcrateopen"
	icon_closed = "weaponcrate"

/obj/structure/closet/crate/secure/phoron
	name = "phoron crate"
	desc = "A secure phoron crate."
	icon_state = "phoroncrate"
	icon_opened = "phoroncrateopen"
	icon_closed = "phoroncrate"

/obj/structure/closet/crate/secure/gear
	name = "gear crate"
	desc = "A secure gear crate."
	icon_state = "secgearcrate"
	icon_opened = "secgearcrateopen"
	icon_closed = "secgearcrate"

/obj/structure/closet/crate/secure/hydrosec
	name = "secure hydroponics crate"
	desc = "A crate with a lock on it, painted in the scheme of botany and botanists."
	icon_state = "hydrosecurecrate"
	icon_opened = "hydrosecurecrateopen"
	icon_closed = "hydrosecurecrate"

/obj/structure/closet/crate/secure/bin
	name = "secure bin"
	desc = "A secure bin."
	icon_state = "largebins"
	icon_opened = "largebinsopen"
	icon_closed = "largebins"
	redlight = "largebinr"
	greenlight = "largebing"
	sparks = "largebinsparks"
	emag = "largebinemag"

/obj/structure/closet/crate/large
	name = "large crate"
	desc = "A hefty metal crate."
	icon = 'icons/obj/storage.dmi'
	icon_state = "largemetal"
	icon_opened = "largemetalopen"
	icon_closed = "largemetal"

/obj/structure/closet/crate/large/close()
	. = ..()
	if (.)//we can hold up to one large item
		var/found = 0
		for(var/obj/structure/S in src.loc)
			if(S == src)
				continue
			if(!S.anchored)
				found = 1
				S.forceMove(src)
				break
		if(!found)
			for(var/obj/machinery/M in src.loc)
				if(!M.anchored)
					M.forceMove(src)
					break
	return

/obj/structure/closet/crate/secure/large
	name = "large crate"
	desc = "A hefty metal crate with an electronic locking system."
	icon = 'icons/obj/storage.dmi'
	icon_state = "largemetal"
	icon_opened = "largemetalopen"
	icon_closed = "largemetal"
	redlight = "largemetalr"
	greenlight = "largemetalg"

/obj/structure/closet/crate/secure/large/close()
	. = ..()
	if (.)//we can hold up to one large item
		var/found = 0
		for(var/obj/structure/S in src.loc)
			if(S == src)
				continue
			if(!S.anchored)
				found = 1
				S.forceMove(src)
				break
		if(!found)
			for(var/obj/machinery/M in src.loc)
				if(!M.anchored)
					M.forceMove(src)
					break
	return

//fluff variant
/obj/structure/closet/crate/secure/large/reinforced
	desc = "A hefty, reinforced metal crate with an electronic locking system."
	icon_state = "largermetal"
	icon_opened = "largermetalopen"
	icon_closed = "largermetal"

/obj/structure/closet/crate/hydroponics
	name = "hydroponics crate"
	desc = "All you need to destroy those pesky weeds and pests."
	icon_state = "hydrocrate"
	icon_opened = "hydrocrateopen"
	icon_closed = "hydrocrate"

/obj/structure/closet/crate/hydroponics/prespawned
	//This exists so the prespawned hydro crates spawn with their contents.

	New()
		..()
		new /obj/item/weapon/reagent_containers/spray/plantbgone(src)
		new /obj/item/weapon/reagent_containers/spray/plantbgone(src)
		new /obj/item/weapon/material/minihoe(src)
		new /obj/item/weapon/material/minihoe(src)
		new /obj/item/weapon/storage/plants(src)
		new /obj/item/weapon/storage/plants(src)
		new /obj/item/weapon/material/hatchet(src)
		new /obj/item/weapon/material/hatchet(src)
		new /obj/item/weapon/wirecutters/clippers(src)
		new /obj/item/weapon/wirecutters/clippers(src)
		new /obj/item/device/analyzer/plant_analyzer(src)
		new /obj/item/device/analyzer/plant_analyzer(src)
//		new /obj/item/weapon/weedspray(src)
//		new /obj/item/weapon/weedspray(src)
//		new /obj/item/weapon/pestspray(src)
//		new /obj/item/weapon/pestspray(src)
//		new /obj/item/weapon/pestspray(src)

/obj/structure/closet/crate/secure/biohazard
	name = "biohazarad cart"
	desc = "A heavy cart with extensive sealing. You shouldn't eat things you find in it."
	icon_state = "biohazard"
	icon_opened = "biohazardopen"
	icon_closed = "biohazard"
	open_sound = 'sound/items/Deconstruct.ogg'
	close_sound = 'sound/items/Deconstruct.ogg'
	req_access = list(access_xenobiology)

/obj/structure/closet/crate/secure/biohazard/blanks
	will_contain = list(/mob/living/carbon/human/blank, /obj/item/usedcryobag)