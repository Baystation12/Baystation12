/obj/item/device/assembly/shocker
	name = "shock device"
	desc = "A device that shocks people near it. You feel an odd urge to back away..Slowly."
	icon_state = "shocker"
	item_state = "assembly"
	throwforce = 5
	w_class = 2
	throw_speed = 4
	throw_range = 10
	dangerous = 1

	wires = WIRE_DIRECT_RECEIVE | WIRE_PROCESS_RECEIVE | WIRE_PROCESS_ACTIVATE | WIRE_MISC_SPECIAL | WIRE_POWER_RECEIVE
	wire_num = 4

	var/power_use = 200

/obj/item/device/assembly/shocker/activate()
	var/mob/living/target
	var/list/targets = list()
	for(var/mob/M in view(2))
		targets.Add(M)
	if(targets.len)
		target = pick(targets)
	if(target && istype(target))
		misc_special(target)
	else
		return 0
	return 1

// Copied from stunbaton.dm, minor tweaks.
/obj/item/device/assembly/shocker/misc_special(var/mob/living/L)
	if(!active_wires & WIRE_MISC_SPECIAL) return 0
	if(get_dist(src, L) > 2)
		return 0
	var/stun = rand(1, 10)
	var/agony = rand(60, 150)
	var/burndmg = rand(1, 15)
	var/target_zone = pick("chest", "head", "groin")
	if(!draw_power(power_use))
		add_debug_log("Insufficient power! \[[src]\]")
		return 0
	if (ishuman(L))
		var/mob/living/carbon/human/H = L
		var/obj/item/organ/external/affecting = H.get_organ(target_zone)
		if (affecting)
			H.visible_message("<span class='danger'>[L] has been electrocuted in the [affecting.name] by \the [src]!</span>")
	else
		L.visible_message("<span class='danger'>[L] has been electrocuted by \the [src]!</span>")
	power_use = round(power_use * 1.05)

	//stun effects
	L.stun_effect_act(stun, agony, target_zone, src)

	playsound(loc, 'sound/weapons/Egloves.ogg', 50, 1, -1)

	L.apply_damage(burndmg, BURN)

	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		H.forcesay(hit_appends)

	return 1