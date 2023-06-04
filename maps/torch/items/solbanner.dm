/obj/structure/solbanner
	name = "\improper SCG banner"
	icon = 'maps/torch/icons/obj/solbanner.dmi'
	icon_state = "wood"
	desc = "A wooden pole bearing a banner of Sol Central Government. Ave."
	anchored = TRUE
	obj_flags = OBJ_FLAG_ANCHORABLE
	layer = ABOVE_HUMAN_LAYER

/obj/structure/solbanner/exo
	name = "exoplanet SCG banner"
	desc = "A rugged metal frame with a banner of Sol Central Government on it. Resistant to radiation bleaching."
	icon_state = "steel"
	obj_flags = 0
	var/plantedby

/obj/structure/solbanner/exo/Initialize()
	. = ..()
	flick("deploy",src)

/obj/structure/solbanner/exo/examine(mob/user)
	. = ..()
	if(plantedby)
		to_chat(user, SPAN_NOTICE("[plantedby]"))

/obj/item/solbanner
	name = "\improper SCG banner capsule"
	desc = "SCG banner packed in a rapid deployment capsule. Used for staking claims on new worlds in the name of Sol Central Government."
	icon = 'maps/torch/icons/obj/uniques.dmi'
	icon_state = "banner_stowed"
	w_class = ITEM_SIZE_HUGE

/obj/item/solbanner/attack_self(mob/living/carbon/human/user)
	..()
	if(!istype(user))
		return
	if(!allowed(user))
		to_chat(user, SPAN_WARNING("\The [src] does not recognize your authority!"))
		return
	var/turf/T = get_turf(src)
	if(!istype(T) && !istype(T,/turf/space))
		to_chat(user, SPAN_WARNING("\The [src] is unable to deploy here!"))
		return
	if(user.unEquip(src))
		forceMove(T)
		if(GLOB.using_map.use_overmap)
			var/obj/effect/overmap/visitable/sector/exoplanet/P = map_sectors["[z]"]
			if(istype(P))
				GLOB.stat_flags_planted += 1
		qdel(src)
		var/obj/structure/solbanner/exo/E = new(T)

		E.plantedby = "Planted on [stationdate2text()] by Solar Forces."
		T.visible_message(SPAN_NOTICE("[user] successfully claims this world with \the [E]!"))

/obj/structure/indiebanner/exo
	name = "exoplanet ICCG banner"
	desc = "A rugged metal frame with a banner of the Independent Colonial Confederation of Gilgamesh on it. Resistant to radiation bleaching."
	icon_state = "steel_iccgn"
	obj_flags = 0
	var/plantedby

/obj/structure/indiebanner/exo/Initialize()
	. = ..()
	flick("deploy_iccgn",src)

/obj/structure/indiebanner/exo/examine(mob/user)
	. = ..()
	if(plantedby)
		to_chat(user, SPAN_NOTICE("[plantedby]"))

/obj/item/indiebanner
	name = "\improper ICCG banner capsule"
	desc = "ICCG banner packed in a rapid deployment capsule. Used for staking claims on new worlds in the name of Independent Colonial Confederation of Gilgamesh."
	icon = 'maps/torch/icons/obj/uniques.dmi'
	icon_state = "banner_stowed"
	w_class = ITEM_SIZE_HUGE

/obj/item/indiebanner/attack_self(mob/living/carbon/human/user)
	..()
	if(!istype(user))
		return
	if(!allowed(user))
		to_chat(user, SPAN_WARNING("\The [src] does not recognize your authority!"))
		return
	var/turf/T = get_turf(src)
	if(!istype(T) && !istype(T,/turf/space))
		to_chat(user, SPAN_WARNING("\The [src] is unable to deploy here!"))
		return
	if(user.unEquip(src))
		forceMove(T)
		if(GLOB.using_map.use_overmap)
			var/obj/effect/overmap/visitable/sector/exoplanet/P = map_sectors["[z]"]
			if(istype(P))
				GLOB.stat_flags_planted += 1
		qdel(src)
		var/obj/structure/indiebanner/exo/E = new(T)
		E.plantedby = "Planted on [stationdate2text()] by Confederate Forces."
		T.visible_message(SPAN_NOTICE("[user] successfully claims this world with \the [E]!"))
