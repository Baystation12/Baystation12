#define UPGRADE_COOLDOWN	40
#define UPGRADE_KILL_TIMER	100

/obj/item/weapon/grab
	name = "grab"
	icon = 'icons/mob/screen1.dmi'
	icon_state = "reinforce"
	flags = 0
	var/obj/screen/grab/hud = null
	var/mob/living/affecting = null
	var/mob/living/carbon/human/assailant = null
	var/state = GRAB_PASSIVE

	var/allow_upgrade = 1
	var/last_action = 0
	var/last_hit_zone = 0
	var/force_down //determines if the affecting mob will be pinned to the ground
	var/dancing //determines if assailant and affecting keep looking at each other. Basically a wrestling position

	layer = 21
	abstract = 1
	item_state = "nothing"
	w_class = 5.0


/obj/item/weapon/grab/New(mob/user, mob/victim)
	..()
	loc = user
	assailant = user
	affecting = victim

	if(affecting.anchored || !assailant.Adjacent(victim))
		qdel(src)
		return

	affecting.grabbed_by += src

	hud = new /obj/screen/grab(src)
	hud.icon_state = "reinforce"
	icon_state = "grabbed"
	hud.name = "reinforce grab"
	hud.master = src

	//check if assailant is grabbed by victim as well
	if(assailant.grabbed_by)
		for (var/obj/item/weapon/grab/G in assailant.grabbed_by)
			if(G.assailant == affecting && G.affecting == assailant)
				G.dancing = 1
				G.adjust_position()
				dancing = 1
	adjust_position()

//Used by throw code to hand over the mob, instead of throwing the grab. The grab is then deleted by the throw code.
/obj/item/weapon/grab/proc/throw_held()
	if(affecting)
		if(affecting.buckled)
			return null
		if(state >= GRAB_AGGRESSIVE)
			animate(affecting, pixel_x = 0, pixel_y = 0, 4, 1)
			return affecting
	return null


//This makes sure that the grab screen object is displayed in the correct hand.
/obj/item/weapon/grab/proc/synch()
	if(affecting)
		if(assailant.r_hand == src)
			hud.screen_loc = ui_rhand
		else
			hud.screen_loc = ui_lhand


/obj/item/weapon/grab/process()
	if(gcDestroyed) // GC is trying to delete us, we'll kill our processing so we can cleanly GC
		return PROCESS_KILL

	confirm()
	if(!assailant)
		qdel(src) // Same here, except we're trying to delete ourselves.
		return PROCESS_KILL

	if(assailant.client)
		assailant.client.screen -= hud
		assailant.client.screen += hud

	if(assailant.pulling == affecting)
		assailant.stop_pulling()

	if(state <= GRAB_AGGRESSIVE)
		allow_upgrade = 1
		//disallow upgrading if we're grabbing more than one person
		if((assailant.l_hand && assailant.l_hand != src && istype(assailant.l_hand, /obj/item/weapon/grab)))
			var/obj/item/weapon/grab/G = assailant.l_hand
			if(G.affecting != affecting)
				allow_upgrade = 0
		if((assailant.r_hand && assailant.r_hand != src && istype(assailant.r_hand, /obj/item/weapon/grab)))
			var/obj/item/weapon/grab/G = assailant.r_hand
			if(G.affecting != affecting)
				allow_upgrade = 0

		//disallow upgrading past aggressive if we're being grabbed aggressively
		for(var/obj/item/weapon/grab/G in affecting.grabbed_by)
			if(G == src) continue
			if(G.state >= GRAB_AGGRESSIVE)
				allow_upgrade = 0

		if(allow_upgrade)
			if(state < GRAB_AGGRESSIVE)
				hud.icon_state = "reinforce"
			else
				hud.icon_state = "reinforce1"
		else
			hud.icon_state = "!reinforce"

	if(state >= GRAB_AGGRESSIVE)
		affecting.drop_l_hand()
		affecting.drop_r_hand()

		var/hit_zone = assailant.zone_sel.selecting
		var/announce = 0
		if(hit_zone != last_hit_zone)
			announce = 1
		last_hit_zone = hit_zone
		if(ishuman(affecting))
			switch(hit_zone)
				if("mouth")
					if(announce)
						assailant.visible_message("<span class='warning'>[assailant] covers [affecting]'s mouth!</span>")
					if(affecting:silent < 3)
						affecting:silent = 3
				if("eyes")
					if(announce)
						assailant.visible_message("<span class='warning'>[assailant] covers [affecting]'s eyes!</span>")
					if(affecting:eye_blind < 3)
						affecting:eye_blind = 3
		if(force_down)
			if(affecting.loc != assailant.loc)
				force_down = 0
			else
				affecting.Weaken(2)

	if(state >= GRAB_NECK)
		affecting.Stun(3)
		if(isliving(affecting))
			var/mob/living/L = affecting
			L.adjustOxyLoss(1)

	if(state >= GRAB_KILL)
		//affecting.apply_effect(STUTTER, 5) //would do this, but affecting isn't declared as mob/living for some stupid reason.
		affecting.stuttering = max(affecting.stuttering, 5) //It will hamper your voice, being choked and all.
		affecting.Weaken(5)	//Should keep you down unless you get help.
		affecting.losebreath = max(affecting.losebreath + 2, 3)

	adjust_position()


/obj/item/weapon/grab/attack_self()
	return s_click(hud)


//Updating pixelshift, position and direction
//Gets called on process, when the grab gets upgraded or the assailant moves
/obj/item/weapon/grab/proc/adjust_position()
	if(affecting.buckled)
		animate(affecting, pixel_x = 0, pixel_y = 0, 4, 1, LINEAR_EASING)
		return
	if(affecting.lying && state != GRAB_KILL)
		animate(affecting, pixel_x = 0, pixel_y = 0, 5, 1, LINEAR_EASING)
		if(force_down)
			affecting.set_dir(SOUTH) //face up
		return
	var/shift = 0
	var/adir = get_dir(assailant, affecting)
	affecting.layer = 4
	switch(state)
		if(GRAB_PASSIVE)
			shift = 8
			if(dancing) //look at partner
				shift = 10
				assailant.set_dir(get_dir(assailant, affecting))
		if(GRAB_AGGRESSIVE)
			shift = 12
		if(GRAB_NECK, GRAB_UPGRADING)
			shift = -10
			adir = assailant.dir
			affecting.set_dir(assailant.dir)
			affecting.loc = assailant.loc
		if(GRAB_KILL)
			shift = 0
			adir = 1
			affecting.set_dir(SOUTH) //face up
			affecting.loc = assailant.loc

	switch(adir)
		if(NORTH)
			animate(affecting, pixel_x = 0, pixel_y =-shift, 5, 1, LINEAR_EASING)
			affecting.layer = 3.9
		if(SOUTH)
			animate(affecting, pixel_x = 0, pixel_y = shift, 5, 1, LINEAR_EASING)
		if(WEST)
			animate(affecting, pixel_x = shift, pixel_y = 0, 5, 1, LINEAR_EASING)
		if(EAST)
			animate(affecting, pixel_x =-shift, pixel_y = 0, 5, 1, LINEAR_EASING)



/obj/item/weapon/grab/proc/s_click(obj/screen/S)
	if(!affecting)
		return
	if(state == GRAB_UPGRADING)
		return
	if(!assailant.canClick())
		return
	if(world.time < (last_action + UPGRADE_COOLDOWN))
		return
	if(!assailant.canmove || assailant.lying)
		qdel(src)
		return

	last_action = world.time

	if(state < GRAB_AGGRESSIVE)
		if(!allow_upgrade)
			return
		if(!affecting.lying)
			assailant.visible_message("<span class='warning'>[assailant] has grabbed [affecting] aggressively (now hands)!</span>")
		else
			assailant.visible_message("<span class='warning'>[assailant] pins [affecting] down to the ground (now hands)!</span>")
			force_down = 1
			affecting.Weaken(3)
			step_to(assailant, affecting)
			assailant.set_dir(EAST) //face the victim
			affecting.set_dir(SOUTH) //face up
		state = GRAB_AGGRESSIVE
		icon_state = "grabbed1"
		hud.icon_state = "reinforce1"
	else if(state < GRAB_NECK)
		if(isslime(affecting))
			assailant << "<span class='notice'>You squeeze [affecting], but nothing interesting happens.</span>"
			return

		assailant.visible_message("<span class='warning'>[assailant] has reinforced \his grip on [affecting] (now neck)!</span>")
		state = GRAB_NECK
		icon_state = "grabbed+1"
		assailant.set_dir(get_dir(assailant, affecting))
		affecting.attack_log += "\[[time_stamp()]\] <font color='orange'>Has had their neck grabbed by [assailant.name] ([assailant.ckey])</font>"
		assailant.attack_log += "\[[time_stamp()]\] <font color='red'>Grabbed the neck of [affecting.name] ([affecting.ckey])</font>"
		msg_admin_attack("[key_name(assailant)] grabbed the neck of [key_name(affecting)]")
		hud.icon_state = "kill"
		hud.name = "kill"
		affecting.Stun(10) //10 ticks of ensured grab
	else if(state < GRAB_UPGRADING)
		assailant.visible_message("<span class='danger'>[assailant] starts to tighten \his grip on [affecting]'s neck!</span>")
		hud.icon_state = "kill1"

		state = GRAB_KILL
		assailant.visible_message("<span class='danger'>[assailant] has tightened \his grip on [affecting]'s neck!</span>")
		affecting.attack_log += "\[[time_stamp()]\] <font color='orange'>Has been strangled (kill intent) by [assailant.name] ([assailant.ckey])</font>"
		assailant.attack_log += "\[[time_stamp()]\] <font color='red'>Strangled (kill intent) [affecting.name] ([affecting.ckey])</font>"
		msg_admin_attack("[key_name(assailant)] strangled (kill intent) [key_name(affecting)]")

		affecting.setClickCooldown(10)
		affecting.losebreath += 1
		affecting.set_dir(WEST)
	adjust_position()


//This is used to make sure the victim hasn't managed to yackety sax away before using the grab.
/obj/item/weapon/grab/proc/confirm()
	if(!assailant || !affecting)
		qdel(src)
		return 0

	if(affecting)
		if(!isturf(assailant.loc) || ( !isturf(affecting.loc) || assailant.loc != affecting.loc && get_dist(assailant, affecting) > 1) )
			qdel(src)
			return 0

	return 1


/obj/item/weapon/grab/attack(mob/M, mob/living/user)
	if(!affecting)
		return

	if(world.time < (last_action + 20))
		return

	if(M == affecting)
		if(ishuman(M))
			last_action = world.time
			var/hit_zone = assailant.zone_sel.selecting
			flick(hud.icon_state, hud)
			switch(assailant.a_intent)
				if(I_HELP)
					if(force_down)
						assailant << "<span class='warning'>You are no longer pinning [affecting] to the ground.</span>"
						force_down = 0
						return
					var/mob/living/carbon/human/H = M
					var/obj/item/organ/external/E = H.get_organ(hit_zone)
					if(E && !(E.status & ORGAN_DESTROYED))
						assailant.visible_message("<span class='notice'>[assailant] starts inspecting [affecting]'s [E.name] carefully.</span>")
						if(do_mob(assailant,H, 10))
							if(E.wounds.len)
								assailant << "<span class='warning'>You find [E.get_wounds_desc()]</span>"
							else
								assailant << "<span class='notice'>You find no visible wounds.</span>"
						else
							assailant << "<span class='notice'>You must stand still to inspect [E] for wounds.</span>"
						assailant << "<span class='notice'>Checking bones now...</span>"
						if(do_mob(assailant, H, 20))
							if(E.status & ORGAN_BROKEN)
								assailant << "<span class='warning'>The [E.encased ? E.encased : "bone in the [E.name]"] moves slightly when you poke it!</span>"
								H.custom_pain("Your [E.name] hurts where it's poked.")
							else
								assailant << "<span class='notice'>The [E.encased ? E.encased : "bones in the [E.name]"] seem to be fine.</span>"
						else
							assailant << "<span class='notice'>You must stand still to feel [E] for fractures.</span>"
						assailant << "<span class='notice'>Checking skin now...</span>"
						if(do_mob(assailant, H, 10))
							var/bad = 0
							if(H.getToxLoss() >= 40)
								assailant << "<span class='warning'>[H] has an unhealthy skin discoloration.</span>"
								bad = 1
							if(H.getOxyLoss() >= 20)
								assailant << "<span class='warning'>[H]'s skin is unusaly pale.</span>"
								bad = 1
							if(E.status & ORGAN_DEAD)
								assailant << "<span class='warning'>[E] is decaying!</span>"
								bad = 1
							if(!bad)
								assailant << "<span class='notice'>[H]'s skin is normal.</span>"
						else
							assailant << "<span class='notice'>You must stand still to check [H]'s skin for abnormalities.</span>"
					else
						assailant << "<span class='notice'>[H] is missing that bodypart.</span>"
				if(I_GRAB)
					if(state < GRAB_AGGRESSIVE)
						assailant << "<span class='warning'>You require a better grab to do this.</span>"
						return
					var/obj/item/organ/external/organ = affecting:get_organ(check_zone(hit_zone))
					if(!organ || organ.dislocated == -1)
						return
					assailant.visible_message("<span class='danger'>[assailant] [pick("bent", "twisted")] [affecting]'s [organ.name] into a jointlock!</span>")
					var/armor = affecting:run_armor_check(affecting, "melee")
					if(armor < 2)
						affecting << "<span class='danger'>You feel extreme pain!</span>"
						affecting.adjustHalLoss(Clamp(0, 40-affecting.halloss, 40)) //up to 40 halloss
					return
				if(I_HURT)

					if(hit_zone == "eyes")
						var/mob/living/carbon/human/H = affecting
						var/datum/unarmed_attack/attack = H.get_unarmed_attack(src, hit_zone)
						if(!attack)
							return
						
						if(state < GRAB_NECK)
							assailant << "<span class='warning'>You require a better grab to do this.</span>"
							return
						for(var/slot in list(slot_wear_mask, slot_head, slot_glasses))
							var/obj/item/protection = affecting.get_equipped_item(slot)
							if(istype(protection) && (protection.body_parts_covered & EYES))
								assailant << "<span class='danger'>You're going to need to remove the eye covering first.</span>"
								return
						if(!affecting.has_eyes())
							assailant << "<span class='danger'>You cannot locate any eyes on [affecting]!</span>"
							return
						assailant.attack_log += text("\[[time_stamp()]\] <font color='red'>Attacked [affecting.name]'s eyes using grab ([affecting.ckey])</font>")
						affecting.attack_log += text("\[[time_stamp()]\] <font color='orange'>Had eyes attacked by [assailant.name]'s grab ([assailant.ckey])</font>")
						msg_admin_attack("[key_name(assailant)] attacked [key_name(affecting)]'s eyes using a grab action.")
						
						attack.handle_eye_attack(assailant, affecting)
					else if(hit_zone != "head")
						if(state < GRAB_NECK)
							assailant << "<span class='warning'>You require a better grab to do this.</span>"
							return
						if(affecting:grab_joint(assailant))
							playsound(loc, 'sound/weapons/thudswoosh.ogg', 50, 1, -1)
							return
					else
						if(affecting.lying)
							return
						assailant.visible_message("<span class='danger'>[assailant] thrusts \his head into [affecting]'s skull!</span>")
						var/damage = 20
						var/obj/item/clothing/hat = assailant.head
						if(istype(hat))
							damage += hat.force * 10
						var/armor = affecting:run_armor_check(affecting, "melee")
						affecting.apply_damage(damage*rand(90, 110)/100, BRUTE, "head", armor)
						assailant.apply_damage(10*rand(90, 110)/100, BRUTE, "head", assailant:run_armor_check("head", "melee"))
						if(!armor && prob(damage))
							affecting.apply_effect(20, PARALYZE)
							affecting.visible_message("<span class='danger'>[affecting] has been knocked unconscious!</span>")
						playsound(assailant.loc, "swing_hit", 25, 1, -1)
						assailant.attack_log += text("\[[time_stamp()]\] <font color='red'>Headbutted [affecting.name] ([affecting.ckey])</font>")
						affecting.attack_log += text("\[[time_stamp()]\] <font color='orange'>Headbutted by [assailant.name] ([assailant.ckey])</font>")
						msg_admin_attack("[key_name(assailant)] has headbutted [key_name(affecting)]")
						assailant.drop_from_inventory(src)
						src.loc = null
						qdel(src)
						return
				if(I_DISARM)
					if(state < GRAB_AGGRESSIVE)
						assailant << "<span class='warning'>You require a better grab to do this.</span>"
						return
					assailant << "<span class='warning'>You start forcing [affecting] to the ground.</span>"
					if(!force_down)
						if(do_after(assailant, 20) && affecting)
							assailant.visible_message("<span class='danger'>[assailant] is forcing [affecting] to the ground!</span>")
							force_down = 1
							affecting.Weaken(3)
							affecting.lying = 1
							step_to(assailant, affecting)
							assailant.set_dir(EAST) //face the victim
							affecting.set_dir(SOUTH) //face up
							return
					else
						assailant << "<span class='warning'>You are already pinning [affecting] to the ground.</span>"
						return

	if(M == assailant && state >= GRAB_AGGRESSIVE)

		var/can_eat
		if((FAT in user.mutations) && issmall(affecting))
			can_eat = 1
		else
			var/mob/living/carbon/human/H = user
			if(istype(H) && H.species.gluttonous)
				if(H.species.gluttonous == 2)
					can_eat = 2
				else if(!ishuman(affecting) && !issmall(affecting) && (affecting.small || iscarbon(affecting)))
					can_eat = 1

		if(can_eat)
			var/mob/living/carbon/attacker = user
			user.visible_message("<span class='danger'>[user] is attempting to devour [affecting]!</span>")
			if(can_eat == 2)
				if(!do_mob(user, affecting)||!do_after(user, 30)) return
			else
				if(!do_mob(user, affecting)||!do_after(user, 100)) return
			user.visible_message("<span class='danger'>[user] devours [affecting]!</span>")
			affecting.loc = user
			attacker.stomach_contents.Add(affecting)
			qdel(src)


/obj/item/weapon/grab/dropped()
	loc = null
	if(!destroying)
		qdel(src)

/obj/item/weapon/grab
	var/destroying = 0

/obj/item/weapon/grab/Destroy()
	animate(affecting, pixel_x = 0, pixel_y = 0, 4, 1, LINEAR_EASING)
	affecting.layer = 4
	if(affecting)
		affecting.grabbed_by -= src
		affecting = null
	if(assailant)
		if(assailant.client)
			assailant.client.screen -= hud
		assailant = null
	qdel(hud)
	hud = null
	destroying = 1 // stops us calling qdel(src) on dropped()
	..()
