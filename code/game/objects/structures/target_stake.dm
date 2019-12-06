// Target stakes for the firing range.
/obj/structure/target_stake
	name = "target stake"
	desc = "A thin platform with negatively-magnetized wheels."
	icon = 'icons/obj/objects.dmi'
	icon_state = "target_stake"
	density = 1
	w_class = ITEM_SIZE_NO_CONTAINER
	obj_flags = OBJ_FLAG_CONDUCTIBLE
	var/obj/item/target/pinned_target

/obj/structure/target_stake/attackby(var/obj/item/W, var/mob/user)
	if (!pinned_target && istype(W, /obj/item/target) && user.unEquip(W, get_turf(src)))
		to_chat(user, "<span class='notice'>You slide [W] into the stake.</span>")
		set_target(W)

/obj/structure/target_stake/attack_hand(var/mob/user)
	. = ..()
	if (pinned_target && ishuman(user))
		var/obj/item/target/T = pinned_target
		to_chat(user, "<span class='notice'>You take [T] out of the stake.</span>")
		set_target(null)
		user.put_in_hands(T)

/obj/structure/target_stake/proc/set_target(var/obj/item/target/T)
	if (T)
		set_density(0)
		T.set_density(1)
		T.pixel_x = 0
		T.pixel_y = 0
		T.layer = ABOVE_OBJ_LAYER
		GLOB.moved_event.register(T, src, /atom/movable/proc/move_to_turf)
		GLOB.moved_event.register(src, T, /atom/movable/proc/move_to_turf)
		T.stake = src
		pinned_target = T
	else
		set_density(1)
		pinned_target.set_density(0)
		pinned_target.layer = OBJ_LAYER
		GLOB.moved_event.unregister(pinned_target, src)
		GLOB.moved_event.unregister(src, pinned_target)
		pinned_target.stake = null
		pinned_target = null

/obj/structure/target_stake/Destroy()
	. = ..()
	set_target(null)