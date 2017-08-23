/obj/item/weapon/ore
	name = "small rock"
	icon = 'icons/obj/mining.dmi'
	icon_state = "ore2"
	randpixel = 8
	w_class = ITEM_SIZE_SMALL
	var/datum/geosample/geologic_data
	var/ore/ore = null // set to a type to find the right instance on init

/obj/item/weapon/ore/Initialize()
	. = ..()
	if(ispath(ore))
		ensure_ore_data_initialised()
		ore = ores_by_type[ore]
		if(ore.ore != type)
			log_error("[src] ([src.type]) had ore type [ore.type] but that type does not have [src.type] set as its ore item!")
		update_ore()

/obj/item/weapon/ore/proc/update_ore()
	name = ore.display_name
	icon_state = "ore_[ore.icon_tag]"
	origin_tech = ore.origin_tech.Copy()

/obj/item/weapon/ore/slag
	name = "Slag"
	desc = "Someone screwed up..."
	icon_state = "slag"

/obj/item/weapon/ore/uranium
	ore = /ore/uranium

/obj/item/weapon/ore/iron
	ore = /ore/hematite

/obj/item/weapon/ore/coal
	ore = /ore/coal

/obj/item/weapon/ore/glass
	ore = /ore/glass
	slot_flags = SLOT_HOLSTER

// POCKET SAND!
/obj/item/weapon/ore/glass/throw_impact(atom/hit_atom)
	..()
	var/mob/living/carbon/human/H = hit_atom
	if(istype(H) && H.has_eyes() && prob(85))
		to_chat(H, "<span class='danger'>Some of \the [src] gets in your eyes!</span>")
		H.eye_blind += 5
		H.eye_blurry += 10
		spawn(1)
			if(istype(loc, /turf/)) qdel(src)


/obj/item/weapon/ore/phoron
	ore = /ore/phoron

/obj/item/weapon/ore/silver
	ore = /ore/silver

/obj/item/weapon/ore/gold
	ore = /ore/gold

/obj/item/weapon/ore/diamond
	ore = /ore/diamond

/obj/item/weapon/ore/osmium
	ore = /ore/platinum

/obj/item/weapon/ore/hydrogen
	ore = /ore/hydrogen

/obj/item/weapon/ore/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/device/core_sampler))
		var/obj/item/device/core_sampler/C = W
		C.sample_item(src, user)
	else
		return ..()
