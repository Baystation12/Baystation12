#define ESWORD_LEAP_DIST 2
#define ESWORD_LEAP_FAR_SPECIES list(/datum/species/sangheili,/datum/species/spartan)
#define LUNGE_DELAY 2 SECONDS

/obj/effect/esword_path
	name = "displaced air"
	icon = null
	icon_state = null

/obj/item/weapon/melee/energy/elite_sword
	name = "Type-1 Energy Weapon"
	desc = "A small handle conceals the equipment required to generate a long shimmering blade of shaped plasma, capable of burning through most armor with ease."
	icon = 'code/modules/halo/icons/Covenant Weapons.dmi'
	icon_state = "T1EW Handle"
	force = 1
	throwforce = 1
	active_force = 65
	active_throwforce = 12
	edge = 0
	sharp = 0

	var/next_leapwhen

/obj/item/weapon/melee/energy/elite_sword/proc/get_species_leap_dist(var/mob/living/carbon/human/mob)
	if(isnull(mob) || !istype(mob))
		return 0
	if(mob.species.type in ESWORD_LEAP_FAR_SPECIES)
		return 5
	return ESWORD_LEAP_DIST

/obj/item/weapon/melee/energy/elite_sword/afterattack(var/atom/target,var/mob/user)
	if(world.time < next_leapwhen)
		to_chat(user,"<span class = 'notice'>You're still recovering from the last lunge!</span>")
		return
	if(!istype(target,/mob))
		if(istype(target,/turf))
			var/turf/targ_turf = target
			var/list/turf_mobs = list()
			for(var/mob/m in targ_turf.contents)
				turf_mobs += m
			if(turf_mobs.len > 0)
				target = pick(turf_mobs)
			else
				to_chat(user,"<span class = 'notice'>You can't leap at non-mobs!</span>")
				return
		else
			to_chat(user,"<span class = 'notice'>You can't leap at non-mobs!</span>")
			return
	if(!(target in view(7,user.loc)))
		to_chat(user,"<span class = 'notice'>That's not in your view!</span>")
		return
	if(get_dist(user,target) <= get_species_leap_dist(user))
		user.visible_message("<span class = 'danger'>[user] lunges forward, [src] in hand, ready to strike!</span>")
		var/image/user_image = image(user)
		user_image.dir = user.dir
		for(var/i = 0 to 1)
			var/obj/after_image = new /obj/effect/esword_path
			if(i == 0)
				after_image.loc = user.loc
			else
				after_image.loc = get_step(user,get_dir(user,target))
			after_image.dir = user.dir
			after_image.overlays += user_image
			spawn(5)
				qdel(after_image)
		user.forceMove(get_step(target,get_dir(target,user)))//If it's not a turf, jump adjacent.
		if(user.Adjacent(target) && ismob(target))
			attack(target,user)
		next_leapwhen = world.time + LUNGE_DELAY

/obj/item/weapon/melee/energy/elite_sword/activate(mob/living/user)
	..()
	playsound(user, 'code/modules/halo/sounds/Energysworddeploy.ogg',75, 1)
	to_chat(user, "<span class='notice'>\The [src] bursts from it's handle.</span>")
	icon_state = "T1EW-deployed"
	w_class = ITEM_SIZE_HUGE
	edge = 1
	sharp = 1
	flags = NOBLOODY
	item_icons = list(slot_l_hand_str ='code/modules/halo/icons/Energy Sword_inhand Human.dmi',slot_r_hand_str = 'code/modules/halo/icons/Energy Sword_inhand Human.dmi')
	item_state_slots = list(
	slot_l_hand_str = "Energy sword_inhand Human l",
	slot_r_hand_str = "Energy sword_inhand Human r" )
	hitsound = 'code/modules/halo/sounds/Energyswordhit.ogg'

/obj/item/weapon/melee/energy/elite_sword/deactivate(mob/living/user)
	..()
	icon_state = initial(icon_state)
	to_chat(user, "<span class='notice'>\The [src] disappears in a flash of light.</span>")
	w_class = ITEM_SIZE_SMALL
	flags = null
	item_icons = list(slot_l_hand_str = null,slot_r_hand_str = null)
	item_state_slots = null
	hitsound = "swing_hit"

/obj/item/weapon/melee/energy/elite_sword/dropped(var/mob/user)
	..()
	if(!istype(loc,/mob))
		deactivate(user)
		visible_message("<span class='notice'>\The [src] disappears in a flash of light.</span>")

/obj/item/weapon/melee/energy/elite_sword/attack(var/mob/m,var/mob/user)
	if(ismob(m))
		damtype = BURN
	return ..()