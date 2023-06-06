/obj/item/reagent_containers/ivbag
	name = "\improper IV bag"
	desc = "Flexible bag for IV injectors."
	icon = 'icons/obj/bloodpack.dmi'
	icon_state = "empty"
	w_class = ITEM_SIZE_TINY
	volume = 120
	matter = list(MATERIAL_PLASTIC = 4000)
	atom_flags = ATOM_FLAG_OPEN_CONTAINER

	/// The set of options for the amount of reagents the bag will try to transfer per process.
	var/static/list/allowed_transfer_amounts = list(2, 1, 0)

	/// The configured amount of reagents the IV bag will try to transfer per process.
	var/transfer_amount = 2

	/// If this bag is attached to a person, that person.
	var/mob/living/carbon/human/patient

	/// The minimum time between bag squeezes.
	var/const/SQUEEZE_DELAY = 3 SECONDS

	/// When squeezing the bag on non-harm intents, the multiplier to apply to transfer amount.
	var/const/SQUEEZE_MULTIPLIER_FRIEND = 2

	/// When squeezing the bag on harm intent, the multiplier to apply to transfer amount.
	var/const/SQUEEZE_MULTIPLIER_FOE = 3

	/// The next world.time this bag can be squeezed.
	var/next_squeeze = 0


/obj/item/reagent_containers/ivbag/Destroy()
	patient = null
	return ..()


/obj/item/reagent_containers/ivbag/Initialize()
	. = ..()
	verbs -= /obj/item/reagent_containers/verb/set_amount_per_transfer_from_this


/obj/item/reagent_containers/ivbag/examine(mob/user, distance)
	. = ..()
	if (distance > 2 && isliving(user))
		return
	var/message
	switch (Percent(reagents.total_volume, volume, 0))
		if (0)
			message = "empty"
		if (1 to 15)
			message = "nearly empty"
		if (16 to 35)
			message = "a third full"
		if (35 to 65)
			message = "half full"
		if (66 to 85)
			message = "two thirds full"
		else
			message = "full"
	to_chat(user, "It has a flow rate of [transfer_amount]u of fluid per cycle and looks [message].")


/obj/item/reagent_containers/ivbag/on_reagent_change()
	UpdateItemSize()
	update_icon()


/obj/item/reagent_containers/ivbag/on_update_icon()
	overlays.Cut()
	if (reagents.total_volume)
		var/state = clamp(Roundm(Percent(reagents.total_volume, volume, 0), 25), 0, 100)
		var/image/filling = image(icon, icon_state = "[state]")
		filling.color = reagents.get_color()
		overlays += filling
	if (patient)
		overlays += image(icon, icon_state = "dongle")


/obj/item/reagent_containers/ivbag/MouseDrop(atom/over_atom)
	if (!usr)
		return
	if (!over_atom)
		return
	if (!Adjacent(usr) || !over_atom.Adjacent(usr))
		return
	if (isliving(over_atom))
		MouseDrop_T(over_atom, usr)
	else
		over_atom.MouseDrop_T(src, usr)


/obj/item/reagent_containers/ivbag/MouseDrop_T(atom/dropped, mob/living/user)
	. = ..()
	if (.)
		return
	if (!ishuman(user) && !isrobot(user))
		return
	if (patient == dropped)
		RemoveDrip(user)
	else if (ishuman(dropped))
		AttachDrip(dropped, user)
	update_icon()


/obj/item/reagent_containers/ivbag/attack_self(mob/living/user)
	if (!patient)
		return ..()
	if (!reagents.total_volume)
		to_chat(user, SPAN_WARNING("You can't squeeze \the [src] - it's empty."))
		return
	var/diff = next_squeeze - world.time
	if (diff > 0)
		to_chat(user, SPAN_WARNING("Wait another [Roundm(diff * 0.1, 0.1)] seconds before squeezing again."))
		return
	next_squeeze = world.time + SQUEEZE_DELAY
	if (user.a_intent == I_HURT)
		reagents.trans_to_mob(patient, transfer_amount * SQUEEZE_MULTIPLIER_FOE, CHEM_BLOOD)
		patient.custom_pain("Your veins ache terribly!", 60)
	else
		reagents.trans_to_mob(patient, transfer_amount * SQUEEZE_MULTIPLIER_FRIEND, CHEM_BLOOD)
		patient.custom_pain("That's not comfortable...", 10)
	user.visible_message(
		SPAN_WARNING("\The [user] squeezes \the [src]!"),
		SPAN_ITALIC("You squeeze \the [src]."),
		range = 3
	)


/obj/item/reagent_containers/ivbag/Process()
	if (!patient)
		return PROCESS_KILL
	if (!patient.Adjacent(loc))
		RipDrip()
		return
	var/mob/living/user = loc
	if (!istype(user))
		RipDrip()
		return
	if (transfer_amount == 0)
		return
	if (SSobj.times_fired & 1)
		return
	if (!reagents.total_volume)
		return
	if (!user.IsHolding(src))
		return
	reagents.trans_to_mob(patient, transfer_amount, CHEM_BLOOD)


/obj/item/reagent_containers/ivbag/proc/AttachDrip(mob/living/carbon/human/target, mob/living/user)
	user.visible_message(
		SPAN_ITALIC("\The [user] starts to hook up \the [target] to \the [src]."),
		SPAN_ITALIC("You start to hook up \the [target] to \the [src]."),
		range = 5
	)
	if (!user.do_skilled(5 SECONDS, SKILL_MEDICAL, target)) //slower than stands and beds
		return
	if (prob(user.skill_fail_chance(SKILL_MEDICAL, 80, SKILL_TRAINED))) // harder than stands and beds
		user.visible_message(
			SPAN_DANGER("\The [user] fishes for a vein on \the [target] and fails, stabbing them instead!"),
			SPAN_DANGER("You fish inexpertly for a vein on \the [target] and stab them instead!"),
			range = 5
		)
		target.apply_damage(rand(2, 6), DAMAGE_BRUTE, pick(BP_R_ARM, BP_L_ARM), damage_flags = DAMAGE_FLAG_SHARP, armor_pen = 100)
		return
	user.visible_message(
		SPAN_ITALIC("\The [user] successfully inserts \a [src]'s cannula into \the [target]."),
		SPAN_NOTICE("You successfully insert \the [src]'s cannula into \the [target]."),
		range = 1
	)
	patient = target
	START_PROCESSING(SSobj, src)


/obj/item/reagent_containers/ivbag/proc/RemoveDrip(mob/living/user)
	if (!patient)
		to_chat(user, SPAN_WARNING("\The [src] is not attached to anything."))
		return
	if (!CanPhysicallyInteractWith(user, src))
		to_chat(user, SPAN_WARNING("You're in no condition to do that!"))
		return
	user.visible_message(
		SPAN_ITALIC("\The [user] starts unhooking \the [patient] from \a [src]."),
		SPAN_ITALIC("You extract \the [src]'s cannula from \the [patient]."),
		range = 5
	)
	if (!user.skill_check(SKILL_MEDICAL, SKILL_BASIC))
		RipDrip(user)
		return
	STOP_PROCESSING(SSobj, src)
	user.visible_message(
		SPAN_WARNING("\The [user] extracts \the [src]'s cannula from \the [patient]."),
		SPAN_NOTICE("You extract \the [src]'s cannula from \the [patient]."),
		range = 1
	)
	patient = null
	update_icon()


/obj/item/reagent_containers/ivbag/proc/RipDrip(mob/living/user)
	if (!patient)
		return
	STOP_PROCESSING(SSobj, src)
	patient.visible_message(
		SPAN_WARNING("\The cannula from \a [src] is ripped out of \the [patient][user ? " by \the [user]" : ""]!"),
		SPAN_DANGER("\The cannula from \the [src] is ripped out of you[user ? " by \the [user]": ""]!"),
		range = 5
	)
	patient.custom_pain(power = 20)
	patient.apply_damage(rand(1, 3), DAMAGE_BRUTE, pick(BP_R_ARM, BP_L_ARM), damage_flags = DAMAGE_FLAG_SHARP, armor_pen = 100)
	patient = null
	update_icon()


/obj/item/reagent_containers/ivbag/proc/UpdateItemSize()
	if (reagents.total_volume > volume * 0.5)
		w_class = ITEM_SIZE_SMALL
	else
		w_class = ITEM_SIZE_TINY


/obj/item/reagent_containers/ivbag/proc/UpdateTransferAmount(mob/living/user, atom/origin)
	if (!origin.Adjacent(user) || user.incapacitated())
		to_chat(user, SPAN_WARNING("You're in no condition to do that."))
		return
	var/title = "[origin]"
	if (origin != src)
		title = "[title] - [src]"
	var/response = input(user, "Set Drip Rate:", title) as null | anything in allowed_transfer_amounts
	if (isnull(response) || !(response in allowed_transfer_amounts))
		return
	if (!origin.Adjacent(user) || user.incapacitated())
		to_chat(user, SPAN_WARNING("You're in no condition to do that."))
		return
	user.visible_message(
		SPAN_ITALIC("\The [user] adjusts the flow rate on \a [origin]'s IV bag."),
		SPAN_ITALIC("You adjust the flow rate on \the [origin]'s IV bag to [response]u."),
		range = 1
	)
	transfer_amount = response


/obj/item/reagent_containers/ivbag/verb/TransferAmountVerb()
	set name = "Set IV Bag Rate"
	set category = "Object"
	set src in usr
	var/mob/living/user = usr
	if (!istype(user))
		return
	UpdateTransferAmount(user, src)


/obj/item/reagent_containers/ivbag/nanoblood
	transfer_amount = 1


/obj/item/reagent_containers/ivbag/nanoblood/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nanoblood, volume)
	AddLabel("Nanoblood")
	UpdateItemSize()


/obj/item/reagent_containers/ivbag/blood
	abstract_type = /obj/item/reagent_containers/ivbag/blood


/obj/item/reagent_containers/ivbag/blood/Initialize(mapload, blood_type, blood_species)
	. = ..()
	if (!(blood_type in GLOB.blood_types))
		crash_with({"Invalid blood_type supplied to [src]- "[blood_type]""})
		return INITIALIZE_HINT_QDEL
	var/datum/species/species = all_species[blood_species]
	if (!species)
		crash_with({"Invalid blood_species supplied to [src]- "[blood_species]""})
		return INITIALIZE_HINT_QDEL
	reagents.add_reagent(/datum/reagent/blood, volume, list(
		"donor" = null,
		"blood_DNA" = null,
		"blood_type" = blood_type,
		"trace_chem" = null,
		"blood_species" = blood_species,
		"blood_colour" = species.blood_color
	))
	AddLabel("[blood_species] [blood_type]")
	UpdateItemSize()


/obj/item/reagent_containers/ivbag/blood/human
	abstract_type = /obj/item/reagent_containers/ivbag/blood/human


/obj/item/reagent_containers/ivbag/blood/human/Initialize(mapload, blood_type)
	return ..(mapload, blood_type, SPECIES_HUMAN)


/obj/item/reagent_containers/ivbag/blood/human/apos/Initialize(mapload)
	return ..(mapload, "A+")


/obj/item/reagent_containers/ivbag/blood/human/aneg/Initialize(mapload)
	return ..(mapload, "A-")


/obj/item/reagent_containers/ivbag/blood/human/bpos/Initialize(mapload)
	return ..(mapload, "B+")


/obj/item/reagent_containers/ivbag/blood/human/bneg/Initialize(mapload)
	return ..(mapload, "B-")


/obj/item/reagent_containers/ivbag/blood/human/abpos/Initialize(mapload)
	return ..(mapload, "AB+")


/obj/item/reagent_containers/ivbag/blood/human/abneg/Initialize(mapload)
	return ..(mapload, "AB-")


/obj/item/reagent_containers/ivbag/blood/human/opos/Initialize(mapload)
	return ..(mapload, "O+")


/obj/item/reagent_containers/ivbag/blood/human/oneg/Initialize(mapload)
	return ..(mapload, "O-")


/obj/item/reagent_containers/ivbag/blood/serpentid
	abstract_type = /obj/item/reagent_containers/ivbag/blood/serpentid


/obj/item/reagent_containers/ivbag/blood/serpentid/Initialize(mapload, blood_type)
	return ..(mapload, blood_type, SPECIES_NABBER)


/obj/item/reagent_containers/ivbag/blood/serpentid/oneg/Initialize(mapload)
	return ..(mapload, "O-")


/obj/item/reagent_containers/ivbag/blood/skrell
	abstract_type = /obj/item/reagent_containers/ivbag/blood/skrell


/obj/item/reagent_containers/ivbag/blood/skrell/Initialize(mapload, blood_type)
	return ..(mapload, blood_type, SPECIES_SKRELL)


/obj/item/reagent_containers/ivbag/blood/skrell/oneg/Initialize(mapload)
	return ..(mapload, "O-")


/obj/item/reagent_containers/ivbag/blood/unathi
	abstract_type = /obj/item/reagent_containers/ivbag/blood/unathi


/obj/item/reagent_containers/ivbag/blood/unathi/Initialize(mapload, blood_type)
	return ..(mapload, blood_type, SPECIES_UNATHI)


/obj/item/reagent_containers/ivbag/blood/unathi/oneg/Initialize(mapload)
	return ..(mapload, "O-")


/obj/item/reagent_containers/ivbag/blood/vox
	abstract_type = /obj/item/reagent_containers/ivbag/blood/vox


/obj/item/reagent_containers/ivbag/blood/vox/Initialize(mapload, blood_type)
	return ..(mapload, blood_type, SPECIES_VOX)


/obj/item/reagent_containers/ivbag/blood/vox/oneg/Initialize(mapload)
	return ..(mapload, "O-")


/obj/item/reagent_containers/ivbag/glucose/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/glucose, volume)
	AddLabel("Glucose")
	UpdateItemSize()


/obj/item/storage/box/bloodpacks
	name = "blood packs box"
	desc = "This box contains empty blood packs."
	icon_state = "sterile"
	startswith = list(
		/obj/item/reagent_containers/ivbag = 7
	)


/obj/item/storage/box/glucose
	name = "glucose box"
	desc = "This box contains glucose IV bags."
	icon_state = "sterile"
	startswith = list(
		/obj/item/reagent_containers/ivbag/glucose = 7
	)


/obj/item/storage/box/freezer/blood
	abstract_type = /obj/item/storage/box/freezer/blood


/obj/item/storage/box/freezer/blood/human
	name = "portable freezer (human blood)"
	startswith = list(
		/obj/item/reagent_containers/ivbag/blood/human/oneg = 4
	)


/obj/item/storage/box/freezer/blood/serpentid
	name = "portable freezer (serpentid blood)"
	startswith = list(
		/obj/item/reagent_containers/ivbag/blood/serpentid/oneg = 4
	)


/obj/item/storage/box/freezer/blood/skrell
	name = "portable freezer (skrellian blood)"
	startswith = list(
		/obj/item/reagent_containers/ivbag/blood/skrell/oneg = 4
	)


/obj/item/storage/box/freezer/blood/unathi
	name = "portable freezer (unathi blood)"
	startswith = list(
		/obj/item/reagent_containers/ivbag/blood/unathi/oneg = 4
	)


/obj/item/storage/box/freezer/blood/vox
	name = "portable freezer (vox blood)"
	startswith = list(
		/obj/item/reagent_containers/ivbag/blood/vox/oneg = 4
	)
