/obj/item/clothing/accessory/buddy_tag
	name = "buddy tag"
	desc = "A tiny device, paired up with a counterpart set to same code. When devices are taken apart too far, they start beeping."
	icon_state = "buddytag0"
	slot_flags = SLOT_TIE
	accessory_flags = ACCESSORY_REMOVABLE | ACCESSORY_HIGH_VISIBILITY
	var/next_search = 0
	var/on = 0
	var/id = 1


/obj/item/clothing/accessory/buddy_tag/on_update_icon()
	icon_state = "buddytag[on]"


/obj/item/clothing/accessory/buddy_tag/attack_self(mob/user)
	if (!CanPhysicallyInteract(user))
		return
	var/dat = "<A href='?src=\ref[src];toggle=1;'>[on ? "Disable" : "Enable"]</a><br>"
	dat += "ID: <A href='?src=\ref[src];setcode=1;'>[id]</a>"
	var/datum/browser/popup = new(user, "buddytag", "Buddy Tag", 290, 200)
	popup.set_content(dat)
	popup.open()


/obj/item/clothing/accessory/buddy_tag/DefaultTopicState()
	return GLOB.physical_state


/obj/item/clothing/accessory/buddy_tag/OnTopic(user, list/href_list, state)
	if (href_list["toggle"])
		on = !on
		if (on)
			next_search = world.time
			START_PROCESSING(SSobj, src)
		update_icon()
		return TOPIC_REFRESH
	if (href_list["setcode"])
		var/newcode = input("Set new buddy ID number.", "Buddy Tag ID", "") as null | num
		if (newcode == null || !CanInteract(user, state))
			return
		id = newcode
		return TOPIC_REFRESH


/obj/item/clothing/accessory/buddy_tag/Process()
	if (!on)
		return PROCESS_KILL
	if (world.time < next_search)
		return
	next_search = world.time + 30 SECONDS
	var/has_friend
	for (var/obj/item/clothing/accessory/buddy_tag/buddy in SSobj.processing)
		if (buddy == src)
			continue
		if (!buddy.on)
			continue
		if (buddy.id != id)
			continue
		if (get_z(buddy) != get_z(src))
			continue
		if (get_dist(get_turf(src), get_turf(buddy)) <= 10)
			has_friend = TRUE
			break
	if (!has_friend)
		playsound(src, 'sound/machines/chime.ogg', 10)
		var/turf/T = get_turf(src)
		if (T)
			T.visible_message(SPAN_WARNING("[src] beeps anxiously."), range = 3)
