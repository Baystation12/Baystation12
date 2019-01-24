/obj/structure/adherent_pylon
	name = "electron reservoir"
	desc = "A tall, crystalline pylon that pulses with electricity."
	icon = 'icons/obj/machines/adherent.dmi'
	icon_state = "pedestal"
	anchored = TRUE
	density = TRUE
	opacity = FALSE

/obj/structure/adherent_pylon/attack_ai(var/mob/living/user)
	if(Adjacent(user))
		attack_hand(user)

/obj/structure/adherent_pylon/attack_hand(var/mob/living/user)
	charge_user(user)

/obj/structure/adherent_pylon/proc/charge_user(var/mob/living/user)
	var/mob/living/carbon/human/H = user
	var/obj/item/weapon/cell/power_cell
	if(ishuman(user))
		var/obj/item/organ/internal/cell/cell = locate() in H.internal_organs
		if(cell && cell.cell)
			power_cell = cell.cell
	else if(isrobot(user))
		var/mob/living/silicon/robot/robot = user
		power_cell = robot.get_cell()

	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(power_cell)
		user.visible_message("<span class='notice'>There is a loud crack and the smell of ozone as \the [user] touches \the [src].</span>")
		power_cell.charge = power_cell.maxcharge
		to_chat(user, "<span class='notice'><b>Your [power_cell] has been charged to capacity.</b></span>")
		if(istype(H) && H.species.name == SPECIES_ADHERENT)
			return
	if(isrobot(user))
		user.apply_damage(150, BURN, def_zone = BP_CHEST)
		visible_message("<span class='danger'>Electricity arcs off [user] as it touches \the [src]!</span>")
		to_chat(user, "<span class='danger'><b>You detect damage to your components!</b></span>")
	else
		user.electrocute_act(100, src, def_zone = BP_CHEST)
		visible_message("<span class='danger'>\The [user] has been shocked by \the [src]!</span>")

/obj/structure/adherent_pylon/attackby(obj/item/grab/normal/G, mob/user)
	if(!istype(G))		
		return
	var/mob/M = G.affecting	
	charge_user(M)