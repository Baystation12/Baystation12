//AMMUNITION

/obj/item/weapon/arrow
	name = "bolt"
	desc = "It's got a tip for you - get the point?"
	icon = 'icons/obj/weapons.dmi'
	icon_state = "bolt"
	item_state = "bolt"
	throwforce = 8
	w_class = 3.0
	sharp = 1
	edge = 0

/obj/item/weapon/arrow/proc/removed() //Helper for metal rods falling apart.
	return

/obj/item/weapon/spike
	name = "alloy spike"
	desc = "It's about a foot of weird silver metal with a wicked point."
	sharp = 1
	edge = 0
	throwforce = 5
	w_class = 2
	icon = 'icons/obj/weapons.dmi'
	icon_state = "metal-rod"
	item_state = "bolt"

/obj/item/weapon/arrow/quill
	name = "vox quill"
	desc = "A wickedly barbed quill from some bizarre animal."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "quill"
	item_state = "quill"
	throwforce = 5

/obj/item/weapon/arrow/rod
	name = "metal rod"
	desc = "Don't cry for me, Orithena."
	icon_state = "metal-rod"

/obj/item/weapon/arrow/rod/removed(mob/user)
	if(throwforce == 15) // The rod has been superheated - we don't want it to be useable when removed from the bow.
		user  << "[src] shatters into a scattering of overstressed metal shards as it leaves the crossbow."
		var/obj/item/weapon/material/shard/shrapnel/S = new()
		S.loc = get_turf(src)
		qdel(src)

/obj/item/weapon/gun/launcher/crossbow
	name = "powered crossbow"
	desc = "A 2557AD twist on an old classic. Pick up that can."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "crossbow"
	item_state = "crossbow-solid"
	fire_sound = 'sound/weapons/punchmiss.ogg' // TODO: Decent THWOK noise.
	fire_sound_text = "a solid thunk"
	fire_delay = 25
	slot_flags = SLOT_BACK

	var/obj/item/bolt
	var/tension = 0                         // Current draw on the bow.
	var/max_tension = 5                     // Highest possible tension.
	var/release_speed = 5                   // Speed per unit of tension.
	var/obj/item/weapon/cell/cell = null    // Used for firing superheated rods.
	var/current_user                        // Used to check if the crossbow has changed hands since being drawn.

/obj/item/weapon/gun/launcher/crossbow/update_release_force()
	release_force = tension*release_speed

/obj/item/weapon/gun/launcher/crossbow/consume_next_projectile(mob/user=null)
	if(tension <= 0)
		user << "<span class='warning'>\The [src] is not drawn back!</span>"
		return null
	return bolt

/obj/item/weapon/gun/launcher/crossbow/handle_post_fire(mob/user, atom/target)
	bolt = null
	tension = 0
	update_icon()
	..()

/obj/item/weapon/gun/launcher/crossbow/attack_self(mob/living/user as mob)
	if(tension)
		if(bolt)
			user.visible_message("[user] relaxes the tension on [src]'s string and removes [bolt].","You relax the tension on [src]'s string and remove [bolt].")
			bolt.loc = get_turf(src)
			var/obj/item/weapon/arrow/A = bolt
			bolt = null
			A.removed(user)
		else
			user.visible_message("[user] relaxes the tension on [src]'s string.","You relax the tension on [src]'s string.")
		tension = 0
		update_icon()
	else
		draw(user)

/obj/item/weapon/gun/launcher/crossbow/proc/draw(var/mob/user as mob)

	if(!bolt)
		user << "You don't have anything nocked to [src]."
		return

	if(user.restrained())
		return

	current_user = user
	user.visible_message("[user] begins to draw back the string of [src].","<span class='notice'>You begin to draw back the string of [src].</span>")
	tension = 1

	while(bolt && tension && loc == current_user)
		if(!do_after(user, 25)) //crossbow strings don't just magically pull back on their own.
			user.visible_message("[usr] stops drawing and relaxes the string of [src].","<span class='warning'>You stop drawing back and relax the string of [src].</span>")
			tension = 0
			update_icon()
			return

		//double check that the user hasn't removed the bolt in the meantime
		if(!(bolt && tension && loc == current_user))
			return
		
		tension++
		update_icon()

		if(tension >= max_tension)
			tension = max_tension
			usr << "[src] clunks as you draw the string to its maximum tension!"
			return

		user.visible_message("[usr] draws back the string of [src]!","<span class='notice'>You continue drawing back the string of [src]!</span>")

/obj/item/weapon/gun/launcher/crossbow/proc/increase_tension(var/mob/user as mob)

	if(!bolt || !tension || current_user != user) //Arrow has been fired, bow has been relaxed or user has changed.
		return


/obj/item/weapon/gun/launcher/crossbow/attackby(obj/item/W as obj, mob/user as mob)
	if(!bolt)
		if (istype(W,/obj/item/weapon/arrow))
			user.drop_from_inventory(W, src)
			bolt = W
			user.visible_message("[user] slides [bolt] into [src].","You slide [bolt] into [src].")
			update_icon()
			return
		else if(istype(W,/obj/item/stack/rods))
			var/obj/item/stack/rods/R = W
			if (R.use(1))
				bolt = new /obj/item/weapon/arrow/rod(src)
				bolt.fingerprintslast = src.fingerprintslast
				bolt.loc = src
				update_icon()
				user.visible_message("[user] jams [bolt] into [src].","You jam [bolt] into [src].")
				superheat_rod(user)
			return

	if(istype(W, /obj/item/weapon/cell))
		if(!cell)
			user.drop_item()
			cell = W
			cell.loc = src
			user << "<span class='notice'>You jam [cell] into [src] and wire it to the firing coil.</span>"
			superheat_rod(user)
		else
			user << "<span class='notice'>[src] already has a cell installed.</span>"

	else if(istype(W, /obj/item/weapon/screwdriver))
		if(cell)
			var/obj/item/C = cell
			C.loc = get_turf(user)
			user << "<span class='notice'>You jimmy [cell] out of [src] with [W].</span>"
			cell = null
		else
			user << "<span class='notice'>[src] doesn't have a cell installed.</span>"

	else
		..()

/obj/item/weapon/gun/launcher/crossbow/proc/superheat_rod(var/mob/user)
	if(!user || !cell || !bolt) return
	if(cell.charge < 500) return
	if(bolt.throwforce >= 15) return
	if(!istype(bolt,/obj/item/weapon/arrow/rod)) return

	user << "<span class='notice'>[bolt] plinks and crackles as it begins to glow red-hot.</span>"
	bolt.throwforce = 15
	bolt.icon_state = "metal-rod-superheated"
	cell.use(500)

/obj/item/weapon/gun/launcher/crossbow/update_icon()
	if(tension > 1)
		icon_state = "crossbow-drawn"
	else if(bolt)
		icon_state = "crossbow-nocked"
	else
		icon_state = "crossbow"


// Crossbow construction.
/obj/item/weapon/crossbowframe
	name = "crossbow frame"
	desc = "A half-finished crossbow."
	icon_state = "crossbowframe0"
	item_state = "crossbow-solid"

	var/buildstate = 0

/obj/item/weapon/crossbowframe/update_icon()
	icon_state = "crossbowframe[buildstate]"

/obj/item/weapon/crossbowframe/examine(mob/user)
	..(user)
	switch(buildstate)
		if(1) user << "It has a loose rod frame in place."
		if(2) user << "It has a steel backbone welded in place."
		if(3) user << "It has a steel backbone and a cell mount installed."
		if(4) user << "It has a steel backbone, plastic lath and a cell mount installed."
		if(5) user << "It has a steel cable loosely strung across the lath."

/obj/item/weapon/crossbowframe/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/stack/rods))
		if(buildstate == 0)
			var/obj/item/stack/rods/R = W
			if(R.use(3))
				user << "<span class='notice'>You assemble a backbone of rods around the wooden stock.</span>"
				buildstate++
				update_icon()
			else
				user << "<span class='notice'>You need at least three rods to complete this task.</span>"
			return
	else if(istype(W,/obj/item/weapon/weldingtool))
		if(buildstate == 1)
			var/obj/item/weapon/weldingtool/T = W
			if(T.remove_fuel(0,user))
				if(!src || !T.isOn()) return
				playsound(src.loc, 'sound/items/Welder2.ogg', 100, 1)
				user << "<span class='notice'>You weld the rods into place.</span>"
			buildstate++
			update_icon()
		return
	else if(istype(W,/obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/C = W
		if(buildstate == 2)
			if(C.use(5))
				user << "<span class='notice'>You wire a crude cell mount into the top of the crossbow.</span>"
				buildstate++
				update_icon()
			else
				user << "<span class='notice'>You need at least five segments of cable coil to complete this task.</span>"
			return
		else if(buildstate == 4)
			if(C.use(5))
				user << "<span class='notice'>You string a steel cable across the crossbow's lath.</span>"
				buildstate++
				update_icon()
			else
				user << "<span class='notice'>You need at least five segments of cable coil to complete this task.</span>"
			return
	else if(istype(W,/obj/item/stack/material) && W.get_material_name() == "plastic")
		if(buildstate == 3)
			var/obj/item/stack/material/P = W
			if(P.use(3))
				user << "<span class='notice'>You assemble and install a heavy plastic lath onto the crossbow.</span>"
				buildstate++
				update_icon()
			else
				user << "<span class='notice'>You need at least three plastic sheets to complete this task.</span>"
			return
	else if(istype(W,/obj/item/weapon/screwdriver))
		if(buildstate == 5)
			user << "<span class='notice'>You secure the crossbow's various parts.</span>"
			new /obj/item/weapon/gun/launcher/crossbow(get_turf(src))
			qdel(src)
		return
	else
		..()
