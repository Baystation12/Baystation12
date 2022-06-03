//Barricades!
/obj/structure/barricade
	name = "barricade"
	icon_state = "barricade"
	anchored = TRUE
	density = TRUE
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CLIMBABLE
	layer = ABOVE_WINDOW_LAYER

	var/spiky = FALSE

/obj/structure/barricade/Initialize(var/mapload, var/material_name)
	. = ..(mapload)
	if(!material_name)
		material_name = MATERIAL_WOOD
	material = SSmaterials.get_material_by_name("[material_name]")
	if(!material)
		return INITIALIZE_HINT_QDEL
	SetName("[material.display_name] barricade")
	desc = "A heavy, solid barrier made of [material.display_name]."
	color = material.icon_colour
	set_max_health(round(material.integrity * 1.33)) // Equivalent to a global resistance value of 0.75

/obj/structure/barricade/get_material()
	return material

/obj/structure/barricade/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/stack/material/rods) && !spiky)
		var/obj/item/stack/material/rods/R = W
		if(R.get_amount() < 5)
			to_chat(user, "<span class='warning'>You need more rods to build a cheval de frise.</span>")
			return
		visible_message("<span class='notice'>\The [user] begins to work on \the [src].</span>")
		if(do_after(user, 4 SECONDS, src, DO_PUBLIC_UNIQUE))
			if(R.use(5))
				visible_message("<span class='notice'>\The [user] fastens \the [R] to \the [src].</span>")
				var/obj/structure/barricade/spike/CDF = new(loc, material.name, R.material.name)
				CDF.dir = user.dir
				qdel(src)
				return
		else
			return

	if(istype(W, /obj/item/stack))
		var/obj/item/stack/D = W
		if(D.get_material_name() != material.name)
			return //hitting things with the wrong type of stack usually doesn't produce messages, and probably doesn't need to.
		if (get_damage_value())
			if (D.get_amount() < 1)
				to_chat(user, "<span class='warning'>You need one sheet of [material.display_name] to repair \the [src].</span>")
				return
			visible_message("<span class='notice'>[user] begins to repair \the [src].</span>")
			if(do_after(user, 2 SECONDS, src, DO_PUBLIC_UNIQUE) && get_damage_value())
				if (D.use(1))
					restore_health(get_max_health())
					visible_message("<span class='notice'>[user] repairs \the [src].</span>")
				return
		return

	else
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
		damage_health(W.force, W.damtype)
		..()

/obj/structure/barricade/on_death()
	dismantle()

/obj/structure/barricade/proc/dismantle()
	visible_message("<span class='danger'>The barricade is smashed apart!</span>")
	material.place_dismantled_product(get_turf(src))
	qdel(src)

/obj/structure/barricade/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)//So bullets will fly over and stuff.
	if(air_group || (height==0))
		return 1
	if(istype(mover) && mover.checkpass(PASS_FLAG_TABLE))
		return 1
	else
		return 0

//spikey barriers
/obj/structure/barricade/spike
	name = "cheval-de-frise"
	icon_state = "cheval"
	atom_flags = ATOM_FLAG_NO_TEMP_CHANGE
	spiky = TRUE

	var/spike_overlay = "cheval_spikes"
	var/material/rod_material
	var/damage //how badly it smarts when you run into this like a rube
	var/list/poke_description = list("gored", "spiked", "speared", "stuck", "stabbed")

/obj/structure/barricade/spike/Initialize(var/mapload, var/material_name, var/rod_material_name)
	. = ..(mapload, material_name)
	if(!rod_material_name)
		rod_material_name = MATERIAL_WOOD
	rod_material = SSmaterials.get_material_by_name("[rod_material_name]")
	SetName("cheval-de-frise")
	desc = "A rather simple [material.display_name] barrier. It menaces with spikes of [rod_material.display_name]."
	damage = (rod_material.hardness * 0.85)
	overlays += overlay_image(icon, spike_overlay, color = rod_material.icon_colour, flags = RESET_COLOR)

/obj/structure/barricade/spike/Bumped(mob/living/victim)
	. = ..()
	if(!isliving(victim))
		return
	if(world.time - victim.last_bumped <= 15) //spam guard
		return FALSE
	victim.last_bumped = world.time
	var/damage_holder = damage
	var/target_zone = pick(BP_CHEST, BP_GROIN, BP_L_LEG, BP_R_LEG)

	if(MOVING_DELIBERATELY(victim)) //walking into this is less hurty than running
		damage_holder = (damage / 4)

	if(isanimal(victim)) //simple animals have simple health, reduce our damage
		damage_holder = (damage / 4)

	victim.apply_damage(damage_holder, DAMAGE_BRUTE, target_zone, damage_flags = DAMAGE_FLAG_SHARP, used_weapon = src)
	visible_message(SPAN_DANGER("\The [victim] is [pick(poke_description)] by \the [src]!"))
