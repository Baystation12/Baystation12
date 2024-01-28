/*******************
sierra specific items
*******************/

/obj/item/storage/backpack/explorer
	name = "explorer backpack"
	desc = "A rugged backpack."
	icon_state = "exppack"

/obj/item/storage/backpack/satchel_explorer
	name = "explorer satchel"
	desc = "A rugged satchel for field work."
	icon_state = "satchel-exp"
	worn_access = TRUE

/obj/item/storage/backpack/messenger/explorer
	name = "explorer messenger bag"
	desc = "A rugged backpack worn over one shoulder."
	icon_state = "courierbagsci"

/obj/item/storage/firstaid/security
	name = "Tactical first-aid kit"
	desc = "It's a small emergency medical kit. Dark and lightweight."
	use_sound = 'sound/effects/storage/pillbottle.ogg'
	icon = 'maps/sierra/icons/obj/medical.dmi'
	icon_state = "fak-sec"
	matter = list(MATERIAL_PLASTIC = 600)
	storage_slots = 7
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_SMALL
	startswith = list(
		/obj/item/reagent_containers/hypospray/autoinjector/inaprovaline,
		/obj/item/reagent_containers/hypospray/autoinjector/antirad,
		/obj/item/reagent_containers/hypospray/autoinjector/detox,
		/obj/item/reagent_containers/hypospray/autoinjector/dexalin,
		/obj/item/reagent_containers/hypospray/autoinjector/kelotane,
		/obj/item/reagent_containers/hypospray/autoinjector/pain,
		/obj/item/stack/medical/bruise_pack
	)
	contents_allowed = list(
		/obj/item/reagent_containers/hypospray/autoinjector,
		/obj/item/stack/medical/bruise_pack
	)

/obj/item/reagent_containers/hypospray/autoinjector/dexalin
	name ="autoinjector (dexalin plus)"
	starts_with = list(/datum/reagent/dexalin = 5)

/obj/item/reagent_containers/hypospray/autoinjector/kelotane
	name = "autoinjector (antiburn)"
	starts_with = list(/datum/reagent/kelotane = 5)

/obj/item/reagent_containers/hypospray/autoinjector/kelotane
	name = "autoinjector (antiburn)"
	starts_with = list(/datum/reagent/kelotane = 5)

// Containers

/obj/item/storage/backpack/dufflebag/syndie_kit/plastique
	startswith = list(
		/obj/item/plastique = 6
		)

/***********
Unique items
***********/

/obj/item/pen/multi/cmd/hop
	name = "head of personnel's pen"
	icon = 'maps/sierra/icons/obj/uniques.dmi'
	icon_state = "pen_xo"
	desc = "A slightly bulky pen with a silvery case. Twisting the top allows you to switch the nib for different colors."

/obj/item/pen/multi/cmd/captain
	name = "captain's pen"
	icon = 'maps/sierra/icons/obj/uniques.dmi'
	icon_state = "pen_co"
	desc = "A slightly bulky pen with a golden case. Twisting the top allows you to switch the nib for different colors."

/obj/item/pen/multi/cmd/attack_self(mob/user)
	if(++selectedColor > 3)
		selectedColor = 1
	colour = colors[selectedColor]
	to_chat(user, "<span class='notice'>Changed color to '[colour].'</span>")

/obj/item/storage/fakebook
	name = "Workplace Crisis Management"
	desc = "Also known as 'I fucked up, what do?'. A very popular book among the NanoTrasen management."
	icon = 'icons/obj/library.dmi'
	icon_state = "booknanoregs"
	attack_verb = list("bashed", "whacked", "educated")
	throw_speed = 1
	throw_range = 5
	w_class = ITEM_SIZE_NORMAL
	max_w_class = ITEM_SIZE_SMALL
	max_storage_space = 2
	startswith = list(
			/obj/item/reagent_containers/pill/cyanide,
			/obj/item/paper/sierrau/liason_note
	)

/obj/paint/hull
	color = "#436b8e"

/obj/paint/dark_gunmetal
	color = COLOR_DARK_GUNMETAL

/obj/paint/nt_white
	color = "#eeeeee"

/obj/paint_stripe/nt_red
	color = "#9d2300"

/obj/paint_stripe/turquoise
	color = "#03ffc6"

/obj/item/device/boombox/anchored //for bar's private rooms
	name = "stationary boombox"
	anchored = TRUE

/obj/item/device/boombox/anchored/attack_hand(mob/user)
	interact(user)

/obj/item/tape/research
	req_access = list(list(access_research, access_explorer))

/******
Passports
******/

// SolGov Passports
/obj/item/passport/scg
	name = "\improper SCG passport"
	icon_state = "passport_scg"
	desc = "A passport from the Sol Central Government."

/obj/item/passport/scg/earth
	name = "\improper Earth passport"
	desc = "A passport from the Earth, within Sol Central Government space."

/obj/item/passport/scg/venus
	name = "\improper Venusian passport"
	desc = "A passport from Venus, within Sol Central Government space."

/obj/item/passport/scg/luna
	name = "\improper Luna passport"
	desc = "A passport from Luna, within Sol Central Government space."

/obj/item/passport/scg/mars
	name = "\improper Martian passport"
	desc = "A passport from Mars, within Sol Central Government space."

/obj/item/passport/scg/phobos
	name = "\improper Phobos passport"
	desc = "A passport from Phobos, within Sol Central Government space."

/obj/item/passport/scg/ceres
	name = "\improper Ceres passport"
	desc = "A passport from Ceres, within Sol Central Government space."

/obj/item/passport/scg/pluto
	name = "\improper Plutonian passport"
	desc = "A passport from Pluto, within Sol Central Government space."

/obj/item/passport/scg/tiamat
	name = "\improper Tiamat passport"
	desc = "A passport from Tiamat, within Sol Central Government space."

/obj/item/passport/scg/gauss
	name = "\improper Gauss passport"
	desc = "A passport from Gauss, within Sol Central Government space."

/obj/item/passport/scg/ceti_epsilon
	name = "\improper Cetite passport"
	desc = "A passport from Ceti Epsilon, within Sol Central Government space."

/obj/item/passport/scg/lordania
	name = "\improper Lordanian passport"
	desc = "A passport from Lordania, within Sol Central Government space."

/obj/item/passport/scg/kingston
	name = "\improper Kingstonian passport"
	desc = "A passport from Kingston, within Sol Central Government space."

/obj/item/passport/scg/cinu
	name = "\improper Cinusian passport"
	desc = "A passport from Cinu, within Sol Central Government space."

/obj/item/passport/scg/yuklid
	name = "\improper Yuklid V passport"
	desc = "A passport from Yuklid V, within Sol Central Government space."

/obj/item/passport/scg/lorriman
	name = "\improper Lorriman passport"
	desc = "A passport from Gesshire, near-independent scientific colony within Sol Central Government space."

/obj/item/passport/scg/tersten
	name = "\improper Tersten passport"
	desc = "A passport from Tersten, within Sol Central Government space."

/obj/item/passport/scg/south_gaia
	name = "\improper Southern Gaian passport"
	desc = "A passport from the southern part of Gaia, under control of the Sol Central Government."

/obj/item/passport/scg/birdcage
	name = "\improper Colchis passport"
	icon_state = "passport"
	desc = "A passport from Colchis habitat within SCG space, commonly known as Birdcage."


// ICCG Passports
/obj/item/passport/iccg
	name = "\improper ICCG passport"
	icon_state = "passport_iccg"
	desc = "A passport from the Independent Colonial Confederation of Gilgamesh."

/obj/item/passport/iccg/north_gaia
	name = "\improper Northern Gaian passport"
	desc = "A passport from the northern part of Gaia, under control of the Independent Colonial Confederation of Gilgamesh."

/obj/item/passport/iccg/terra
	name = "\improper Terran passport"
	desc = "A passport from Terra, within ICCG space."

/obj/item/passport/iccg/novayazemlya
	name = "\improper Novaya Zemlya passport"
	desc = "A passport from Novaya Zemlya, within ICCG space."


// independent
/obj/item/passport/independent
	name = "\improper Independent passport"
	icon_state = "passport"
	desc = "Passport of one of the many independent colonies"

/obj/item/passport/independent/magnitka
	name = "\improper Magnitkan passport"
	desc = "A passport from Magnitka, an independent colony."

/obj/item/passport/independent/kaldark
	name = "\improper Kaldark passport"
	desc = "A passport from Kaldark, an independent colony."

/obj/item/passport/independent/brinkburn
	name = "\improper Brinkburn passport"
	desc = "A passport from Brinkburn, an independent colony."

/obj/item/passport/independent/mirania
	name = "\improper Mirania passport"
	desc = "A passport from Mirania, an independent colony."

/obj/item/passport/independent/avalon
	name = "\improper Avalon passport"
	desc = "A passport from Avalon, an independent colony."

/obj/item/passport/independent/eremus
	name = "\improper Eremus passport"
	icon_state = "passport"
	desc = "A passport from Eremus, the most populated system bordering Resomi Empire."

/obj/item/passport/independent/asranda
	name = "\improper Randian passport"
	icon_state = "passport"
	desc = "A passport issued by the Republic of Asranda, an isolated colony resembling long-gone Resomi Republic."


// xeno passports
/obj/item/passport/xeno
	name = "\improper Xeno passport"
	icon = 'maps/sierra/icons/obj/passports.dmi'
	icon_state = "passport"
	desc = "A passport for Xenos."

/obj/item/passport/xeno/resomi
	name = "\improper Resomi registration document"
	icon_state = "passport"
	desc = "Something like a passport for Resomi."

/obj/item/passport/xeno/unathi
	name = "\improper Unathi registration document"
	icon_state = "passport"
	desc = "Passport, belongs to Unathi species."


/obj/item/storage/backpack/sci
	name = "science backpack"
	desc = "It's a stain-resistant light backpack, modeled for use by Expeditionary Corps science personnel in laboratories and other scientific settings."
	icon_state = "scipack"
	item_state_slots = list(
		slot_l_hand_str = "scipack",
		slot_r_hand_str = "scipack"
	)

/obj/item/storage/backpack/satchel/sci
	name = "science satchel"
	desc = "It's a stain-resistant satchel, modeled for use by Expeditionary Corps science personnel in laboratories and other scientific settings."
	icon_state = "satchel-sci"
	item_state_slots = list(
		slot_l_hand_str = "satchel-sci",
		slot_r_hand_str = "satchel-sci",
		)

/obj/item/storage/backpack/messenger/sci
	name = "science messenger bag"
	desc = "A small, stain-resistant backpack worn over one shoulder. This one was modeled for use by Expeditionary Corps science personnel in laboratories and other scientific settings."
	icon_state = "courierbagsci"

	//remote devices//

#define REMOTE_OPEN "Open Door"
#define REMOTE_BOLT "Toggle Bolts"
#define REMOTE_ELECT "Electrify Door"

/obj/item/device/remote_device
	name = "door remote"
	desc = "Remotely controls airlocks."
	icon = 'maps/sierra/icons/obj/remote_device.dmi'
	icon_state = "gangtool-white"
	item_state = "electronic"
	w_class = ITEM_SIZE_TINY
	var/mode = REMOTE_OPEN
	var/region_access = ACCESS_REGION_NONE
	var/obj/item/card/id/ID
	var/emagged = FALSE
	var/disabled = FALSE
	var/safety = TRUE

/obj/item/device/remote_device/Initialize()
	. = ..()
	create_access()

/obj/item/device/remote_device/proc/create_access(obj/item/card/id/user_id)
	QDEL_NULL(ID)
	ID = new /obj/item/card/id
	ID.access = list()

	for(var/access in region_access)
		ID.access += get_region_accesses(access)

	if(user_id?.access && !safety)
		ID.access |= user_id.access

/obj/item/device/remote_device/Destroy()
	QDEL_NULL(ID)
	return ..()

/obj/item/device/remote_device/use_tool(obj/item/tool, mob/living/user, list/click_params)
	if(istype(tool, /obj/item/card/id))
		var/obj/item/card/id/ID = tool
		if((ID.access && region_access) && (ID.access & region_access))
			safety = !safety
			to_chat(user, SPAN_NOTICE("You swipe your indefication card on \the [src]. The safety lock [safety ? "has been reset" : "off"]."))
			var/static/list/beepsounds = list(
				'sound/effects/compbeep1.ogg',
				'sound/effects/compbeep2.ogg',
				'sound/effects/compbeep3.ogg',
				'sound/effects/compbeep4.ogg',
				'sound/effects/compbeep5.ogg'
			)
			playsound(src.loc, pick(beepsounds),15,1,10)
			create_access(ID)
			user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
			return TRUE

	if(istype(tool, /obj/item/card/emag) && !emagged)
		safety = FALSE
		emagged = TRUE
		to_chat(user, "This device now can electrify doors.")
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		return TRUE

	return ..()

/obj/item/device/remote_device/attack_self(mob/user)
	if(mode == REMOTE_OPEN)
		if(emagged)
			mode = REMOTE_ELECT
		else mode = REMOTE_BOLT
	else if(mode == REMOTE_BOLT)
		mode = REMOTE_OPEN
	else if(mode == REMOTE_ELECT)
		mode = REMOTE_BOLT
	to_chat(user, "Now in mode: [mode].")

/obj/item/device/remote_device/afterattack(obj/machinery/door/airlock/D, mob/user)
	if(!istype(D) || safety || disabled || user.client.eye != user.client.mob)
		return
	if(!(D.arePowerSystemsOn()))
		to_chat(user, "<span class='danger'>[D] has no power!</span>")
		return
	if(!D.requiresID())
		to_chat(user, "<span class='danger'>[D]'s ID scan is disabled!</span>")
		return
	if(D.check_access(ID) && D.canAIControl(user))
		switch(mode)
			if(REMOTE_OPEN)
				if(D.density)
					D.open()
				else
					D.close()
			if(REMOTE_BOLT)
				if(D.locked)
					D.unlock()
				else
					D.lock()
			if(REMOTE_ELECT)
				if(D.electrified_until > 0)
					D.electrified_until = 0
				else
					D.electrified_until = 10
	else
		to_chat(user, "<span class='danger'>[src] does not have access to this door.</span>")

/obj/item/device/remote_device/omni
	name = "omni door remote"
	desc = "This remote control device can access any door on the facility."
	icon_state = "gangtool-yellow"
	safety = FALSE
	region_access = ACCESS_REGION_ALL

/obj/item/device/remote_device/captain
	name = "command door remote"
	icon_state = "gangtool-yellow"
	region_access = ACCESS_REGION_COMMAND

/obj/item/device/remote_device/chief_engineer
	name = "engineering door remote"
	icon_state = "gangtool-orange"
	region_access = ACCESS_REGION_ENGINEERING

/obj/item/device/remote_device/research_director
	name = "research door remote"
	icon_state = "gangtool-purple"
	region_access = ACCESS_REGION_RESEARCH

/obj/item/device/remote_device/head_of_security
	name = "security door remote"
	icon_state = "gangtool-red"
	region_access = ACCESS_REGION_SECURITY

/obj/item/device/remote_device/quartermaster
	name = "supply door remote"
	icon_state = "gangtool-green"
	region_access = ACCESS_REGION_SUPPLY

/obj/item/device/remote_device/chief_medical_officer
	name = "medical door remote"
	icon_state = "gangtool-blue"
	region_access = ACCESS_REGION_MEDBAY

/obj/item/device/remote_device/civillian
	name = "civillian door remote"
	icon_state = "gangtool-white"
	region_access = ACCESS_REGION_GENERAL

// Overrides

/obj/item/melee/baton
	icon = 'maps/sierra/icons/obj/baton.dmi'
	icon_state = "stunbaton"
	item_state = "baton"
	item_icons = list(
		slot_r_hand_str = 'maps/sierra/icons/mob/onmob/item/righthand.dmi',
		slot_l_hand_str = 'maps/sierra/icons/mob/onmob/item/lefthand.dmi',
		)

/obj/item/melee/baton/on_update_icon()
	if(status)
		icon_state = "[initial(icon_state)]_active"
		item_state = "[initial(item_state)]_active"
	else if(!bcell)
		icon_state = "[initial(icon_state)]_nocell"
		item_state = "[initial(item_state)]"
	else
		icon_state = "[initial(icon_state)]"
		item_state = "[initial(item_state)]"

	if(icon_state == "[initial(item_state)]_active")
		set_light(1.5, 2, "#75acff")
	else
		set_light(0)
	loc.update_icon()

#undef REMOTE_OPEN
#undef REMOTE_BOLT
#undef REMOTE_ELECT
