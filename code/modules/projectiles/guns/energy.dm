GLOBAL_LIST_INIT(registered_weapons, list())

/obj/item/weapon/gun/energy
	name = "energy gun"
	desc = "A basic energy-based gun."
	icon_state = "energy"
	fire_sound = 'sound/weapons/Taser.ogg'
	fire_sound_text = "laser blast"

	var/obj/item/weapon/cell/power_supply //What type of power cell this uses
	var/charge_cost = 20 //How much energy is needed to fire.
	var/max_shots = 10 //Determines the capacity of the weapon's power cell. Specifying a cell_type overrides this value.
	var/cell_type = null
	var/projectile_type = /obj/item/projectile/beam/practice
	var/modifystate
	var/charge_meter = 1	//if set, the icon state will be chosen based on the current charge

	//self-recharging
	var/self_recharge = 0	//if set, the weapon will recharge itself
	var/use_external_power = 0 //if set, the weapon will look for an external power source to draw from, otherwise it recharges magically
	var/recharge_time = 4
	var/charge_tick = 0
	var/icon_rounder = 25
	combustion = 1

/obj/item/weapon/gun/energy/switch_firemodes()
	. = ..()
	if(.)
		update_icon()

/obj/item/weapon/gun/energy/emp_act(severity)
	..()
	update_icon()

/obj/item/weapon/gun/energy/New()
	..()
	if(cell_type)
		power_supply = new cell_type(src)
	else
		power_supply = new /obj/item/weapon/cell/device/variable(src, max_shots*charge_cost)
	if(self_recharge)
		START_PROCESSING(SSobj, src)
	update_icon()

/obj/item/weapon/gun/energy/Destroy()
	if(self_recharge)
		STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/weapon/gun/energy/Process()
	if(self_recharge) //Every [recharge_time] ticks, recharge a shot for the cyborg
		charge_tick++
		if(charge_tick < recharge_time) return 0
		charge_tick = 0

		if(!power_supply || power_supply.charge >= power_supply.maxcharge)
			return 0 // check if we actually need to recharge

		if(use_external_power)
			var/obj/item/weapon/cell/external = get_external_power_supply()
			if(!external || !external.use(charge_cost)) //Take power from the borg...
				return 0

		power_supply.give(charge_cost) //... to recharge the shot
		update_icon()
	return 1

/obj/item/weapon/gun/energy/consume_next_projectile()
	if(!power_supply) return null
	if(!ispath(projectile_type)) return null
	if(!power_supply.checked_use(charge_cost)) return null
	return new projectile_type(src)

/obj/item/weapon/gun/energy/proc/get_external_power_supply()
	if(isrobot(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		return R.cell
	if(istype(src.loc, /obj/item/rig_module))
		var/obj/item/rig_module/module = src.loc
		if(module.holder && module.holder.wearer)
			var/mob/living/carbon/human/H = module.holder.wearer
			if(istype(H) && H.back)
				var/obj/item/weapon/rig/suit = H.back
				if(istype(suit))
					return suit.cell
	return null

/obj/item/weapon/gun/energy/examine(mob/user)
	. = ..(user)
	var/shots_remaining = round(power_supply.charge / charge_cost)
	to_chat(user, "Has [shots_remaining] shot\s remaining.")
	return

/obj/item/weapon/gun/energy/update_icon()
	..()
	if(charge_meter)
		var/ratio = power_supply.percent()

		//make sure that rounding down will not give us the empty state even if we have charge for a shot left.
		if(power_supply.charge < charge_cost)
			ratio = 0
		else
			ratio = max(round(ratio, icon_rounder), icon_rounder)

		if(modifystate)
			icon_state = "[modifystate][ratio]"
		else
			icon_state = "[initial(icon_state)][ratio]"

/obj/item/weapon/gun/energy/secure
	desc = "A basic energy-based gun with a secure authorization chip."
	req_access = list(access_brig)
	var/list/authorized_modes = list(ALWAYS_AUTHORIZED) // index of this list should line up with firemodes, unincluded firemodes at the end will default to unauthorized
	var/registered_owner
	var/emagged = 0

/obj/item/weapon/gun/energy/secure/Initialize()
	if(!authorized_modes)
		authorized_modes = list()

	for(var/i = authorized_modes.len + 1 to firemodes.len)
		authorized_modes.Add(UNAUTHORIZED)

	. = ..()

/obj/item/weapon/gun/energy/secure/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/card/id))
		if(!emagged)
			if(!registered_owner)
				if(allowed(user))
					var/obj/item/weapon/card/id/id = W
					GLOB.registered_weapons += src
					registered_owner = id.registered_name
					user.visible_message("[user] swipes an ID through \the [src], registering it.", "You swipe an ID through \the [src], registering it.")
				else
					to_chat(user, "<span class='warning'>Access denied.</span>")
			else
				to_chat(user, "This weapon is already registered, you must reset it first.")
		else
			to_chat(user, "You swipe your ID, but nothing happens.")
	else
		..()

/obj/item/weapon/gun/energy/secure/verb/reset()
	set name = "Reset Registration"
	set category = "Object"
	set src in usr

	if(issilicon(usr))
		return

	if(allowed(usr))
		usr.visible_message("[usr] presses the reset button on \the [src], resetting its registration.", "You press the reset button on \the [src], resetting its registration.")
		registered_owner = null
		GLOB.registered_weapons -= src

/obj/item/weapon/gun/energy/secure/Destroy()
	GLOB.registered_weapons -= src

	. = ..()

/obj/item/weapon/gun/energy/secure/proc/authorize(var/mode, var/authorized, var/by)
	if(emagged || mode < 1 || mode > authorized_modes.len || authorized_modes[mode] == authorized)
		return 0

	authorized_modes[mode] = authorized

	if(mode == sel_mode && !authorized)
		switch_firemodes()

	var/mob/M = get_holder_of_type(src, /mob)
	if(M)
		to_chat(M, "<span class='notice'>Your [src.name] has been [authorized ? "granted" : "denied"] [firemodes[mode]] fire authorization by [by].</span>")

	return 1

/obj/item/weapon/gun/energy/secure/special_check()
	if(!emagged && (!authorized_modes[sel_mode] || !registered_owner))
		audible_message("<span class='warning'>\The [src] buzzes, refusing to fire.</span>")
		playsound(loc, 'sound/machines/buzz-sigh.ogg', 50, 0)
		return 0

	. = ..()

/obj/item/weapon/gun/energy/secure/switch_firemodes()
	var/next_mode = get_next_authorized_mode()
	if(firemodes.len <= 1 || next_mode == null || sel_mode == next_mode)
		return null

	sel_mode = next_mode
	var/datum/firemode/new_mode = firemodes[sel_mode]
	new_mode.apply_to(src)
	update_icon()

	return new_mode

/obj/item/weapon/gun/energy/secure/examine(var/mob/user)
	..()

	if(registered_owner)
		to_chat(user, "A small screen on the side of the weapon indicates that it is registered to [registered_owner].")

/obj/item/weapon/gun/energy/secure/proc/get_next_authorized_mode()
	. = sel_mode
	do
		.++
		if(. > authorized_modes.len)
			. = 1
		if(. == sel_mode) // just in case all modes are unauthorized
			return null
	while(!authorized_modes[.] && !emagged)

/obj/item/weapon/gun/energy/secure/emag_act(var/charges, var/mob/user)
	if(emagged || !charges)
		return NO_EMAG_ACT
	else
		emagged = 1
		registered_owner = null
		GLOB.registered_weapons -= src
		to_chat(user, "The authorization chip fries, giving you full use of \the [src].")
		return 1
