/obj/item/reagent_containers/food/drinks/Initialize()
	. = ..()
	if(is_open_container())
		verbs += /obj/item/reagent_containers/food/drinks/proc/gulp_whole

/obj/item/reagent_containers/food/drinks/proc/gulp_whole()
	set category = "Object"
	set name = "Gulp Down"
	set src in view(1)

	if(!istype(usr.get_active_hand(), src))
		to_chat(usr, SPAN_WARNING("You need to hold \the [src] in hands!"))
		return

	if(is_open_container())
		if(!reagents || reagents.total_volume == 0)
			to_chat(usr, "<span class='notice'>\The [src] is empty!</span>")
		else
			if(ishuman(usr))
				var/mob/living/carbon/human/H = usr
				if(!H.check_has_mouth())
					to_chat(H, "Where do you intend to put \the [src]? You don't have a mouth!")
					return
				var/obj/item/blocked = H.check_mouth_coverage()
				if(blocked)
					to_chat(H, SPAN_WARNING("\The [blocked] is in the way!"))
					return
			if(reagents.total_volume > 30) // 30 equates to 3 SECONDS.
				usr.visible_message(SPAN_NOTICE("[usr] prepares to gulp down [src]."), SPAN_NOTICE("You prepare to gulp down [src]."))
			playsound(usr, 'packs/infinity/sound/items/drinking.ogg', reagents.total_volume, 1)
			if(!do_after(usr, reagents.total_volume))
				if(!Adjacent(usr))
					return
				standard_splash_mob(src, src)
				return
			if(!Adjacent(usr))
				return
			usr.visible_message(SPAN_NOTICE("[usr] gulped down the whole [src]!"),SPAN_NOTICE("You gulped down the whole [src]!"))
			playsound(usr, 'packs/infinity/sound/items/drinking_after.ogg', reagents.total_volume, 1)
			reagents.trans_to_mob(usr, reagents.total_volume, CHEM_INGEST)
	else
		to_chat(usr, SPAN_NOTICE("You need to open \the [src] first!"))
