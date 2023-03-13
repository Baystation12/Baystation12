/obj/item/wheelchair_kit
	name = "compressed wheelchair kit"
	desc = "Collapsed parts, prepared to immediately spring into the shape of a wheelchair."
	icon = 'packs/infinity/icons/obj/items.dmi'
	icon_state = "wheelchair-item"
	item_state = "rbed"
	w_class = ITEM_SIZE_LARGE

/obj/item/wheelchair_kit/attack_self(mob/user)
	visible_message("<b>[user]</b> starts lay out \the [src.name].")
	if(do_after(user, 4 SECONDS, src))
		var/obj/structure/bed/chair/wheelchair/W = new /obj/structure/bed/chair/wheelchair(get_turf(user))
		visible_message(SPAN_NOTICE("<b>[user]</b> lay out \the [W.name]."))
		W.add_fingerprint(user)
		qdel(src)
