/obj/structure/flora/tree
	name = "tree"
	anchored = TRUE
	density = TRUE
	pixel_x = -16
	layer = ABOVE_HUMAN_LAYER
	health_max = 200

	/// How much to shake the tree by when struck
	var/shake_animation_degrees = 4

	/// If set, a material product from cutting the tree down
	var/material/product = MATERIAL_WOOD

	/// If there is a product, the max amount that can be produced
	var/product_max = 10

	/// When true, the tree has already been cut down
	var/is_stump

	/// A local override for damage that should reduce the product_max
	var/const/DAMAGE_FLAG_PRODUCT = FLAG(23)


/obj/structure/flora/tree/Initialize()
	. = ..()
	product = SSmaterials.get_material_by_name(product)
	if (!product)
		log_debug({"Instance of [type] created with bad product "[initial(product)]""})
		return INITIALIZE_HINT_QDEL
	health_min_damage = 5


/obj/structure/flora/tree/use_tool(obj/item/tool, mob/living/user, list/click_params)
	SHOULD_CALL_PARENT(FALSE)
	if (istype(tool, /obj/item/shovel) && user.a_intent != I_HURT)
		if (!is_stump)
			to_chat(user, SPAN_WARNING("You can't dig up \the [src] without cutting it down first!"))
			return
		if (!do_after(user, 5 SECONDS, src, DO_PUBLIC_UNIQUE))
			return
		user.visible_message(
			SPAN_ITALIC("\The [user] digs up \a [src] with \a [tool]."),
			SPAN_ITALIC("You dig up \the [src] with \the [tool].")
		)
		qdel(src)
		return TRUE
	user.setClickCooldown(user.get_attack_speed(tool))
	user.do_attack_animation(src)
	TryChop(tool, user)
	return TRUE


/obj/structure/flora/tree/use_weapon(obj/item/weapon, mob/living/user, list/click_params)
	SHOULD_CALL_PARENT(FALSE)
	if (!is_stump)
		TryChop(weapon, user)
		return TRUE
	var/other_message = ""
	var/self_message = ""
	if (istype(weapon, /obj/item/natural_weapon))
		var/datum/pronouns/pronouns = user.choose_from_pronouns()
		other_message = " with [pronouns.his] [weapon]"
		self_message = " with your [weapon]"
	else
		other_message = " with \a [weapon]"
		self_message = " with \the [weapon]"
	user.visible_message(
		SPAN_ITALIC("\The [user] hits \a [src][other_message]."),
		SPAN_ITALIC("You hit \the [src][self_message].") + SPAN_WARNING(" It does nothing!"),
		SPAN_WARNING("You hear something impact on wood!")
	)
	return TRUE


/obj/structure/flora/tree/on_death()
	if (holographic || is_stump)
		return
	if (product && product_max > 0)
		var/amount = rand(ceil(product_max / 2), product_max)
		product.place_sheet(get_turf(src), amount)
	visible_message(SPAN_WARNING("\The [src] is felled!"))
	icon_state = "[initial(icon_state)]_stump"
	name = "[name] stump"
	is_stump = TRUE
	density = FALSE
	set_light(0)


/obj/structure/flora/tree/proc/TryChop(obj/item/item, mob/living/user)
	var/damage
	var/damage_flags
	var/chop
	var/other_message = ""
	var/self_message = ""
	damage = item.force
	chop = item.sharp && item.edge && user.a_intent != I_HURT
	if (isHatchet(item))
		damage *= 1.5
	if (istype(item, /obj/item/natural_weapon))
		var/datum/pronouns/pronouns = user.choose_from_pronouns()
		other_message = " with [pronouns.his] [item]"
		self_message = " with your [item]"
	else
		other_message = " with \a [item]"
		self_message = " with \the [item]"
	if (holographic)
		other_message = SPAN_ITALIC("\The [user] swipes at \a [src][other_message].")
		self_message = SPAN_ITALIC("You swipe at \the [src][self_message].")
		damage = 0
	else if (chop)
		other_message = SPAN_ITALIC("\The [user] chops \a [src][other_message].")
		self_message = SPAN_ITALIC("You chop \the [src][self_message].")
	else if (item.sharp || item.edge)
		other_message = SPAN_ITALIC("\The [user] hacks at \a [src][other_message].")
		self_message = SPAN_ITALIC("You hack at \the [src][self_message].")
		damage *= 0.5
		damage_flags = DAMAGE_FLAG_PRODUCT
	else
		other_message = SPAN_ITALIC("\The [user] hits \a [src][other_message].")
		self_message = SPAN_ITALIC("You hit \the [src][self_message].")
		damage *= 0.25
		damage_flags = DAMAGE_FLAG_PRODUCT
	damage = max(damage, 0)
	if (damage)
		if (chop)
			playsound(src, 'sound/effects/woodcutting.ogg', 50, TRUE)
		else if (item?.hitsound)
			playsound(src, item.hitsound, 50, TRUE)
	if (damage < health_min_damage)
		self_message += SPAN_WARNING(" It does nothing!")
	else
		damage_health(damage, item.damtype, damage_flags)
		shake_animation(shake_animation_degrees)
	user.visible_message(
		other_message,
		self_message,
		SPAN_WARNING("You hear something impact on wood!")
	)


/obj/structure/flora/tree/damage_health(damage, damage_type, damage_flags, severity, skip_can_damage_check)
	if (holographic || is_stump)
		return FALSE
	if (product_max && HAS_FLAGS(damage_flags, DAMAGE_FLAG_PRODUCT))
		var/removed = initial(product_max) * damage / get_max_health()
		product_max -= max(removed, 0)
	return ..()


/obj/structure/flora/tree/ex_act(severity)
	damage_health(get_max_health() / severity, DAMAGE_EXPLODE, DAMAGE_FLAG_PRODUCT)


/obj/structure/flora/tree/bullet_act(obj/item/projectile/projectile)
	if (!projectile.get_structure_damage())
		return
	var/amount = projectile.get_structure_damage()
	damage_health(amount, projectile.damage_type, DAMAGE_FLAG_PRODUCT)


/obj/structure/flora/tree/pine
	name = "pine tree"
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "pine"
	product = MATERIAL_WOOD
	shake_animation_degrees = 3


/obj/structure/flora/tree/pine/Initialize()
	. = ..()
	var/state = rand(2)
	if (state)
		icon_state = "[initial(icon_state)]_[state]"


/obj/structure/flora/tree/pine/xmas
	name = "\improper Christmas tree"
	desc = "O Christmas tree, O Christmas tree..."
	icon = 'icons/obj/flora/pinetrees.dmi'
	product = MATERIAL_PLASTIC
	product_max = 8


/obj/structure/flora/tree/pine/xmas/Initialize()
	. = ..()
	icon_state = "pine_c"


/obj/structure/flora/tree/festivus
	name = "\improper Festivus pole"
	desc = "Technically, one could air a grievance with a feat of strength."
	icon_state = "festivus_pole"
	health_max = 100
	product_max = 5


/obj/structure/flora/tree/dead
	icon = 'icons/obj/flora/deadtrees.dmi'
	icon_state = "tree"


/obj/structure/flora/tree/dead/Initialize()
	. = ..()
	var/state = rand(5)
	if (state)
		icon_state = "[initial(icon_state)]_[state]"


/obj/structure/flora/tree/alien
	name = "alien tree"
	desc = "A large xenofloral specimen."
	icon = 'icons/obj/flora/deadtrees.dmi'
	icon_state = "tree_sif"


/obj/structure/flora/tree/alien/Initialize()
	. = ..()
	var/state = rand(5)
	if (state)
		icon_state = "[initial(icon_state)]_[state]"
	queue_icon_update()


/obj/structure/flora/tree/alien/on_death()
	..()
	update_icon()


/obj/structure/flora/tree/alien/on_update_icon()
	ClearOverlays()
	if (is_stump)
		return
	var/mutable_appearance/glow = emissive_appearance(icon, "[icon_state]_glow", src, 128)
	AddOverlays(glow)
