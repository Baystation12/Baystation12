/obj/item/weapon/slugegg
	name = "slugegg"
	desc = "A pulsing, disgusting door to new life."
	force = 1
	throwforce = 6
	icon_state = "slugegg"
	var/break_on_impact = 1 //There are two modes to the eggs.
							//One breaks the egg on hit,

/obj/item/weapon/slugegg/throw_impact(atom/hit_atom, var/speed)
	if(break_on_impact)
		squish()
	else
		flags |= PROXMOVE //Dont want it active during the throw... loooots of unneeded checking.
	return ..()

/obj/item/weapon/slugegg/attack_self(var/mob/living/user)
	user.drop_from_inventory(src)
	squish()

/obj/item/weapon/slugegg/HasProximity(var/atom/movable/AM)
	if(isliving(AM))
		if(istype(AM,/mob/living/carbon/human))
			var/mob/living/carbon/human/H = AM
			if(H.species && H.species.get_bodytype() == SPECIES_VOX)
				return
		else
			var/mob/living/L = AM
			if(L.faction == SPECIES_VOX)
				return
		squish()

/obj/item/weapon/slugegg/proc/squish()
	src.visible_message("<span class='warning'>\The [src] bursts open!</span>")
	new /mob/living/simple_animal/hostile/voxslug(get_turf(src))
	playsound(src.loc,'sound/effects/attackblob.ogg',100, 1)
	qdel(src)

//a slug sling basically launches a small egg that hatches (either on a person or on the floor), releasing a terrible blood thirsty monster.
//Balanced due to the non-spammy nature of the gun, as well as the frailty of the creatures.
/obj/item/weapon/gun/launcher/alien/slugsling
	name = "slug sling"
	desc = "A bulbous looking rifle. It feels like holding a plastic bag full of meat."
	w_class = ITEM_SIZE_LARGE
	icon_state = "slugsling"
	item_state = "spikethrower"
	fire_sound_text = "a strange noise"
	fire_sound = 'sound/weapons/towelwhip.ogg'
	release_force = 6
	ammo_name = "slug"
	ammo_type = /obj/item/weapon/slugegg
	max_ammo = 2
	ammo = 2
	ammo_gen_time = 200
	var/mode = "Impact"

/obj/item/weapon/gun/launcher/alien/slugsling/consume_next_projectile()
	var/obj/item/weapon/slugegg/S = ..()
	if(S)
		S.break_on_impact = (mode == "Impact")
	return S


/obj/item/weapon/gun/launcher/alien/slugsling/attack_self(var/mob/living/user)
	mode = mode == "Impact" ? "Sentry" : "Impact"
	to_chat(user,"<span class='notice'>You switch \the [src]'s mode to \"[mode]\"</span>")