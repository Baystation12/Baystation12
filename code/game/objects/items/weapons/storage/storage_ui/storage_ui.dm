/datum/storage_ui
	var/obj/item/weapon/storage/storage

/datum/storage_ui/New(var/storage)
	src.storage = storage
	..()

/datum/storage_ui/Destroy()
	storage = null
	. = ..()

/datum/storage_ui/proc/show_to(var/mob/user)
	return

/datum/storage_ui/proc/hide_from(var/mob/user)
	return

/datum/storage_ui/proc/prepare_ui()
	return

/datum/storage_ui/proc/close_all()
	return

/datum/storage_ui/proc/on_open(var/mob/user)
	return

/datum/storage_ui/proc/after_close(var/mob/user)
	return

/datum/storage_ui/proc/on_insertion(var/mob/user)
	return

/datum/storage_ui/proc/on_pre_remove(var/mob/user, var/obj/item/W)
	return

/datum/storage_ui/proc/on_post_remove(var/mob/user, var/obj/item/W)
	return

/datum/storage_ui/proc/on_hand_attack(var/mob/user)
	return
