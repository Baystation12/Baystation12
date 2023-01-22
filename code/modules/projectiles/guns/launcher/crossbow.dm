//AMMUNITION

/obj/item/arrow
	name = "bolt"
	desc = "It's got a tip for you - get the point?"
	icon = 'icons/obj/weapons/other.dmi'
	icon_state = "bolt"
	item_state = "bolt"
	throwforce = 8
	w_class = ITEM_SIZE_NORMAL
	sharp = TRUE
	lock_picking_level = 3

/obj/item/arrow/proc/removed() //Helper for metal rods falling apart.
	return

/obj/item/spike
	name = "alloy spike"
	desc = "It's about a foot of weird silver metal with a wicked point."
	sharp = TRUE
	throwforce = 5
	w_class = ITEM_SIZE_SMALL
	icon = 'icons/obj/weapons/other.dmi'
	icon_state = "metal-rod"
	item_state = "bolt"

/obj/item/arrow/quill
	name = "vox quill"
	desc = "A wickedly barbed quill from some bizarre animal."
	icon_state = "quill"
	item_state = "quill"
	throwforce = 5

/obj/item/arrow/rod
	name = "metal rod"
	desc = "Don't cry for me, Orithena."
	icon_state = "metal-rod"

/obj/item/arrow/rod/removed(mob/user)
	if(throwforce == 15) // The rod has been superheated - we don't want it to be useable when removed from the bow.
		to_chat(user, "[src] shatters into a scattering of overstressed metal shards as it leaves the crossbow.")
		var/obj/item/material/shard/shrapnel/steel/shrapnel = new
		shrapnel.dropInto(loc)
		qdel(src)

/obj/item/gun/launcher/crossbow
	name = "powered crossbow"
	desc = "A modern twist on an old classic. Pick up that can."
	icon = 'icons/obj/guns/crossbow.dmi'
	icon_state = "crossbow"
	item_state = "crossbow-solid"
	fire_sound = 'sound/weapons/punchmiss.ogg' // TODO: Decent THWOK noise.
	fire_sound_text = "a solid thunk"
	fire_delay = 25
	slot_flags = SLOT_BACK
	has_safety = FALSE

	var/obj/item/bolt
	var/tension = 0                         // Current draw on the bow.
	var/max_tension = 3                     // Highest possible tension.
	var/release_speed = 10                  // Speed per unit of tension.
	var/obj/item/cell/cell = null    // Used for firing superheated rods.
	var/current_user                        // Used to check if the crossbow has changed hands since being drawn.
	var/draw_time = 20						// Time needed to draw the bow back by one "tension"

/obj/item/gun/launcher/crossbow/toggle_safety(var/mob/user)
	to_chat(user, "<span class='warning'>There's no safety on \the [src]!</span>")

/obj/item/gun/launcher/crossbow/update_release_force()
	release_force = tension*release_speed

/obj/item/gun/launcher/crossbow/consume_next_projectile(mob/user=null)
	if(tension <= 0)
		to_chat(user, "<span class='warning'>\The [src] is not drawn back!</span>")
		return null
	return bolt

/obj/item/gun/launcher/crossbow/handle_post_fire(mob/user, atom/target)
	bolt = null
	tension = 0
	update_icon()
	..()

/obj/item/gun/launcher/crossbow/attack_self(mob/living/user as mob)
	if(tension)
		if(bolt)
			user.visible_message("[user] relaxes the tension on [src]'s string and removes [bolt].","You relax the tension on [src]'s string and remove [bolt].")
			bolt.dropInto(loc)
			var/obj/item/arrow/A = bolt
			bolt = null
			A.removed(user)
		else
			user.visible_message("[user] relaxes the tension on [src]'s string.","You relax the tension on [src]'s string.")
		tension = 0
		update_icon()
	else
		draw(user)

/obj/item/gun/launcher/crossbow/proc/draw(var/mob/user as mob)

	if(!bolt)
		to_chat(user, "You don't have anything nocked to [src].")
		return

	if(user.restrained())
		return

	current_user = user
	user.visible_message("[user] begins to draw back the string of [src].","<span class='notice'>You begin to draw back the string of [src].</span>")
	tension = 1

	while(bolt && tension && loc == current_user)
		if(!do_after(user, draw_time, src, DO_PUBLIC_UNIQUE)) //crossbow strings don't just magically pull back on their own.
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
			to_chat(usr, "[src] clunks as you draw the string to its maximum tension!")
			return

		user.visible_message("[usr] draws back the string of [src]!","<span class='notice'>You continue drawing back the string of [src]!</span>")

/obj/item/gun/launcher/crossbow/proc/increase_tension(var/mob/user as mob)

	if(!bolt || !tension || current_user != user) //Arrow has been fired, bow has been relaxed or user has changed.
		return


/obj/item/gun/launcher/crossbow/attackby(obj/item/W, mob/user)

	if(istype(W, /obj/item/rcd))
		var/obj/item/rcd/rcd = W
		if(rcd.crafting && user.unEquip(rcd) && user.unEquip(src))
			new /obj/item/gun/launcher/crossbow/rapidcrossbowdevice(get_turf(src))
			qdel(rcd)
			qdel_self()
		else
			to_chat(user, SPAN_WARNING("\The [rcd] is not prepared for installation in \the [src]."))
		return

	if(!bolt)
		if (istype(W,/obj/item/arrow) && user.unEquip(W, src))
			bolt = W
			user.visible_message("[user] slides [bolt] into [src].","You slide [bolt] into [src].")
			update_icon()
			return
		else if(istype(W,/obj/item/stack/material/rods))
			var/obj/item/stack/material/rods/R = W
			if (R.use(1))
				bolt = new /obj/item/arrow/rod(src)
				bolt.fingerprintslast = src.fingerprintslast
				update_icon()
				user.visible_message("[user] jams [bolt] into [src].","You jam [bolt] into [src].")
				superheat_rod(user)
			return

	if(istype(W, /obj/item/cell))
		if(!cell)
			if(!user.unEquip(W, src))
				return
			cell = W
			to_chat(user, "<span class='notice'>You jam [cell] into [src] and wire it to the firing coil.</span>")
			superheat_rod(user)
		else
			to_chat(user, "<span class='notice'>[src] already has a cell installed.</span>")

	else if(isScrewdriver(W))
		if(cell)
			var/obj/item/C = cell
			C.dropInto(user.loc)
			to_chat(user, "<span class='notice'>You jimmy [cell] out of [src] with [W].</span>")
			cell = null
		else
			to_chat(user, "<span class='notice'>[src] doesn't have a cell installed.</span>")

	else
		..()

/obj/item/gun/launcher/crossbow/proc/superheat_rod(var/mob/user)
	if(!user || !cell || !bolt) return
	if(cell.charge < 500) return
	if(bolt.throwforce >= 15) return
	if(!istype(bolt,/obj/item/arrow/rod)) return

	to_chat(user, "<span class='notice'>[bolt] plinks and crackles as it begins to glow red-hot.</span>")
	bolt.throwforce = 15
	bolt.icon_state = "metal-rod-superheated"
	cell.use(500)

/obj/item/gun/launcher/crossbow/on_update_icon()
	if(tension > 1)
		icon_state = "crossbow-drawn"
	else if(bolt)
		icon_state = "crossbow-nocked"
	else
		icon_state = "crossbow"

/*////////////////////////////
//	Rapid Crossbow Device	//
*/////////////////////////////

/obj/item/arrow/rapidcrossbowdevice
	name = "flashforged bolt"
	desc = "The ultimate ghetto deconstruction implement."
	throwforce = 4

/obj/item/gun/launcher/crossbow/rapidcrossbowdevice
	name = "rapid crossbow device"
	desc = "A hacked RCD turns an innocent construction tool into the penultimate deconstruction tool. Flashforges bolts using matter units when the string is drawn back."
	icon_state = "rxb"
	slot_flags = null
	draw_time = 10
	var/stored_matter = 0
	var/max_stored_matter = 120
	var/boltcost = 30

/obj/item/gun/launcher/crossbow/rapidcrossbowdevice/proc/generate_bolt(var/mob/user)
	if(stored_matter >= boltcost && !bolt)
		bolt = new/obj/item/arrow/rapidcrossbowdevice(src)
		stored_matter -= boltcost
		to_chat(user, "<span class='notice'>The RCD flashforges a new bolt!</span>")
		queue_icon_update()
	else
		to_chat(user, "<span class='warning'>The \'Low Ammo\' light on the device blinks yellow.</span>")
		flick("[icon_state]-empty", src)


/obj/item/gun/launcher/crossbow/rapidcrossbowdevice/attack_self(mob/living/user as mob)
	if(tension)
		user.visible_message("[user] relaxes the tension on [src]'s string.","You relax the tension on [src]'s string.")
		tension = 0
		update_icon()
	else
		generate_bolt(user)
		draw(user)

/obj/item/gun/launcher/crossbow/rapidcrossbowdevice/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/rcd_ammo))
		var/obj/item/rcd_ammo/cartridge = W
		if(stored_matter >= max_stored_matter)
			to_chat(user, "<span class='notice'>The RCD is at maximum capacity.</span>")
			return
		var/matter_exchange = min(cartridge.remaining,max_stored_matter - stored_matter)
		stored_matter += matter_exchange
		cartridge.remaining -= matter_exchange
		if(cartridge.remaining <= 0)
			qdel(W)
		cartridge.matter = list(MATERIAL_STEEL = 500 * cartridge.remaining,MATERIAL_GLASS = 250 * cartridge.remaining)
		playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
		to_chat(user, "<span class='notice'>The RCD now holds [stored_matter]/[max_stored_matter] matter-units.</span>")
		update_icon()

	if(istype(W, /obj/item/arrow/rapidcrossbowdevice))
		var/obj/item/arrow/rapidcrossbowdevice/A = W
		if((stored_matter + 10) > max_stored_matter)
			to_chat(user, "<span class='notice'>Unable to reclaim flashforged bolt. The RCD can't hold that many additional matter-units.</span>")
			return
		stored_matter += 10
		qdel(A)
		playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
		to_chat(user, "<span class='notice'>Flashforged bolt reclaimed. The RCD now holds [stored_matter]/[max_stored_matter] matter-units.</span>")
		update_icon()

/obj/item/gun/launcher/crossbow/rapidcrossbowdevice/on_update_icon()
	overlays.Cut()

	if(bolt)
		overlays += "rxb-bolt"

	var/ratio = 0
	if(stored_matter < boltcost)
		ratio = 0
	else
		ratio = stored_matter / max_stored_matter
		ratio = max(round(ratio, 0.25) * 100, 25)
	overlays += "rxb-[ratio]"

	if(tension > 1)
		icon_state = "rxb-drawn"
	else
		icon_state = "rxb"

/obj/item/gun/launcher/crossbow/rapidcrossbowdevice/examine(mob/user)
	. = ..()
	to_chat(user, "It currently holds [stored_matter]/[max_stored_matter] matter-units.")
