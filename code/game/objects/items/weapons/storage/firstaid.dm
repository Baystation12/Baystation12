/* First aid storage
 * Contains:
 *		First Aid Kits
 * 		Pill Bottles
 */

/*
 * First Aid Kits
 */
/obj/item/storage/firstaid
	name = "first-aid kit"
	desc = "It's an emergency medical kit for those serious boo-boos."
	icon_state = "firstaid"
	throw_speed = 2
	throw_range = 8
	max_w_class = ITEM_SIZE_SMALL
	max_storage_space = DEFAULT_BOX_STORAGE
	use_sound = 'sound/effects/storage/box.ogg'
	allow_slow_dump = TRUE

/obj/item/storage/firstaid/empty
	icon_state = "firstaid"
	name = "First-Aid (empty)"

/obj/item/storage/firstaid/regular
	icon_state = "firstaid"

	startswith = list(
		/obj/item/stack/medical/bruise_pack = 2,
		/obj/item/stack/medical/ointment = 2,
		/obj/item/storage/pill_bottle/antidexafen,
		/obj/item/storage/pill_bottle/paracetamol,
		/obj/item/stack/medical/splint
		)

/obj/item/storage/firstaid/trauma
	name = "trauma first-aid kit"
	desc = "It's an emergency medical kit for when people brought ballistic weapons to a laser fight."
	icon_state = "radfirstaid"
	item_state = "firstaid-ointment"

	startswith = list(
		/obj/item/storage/med_pouch/trauma = 4
		)

/obj/item/storage/firstaid/trauma/New()
	..()
	icon_state = pick("radfirstaid", "radfirstaid2", "radfirstaid3")

/obj/item/storage/firstaid/fire
	name = "fire first-aid kit"
	desc = "It's an emergency medical kit for when the toxins lab <i>-spontaneously-</i> burns down."
	icon_state = "ointment"
	item_state = "firstaid-ointment"

	startswith = list(
		/obj/item/storage/med_pouch/burn = 4
		)

/obj/item/storage/firstaid/fire/New()
	..()
	icon_state = pick("ointment","firefirstaid")

/obj/item/storage/firstaid/toxin
	name = "toxin first aid"
	desc = "Used to treat when you have a high amount of toxins in your body."
	icon_state = "antitoxin"
	item_state = "firstaid-toxin"

	startswith = list(
		/obj/item/storage/med_pouch/toxin = 4
		)

/obj/item/storage/firstaid/toxin/New()
	..()
	icon_state = pick("antitoxin","antitoxfirstaid","antitoxfirstaid2","antitoxfirstaid3")

/obj/item/storage/firstaid/o2
	name = "oxygen deprivation first aid"
	desc = "A box full of oxygen goodies."
	icon_state = "o2"
	item_state = "firstaid-o2"

	startswith = list(
		/obj/item/storage/med_pouch/oxyloss = 4
		)

/obj/item/storage/firstaid/adv
	name = "advanced first-aid kit"
	desc = "Contains advanced medical treatments."
	icon_state = "purplefirstaid"
	item_state = "firstaid-advanced"

	startswith = list(
		/obj/item/storage/pill_bottle/assorted,
		/obj/item/stack/medical/advanced/bruise_pack = 3,
		/obj/item/stack/medical/advanced/ointment = 2,
		/obj/item/stack/medical/splint
		)

/obj/item/storage/firstaid/combat
	name = "combat medical kit"
	desc = "Contains advanced medical treatments."
	icon_state = "bezerk"
	item_state = "firstaid-advanced"

	startswith = list(
		/obj/item/storage/pill_bottle/bicaridine,
		/obj/item/storage/pill_bottle/dermaline,
		/obj/item/storage/pill_bottle/dexalin_plus,
		/obj/item/storage/pill_bottle/dylovene,
		/obj/item/storage/pill_bottle/tramadol,
		/obj/item/storage/pill_bottle/spaceacillin,
		/obj/item/stack/medical/splint,
		)

/obj/item/storage/firstaid/stab
	name = "stabilisation first aid"
	desc = "Stocked with medical pouches."
	icon_state = "stabfirstaid"
	item_state = "firstaid-advanced"

	startswith = list(
		/obj/item/storage/med_pouch/trauma,
		/obj/item/storage/med_pouch/burn,
		/obj/item/storage/med_pouch/oxyloss,
		/obj/item/storage/med_pouch/toxin,
		/obj/item/storage/med_pouch/radiation,
		)

/obj/item/storage/firstaid/surgery
	name = "surgery kit"
	desc = "Contains tools for surgery. Has precise foam fitting for safe transport and automatically sterilizes the content between uses."
	icon_state = "surgerykit"
	item_state = "firstaid-surgery"

	storage_slots = 14
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = null
	use_sound = 'sound/effects/storage/briefcase.ogg'

	can_hold = list(
		/obj/item/bonesetter,
		/obj/item/cautery,
		/obj/item/circular_saw,
		/obj/item/hemostat,
		/obj/item/retractor,
		/obj/item/scalpel,
		/obj/item/surgicaldrill,
		/obj/item/bonegel,
		/obj/item/FixOVein,
		/obj/item/stack/medical/advanced/bruise_pack,
		/obj/item/stack/nanopaste
		)

	startswith = list(
		/obj/item/bonesetter,
		/obj/item/cautery,
		/obj/item/circular_saw,
		/obj/item/hemostat,
		/obj/item/retractor,
		/obj/item/scalpel,
		/obj/item/surgicaldrill,
		/obj/item/bonegel,
		/obj/item/FixOVein,
		/obj/item/stack/medical/advanced/bruise_pack,
		)

/*
 * Pill Bottles
 */
/obj/item/storage/pill_bottle
	name = "pill bottle"
	desc = "It's an airtight container for storing medication."
	icon_state = "pill_canister"
	icon = 'icons/obj/chemical.dmi'
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

/obj/item/storage/pill_bottle/afterattack(mob/living/target, mob/living/user, proximity_flag)
	if(!proximity_flag || !istype(target) || target != user)
		return 1
	if(!contents.len)
		to_chat(user, "<span class='warning'>It's empty!</span>")
		return 1
	var/zone = user.zone_sel.selecting
	if(zone == BP_MOUTH && target.can_eat())
		user.visible_message("<span class='notice'>[user] pops a pill from \the [src].</span>")
		playsound(get_turf(src), 'sound/effects/peelz.ogg', 50)
		var/list/peelz = filter_list(contents,/obj/item/reagent_containers/pill)
		if(peelz.len)
			var/obj/item/reagent_containers/pill/P = pick(peelz)
			remove_from_storage(P)
			P.attack(target,user)
			return 1

/obj/item/storage/pill_bottle/afterattack(obj/target, mob/living/user, proximity)
	if(!proximity)
		return
	if(target.is_open_container() && target.reagents)
		if(!target.reagents.total_volume)
			to_chat(user, SPAN_NOTICE("[target] is empty. Can't dissolve a pill."))
			return

		var/list/peelz = filter_list(contents,/obj/item/reagent_containers/pill)
		if(peelz.len)
			var/obj/item/reagent_containers/pill/P = pick(peelz)
			remove_from_storage(P)
			P.afterattack(target, user, proximity)
	return


/obj/item/storage/pill_bottle/attack_self(mob/living/user)
	if(user.get_inactive_hand())
		to_chat(user, "<span class='notice'>You need an empty hand to take something out.</span>")
		return
	if(contents.len)
		var/obj/item/I = contents[1]
		if(!remove_from_storage(I,user))
			return
		if(user.put_in_inactive_hand(I))
			to_chat(user, "<span class='notice'>You take \the [I] out of \the [src].</span>")
			if(iscarbon(user))
				var/mob/living/carbon/C = user
				C.swap_hand()
		else
			I.dropInto(loc)
			to_chat(user, "<span class='notice'>You fumble around with \the [src] and drop \the [I] on the floor.</span>")
	else
		to_chat(user, "<span class='warning'>\The [src] is empty.</span>")


/obj/item/storage/pill_bottle/Initialize()
	. = ..()
	update_icon()

/obj/item/storage/pill_bottle/on_update_icon()
	overlays.Cut()
	if(wrapper_color)
		var/image/I = image(icon, "pillbottle_wrap")
		I.color = wrapper_color
		overlays += I

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

//Baycode specific Psychiatry pills.
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

/obj/item/storage/firstaid/light
	name = "light first-aid kit"
	desc = "It's a small emergency medical kit."
	icon_state = "light_firstaid"
	storage_slots = 5
	w_class = ITEM_SIZE_SMALL
	max_w_class = ITEM_SIZE_SMALL
	startswith = list(
	/obj/item/clothing/gloves/latex/nitrile,
	/obj/item/reagent_containers/hypospray/autoinjector,
	/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/deletrathol,
	/obj/item/reagent_containers/hypospray/autoinjector/pouch_auto/dexalin,
	/obj/item/stack/medical/bruise_pack
		)
	can_hold = list(
		/obj/item/clothing/gloves/latex,
		/obj/item/reagent_containers/hypospray/autoinjector,
		/obj/item/stack/medical/bruise_pack
		)
