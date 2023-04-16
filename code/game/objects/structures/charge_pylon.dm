/obj/structure/adherent_pylon
	name = "electron reservoir"
	desc = "A tall, crystalline pylon that pulses with electricity."
	icon = 'icons/obj/machines/adherent.dmi'
	icon_state = "pedestal"
	anchored = TRUE
	density = TRUE
	opacity = FALSE
	var/next_use

/obj/structure/adherent_pylon/attack_ai(mob/living/user)
	if(Adjacent(user))
		attack_hand(user)

/obj/structure/adherent_pylon/attack_hand(mob/living/user)
	charge_user(user)

/obj/structure/adherent_pylon/proc/charge_user(mob/living/user)
	if(next_use > world.time) return
	next_use = world.time + 10
	var/mob/living/carbon/human/H = user
	var/obj/item/cell/power_cell
	if(ishuman(user))
		var/obj/item/organ/internal/cell/cell = locate() in H.internal_organs
		if(cell && cell.cell)
			power_cell = cell.cell
	else if(isrobot(user))
		var/mob/living/silicon/robot/robot = user
		power_cell = robot.get_cell()

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	user.visible_message(SPAN_WARNING("There is a loud crack and the smell of ozone as \the [user] touches \the [src]."))
	playsound(loc, 'sound/effects/snap.ogg', 50, 1)
	if(power_cell)
		power_cell.charge = power_cell.maxcharge
		to_chat(user, SPAN_NOTICE("<b>Your [power_cell] has been charged to capacity.</b>"))
	if(istype(H) && H.species.name == SPECIES_ADHERENT)
		return
	if(isrobot(user))
		user.apply_damage(150, DAMAGE_BURN, def_zone = BP_CHEST)
		visible_message(SPAN_DANGER("Electricity arcs off [user] as it touches \the [src]!"))
		to_chat(user, SPAN_DANGER("<b>You detect damage to your components!</b>"))
	else
		user.electrocute_act(100, src, def_zone = BP_CHEST)
		visible_message(SPAN_DANGER("\The [user] has been shocked by \the [src]!"))
	user.throw_at(get_step(user,get_dir(src,user)), 5, 10)


/obj/structure/adherent_pylon/use_grab(obj/item/grab/grab, list/click_params)
	// Charge victim
	charge_user(grab.affecting)


/obj/structure/adherent_pylon/Bumped(atom/AM)
	if(ishuman(AM))
		charge_user(AM)

/obj/structure/adherent_pylon/hitby(atom/AM)
	. =..()
	if(ishuman(AM))
		charge_user(AM)
