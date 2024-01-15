/obj/structure/bookcase/manuals/security
	name = "Law Manuals bookcase"

/obj/structure/bookcase/manuals/security/New()
		..()
		new /obj/item/book/manual/detective(src)
		new /obj/item/book/manual/nt_regs(src)
		new /obj/item/book/manual/solgov_law(src)
		new /obj/item/book/manual/nt_sop(src)
		new /obj/item/book/manual/nt_tc(src)
		new /obj/item/book/manual/military_law(src)
		update_icon()

// Targets, the things that actually get shot!
/obj/item/target
	name = "shooting target"
	desc = "A shooting target."
	icon = 'maps/sierra/icons/obj/target.dmi'
	icon_state = "target_h"
	density = FALSE
	var/hp = 1800
	var/icon/virtualIcon
	var/list/bulletholes = list()

/obj/item/target/use_tool(obj/item/tool, mob/living/user, list/click_params)
	if (isWelder(tool))
		var/obj/item/weldingtool/welder = tool
		if (welder.remove_fuel(0, user))
			ClearOverlays()
			bulletholes.Cut()
			hp = initial(hp)
			user.visible_message(
				SPAN_NOTICE("[user] slices off uneven chunks of aluminium and scorch marks from [src]."),
				SPAN_NOTICE("You slice off uneven chunks of aluminium and scorch marks from [src]."),
				SPAN_NOTICE("You hear welding."),
			)
		return TRUE
	return ..()

/obj/item/target/syndicate
	icon_state = "target_s"
	desc = "A shooting target that looks like a hostile agent."
	hp = 2600 // i guess syndie targets are sturdier?

/obj/item/target/alien
	icon_state = "target_q"
	desc = "A shooting target with a threatening silhouette."
	hp = 2350 // alium onest too kinda

#define PROJECTILE_TYPE_SCORCH 1
#define PROJECTILE_TYPE_BULLET 2
#define TARGET_RANDOM_OFFSET pick(0, 0, 0, 0, 0, -1, 1)

/obj/item/target/bullet_act(obj/item/projectile/projectile)
	var/p_x = projectile.p_x + TARGET_RANDOM_OFFSET
	var/p_y = projectile.p_y + TARGET_RANDOM_OFFSET

	var/projectile_type = PROJECTILE_TYPE_SCORCH
	if (istype(/obj/item/projectile/bullet, projectile))
		projectile_type = PROJECTILE_TYPE_BULLET

	virtualIcon = new(icon, icon_state)

	if (isnull(virtualIcon.GetPixel(p_x, p_y)))
		return PROJECTILE_CONTINUE // The projectile goes through the target!

	hp -= projectile.damage
	if (hp <= 0)
		visible_message(SPAN_WARNING("\The [src] breaks into tiny pieces and collapses!"))
		qdel(src)
		return FALSE // The projectile stops

	// Create a temporary object to represent the damage
	var/obj/bmark = new
	bmark.pixel_x = p_x
	bmark.pixel_y = p_y
	bmark.icon = 'icons/effects/effects.dmi'
	bmark.layer = ABOVE_OBJ_LAYER

	// Set bmark icon_state
	if (projectile_type == PROJECTILE_TYPE_SCORCH)
		// Energy weapons are hot. they scorch!

		// Offset correction
		bmark.pixel_x--
		bmark.pixel_y--

		if (projectile.damage >= 20 || istype(projectile, /obj/item/projectile/beam/practice))
			bmark.icon_state = "scorch"
			bmark.set_dir(pick(NORTH, SOUTH, EAST, WEST)) // Random scorch design
		else
			bmark.icon_state = "light_scorch"
	else
		// Bullets are hard. They make dents!
		bmark.icon_state = "dent"

	// Create bulletholes
	if (projectile.damage >= 25) // Seriously, we commonly won't achive more than 35 holes. Because this things are beyond window.

		// Bullets make holes more commonly
		if (projectile_type == PROJECTILE_TYPE_BULLET && prob(projectile.damage + 30))
			new/datum/bullethole(src, bmark.pixel_x, bmark.pixel_y)

		// Lasers make holes less commonly
		if (projectile_type == PROJECTILE_TYPE_SCORCH && prob(projectile.damage - 10))
			new/datum/bullethole(src, bmark.pixel_x, bmark.pixel_y)

	// Draw bullet holes
	for(var/datum/bullethole/bhole in bulletholes)
		virtualIcon.DrawBox(null, bhole.b1x1, bhole.b1y, bhole.b1x2, bhole.b1y) // Horizontal line, left to right
		virtualIcon.DrawBox(null, bhole.b2x, bhole.b2y1, bhole.b2x, bhole.b2y2) // Vertical line, top to bottom

	AddOverlays(bmark) // Add the decal
	icon = virtualIcon // Apply bulletholes over decals

	return FALSE // The projectile stops

#undef TARGET_RANDOM_OFFSET
#undef PROJECTILE_TYPE_BULLET
#undef PROJECTILE_TYPE_SCORCH

#define BULLETHOLE_RANDOM_OFFSET pick(1, 1, 1, 1, 2, 2, 3, 3, 4)

// Small memory holder entity for transparent bullet holes
/datum/bullethole
	// First box
	var/b1x1 = 0
	var/b1x2 = 0
	var/b1y = 0

	// Second box
	var/b2x = 0
	var/b2y1 = 0
	var/b2y2 = 0

/datum/bullethole/New(obj/item/target/owner, pixel_x = 0, pixel_y = 0)
	if (!owner) return

	// Randomize the first box
	b1x1 = pixel_x - BULLETHOLE_RANDOM_OFFSET
	b1x2 = pixel_x + BULLETHOLE_RANDOM_OFFSET
	b1y = pixel_y
	if (prob(35))
		b1y += rand(-4, 4)

	// Randomize the second box
	b2x = pixel_x
	if (prob(35))
		b2x += rand(-4, 4)
	b2y1 = pixel_y + BULLETHOLE_RANDOM_OFFSET
	b2y2 = pixel_y - BULLETHOLE_RANDOM_OFFSET

	owner.bulletholes += src

#undef BULLETHOLE_RANDOM_OFFSET
