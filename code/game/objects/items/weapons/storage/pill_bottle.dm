/obj/item/storage/pill_bottle
	name = "pill bottle"
	desc = "It's an airtight container for storing medication."
	icon_state = "pill_canister"
	icon = 'icons/obj/chemical_storage.dmi'
	item_state = "contsolid"
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_TINY
	max_storage_space = 21
	can_hold = list(/obj/item/reagent_containers/pill,/obj/item/dice,/obj/item/paper)
	allow_quick_gather = 1
	use_to_pickup = 1
	use_sound = 'sound/effects/storage/pillbottle.ogg'
	matter = list(MATERIAL_PLASTIC = 250)
	var/wrapper_color
	var/label


/obj/item/storage/pill_bottle/use_after(atom/target, mob/living/user)
	if (!length(contents))
		to_chat(user, SPAN_WARNING("It's empty!"))
		return TRUE

	if (istype(user) && target == user && user.can_eat())
		user.visible_message(SPAN_NOTICE("[user] pops a pill from \the [src]."))
		playsound(get_turf(src), 'sound/effects/peelz.ogg', 50)
		var/list/peelz = filter_list(contents,/obj/item/reagent_containers/pill)
		if (length(peelz))
			var/obj/item/reagent_containers/pill/P = pick(peelz)
			remove_from_storage(P)
			P.resolve_attackby(target ,user)
			return TRUE

	if (isobj(target) && target.is_open_container() && target.reagents)
		if (!target.reagents.total_volume)
			to_chat(user, SPAN_NOTICE("[target] is empty. Can't dissolve a pill."))
			return TRUE

		var/list/peelz = filter_list(contents,/obj/item/reagent_containers/pill)
		if (length(peelz))
			var/obj/item/reagent_containers/pill/P = pick(peelz)
			remove_from_storage(P)
			P.use_after(target, user)
			return TRUE


/obj/item/storage/pill_bottle/attack_self(mob/living/user)
	if(user.get_inactive_hand())
		to_chat(user, SPAN_NOTICE("You need an empty hand to take something out."))
		return
	if(length(contents))
		var/obj/item/I = contents[1]
		if(!remove_from_storage(I,user))
			return
		if(user.put_in_inactive_hand(I))
			to_chat(user, SPAN_NOTICE("You take \the [I] out of \the [src]."))
			if(iscarbon(user))
				var/mob/living/carbon/C = user
				C.swap_hand()
		else
			I.dropInto(loc)
			to_chat(user, SPAN_NOTICE("You fumble around with \the [src] and drop \the [I] on the floor."))
	else
		to_chat(user, SPAN_WARNING("\The [src] is empty."))


/obj/item/storage/pill_bottle/Initialize()
	. = ..()
	update_icon()


/obj/item/storage/pill_bottle/on_update_icon()
	ClearOverlays()
	if(wrapper_color)
		var/image/I = image(icon, "pillbottle_wrap")
		I.color = wrapper_color
		AddOverlays(I)


/obj/item/storage/pill_bottle/antitox
	name = "pill bottle (Dylovene)"
	desc = "Contains pills used to counter toxins."
	startswith = list(/obj/item/reagent_containers/pill/antitox = 21)
	wrapper_color = COLOR_GREEN


/obj/item/storage/pill_bottle/bicaridine
	name = "pill bottle (Bicaridine)"
	desc = "Contains pills used to stabilize the severely injured."
	startswith = list(/obj/item/reagent_containers/pill/bicaridine = 21)
	wrapper_color = COLOR_MAROON


/obj/item/storage/pill_bottle/dexalin_plus
	name = "pill bottle (Dexalin Plus)"
	desc = "Contains pills used to treat extreme cases of oxygen deprivation."
	startswith = list(/obj/item/reagent_containers/pill/dexalin_plus = 14)
	wrapper_color = COLOR_CYAN_BLUE


/obj/item/storage/pill_bottle/dexalin
	name = "pill bottle (Dexalin)"
	desc = "Contains pills used to treat oxygen deprivation."
	startswith = list(/obj/item/reagent_containers/pill/dexalin = 21)
	wrapper_color = COLOR_LIGHT_CYAN


/obj/item/storage/pill_bottle/dermaline
	name = "pill bottle (Dermaline)"
	desc = "Contains pills used to treat burn wounds."
	startswith = list(/obj/item/reagent_containers/pill/dermaline = 14)
	wrapper_color = COLOR_ORANGE


/obj/item/storage/pill_bottle/dylovene
	name = "pill bottle (Dylovene)"
	desc = "Contains pills used to treat toxic substances in the blood."
	startswith = list(/obj/item/reagent_containers/pill/dylovene = 21)
	wrapper_color = COLOR_GREEN


/obj/item/storage/pill_bottle/inaprovaline
	name = "pill bottle (Inaprovaline)"
	desc = "Contains pills used to stabilize patients."
	startswith = list(/obj/item/reagent_containers/pill/inaprovaline = 21)
	wrapper_color = COLOR_PALE_BLUE_GRAY


/obj/item/storage/pill_bottle/kelotane
	name = "pill bottle (Kelotane)"
	desc = "Contains pills used to treat burns."
	startswith = list(/obj/item/reagent_containers/pill/kelotane = 21)
	wrapper_color = COLOR_YELLOW


/obj/item/storage/pill_bottle/spaceacillin
	name = "pill bottle (Spaceacillin)"
	desc = "A theta-lactam antibiotic. Effective against many diseases likely to be encountered in space."
	startswith = list(/obj/item/reagent_containers/pill/spaceacillin = 14)
	wrapper_color = COLOR_PALE_GREEN_GRAY


/obj/item/storage/pill_bottle/tramadol
	name = "pill bottle (Tramadol)"
	desc = "Contains pills used to relieve pain."
	startswith = list(/obj/item/reagent_containers/pill/tramadol = 14)
	wrapper_color = COLOR_PURPLE_GRAY


/obj/item/storage/pill_bottle/citalopram
	name = "pill bottle (Citalopram)"
	desc = "Mild antidepressant. For use in individuals suffering from depression or anxiety. 15u dose per pill."
	startswith = list(/obj/item/reagent_containers/pill/citalopram = 21)
	wrapper_color = COLOR_GRAY


/obj/item/storage/pill_bottle/methylphenidate
	name = "pill bottle (Methylphenidate)"
	desc = "Mental stimulant. For use in individuals suffering from ADHD, or general concentration issues. 15u dose per pill."
	startswith = list(/obj/item/reagent_containers/pill/methylphenidate = 21)
	wrapper_color = COLOR_GRAY


/obj/item/storage/pill_bottle/paroxetine
	name = "pill bottle (Paroxetine)"
	desc = "High-strength antidepressant. Only for use in severe depression. 10u dose per pill. <span class='warning'>WARNING: side-effects may include hallucinations.</span>"
	startswith = list(/obj/item/reagent_containers/pill/paroxetine = 14)
	wrapper_color = COLOR_GRAY


/obj/item/storage/pill_bottle/antidexafen
	name = "pill bottle (cold medicine)"
	desc = "All-in-one cold medicine. 15u dose per pill. Safe for babies like you!"
	startswith = list(/obj/item/reagent_containers/pill/antidexafen = 21)
	wrapper_color = COLOR_VIOLET


/obj/item/storage/pill_bottle/paracetamol
	name = "pill bottle (Paracetamol)"
	desc = "Mild painkiller, also known as Tylenol. Won't fix the cause of your headache (unlike cyanide), but might make it bearable."
	startswith = list(/obj/item/reagent_containers/pill/paracetamol = 21)
	wrapper_color = "#a2819e"


/obj/item/storage/pill_bottle/assorted
	name = "pill bottle (assorted)"
	desc = "Commonly found on paramedics, these assorted pill bottles contain all the basics."
	startswith = list(
		/obj/item/reagent_containers/pill/inaprovaline = 6,
		/obj/item/reagent_containers/pill/dylovene = 6,
		/obj/item/reagent_containers/pill/sugariron = 2,
		/obj/item/reagent_containers/pill/tramadol = 2,
		/obj/item/reagent_containers/pill/dexalin = 2,
		/obj/item/reagent_containers/pill/kelotane = 2,
		/obj/item/reagent_containers/pill/hyronalin
	)
