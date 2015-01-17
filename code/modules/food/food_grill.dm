/obj/machinery/cooker/foodgrill
	name = "grill"
	desc = "Backyard grilling, IN SPACE."
	icon = 'icons/obj/cooking_machines.dmi'
	icon_state = "grill_off"
	thiscooktype = "grilled"
	burns = 1
	firechance = 20
	cooktime = 50
	foodcolor = "#A34719"
	onicon = "grill_on"
	officon = "grill_off"

obj/machinery/cooker/foodgrill/putIn(obj/item/In, mob/chef)
	..()
	var/image/img = new(In.icon, In.icon_state)
	img.pixel_y = 5
	overlays += img
	sleep(50)
	overlays = 0
	img.color = "#C28566"
	overlays += img
	sleep(50)
	overlays = 0
	img.color = "#A34719"
	overlays += img
	sleep(50)
	overlays = 0


//Lets grill people, because why not.
/obj/machinery/cooker/foodgrill/proc/fry_mob_by_limb(var/mob/living/M, var/limb)
	switch(limb)
		if("head")
			M.apply_damage(40, BURN, limb)
			M << "\red  Your thoughts are overwritten by the pain from the searing hot metal pressed against your face."
			M.say("*scream")
			return "face"
		if("l_leg")
			M.apply_damage(20, BURN, limb)
			M.apply_damage(30, BURN, "l_foot")
			M << "\red  Your thoughts are overwritten by the pain from the searing hot metal pressed against your left leg and foot."
			M.say("*scream")
			return "left leg"
		if("l_foot")
			M.apply_damage(20, BURN, limb)
			M << "\red  Your thoughts are overwritten by the pain from the searing hot metal pressed against your left foot."
			M.say("*scream")
			return "left foot"
		if("r_leg")
			M.apply_damage(20, BURN, limb)
			M.apply_damage(30, BURN, "r_foot")
			M << "\red  Your thoughts are overwritten by the pain from the searing hot metal pressed against your right leg and foot."
			M.say("*scream")
			return "right leg"
		if("r_foot")
			M.apply_damage(20, BURN, limb)
			M << "\red  Your thoughts are overwritten by the pain from the searing hot metal pressed against your right foot."
			M.say("*scream")
			return "right foot"
		if("l_arm")
			M.apply_damage(20, BURN, limb)
			M.apply_damage(30, BURN, "l_hand")
			M << "\red  Your thoughts are overwritten by the pain from the searing hot metal pressed against your left arm and hand."
			M.say("*scream")
			return "left arm"
		if("l_hand")
			M.apply_damage(20, BURN, limb)
			M << "\red  Your thoughts are overwritten by the pain from the searing hot metal pressed against your left hand."
			M.say("*scream")
			return "left hand"
		if("r_arm")
			M.apply_damage(20, BURN, limb)
			M.apply_damage(30, BURN, "r_hand")
			M << "\red  Your thoughts are overwritten by the pain from the searing hot metal pressed against your right arm and hand."
			M.say("*scream")
			return "right arm"
		if("r_hand")
			M.apply_damage(20, BURN, limb)
			M << "\red  Your thoughts are overwritten by the pain from the searing hot metal pressed against your right hand."
			M.say("*scream")
			return "right hand"
	return null

/obj/machinery/cooker/foodgrill/attackby(obj/item/I, mob/user)
	if(on)
		var/obj/item/weapon/grab/G = I
		if(istype(G))	// handle grabbed mob
			if(ismob(G.affecting))
				var/mob/living/GM = G.affecting
				user.visible_message("<span class='warning'>[user] starts pushing [GM.name] into the grill.</span>", "<span class='warning'>You try to force [GM.name] towards the grill.</span>", "You hear a struggle.")

				if(do_after(usr, 20))
					var/body_part = fry_mob_by_limb(GM, user.zone_sel.selecting)
					if(!body_part) //If you fry a valid part this will be set
						if(GM.sleeping||GM.resting)
							user.visible_message("[GM.name] falls limp.", "[GM.name] is to much of a dead weight to be place in the grill", "You hear a thump.")
						else
							GM.visible_message("[GM.name] breaks free.", "You broke free from [user]'s grip", "You stop hearing a struggle.")
						return

					user.visible_message("[GM.name]'s [body_part] has been placed in the [src] by [user]", "You place [GM.name]'s [body_part] in the grill", "You hear a sizzling.")
					del(G)
					usr.attack_log += text("\[[time_stamp()]\] <font color='red'>Has placed [GM.name] ([GM.ckey]) in in the grill.</font>")
					GM.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been fried by [usr.name] ([usr.ckey])</font>")
					msg_admin_attack("[usr] ([usr.ckey]) placed [GM] ([GM.ckey])'s [body_part] in a grill. (<A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[usr.x];Y=[usr.y];Z=[usr.z]'>JMP</a>)")
				else
					GM.visible_message("[GM.name] breaks free.", "You broke free from [user]'s grip", "You stop hearing a struggle.")
			return

		else
			user << "<span class='notice'>[src] is still active!</span>"
			return

	else
		..()