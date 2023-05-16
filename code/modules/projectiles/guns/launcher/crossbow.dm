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

/obj/item/gun/launcher/crossbow/toggle_safety(mob/user)
	to_chat(user, SPAN_WARNING("There's no safety on \the [src]!"))

/obj/item/gun/launcher/crossbow/update_release_force()
	release_force = tension*release_speed

/obj/item/gun/launcher/crossbow/consume_next_projectile(mob/user=null)
	if(tension <= 0)
		to_chat(user, SPAN_WARNING("\The [src] is not drawn back!"))
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

/obj/item/gun/launcher/crossbow/proc/draw(mob/user as mob)

	if(!bolt)
		to_chat(user, "You don't have anything nocked to [src].")
		return

	if(user.restrained())
		return

	current_user = user
	user.visible_message("[user] begins to draw back the string of [src].",SPAN_NOTICE("You begin to draw back the string of [src]."))
	tension = 1

	while(bolt && tension && loc == current_user)
		if(!do_after(user, draw_time, src, DO_PUBLIC_UNIQUE)) //crossbow strings don't just magically pull back on their own.
			user.visible_message("[usr] stops drawing and relaxes the string of [src].",SPAN_WARNING("You stop drawing back and relax the string of [src]."))
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

		user.visible_message("[usr] draws back the string of [src]!",SPAN_NOTICE("You continue drawing back the string of [src]!"))

/obj/item/gun/launcher/crossbow/proc/increase_tension(mob/user as mob)

	if(!bolt || !tension || current_user != user) //Arrow has been fired, bow has been relaxed or user has changed.
		return


/obj/item/gun/launcher/crossbow/use_tool(obj/item/tool, mob/user, list/click_params)
	// Arrow - Load ammo
	if (istype(tool, /obj/item/arrow))
		if (bolt)
			USE_FEEDBACK_FAILURE("\The [src] already has \a [bolt] loaded.")
			return TRUE
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		bolt = tool
		update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] slides \a [bolt] into \a [src]."),
			SPAN_NOTICE("You slide \the [bolt] into \the [src].")
		)
		return TRUE

	// RCD - Created rapid crossbow device
	if (istype(tool, /obj/item/rcd))
		var/obj/item/rcd/rcd = tool
		if (!rcd.crafting)
			USE_FEEDBACK_FAILURE("\The [tool] isn't ready to be modified.")
			return TRUE
		if (!user.canUnEquip(tool))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		if (!user.canUnEquip(src))
			FEEDBACK_UNEQUIP_FAILURE(user, src)
			return TRUE
		var/obj/item/gun/launcher/crossbow/rapidcrossbowdevice/new_crossbow = new(get_turf(src))
		transfer_fingerprints_to(new_crossbow)
		tool.transfer_fingerprints_to(new_crossbow)
		new_crossbow.add_fingerprint(user)
		user.visible_message(
			SPAN_NOTICE("\The [user] combines \a [tool] and \a [src] to create \a [new_crossbow]."),
			SPAN_NOTICE("You combine \the [tool] and \the [src] to create \a [new_crossbow].")
		)
		qdel(tool)
		qdel_self()
		return TRUE

	// Rods - Load ammo
	if (istype(tool, /obj/item/stack/material/rods))
		if (bolt)
			USE_FEEDBACK_FAILURE("\The [src] already has \a [bolt] loaded.")
			return TRUE
		var/obj/item/stack/material/rods/rods = tool
		if (!rods.use(1))
			USE_FEEDBACK_STACK_NOT_ENOUGH(rods, 1, "to load \the [src].")
			return TRUE
		bolt = new /obj/item/arrow/rod(src)
		bolt.add_fingerprint(user)
		update_icon()
		superheat_rod(user)
		user.visible_message(
			SPAN_NOTICE("\The [user] jams ")
		)

	return ..()


/obj/item/gun/launcher/crossbow/use_tool(obj/item/tool, mob/user, list/click_params)
	// Arrow - Load ammo
	if (istype(tool, /obj/item/arrow))
		if (bolt)
			USE_FEEDBACK_FAILURE("\The [src] already has \a [bolt] loaded.")
			return TRUE
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		bolt = tool
		update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] slides \a [tool] into \a [src]."),
			SPAN_NOTICE("You slide \the [tool] into \the [src].")
		)
		return TRUE

	// Cell - Attach cell
	if (istype(tool, /obj/item/cell))
		if (cell)
			USE_FEEDBACK_FAILURE("\The [src] already has \a [cell] installed.")
			return TRUE
		if (!user.unEquip(tool, src))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		cell = tool
		user.visible_message(
			SPAN_NOTICE("\The [user] jams \a [cell] into \a [src] and wires it to the firing coil."),
			SPAN_NOTICE("You jam \the [cell] into \the [src] and wire it to the firing coil.")
		)
		superheat_rod(user)
		return TRUE

	// Rods - Load ammo
	if (istype(tool, /obj/item/stack/material/rods))
		if (bolt)
			USE_FEEDBACK_FAILURE("\The [src] already has \a [bolt] loaded.")
			return TRUE
		var/obj/item/stack/material/rods/rods = tool
		if (!rods.use(1))
			USE_FEEDBACK_STACK_NOT_ENOUGH(rods, 1, "to load \the [src].")
			return TRUE
		bolt = new /obj/item/arrow/rod(src)
		tool.transfer_fingerprints_to(bolt)
		bolt.add_fingerprint(user, tool = src)
		update_icon()
		user.visible_message(
			SPAN_NOTICE("\The [user] slides [rods.get_vague_name()] into \a [src]."),
			SPAN_NOTICE("You slide [rods.get_exact_name(1)] into \the [src].")
		)
		superheat_rod(user)
		return TRUE

	// Screwdriver - Remove cell
	if (isScrewdriver(tool))
		if (!cell)
			USE_FEEDBACK_FAILURE("\The [src] has no cell to remove.")
			return TRUE
		user.put_in_hands(cell)
		user.visible_message(
			SPAN_NOTICE("\The [user] jimmies \a [cell] out of \a [src] with \a [tool]."),
			SPAN_NOTICE("You jimmy \the [cell] out of \the [src] with \the [tool].")
		)
		cell = null
		update_icon()
		return TRUE

	return ..()


/obj/item/gun/launcher/crossbow/proc/superheat_rod(mob/user)
	if(!user || !cell || !bolt) return
	if(cell.charge < 500) return
	if(bolt.throwforce >= 15) return
	if(!istype(bolt,/obj/item/arrow/rod)) return

	to_chat(user, SPAN_NOTICE("[bolt] plinks and crackles as it begins to glow red-hot."))
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
	fire_sound = 'sound/weapons/rcd_crossbow.ogg'
	icon_state = "rxb"
	slot_flags = null
	draw_time = 10
	var/stored_matter = 0
	var/max_stored_matter = 120
	var/boltcost = 30

/obj/item/gun/launcher/crossbow/rapidcrossbowdevice/proc/generate_bolt(mob/user)
	if(stored_matter >= boltcost && !bolt)
		bolt = new/obj/item/arrow/rapidcrossbowdevice(src)
		stored_matter -= boltcost
		to_chat(user, SPAN_NOTICE("The RCD flashforges a new bolt!"))
		queue_icon_update()
	else
		to_chat(user, SPAN_WARNING("The \'Low Ammo\' light on the device blinks yellow."))
		flick("[icon_state]-empty", src)


/obj/item/gun/launcher/crossbow/rapidcrossbowdevice/attack_self(mob/living/user as mob)
	if(tension)
		user.visible_message("[user] relaxes the tension on [src]'s string.","You relax the tension on [src]'s string.")
		tension = 0
		update_icon()
	else
		generate_bolt(user)
		draw(user)


/obj/item/gun/launcher/crossbow/rapidcrossbowdevice/use_tool(obj/item/tool, mob/user, list/click_params)
	// RCD Ammo - Reload RCD
	if (istype(tool, /obj/item/rcd_ammo))
		if (stored_matter >= max_stored_matter)
			USE_FEEDBACK_FAILURE("\The [src]'s RCD is already at maximum capacity.")
			return TRUE
		var/obj/item/rcd_ammo/cartridge = tool
		var/matter_exchange = min(cartridge.remaining, max_stored_matter - stored_matter)
		stored_matter += matter_exchange
		cartridge.remaining -= matter_exchange
		if (cartridge.remaining <= 0)
			qdel(tool)
		else
			cartridge.matter = list(
				MATERIAL_STEEL = 500 * cartridge.remaining,
				MATERIAL_GLASS = 250 * cartridge.remaining
			)
		update_icon()
		playsound(src, 'sound/machines/click.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] loads \a [tool] into \a [src]'s RCD."),
			SPAN_NOTICE("You load \the [tool] into \the [src]'s RCD.")
		)
		if (max_stored_matter > 1)
			to_chat(user, SPAN_INFO("\The [src]'s RCD now holds [stored_matter]/[max_stored_matter] matter unit\s."))
		return TRUE

	// Bolt - Reclaim bolt
	if (istype(tool, /obj/item/arrow/rapidcrossbowdevice))
		if ((stored_matter + 10) > max_stored_matter)
			USE_FEEDBACK_FAILURE("\The [src] can't reclaim \the [tool]. The RCD is too full.")
			return TRUE
		if (!user.canUnEquip(tool))
			FEEDBACK_UNEQUIP_FAILURE(user, tool)
			return TRUE
		stored_matter += 10
		qdel(tool)
		update_icon()
		playsound(src, 'sound/machines/click.ogg', 50, TRUE)
		user.visible_message(
			SPAN_NOTICE("\The [user] reclaims \a [tool] with \a [src]'s RCD."),
			SPAN_NOTICE("You reclaim \the [tool] with \the [src]'s RCD.")
		)
		if (max_stored_matter > 1)
			to_chat(user, SPAN_INFO("\The [src]'s RCD now holds [stored_matter]/[max_stored_matter] matter unit\s."))
		return TRUE

	return ..()


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
