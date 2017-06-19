/obj/item/weapon/gun/composite
	name = "composite weapon"
	desc = "This really shouldn't exist yet."
	appearance_flags = KEEP_TOGETHER

	var/max_shots = 0                          // Weapon capacity.
	var/caliber = ""                           // Barrel size/type of projectile.
	var/decl/weapon_model/model                // Model and manufacturer info, if any.
	var/list/accessories = list()              // Installed accessories, if any.
	var/force_icon                             // File to override component icons with.
	var/force_icon_state                       // State to use with the above.
	var/gun_type                               // General class of gun.
	var/dam_type                               // General class of projectile.
	var/jammed                                 // Are we jammed?
	var/installed_in_turret = FALSE            // Are we installed in a turret?

	// Component helpers.
	var/obj/item/gun_component/barrel/barrel   // Caliber, projectile type.
	var/obj/item/gun_component/body/body       // Class of weapon, weapon size.
	var/obj/item/gun_component/grip/grip       // Size/accuracy/recoil modifier.
	var/obj/item/gun_component/stock/stock     // Size/accuracy/recoil modifier.
	var/obj/item/gun_component/chamber/chamber // Loading type, firing modes, special behavior.

/obj/item/weapon/gun/composite/New(var/newloc, var/obj/item/gun_assembly/assembly)
	if(istype(assembly))
		for(var/obj/item/I in assembly.contents)
			I.forceMove(src)
		barrel =      assembly.barrel
		body =        assembly.body
		grip =        assembly.grip
		stock =       assembly.stock
		chamber =     assembly.chamber
		accessories = assembly.accessories.Copy()
		update_from_components()
		qdel(assembly)
	if(istype(newloc, /obj/machinery/porta_turret))
		installed_in_turret = TRUE
	..(newloc)

/obj/item/weapon/gun/composite/forceMove()
	. = ..()
	if(istype(loc, /obj/machinery/porta_turret))
		installed_in_turret = TRUE
	else
		installed_in_turret = FALSE

/obj/item/weapon/gun/composite/pickup()
	. = ..()
	update_strings()
	update_icon()

/obj/item/weapon/gun/composite/dropped()
	. = ..()
	update_strings()
	update_icon()

/obj/item/weapon/gun/composite/reset_name()
	update_strings()
	return name

/obj/item/weapon/gun/composite/Destroy()
	barrel = null
	body = null
	grip = null
	stock = null
	chamber = null
	accessories.Cut()
	for(var/obj/item/I in contents)
		qdel(I)
	return ..()

/obj/item/weapon/gun/composite/proc/update_from_components()

	// Should we actually exist?
	if(!barrel || !body || !grip || !chamber)
		var/mob/M = loc
		if(istype(M))
			M.unEquip(src)
			qdel(src)
		return

	// Grab fire data from our components.
	if(barrel.caliber) caliber = barrel.caliber
	chamber.reset_max_shots()
	max_shots = chamber.max_shots

	// To avoid writing over/mixing up.
	firemodes = chamber.firemodes.Copy()

	// Nested lists in DM are horrible.
	if(barrel.firemodes && barrel.firemodes.len)
		for(var/list/L in barrel.firemodes)
			firemodes += list(L.Copy())

	// Update physical variables.
	slot_flags = body.slot_flags
	w_class = 1
	for(var/obj/item/gun_component/GC in list(body, chamber, barrel, grip, stock))
		if(GC && GC.w_class > w_class)
			w_class = GC.w_class

	fire_sound = barrel.fire_sound
	fire_delay = chamber.fire_delay
	silenced = 0
	verbs -= /obj/item/weapon/gun/composite/proc/scope
	one_hand_penalty = body.two_handed

	attack_verb = initial(attack_verb)
	force = body.force

	for(var/obj/item/gun_component/GC in list(body, chamber, barrel, grip, stock) + accessories)
		if (!GC) continue
		GC.holder = src
		GC.installed(src)
		GC.apply_mod(src)
		if(!gun_type) gun_type = GC.weapon_type
		if(!dam_type) dam_type = GC.projectile_type
		if(GC.model)
			if(isnull(model))
				model = GC.model
			else if(model != GC.model)
				model = 0
		else if(model)
			model = 0
	if(!gun_type)
		gun_type = "gun"

	// Update based on model modifiers.
	if(model && model.produced_by)
		if(!isnull(model.produced_by.accuracy))
			accuracy = round(accuracy * model.produced_by.accuracy)
		if(!isnull(model.produced_by.capacity))
			chamber.apply_shot_mod(model.produced_by.capacity)
			max_shots = chamber.max_shots
		if(!isnull(model.produced_by.recoil))
			recoil = round(recoil * model.produced_by.recoil)
		if(!isnull(model.produced_by.fire_rate))
			fire_delay = round(fire_delay * model.produced_by.fire_rate)
		if(!isnull(model.produced_by.weight))
			w_class = round(w_class * model.produced_by.weight)

	w_class = Clamp(w_class,1,5)

	if(dam_type == GUN_TYPE_LASER)
		recoil = 0

	update_icon(regenerate=1)
	update_strings()

/obj/item/weapon/gun/composite/proc/update_strings()
	if(model)
		if(model.force_gun_name)
			name = "\improper [model.force_gun_name]"
		else
			if(model.produced_by.manufacturer_short != "unbranded")
				name = "\improper [model.produced_by.manufacturer_short] [get_gun_name(src, dam_type, gun_type)]"
			else
				name = "\improper [get_gun_name(src, dam_type, gun_type)]"
		desc = "The casing is stamped with '[model.model_name]'. [model.model_desc]"
		if(model.produced_by.manufacturer_short != "unbranded")
			desc += " It's stamped with the [model.produced_by.manufacturer_name] logo. [model.produced_by.casing_desc]"

	else
		name = "[get_gun_name(src, dam_type, gun_type)]"
		desc = "[body.base_desc] You can't work out who manufactured this one; it might be an aftermarket job."

/obj/item/weapon/gun/composite/update_icon(var/ignore_inhands, var/regenerate = 0)

	if(force_icon && force_icon_state)
		icon = force_icon
		icon_state = force_icon_state
	else
		if (regenerate)
			icon_state = ""
			if(model && model.force_item_state)
				item_state = model.force_item_state
			else
				item_state = body.item_state
			if(body.slot_flags & SLOT_BACK)
				item_state_slots[slot_back_str] = body.item_state

	overlays.Cut()
	if(chamber)
		chamber.update_ammo_overlay()
	var/list/overlays_to_add = list()
	for(var/obj/item/gun_component/GC in list(body, barrel, grip, stock, chamber) + accessories)
		if(GC)
			GC.layer = layer
			overlays_to_add += GC

	overlays += overlays_to_add

	if(one_hand_penalty)
		var/mob/user = loc
		if(istype(user) && (user.can_wield_item(src) && src.is_held_twohanded(user)))
			if(body.wielded_state)
				item_state = body.wielded_state
		else if(body)
			item_state = body.item_state

/obj/item/weapon/gun/composite/AltClick()
	if(!(src in usr))
		return ..()
	var/list/possible_interactions = list()
	for(var/obj/item/gun_component/GC in contents)
		if(GC.has_alt_interaction)
			possible_interactions += GC
	if(!possible_interactions.len)
		return ..()
	var/obj/item/gun_component/chosen = possible_interactions[1]
	if(possible_interactions.len > 1)
		chosen = input("What do you wish to interact with?") as null|anything in possible_interactions
	if(chosen && (chosen in src) && chosen.do_user_alt_interaction(usr))
		return
	return ..()

/obj/item/weapon/gun/composite/proc/explode()

	// Grab refs.
	var/mob/M = loc
	var/turf/T = get_turf(src)
	if(istype(M))
		M.unEquip(src)

	// EXPLODE.
	visible_message("<span class='danger'>\The [src] blows apart!</span>")
	for(var/obj/item/gun_component/I in src)
		I.forceMove(T)
		if(istype(I)) I.empty()
		if(prob(25))
			qdel(src)
			continue
		spawn(1)
			I.throw_at(get_edge_target_turf(src,pick(alldirs)),rand(1,3),rand(10,20))

	// Destroy self.
	accessories.Cut()
	barrel = null
	body = null
	grip = null
	stock = null
	chamber = null
	qdel(src)

/obj/item/weapon/gun/composite/proc/jam()
	if(jammed) return
	var/mob/M = loc
	if(istype(M))
		M << "<span class='danger'>\The [src] jams!</span>"
	jammed = 1

/obj/item/weapon/gun/composite/attack_self(var/mob/user)
	if(!(src in usr))
		return ..()

	if(jammed)
		user.setClickCooldown(rand(5,10))
		if(prob(30))
			user.visible_message("<span class='notice'>\The [user] unjams \the [src]!</span>")
			jammed = 0
		else
			user.visible_message("<span class='notice'>\The [user] attempts to unjam \the [src]!</span>")
		return

	var/list/possible_interactions = list()
	if(firemodes.len)
		possible_interactions += "change fire mode"
	for(var/obj/item/gun_component/GC in contents)
		if(GC.has_user_interaction)
			possible_interactions += GC
	if(!possible_interactions.len)
		return
	var/obj/item/gun_component/chosen = possible_interactions[1]
	if(possible_interactions.len > 1)
		chosen = input("What do you wish to interact with?") as null|anything in possible_interactions
	if(chosen == "change fire mode")
		switch_firemodes(user)
	else if(istype(chosen) && (chosen in src))
		chosen.do_user_interaction(usr)
	return

/obj/item/weapon/gun/composite/switch_firemodes(var/mob/user)
	var/datum/firemode/new_mode = ..()
	barrel.caliber = caliber
	barrel.update_from_caliber()
	if(new_mode)
		user << "<span class='notice'>\The [src] is now set to [new_mode.name].</span>"
	return new_mode