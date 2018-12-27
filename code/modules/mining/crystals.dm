


/* CRYSTAL STRUCTURE */

/obj/structure/crystal_deposit
	name = "green crystal"
	desc = "Seems to glow with a faint inner light."
	icon = 'icons/obj/mining.dmi'
	icon_state = "crystal"
	var/health = 50
	var/spawn_crystal_type = /obj/item/crystal
	light_range = 6
	light_power = 2
	light_color = "#00FF00"

/obj/structure/crystal_deposit/New()
	. = ..()
	update_light()

/obj/structure/crystal_deposit/pink
	name = "pink crystal"
	icon_state = "crystal2"
	spawn_crystal_type = /obj/item/crystal/pink
	light_color = "#FF00FF"

/obj/structure/crystal_deposit/orange
	name = "orange crystal"
	icon_state = "crystal3"
	spawn_crystal_type = /obj/item/crystal/orange
	light_color = "#FFA500"



/* CRYSTAL ITEM */

/obj/item/crystal
	name = "green crystal"
	desc = "Seems to glow with a faint inner light."
	icon = 'icons/obj/mining.dmi'
	icon_state = "crystal_green"
	light_range = 3
	light_power = 1
	light_color = "#00FF00"

/obj/item/crystal/New()
	. = ..()
	update_light()

/obj/item/crystal/pink
	name = "pink crystal"
	desc = "Seems to glow with a faint inner light."
	icon = 'icons/obj/mining.dmi'
	icon_state = "crystal_pink"
	light_color = "#FF00FF"

/obj/item/crystal/orange
	name = "orange crystal"
	desc = "Seems to glow with a faint inner light."
	icon = 'icons/obj/mining.dmi'
	icon_state = "crystal_orange"
	light_color = "#FFA500"



/* DRILLING THE CRYSTAL */

/obj/structure/crystal_deposit/attackby(obj/item/weapon/W as obj, mob/user as mob)
	var/damage = 0
	var/attack_verb = "has [pick(W.attack_verb)]"
	if(istype(W, /obj/item/weapon/pickaxe))
		var/obj/item/weapon/pickaxe/P = W
		playsound(user, P.drill_sound, 20, 1)
		damage = 9999	//instantly destroy it
		attack_verb = "begins [P.drill_verb]"
	else
		damage = W.force

	health -= damage
	src.visible_message("<span class='warning'>[user] [attack_verb] [src].</span>")
	if(health <= 0)
		src.visible_message("<span class='info'>[src] shatters!</span>")
		new spawn_crystal_type(src.loc)
		qdel(src)
