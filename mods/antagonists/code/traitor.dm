//
//        DOOR CHARGE
//

/obj/item/door_charge
	name = "door charge"
	desc = "This is a booby trap, planted on doors. When door opens, it will explode!."
	gender = PLURAL
	icon = 'mods/antagonists/icons/obj/door_charge.dmi'
	icon_state = "door_charge"
	item_state = "door_charge"
	item_flags = ITEM_FLAG_NO_BLUDGEON
	w_class = ITEM_SIZE_SMALL
	origin_tech = list(TECH_ESOTERIC = 4)
	var/ready = 0

/obj/item/door_charge/use_after(atom/movable/target, mob/user)
	if (ismob(target) || !istype(target, /obj/machinery/door/airlock))
		return FALSE

	to_chat(user, "Planting explosives...")
	user.do_attack_animation(target)

	if(do_after(user, 50, target) && in_range(user, target))
		if(!user.unequip_item())
			return TRUE

		forceMove(target)

		log_and_message_admins("planted \a [src] on \the [target].")

		to_chat(user, "Bomb has been planted.")

		GLOB.density_set_event.register(target, src, PROC_REF(explode))

	return TRUE


/obj/item/door_charge/proc/explode(obj/machinery/door/airlock/airlock)
	if(!airlock.density)
		explosion(get_turf(airlock), -1, 1, 2, 3)
		airlock.ex_act(1)
		qdel(src)

//
//        BLUESPACE JAUNTER
//

/obj/item/device/syndietele
	name = "strange sensor"
	desc = "Looks like regular powernet sensor, but this one almost black and have spooky red light blinking"
	icon = 'mods/antagonists/icons/obj/syndiejaunter.dmi'
	icon_state = "beacon"
	item_state = "signaler"
	origin_tech = list(TECH_BLUESPACE = 4, TECH_ESOTERIC = 3)

	w_class = ITEM_SIZE_SMALL

/obj/item/device/syndiejaunter
	name = "strange device"
	desc = "This thing looks like remote. Almost black, with red button and status display."
	icon = 'mods/antagonists/icons/obj/syndiejaunter.dmi'
	icon_state = "jaunter"
	item_state = "jaunter"
	w_class = ITEM_SIZE_SMALL
	var/obj/item/device/syndietele/beacon
	var/usable = 1
	var/image/cached_usable

/obj/item/device/syndiejaunter/examine(mob/user, distance)
	. = ..()
	to_chat(user, SPAN_NOTICE("Display is [usable ? "online and shows number [usable]" : "offline"]."))
/obj/item/device/syndiejaunter/Initialize()
	. = ..()
	update_icon()

/obj/item/device/syndiejaunter/on_update_icon()
	. = ..()
	if(usable)
		AddOverlays(image(icon, "usable"))
	else
		ClearOverlays()

/obj/item/device/syndiejaunter/attack_self(mob/user)
	if(!istype(beacon) || !usable)
		return 0

	animated_teleportation(user, beacon)
	usable = max(usable - 1, 0)
	update_icon()

/obj/item/device/syndiejaunter/use_after(atom/target, mob/user)
	if(istype(target,/obj/item/device/syndietele))
		beacon = target
		to_chat(user, "You succesfully linked [src] to [target]!")
	else
		to_chat(user, "You can't link [src] to [target]!")
	update_icon()

/obj/item/storage/box/syndie_kit/jaunter
	startswith = list(/obj/item/device/syndietele,
					  /obj/item/device/syndiejaunter)

//
//        HOLOBOMBS
//

/obj/item/device/holobomb
	name = "holobomb"
	desc = "A small explosive charge with a holoprojector designed to disable the curious guards."
	icon = 'mods/antagonists/icons/obj/holobomb.dmi'
	icon_state = "minibomb"
	item_state = "nothing"
	slot_flags = SLOT_EARS
	w_class = ITEM_SIZE_SMALL
	var/active = FALSE
	var/mode = 0

/obj/item/device/holobomb/afterattack(obj/item/target, mob/user , proximity)
	if(!proximity)
		return
	if(!target)
		return
	if(target.w_class <= w_class)
		name = target.name
		desc = target.desc
		icon = target.icon
		color = target.color
		icon_state = target.icon_state
		active = TRUE
		to_chat(user, "\The [src] is now active.")
		playsound(get_turf(src), 'sound/weapons/flash.ogg', 100, 1, -6)
		update_icon()
	else
		to_chat(user, "\The [target] is too big for \the [src] hologramm")

/obj/item/device/holobomb/attack_self(mob/user)
	trigger(user)

/obj/item/device/holobomb/emp_act()
	..()
	trigger()

/obj/item/device/holobomb/attack_hand(mob/user)
	. = ..()
	if(!mode)
		trigger(user)

/obj/item/device/holobomb/proc/switch_mode(mob/user)
	mode = !mode
	if(mode)
		to_chat(user, "Mode 1.Now \the [src] will explode upon activation.")
	else
		to_chat(user, "Mode 2. Now \the [src] will explode as soon as they pick it up or upon activation.")

/obj/item/device/holobomb/proc/trigger(mob/user)
	if(!active)
		switch_mode(user)
		return
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(!user)
		return
	var/obj/item/organ/external/O = H.get_organ(pick(BP_L_HAND, BP_R_HAND))
	if(!O)
		return

	var/dam = rand(35, 45)
	H.visible_message("<span class='danger'>\The [src] in \the [H]'s hand explodes with a loud bang!</span>")
	H.apply_damage(dam, DAMAGE_BRUTE, O, damage_flags = DAMAGE_FLAG_SHARP, used_weapon = "explode")
	explosion(src.loc, 0,0,1,1)
	H.Stun(5)
	qdel(src)

/obj/item/paper/holobomb
	name = "instruction"
	info = "Бомба имеет два режима. В первом она взрывается при попытке \"ипользовать\" её, во втором при прикосновении. Для начала работы с бомбой выберете режим и просканируйте нужный вам небольшой предмет. Всё, бомба взведена, удачи! И помните, после активации режим бомбы лучше не менять."

/obj/item/storage/box/syndie_kit/holobombs
	name = "box of holobombs"
	desc = "A box containing 5 experimental holobombs."
	icon_state = "flashbang"
	startswith = list(/obj/item/device/holobomb = 5, /obj/item/paper/holobomb = 1)

//
//        Poison
//

/obj/item/storage/box/syndie_kit/bioterror
	startswith = list(
		/obj/item/reagent_containers/glass/beaker/vial/random/toxin/bioterror = 7
	)

/obj/item/reagent_containers/glass/beaker/vial/random/toxin/bioterror
	random_reagent_list = list(
		list(/datum/reagent/drugs/mindbreaker = 10, /datum/reagent/drugs/hextro = 20) = 2,
		list(/datum/reagent/toxin/carpotoxin = 30)                                    = 2,
		list(/datum/reagent/impedrezene = 30)                                         = 2,
		list(/datum/reagent/mutagen = 30)                                             = 2,
		list(/datum/reagent/toxin/amatoxin = 30)                                      = 2,
		list(/datum/reagent/drugs/cryptobiolin = 30)                                  = 2,
		list(/datum/reagent/impedrezene = 30)                                         = 2,
		list(/datum/reagent/toxin/potassium_chlorophoride = 30)                       = 2,
		list(/datum/reagent/acid/polyacid = 30)                                       = 2,
		list(/datum/reagent/radium = 30)                                              = 2,
		list(/datum/reagent/toxin/zombiepowder = 30)                                  = 1)

// Key

/obj/item/device/encryptionkey/syndie_full
	icon_state = "cypherkey"
	channels = list("Mercenary" = 1, "Command" = 1, "Security" = 1, "Engineering" = 1, "Exploration" = 1, "Science" = 1, "Medical" = 1, "Supply" = 1, "Service" = 1)
	origin_tech = list(TECH_ESOTERIC = 3)
	syndie = 1

// Stimm

/obj/item/reagent_containers/hypospray/autoinjector/stimpack
	name = "stimpack"
	band_color = COLOR_PINK //inf //was: COLOR_DARK_GRAY
	starts_with = list(/datum/reagent/nitritozadole = 5)

/datum/reagent/nitritozadole
	name = "Nitritozadole"
	description = "Nitritozadole is a very dangerous mix, which can increase your speed temporarly."
	taste_description = "metal"
	reagent_state = LIQUID
	color = "#ff2681"
	metabolism = REM * 0.20
	overdose = REAGENTS_OVERDOSE / 3
	value = 4.5

/datum/reagent/nitritozadole/affect_blood(mob/living/carbon/M, alien, removed)
	if(alien == SPECIES_DIONA)
		return

	if(prob(2))
		to_chat(M, SPAN_DANGER("My heart gonna break out from the chest!"))
		M.stun_effect_act(0, 15, BP_CHEST, "heart damage") //a small pain without damage
		if(prob(15))
			for(var/obj/item/organ/internal/heart/H in M.internal_organs)
				H.damage += 1

	if(prob(5))
		M.emote(pick("twitch", "blink_r", "shiver"))
	M.add_chemical_effect(CE_SPEEDBOOST, 1.5)
	M.add_chemical_effect(CE_PULSE, 3)


// Radlaser

/obj/item/device/scanner/health/syndie
	name = "health analyzer"
	desc = "A hand-held body scanner able to distinguish vital signs of the subject."
	item_flags = ITEM_FLAG_NO_BLUDGEON
	matter = list(MATERIAL_ALUMINIUM = 200)
	origin_tech = list(TECH_MAGNET = 3, TECH_BIO = 2, TECH_ESOTERIC = 2)

/obj/item/device/scanner/health/syndie/scan(mob/living/carbon/human/A, mob/user)
	playsound(src, 'sound/effects/fastbeep.ogg', 20)
	if(!istype(A))
		return

	A.apply_damage(30, DAMAGE_RADIATION, damage_flags = DAMAGE_FLAG_DISPERSED)

/obj/item/device/scanner/health/syndie/examine(mob/user)
	. = ..()
	if (isobserver(user) || (user.mind && user.mind.special_role != null) || user.skill_check(SKILL_DEVICES, SKILL_MASTER) || user.skill_check(SKILL_MEDICAL, SKILL_MASTER))
		to_chat(user, "The scanner contacts do not look as they should. ")
		return
