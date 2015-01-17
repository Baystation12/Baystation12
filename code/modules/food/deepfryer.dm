/obj/machinery/deepfryer
	name = "deep fryer"
	desc = "Deep fried <i>everything</i>."
	icon = 'icons/obj/cooking_machines.dmi'
	icon_state = "fryer_off"
	layer = 2.9
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 5
	var/on = FALSE	//Is it deep frying already?
	var/obj/item/frying = null	//What's being fried RIGHT NOW?

/obj/machinery/deepfryer/examine()
	..()
	if(frying)
		usr << "You can make out [frying] in the oil."

/obj/machinery/deepfryer/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/weapon/card/emag))
		if(emagged)
			user << "<span class='notice'>[src] is already emagged!</span>"
		else
			user << "<span class='notice'>Override the safety on [src].</span>"
			emagged = 1
		return

	if(on || emagged)
		var/obj/item/weapon/grab/G = I
		if(istype(G))	// handle grabbed mob
			if(ismob(G.affecting))
				var/mob/living/GM = G.affecting
				user.visible_message("<span class='warning'>[user] starts pushing [GM.name] into the fryer.</span>", "<span class='warning'>You try to force [GM.name] towards the fryer.</span>", "You hear a struggle.")

				if(emagged)
					icon_state = "fryer_on"
					on = TRUE
					spawn(30)
						icon_state = "fryer_off"
						on = TRUE

				if(do_after(usr, 20))
					var/body_part = fry_mob_by_limb(GM, user.zone_sel.selecting)
					if(!body_part) //If you fry a valid part this will be set
						if(GM.sleeping||GM.resting)
							user.visible_message("[GM.name] falls limp.", "[GM.name] is to much of a dead weight to be place in the fryer", "You hear a thump.")
						else
							GM.visible_message("[GM.name] breaks free.", "You broke free from [user]'s grip", "You stop hearing a struggle.")
						return

					user.visible_message("[GM.name]'s [body_part] has been placed in the [src] by [user]", "You place [GM.name]'s [body_part] in the fryer", "You hear a sizzling.")
					del(G)
					usr.attack_log += text("\[[time_stamp()]\] <font color='red'>Has placed [GM.name] ([GM.ckey]) in in the fryer.</font>")
					GM.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been fried by [usr.name] ([usr.ckey])</font>")
					msg_admin_attack("[usr] ([usr.ckey]) placed [GM] ([GM.ckey]) in a fryer. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[usr.x];Y=[usr.y];Z=[usr.z]'>JMP</a>)")
				else
					GM.visible_message("[GM.name] breaks free.", "You broke free from [user]'s grip", "You stop hearing a struggle.")
			return

		else
			user << "<span class='notice'>[src] is still active!</span>"
			return

	if(!istype(I, /obj/item/weapon/reagent_containers/food/snacks/))
		user << "<span class='warning'>Budget cuts won't let you put that in there.</span>"
		return
	if(istype(I, /obj/item/weapon/reagent_containers/food/snacks/deepfryholder))
		user << "<span class='userdanger'>You cannot doublefry.</span>"
		return
	if(istype(I, /obj/item/weapon/reagent_containers/food/snacks/customizable/candy))
		user << "<span class='warning'>That would probably break [src].</span>"
		return
	if(istype(I, /obj/item/weapon/reagent_containers/food/snacks/cereal))
		user << "<span class='warning'>That isn't going to fit.</span>"
		return
	else
		fry_food(I, user)

/obj/machinery/deepfryer/proc/fry_mob_by_limb(var/mob/living/M, var/limb)
	switch(limb)
		if("head")
			M.apply_damage(40, BURN, limb)
			M << "\red  Your thoughts are overwritten by the pain, as searing hot oil encompasses your head."
			M.say("*scream")
			return "head"
		if("l_leg")
			M.apply_damage(20, BURN, limb)
			M.apply_damage(30, BURN, "l_foot")
			M << "\red  Your thoughts are overwritten by the pain, as searing hot oil encompasses your left leg and foot."
			M.say("*scream")
			return "left leg"
		if("l_foot")
			M.apply_damage(20, BURN, limb)
			M << "\red  Your thoughts are overwritten by the pain, as searing hot oil encompasses your left foot."
			M.say("*scream")
			return "left foot"
		if("r_leg")
			M.apply_damage(20, BURN, limb)
			M.apply_damage(30, BURN, "r_foot")
			M << "\red  Your thoughts are overwritten by the pain, as searing hot oil encompasses your right leg and foot."
			M.say("*scream")
			return "right leg"
		if("r_foot")
			M.apply_damage(20, BURN, limb)
			M << "\red  Your thoughts are overwritten by the pain, as searing hot oil encompasses your right foot."
			M.say("*scream")
			return "right foot"
		if("l_arm")
			M.apply_damage(20, BURN, limb)
			M.apply_damage(30, BURN, "l_hand")
			M << "\red  Your thoughts are overwritten by the pain, as searing hot oil encompasses your left arm and hand."
			M.say("*scream")
			return "left arm"
		if("l_hand")
			M.apply_damage(20, BURN, limb)
			M << "\red  Your thoughts are overwritten by the pain, as searing hot oil encompasses your left hand."
			M.say("*scream")
			return "left hand"
		if("r_arm")
			M.apply_damage(20, BURN, limb)
			M.apply_damage(30, BURN, "r_hand")
			M << "\red  Your thoughts are overwritten by the pain, as searing hot oil encompasses your right arm and hand."
			M.say("*scream")
			return "right arm"
		if("r_hand")
			M.apply_damage(20, BURN, limb)
			M << "\red  Your thoughts are overwritten by the pain, as searing hot oil encompasses your right hand."
			M.say("*scream")
			return "right hand"
	return null

/obj/machinery/deepfryer/attack_hand(mob/user)
	if(on && frying)
		user << "<span class='notice'>You pull [frying] from [src]! It looks like you were just in time!</span>"
		user.put_in_hands(frying)
		frying = null
		return
	..()

/obj/machinery/deepfryer/proc/fry_food(var/obj/I, var/mob/user)
	user << "<span class='notice'>You put [I] into [src].</span>"
	on = TRUE
	user.drop_item()
	frying = I
	frying.loc = src
	icon_state = "fryer_on"
	sleep(200)

	if(frying && frying.loc == src)
		var/obj/item/weapon/reagent_containers/food/snacks/deepfryholder/S = new(get_turf(src))
		if(istype(frying, /obj/item/weapon/reagent_containers/))
			var/obj/item/weapon/reagent_containers/food = frying
			food.reagents.trans_to(S, food.reagents.total_volume)
		S.color = "#FFAD33"
		S.icon = frying.icon
		S.overlays = I.overlays
		S.icon_state = frying.icon_state
		S.name = "deep fried [frying.name]"
		S.desc = I.desc
		frying.loc = S	//this might be a bad idea.
		del(I)

	icon_state = "fryer_off"
	on = FALSE
	playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
	return