#define BASE_AUTOTURRET_INTERACT_DELAY 10 SECONDS

/obj/structure/autoturret
	name = "\improper Autoturret"
	desc = "A mounted weapon powered by a simple AI and a sensor package. It has a slot for materials."

	icon = 'code/modules/halo/weapons/turrets/turrets_unsc.dmi'
	icon_state = "hmgturret"

	density = 1
	w_class = ITEM_SIZE_HUGE

	var/vision_range = 9
	var/burst_size = 5
	var/list/friendlies_stored = list()
	var/list/allowed_materials = list("steel" = 5) //Format: material name = amount of bullets created
	var/obj/item/projectile/to_fabricate = /obj/item/projectile/bullet/a762_M392
	var/max_rounds = 100
	var/list/loaded_ammo = list()
	var/burst_delay = 0.7 SECONDS
	var/fire_sound = 'code/modules/halo/sounds/Assault_Rifle_Short_Burst_Sound_Effect.ogg'
	var/list/targets_in_view = list()

/obj/structure/autoturret/examine(var/examiner)
	. = ..()
	if(loaded_ammo.len == 0)
		var/str_allowed_mats = ""
		for(var/mat in allowed_materials)
			str_allowed_mats += "[mat] "
		to_chat(examiner,"It is empty. Refill the material hopper with one of the following to restart ammunition manufacture: [str_allowed_mats].")
	else
		to_chat(examiner,"It has [loaded_ammo.len] rounds left.")

/obj/structure/autoturret/verb/activate_autoturret()
	set name = "Activate Autoturret"
	set category = "Turret"
	set src in view(1)

	var/mob/living/user = usr
	if(!istype(user))
		return
	if(anchored)
		to_chat(user,"<span class = 'notice'>[src] is already active!</span>")
		return
	visible_message("<span class = 'notice'>[user] starts to activate [src]...</span>")
	if(!do_after(user,BASE_AUTOTURRET_INTERACT_DELAY*0.5,src))
		return
	visible_message("<span class = 'notice'>[user] activates [src]</span>")
	targets_in_view.Cut()
	anchored = 1
	GLOB.processing_objects += src

/obj/structure/autoturret/verb/deactivate_autoturret()
	set name = "Deactivate Autoturret"
	set category = "Turret"
	set src in view(1)
	var/mob/living/user = usr
	if(!istype(user))
		return
	if(!anchored)
		to_chat(user,"<span class = 'notice'>[src] is already inactive!</span>")
		return
	visible_message("<span class = 'notice'>[user] starts to deactivate [src]...</span>")
	if(!do_after(user,BASE_AUTOTURRET_INTERACT_DELAY,src))
		return
	visible_message("<span class = 'notice'>[user] deactivates [src]</span>")
	targets_in_view.Cut()
	anchored = 0
	GLOB.processing_objects -= src

/obj/structure/autoturret/verb/clear_friendlies()
	set name = "Clear Friendlies"
	set category = "Turret"
	set src in view(1)

	var/mob/living/user = usr
	if(!istype(user))
		return
	visible_message("<span class = 'notice'>[user] starts to wipe [src]'s memory...</span>")
	if(!do_after(user,BASE_AUTOTURRET_INTERACT_DELAY,src))
		return
	visible_message("<span class = 'notice'>[user] wipes [src]'s memory.</span>")
	friendlies_stored = list()

/obj/structure/autoturret/verb/scan_for_friendlies()
	set name = "Scan for Friendlies"
	set category = "Turret"
	set src in view(1)
	var/mob/living/user = usr
	if(!istype(user))
		return
	visible_message("<span class = 'notice'>[user] starts to activate [src]'s FoF scanning arrays...</span>")
	if(!do_after(user,BASE_AUTOTURRET_INTERACT_DELAY*0.5,src))
		return
	visible_message("<span class = 'notice'>[src] performs a scan of its surroundings, logging any nearby creatures as friendly.</span>")
	for(var/mob/living/m in view(7,loc))
		friendlies_stored += m

/obj/structure/autoturret/ex_act(var/severity)
	visible_message("<span class = 'notice'>[src] fully withstands the explosion!</span>")
	return

/obj/structure/autoturret/bullet_act(var/obj/item/projectile/p)
	if(!(p.damtype in list("burn","brute","bomb")))
		return
	if(loaded_ammo.len == 0)
		return
	visible_message("<span class = 'danger'>[p] damages [src]'s ammunition storage!</span>")
	loaded_ammo.Cut(loaded_ammo.len-(p.damage/2))

/obj/structure/autoturret/process()
	for(var/mob/living/m in view(vision_range,loc))
		if(!(m in targets_in_view) && !(m in friendlies_stored) && (!(m.health <= 0) || m.stat == CONSCIOUS))
			targets_in_view += m

	if(targets_in_view.len > 0)
		var/list/targets_fireat = targets_in_view.Copy()
		var/shots_per_target = burst_size/targets_fireat.len
		if(targets_fireat.len > burst_size)
			targets_fireat = targets_fireat.Cut(burst_size+1)
			shots_per_target = 1
		for(var/mob/living/target in targets_fireat)
			if(get_dist(loc,target.loc) > vision_range)
				targets_fireat -= target
				break
			else
				for(var/i = 0,i<shots_per_target,i++)
					sleep(burst_delay*i)
					fire_proj_at(target)
		targets_in_view.Cut()

/obj/structure/autoturret/proc/fire_proj_at(var/atom/target)
	if(loaded_ammo.len == 0)
		visible_message("<span class = 'notice'>[src] lets out two clicks.</span>")
		return
	visible_message("<span class = 'notice'>[src] fires at [target]!</span>")
	var/obj/item/projectile/to_fire = loaded_ammo[1]
	loaded_ammo -= to_fire
	to_fire.loc = loc
	to_fire.starting = loc
	if(isnull(target))
		to_fire.launch(target.loc)
	else
		to_fire.launch(target)
	if(fire_sound)
		playsound(loc, fire_sound, 75, 1)
	dir = get_dir(loc,target.loc)

/obj/structure/autoturret/attackby(var/obj/item/stack/I,var/mob/user)
	if(user.a_intent == I_HELP && istype(I))
		if(loaded_ammo.len == max_rounds)
			to_chat(user,"<span class = 'notice'>[src] is full on ammo.</span>")
			return
		if(I.get_material_name() in allowed_materials)
			if(!I.use(1))
				return
			user.visible_message("<span class = 'notice'>[user] places a material into [src]'s material storage.</span>")
			fabricate_rounds(allowed_materials[I.get_material_name()])
			return
	. = ..()
/obj/structure/autoturret/proc/fabricate_rounds(var/amount)
	for(var/i = 0,i<amount,i++)
		if(loaded_ammo.len < max_rounds)
			loaded_ammo += new to_fabricate

/obj/structure/autoturret/Destroy()
	GLOB.processing_objects -= src
	. = ..()

/obj/structure/autoturret/ONI
	name = "\improper Automated Turret"
	desc = "An automatic turret with integrated forerunner technology for ammunition manufacturing and long-range targeting."
	icon = 'code/modules/halo/icons/sentry.dmi'
	icon_state = "artifact"
