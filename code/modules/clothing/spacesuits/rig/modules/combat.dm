/*
 * Contains
 * /obj/item/rig_module/device/flash
 * /obj/item/rig_module/device/flash/advanced
 * /obj/item/rig_module/grenade_launcher (cleaner, smoke, mfoam)
 * /obj/item/rig_module/mounted
 * /obj/item/rig_module/mounted/lcannon
 * /obj/item/rig_module/mounted/egun
 * /obj/item/rig_module/mounted/taser
 * /obj/item/rig_module/mounted/plasmacutter
 * /obj/item/rig_module/mounted/energy_blade
 * /obj/item/rig_module/fabricator
 * /obj/item/rig_module/fabricator/wf_sign
 * /obj/item/rig_module/mounted/arm_blade
 * /obj/item/rig_module/mounted/power_fist
 */

/obj/item/rig_module/device/flash
	name = "mounted flash"
	desc = "You are the law."
	icon_state = "flash"

	selectable = 0
	toggleable = 1
	activates_on_touch = 1
	module_cooldown = 0
	usable = 1
	active_power_cost = 100
	use_power_cost = 18000 //10 Whr

	engage_string = "Flash"
	activate_string = "Activate Flash Module"
	deactivate_string = "Deactivate Flash Module"

	interface_name = "mounted flash"
	interface_desc = "Disorientates your target by blinding them with this intense palm-mounted light."
	device = /obj/item/device/flash
	origin_tech = list(TECH_COMBAT = 2, TECH_MAGNET = 3, TECH_ENGINEERING = 5)

/obj/item/rig_module/device/flash/advanced
	name = "advanced mounted flash"
	device = /obj/item/device/flash/advanced
	origin_tech = list(TECH_COMBAT = 3, TECH_MAGNET = 3, TECH_ENGINEERING = 5)

/obj/item/rig_module/device/flash/installed()
	. = ..()
	if(!holder.glove_type)//gives select option for gloveless suits, why even use rig at this point
		selectable = 1
		activates_on_touch = 0
		toggleable = 0
	else
		selectable = 0
		activates_on_touch = 1
		toggleable = 1

/obj/item/rig_module/device/flash/engage(atom/target)
	if(!check() || !device)
		return 0

	if(!holder.cell.check_charge(use_power_cost * CELLRATE))
		to_chat(holder.wearer,SPAN_WARNING("Not enough stored power."))
		return 0

	if(!target)
		if(device.attack_self(holder.wearer))
			holder.cell.use(use_power_cost * CELLRATE)
		return 1

	if(!target.Adjacent(holder.wearer) || !ismob(target))
		return 0

	var/resolved = device.resolve_attackby(target,holder.wearer)
	if(resolved)
		holder.cell.use(use_power_cost * CELLRATE)
	return resolved

/obj/item/rig_module/device/flash/activate()
	if(active || !check())
		return

	to_chat(holder.wearer, SPAN_NOTICE("Your hardsuit gauntlets heat up and lock into place, ready to be used."))
	playsound(src.loc, 'sound/items/goggles_charge.ogg', 20, 1)
	active = 1

/obj/item/rig_module/grenade_launcher
	name = "mounted grenade launcher"
	desc = "A forearm-mounted micro-explosive dispenser."
	selectable = 1
	icon_state = "grenadelauncher"
	use_power_cost = 2 KILOWATTS	// 2kJ per shot, a mass driver that propels the grenade?

	suit_overlay_active = "grenade"

	interface_name = "integrated grenade launcher"
	interface_desc = "Discharges loaded grenades against the wearer's location."

	var/fire_force = 30
	var/fire_distance = 10

	charges = list(
		list("flashbang",   "flashbang",   /obj/item/grenade/flashbang,  3),
		list("smoke bomb",  "smoke bomb",  /obj/item/grenade/smokebomb,  3),
		list("EMP grenade", "EMP grenade", /obj/item/grenade/empgrenade, 3),
		)

/obj/item/rig_module/grenade_launcher/accepts_item(obj/item/input_device, mob/living/user)

	if(!istype(input_device) || !istype(user))
		return 0

	var/datum/rig_charge/accepted_item
	for(var/charge in charges)
		var/datum/rig_charge/charge_datum = charges[charge]
		if(input_device.type == charge_datum.product_type)
			accepted_item = charge_datum
			break

	if(!accepted_item)
		return 0

	if(accepted_item.charges >= 5)
		to_chat(user, SPAN_DANGER("Another grenade of that type will not fit into the module."))
		return 0

	to_chat(user, SPAN_INFO("<b>You slot \the [input_device] into the suit module.</b>"))
	qdel(input_device)
	accepted_item.charges++
	return 1

/obj/item/rig_module/grenade_launcher/engage(atom/target)

	if(!..())
		return 0

	if(!target)
		return 0

	var/mob/living/carbon/human/H = holder.wearer

	if(!charge_selected)
		to_chat(H, SPAN_DANGER("You have not selected a grenade type."))
		return 0

	var/datum/rig_charge/charge = charges[charge_selected]

	if(!charge)
		return 0

	if(charge.charges <= 0)
		to_chat(H, SPAN_DANGER("Insufficient grenades!"))
		return 0

	charge.charges--
	var/obj/item/grenade/new_grenade = new charge.product_type(get_turf(H))
	H.visible_message(SPAN_DANGER("[H] launches \a [new_grenade]!"))
	log_and_message_admins("fired a grenade ([new_grenade.name]) from a rigsuit grenade launcher.")
	new_grenade.activate(H)
	new_grenade.throw_at(target,fire_force,fire_distance)

/obj/item/rig_module/grenade_launcher/cleaner
	name = "mounted cleaning grenade launcher"
	interface_name = "cleaning grenade launcher"
	desc = "A shoulder-mounted micro-explosive dispenser designed only to accept standard cleaning foam grenades."

	charges = list(
		list("cleaning grenade",   "cleaning grenade",   /obj/item/grenade/chem_grenade/cleaner,  9),
		)

/obj/item/rig_module/grenade_launcher/smoke
	name = "mounted smoke grenade launcher"
	interface_name = "smoke grenade launcher"
	desc = "A shoulder-mounted micro-explosive dispenser designed only to accept standard smoke grenades."

	charges = list(
		list("smoke bomb",   "smoke bomb",   /obj/item/grenade/smokebomb,  6),
		)

/obj/item/rig_module/grenade_launcher/mfoam
	name = "mounted foam grenade launcher"
	interface_name = "foam grenade launcher"
	desc = "A shoulder-mounted micro-explosive dispenser designed only to accept standard metal foam grenades."

	charges = list(
		list("metal foam grenade",   "metal foam grenade",   /obj/item/grenade/chem_grenade/metalfoam,  4),
		)

/obj/item/rig_module/grenade_launcher/light
	name = "mounted illumination grenade launcher"
	interface_name = "illumination grenade launcher"
	desc = "A shoulder-mounted micro-explosive dispenser designed only to accept standard illumination grenades."

	charges = list(
		list("illumination grenade",   "illumination grenade",   /obj/item/grenade/light,  6),
		)

/obj/item/rig_module/mounted ///Separated into energy and ballistics to allow their respective interactions

	name = "mounted gun"
	desc = "Some sort of mounted gun."
	selectable = 1
	usable = 1
	module_cooldown = 0
	icon_state = "lcannon"

	suit_overlay_active = "mounted-lascannon"

	engage_string = "Configure"

	interface_name = "mounted gun"
	interface_desc = "A suit mounted gun."


/obj/item/rig_module/mounted/energy
	abstract_type = /obj/item/rig_module/mounted/energy
	var/obj/item/gun/energy/laser

/obj/item/rig_module/mounted/energy/Initialize()
	. = ..()
	if (ispath(laser))
		laser = new laser(src)
		laser.canremove = FALSE

/obj/item/rig_module/mounted/energy/engage(atom/target)

	if (!..() || !laser)
		return FALSE

	if (!target)
		laser.attack_self(holder.wearer)
		return

	laser.Fire(target,holder.wearer)
	return TRUE

/obj/item/rig_module/mounted/ballistic
	abstract_type = /obj/item/rig_module/mounted/ballistic
	var/obj/item/gun/projectile/ballistic

/obj/item/rig_module/mounted/ballistic/Initialize()
	. = ..()
	if (ispath(ballistic))
		ballistic = new ballistic(src)
		ballistic.canremove = FALSE

/obj/item/rig_module/mounted/ballistic/engage(atom/target)

	if (!..() || !ballistic)
		return FALSE

	if (!target)
		ballistic.attack_self(holder.wearer)
		return

	ballistic.Fire(target,holder.wearer)
	return TRUE

/obj/item/rig_module/mounted/ballistic/accepts_item(obj/item/input, mob/living/user)
	var /obj/item/rig/rig = get_rig(src)

	if (!istype(input) || !istype(user) || !rig)
		return FALSE

	if (ismagazine(input) && ballistic.ammo_magazine) /// Weapon will attempt to eject the current magazine/ammo if it is loaded when a new magazine is used on it.
		ballistic.unload_ammo(user, FALSE)

	else /// Weapon will load normally if no magazine is present
		ballistic.load_ammo(input, user)

/obj/item/rig_module/mounted/energy/lcannon

	name = "mounted laser cannon"
	desc = "A shoulder-mounted battery-powered laser cannon mount."
	usable = 0

	interface_name = "mounted laser cannon"
	interface_desc = "A shoulder-mounted cell-powered laser cannon."
	origin_tech = list(TECH_POWER = 6, TECH_COMBAT = 6, TECH_ENGINEERING = 6)

	laser = /obj/item/gun/energy/lasercannon/mounted

/obj/item/rig_module/mounted/energy/ion

	name = "mounted ion gun"
	desc = "A shoulder-mounted battery-powered ion gun mount."
	usable = 0

	interface_name = "mounted ion gun"
	interface_desc = "A shoulder-mounted cell-powered ion gun."
	origin_tech = list(TECH_POWER = 6, TECH_COMBAT = 6, TECH_ENGINEERING = 6)

	laser = /obj/item/gun/energy/ionrifle/mounted

/obj/item/rig_module/mounted/energy/egun

	name = "mounted energy gun"
	desc = "A shoulder-mounted energy projector."
	icon_state = "egun"

	suit_overlay_active = "mounted-taser"

	interface_name = "mounted energy gun"
	interface_desc = "A shoulder-mounted suit-powered energy gun."
	origin_tech = list(TECH_POWER = 6, TECH_COMBAT = 6, TECH_ENGINEERING = 6)

	laser = /obj/item/gun/energy/gun/mounted

/obj/item/rig_module/mounted/energy/taser

	name = "mounted electrolaser"
	desc = "A shoulder-mounted nonlethal energy projector."
	icon_state = "taser"
	usable = 0

	suit_overlay_active = "mounted-taser"

	interface_name = "mounted electrolaser"
	interface_desc = "A shoulder-mounted, cell-powered electrolaser."
	origin_tech = list(TECH_POWER = 5, TECH_COMBAT = 5, TECH_ENGINEERING = 6)

	laser = /obj/item/gun/energy/taser/mounted

/obj/item/rig_module/mounted/energy/plasmacutter

	name = "mounted plasma cutter"
	desc = "A forearm-mounted plasma cutter."
	icon_state = "plasmacutter"
	usable = 0

	suit_overlay_active = "plasmacutter"

	interface_name = "mounted plasma cutter"
	interface_desc = "A forearm-mounted suit-powered plasma cutter."
	origin_tech = list(TECH_MATERIAL = 5, TECH_PHORON = 4, TECH_ENGINEERING = 7, TECH_COMBAT = 5)

	laser = /obj/item/gun/energy/plasmacutter/mounted

/obj/item/rig_module/mounted/energy/plasmacutter/engage(atom/target)

	if(!check() || !laser)
		return 0

	if(holder.wearer.a_intent == I_HURT || !target.Adjacent(holder.wearer))
		laser.Fire(target,holder.wearer)
		return 1
	else
		var/resolved = target.attackby(laser,holder.wearer)
		if(!resolved && laser && target)
			laser.afterattack(target,holder.wearer,1)
			return 1

/obj/item/rig_module/mounted/energy/energy_blade

	name = "energy blade projector"
	desc = "A powerful cutting beam projector."
	icon_state = "eblade"

	suit_overlay_active = null

	activate_string = "Project Blade"
	deactivate_string = "Cancel Blade"

	interface_name = "spider fang blade"
	interface_desc = "A lethal energy projector that can shape a blade projected from the hand of the wearer or launch radioactive darts."

	usable = 0
	selectable = 1
	toggleable = 1
	use_power_cost = 10 KILOWATTS
	active_power_cost = 0.5 KILOWATTS
	passive_power_cost = 0

	laser = /obj/item/gun/energy/crossbow/ninja/mounted

/obj/item/rig_module/mounted/energy/energy_blade/Process()

	if(holder && holder.wearer)
		if(!(locate(/obj/item/melee/energy/blade) in holder.wearer))
			deactivate()
			return 0

	return ..()

/obj/item/rig_module/mounted/energy/energy_blade/activate()
	var/mob/living/M = holder.wearer

	if (!M.HasFreeHand())
		to_chat(M, SPAN_DANGER("Your hands are full."))
		deactivate()
		return

	var/obj/item/melee/energy/blade/blade = new(M)
	blade.creator = M
	M.put_in_hands(blade)

	if(!..() || !laser)
		return 0

/obj/item/rig_module/mounted/energy/energy_blade/deactivate()

	..()

	var/mob/living/M = holder.wearer

	if(!M)
		return

	for(var/obj/item/melee/energy/blade/blade in M.contents)
		qdel(blade)

/obj/item/rig_module/mounted/ballistic/minigun

	name = "mounted minigun"
	desc = "An arm-mounted minigun. Reloading this looks like a pain."
	icon_state = "egun"

	suit_overlay_active = "mounted-taser"

	interface_name = "mounted minigun"
	interface_desc = "An arm-mounted minigun. While it carries a large amount of ammo, reloading it takes a very long time. Use an ammo box on your suit control module to reload."
	origin_tech = list(TECH_POWER = 4, TECH_COMBAT = 8, TECH_ENGINEERING = 6)

	ballistic = /obj/item/gun/projectile/automatic/minigun/mounted ///Reloading handled in automatic.dm

/obj/item/rig_module/fabricator

	name = "matter fabricator"
	desc = "A self-contained microfactory system for hardsuit integration."
	selectable = 1
	usable = 1
	use_power_cost = 5 KILOWATTS
	icon_state = "enet"

	engage_string = "Fabricate Star"

	interface_name = "death blossom launcher"
	interface_desc = "An integrated microfactory that produces poisoned throwing stars from thin air and electricity."

	var/fabrication_type = /obj/item/material/star/ninja
	var/fire_force = 30
	var/fire_distance = 10

/obj/item/rig_module/fabricator/engage(atom/target)

	if(!..())
		return 0

	var/mob/living/H = holder.wearer

	if(target)
		var/obj/item/firing = new fabrication_type()
		firing.dropInto(loc)
		H.visible_message(SPAN_DANGER("[H] launches \a [firing]!"))
		firing.throw_at(target,fire_force,fire_distance)
	else
		if (!H.HasFreeHand())
			to_chat(H, SPAN_DANGER("Your hands are full."))
		else
			var/obj/item/new_weapon = new fabrication_type()
			new_weapon.forceMove(H)
			to_chat(H, SPAN_INFO("<b>You quickly fabricate \a [new_weapon].</b>"))
			H.put_in_hands(new_weapon)

	return 1

/obj/item/rig_module/fabricator/wf_sign
	name = "wet floor sign fabricator"
	use_power_cost = 50 KILOWATTS
	engage_string = "Fabricate Sign"

	interface_name = "work saftey launcher"
	interface_desc = "An integrated microfactory that produces wet floor signs from thin air and electricity."

	fabrication_type = /obj/item/caution

/obj/item/rig_module/actuators /// While on, will dampen the fall from any height and scale power usage accordingly. Enables the user to also jump up 1 z-level.
	name = "agility enhancement actuators"
	desc = "A set of electromechanical actuators that drastically increase a hardsuit's mobility. They allow the suit to be able to absorb impacts from long falls and leap incredible distances."
	icon_state = "actuators"

	interface_name = "leg actuators"
	interface_desc = "Allows you to fall from heights without taking damage and quickly jump up a level if there is something above you."

	use_power_cost = 50 KILOWATTS
	module_cooldown = 10 SECONDS
	toggleable = TRUE
	selectable = TRUE
	usable = FALSE
	/// Combat versions are able to lunge at mobs and grab them.
	var/combatType = TRUE
	/// Leaping radius. Inclusive. Applies to diagonal distances.
	var/leapDistance = 4
	engage_string = "Toggle Powered Lunge"
	activate_string = "Engage Mobility Enhancement"
	deactivate_string = "Disable Mobility Enhancement"


/obj/item/rig_module/actuators/engage(atom/target, mob/user)
	if (!..())
		return FALSE

	if (!target)
		return TRUE

	var/mob/living/carbon/human/H = holder.wearer

	if (!isturf(H.loc))
		to_chat(H, SPAN_WARNING("You cannot leap out of your current location!"))
		return FALSE

	var/turf/T = get_turf(target)

	if (!T || T.density)
		to_chat(H, SPAN_WARNING("You cannot leap at solid walls!"))
		return FALSE

	var/dist = max(get_dist(T, get_turf(H)), 0) /// The target the user has selected

	if (dist)
		for (var/A in T)
			var/atom/aA = A
			if (combatType && ismob(aA)) /// Combat versions of this module allow you to leap at mobs
				continue

			if (aA.density)
				to_chat(H, SPAN_WARNING("You cannot leap at a location with solid objects on it!"))
				return FALSE

	if (T.z != H.z || dist > leapDistance)
		to_chat(H, SPAN_WARNING("You cannot leap at such a distant object!"))
		return FALSE

	if (dist)
		H.visible_message(SPAN_WARNING("\The [H]'s suit whirrs aggressively, launching them towards \the [target]!"),
			SPAN_WARNING("Your suit whirrs aggressively, launching you towards \the [target]!"),
			SPAN_WARNING("You hear an electric <i>whirr</i> followed by a weighty thump!"))
		H.face_atom(T)
		H.throw_at(T, leapDistance, 0.5, H, FALSE)
		return TRUE

/obj/item/rig_module/mounted/arm_blade

	name = "forearm-mounted armblades"
	desc = "A pair of steel armblades to be mounted onto a hardsuit."
	icon_state = "module"

	suit_overlay_active = null

	activate_string = "Extend Blade"
	deactivate_string = "Retract Blade"

	interface_name = "forearm-mounted blade"
	interface_desc = "A pair of steel armblades built into each forearm of your hardsuit."

	usable = 0
	selectable = 0
	toggleable = 1
	use_power_cost = 10 KILOWATTS
	active_power_cost = 0.5 KILOWATTS
	passive_power_cost = 0

/obj/item/rig_module/mounted/arm_blade/Process()

	if(holder && holder.wearer)
		if(!(locate(/obj/item/material/armblade) in holder.wearer))
			deactivate()
			return 0

	return ..()

/obj/item/rig_module/mounted/arm_blade/activate()
	var/mob/living/M = holder.wearer

	if (!M.HasFreeHand())
		to_chat(M, SPAN_DANGER("Your hands are full."))
		deactivate()
		return

	var/obj/item/material/armblade/mounted/blade = new(M)
	M.put_in_hands(blade)

	if(!..())
		return 0

/obj/item/rig_module/mounted/arm_blade/deactivate()

	..()

	var/mob/living/M = holder.wearer

	if(!M)
		return

	for(var/obj/item/material/armblade/mounted/blade in M.contents)
		qdel(blade)

/obj/item/rig_module/mounted/power_fist

	name = "hand-mounted powerfists"
	desc = "A pair of heavy powerfists to be installed into a hardsuit gauntlets."
	icon_state = "module"

	suit_overlay_active = null

	activate_string = "Power up Fist"
	deactivate_string = "Power off Fist"

	interface_name = "hand-mounted powerfists"
	interface_desc = "A pair of heavy powerfists to be installed into a hardsuit gauntlets."

	usable = 0
	selectable = 0
	toggleable = 1
	use_power_cost = 10 KILOWATTS
	active_power_cost = 5 KILOWATTS
	passive_power_cost = 0

/obj/item/rig_module/mounted/power_fist/Process()

	if(holder && holder.wearer)
		if(!(locate(/obj/item/melee/powerfist/mounted) in holder.wearer))
			deactivate()
			return 0

	return ..()

/obj/item/rig_module/mounted/power_fist/activate()
	var/mob/living/M = holder.wearer

	if (!M.HasFreeHand())
		to_chat(M, SPAN_DANGER("Your hands are full."))
		deactivate()
		return

	var/obj/item/melee/powerfist/mounted/blade = new(M)
	M.put_in_hands(blade)

	if(!..())
		return 0

/obj/item/rig_module/mounted/power_fist/deactivate()

	..()

	var/mob/living/M = holder.wearer

	if(!M)
		return

	for(var/obj/item/melee/powerfist/mounted/blade in M.contents)
		qdel(blade)
