/*
	A tool upgrade is a little attachment for a tool that improves it in some way
	Tool upgrades are generally permanant

	Some upgrades have multiple bonuses. Some have drawbacks in addition to boosts
*/

/*/client/verb/debugupgrades()
	for (var/t in subtypesof(/obj/item/weapon/tool_upgrade))
		new t(usr.loc)
*/

/obj/item/weapon/tool_upgrade
	name = "tool upgrade"
	icon = 'icons/obj/tool_upgrades.dmi'
	force = WEAPON_FORCE_HARMLESS
	w_class = ITEM_SIZE_SMALL
	//price_tag = 200

	var/prefix = "upgraded" //Added to the tool's name

	//The upgrade can be applied to a tool that has any of these qualities
	var/list/required_qualities = list()

	//If true, can only be applied to tools that use fuel
	var/req_fuel = FALSE

	//If true, can only be applied to tools that use a power cell
	var/req_cell = FALSE

	var/obj/item/weapon/tool/holder = null //The tool we're installed into
	matter = list(MATERIAL_STEEL = 1)

	//Actual effects of upgrades
	var/precision = 0
	var/workspeed = 0
	var/degradation_mult = 1
	var/force_mult = 1	//Multiplies weapon damage
	var/force_mod = 0	//Adds a flat value to weapon damage
	var/powercost_mult = 1
	var/fuelcost_mult = 1
	var/bulk_mod = 0

/obj/item/weapon/tool_upgrade/examine(var/mob/user)
	.=..()
	if (precision > 0)
		user << SPAN_NOTICE("Enhances precision by [precision]")
	else if (precision < 0)
		user << SPAN_WARNING("Reduces precision by [abs(precision)]")
	if (workspeed)
		user << SPAN_NOTICE("Enhances workspeed by [workspeed*100]%")

	if (degradation_mult < 1)
		user << SPAN_NOTICE("Reduces tool degradation by [(1-degradation_mult)*100]%")
	else if	(degradation_mult > 1)
		user << SPAN_WARNING("Increases tool degradation by [(degradation_mult-1)*100]%")

	if (force_mult != 1)
		user << SPAN_NOTICE("Increases tool damage by [(force_mult-1)*100]%")
	if (force_mod)
		user << SPAN_NOTICE("Increases tool damage by [force_mod]")
	if (powercost_mult != 1)
		user << SPAN_WARNING("Modifies power usage by [(powercost_mult-1)*100]%")
	if (fuelcost_mult != 1)
		user << SPAN_WARNING("Modifies fuel usage by [(fuelcost_mult-1)*100]%")
	if (bulk_mod)
		user << SPAN_WARNING("Increases tool size by [bulk_mod]")

	if (required_qualities.len)
		user << SPAN_WARNING("Requires a tool with one of the following qualities:")
		user << english_list(required_qualities, and_text = " or ")



/******************************
	CORE CODE
******************************/


/obj/item/weapon/tool_upgrade/afterattack(obj/O, mob/user, proximity)

	if(!proximity) return
	try_apply(O, user)

/obj/item/weapon/tool_upgrade/proc/try_apply(var/obj/item/weapon/tool/O, var/mob/user)
	if (!can_apply(O, user))
		return

	apply(O, user)


/obj/item/weapon/tool_upgrade/proc/can_apply(var/obj/item/weapon/tool/T, var/mob/user)
	if (isrobot(T))
		var/mob/living/silicon/robot/R = T
		if(!R.opened)
			user << SPAN_WARNING("You need to open [R]'s panel to access its tools.")
		var/list/robotools = list()
		for(var/obj/item/weapon/tool/robotool in R.module.modules)
			robotools.Add(robotool)
		if(robotools.len)
			var/obj/item/weapon/tool/chosen_tool = input(user,"Which tool are you trying to modify?","Tool Modification","Cancel") in robotools + "Cancel"
			if(chosen_tool == "Cancel")
				return
			try_apply(chosen_tool,user)
		else
			user << SPAN_WARNING("[R] has no modifiable tools.")
		return

	if (!istool(T))
		user << SPAN_WARNING("This can only be applied to a tool!")
		return

	if (T.upgrades.len >= T.max_upgrades)
		user << SPAN_WARNING("This tool can't fit anymore modifications!")
		return

	if (required_qualities.len)
		var/qmatch = FALSE
		for (var/q in required_qualities)
			if (T.ever_has_quality(q))
				qmatch = TRUE
				break

		if (!qmatch)
			user << SPAN_WARNING("This tool lacks the required qualities!")
			return

	if (req_fuel && !T.use_fuel_cost)
		user << SPAN_WARNING("This tool doesn't use fuel!")
		return

	if (req_cell && !T.use_power_cost)
		user << SPAN_WARNING("This tool doesn't use power!")
		return

	//No using multiples of the same upgrade
	for (var/obj/item/weapon/tool_upgrade/U in T.upgrades)
		if (U.type == type)
			user << SPAN_WARNING("An upgrade of this type is already installed!")
			return

	return TRUE


//Applying an upgrade to a tool is a mildly difficult process
/obj/item/weapon/tool_upgrade/proc/apply(var/obj/item/weapon/tool/T, var/mob/user)

	if (user)
		user.visible_message(SPAN_NOTICE("[user] starts applying the [src] to [T]"), SPAN_NOTICE("You start applying the [src] to [T]"))
		if (!use_tool(user = user, target =  T, base_time = WORKTIME_NORMAL, required_quality = null, fail_chance = FAILCHANCE_EASY+T.unreliability, required_stat = "construction", forced_sound = WORKSOUND_WRENCHING))
			return
		user << SPAN_NOTICE("You have successfully installed [src] in [T]")
		user.drop_from_inventory(src)
	//If we get here, we succeeded in the applying
	holder = T
	forceMove(T)
	T.upgrades.Add(src)
	T.refresh_upgrades()


//This does the actual numerical changes.
//The tool itself asks us to call this, and it resets itself before doing so
/obj/item/weapon/tool_upgrade/proc/apply_values()
	if (!holder)
		return

	holder.precision += precision
	holder.workspeed += workspeed
	holder.degradation *= degradation_mult
	holder.force *= force_mult
	holder.switched_on_force *= force_mult
	holder.force += force_mod
	holder.switched_on_force += force_mod
	holder.use_fuel_cost *= fuelcost_mult
	holder.use_power_cost *= powercost_mult
	holder.extra_bulk += bulk_mod
	holder.prefixes |= prefix
	return TRUE