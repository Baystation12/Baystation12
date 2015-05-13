var/global/material/material_holographic_steel = null
var/global/material/material_holographic_wood = null

/obj/structure/table

	standard
		icon_state = "plain_preview"
		color = "#666666"
		New()
			material = name_to_material[DEFAULT_WALL_MATERIAL]
			..()

	reinforced
		icon_state = "reinf_preview"
		color = "#666666"
		New()
			material = name_to_material[DEFAULT_WALL_MATERIAL]
			reinforced = name_to_material[DEFAULT_WALL_MATERIAL]
			..()

	woodentable
		icon_state = "plain_preview"
		color = "#824B28"
		New()
			material = name_to_material["wood"]
			..()

	gamblingtable
		icon_state = "gamble_preview"
		New()
			material = name_to_material["wood"]
			carpeted = 1
			..()

	glass
		icon_state = "plain_preview"
		color = "#00E1FF"
		alpha = 77 // 0.3 * 255
		New()
			material = name_to_material["glass"]
			..()

	holotable
		icon_state = "holo_preview"
		color = "#666666"
		New()
			if(!material_holographic_steel)
				material_holographic_steel = new /material/steel
				material_holographic_steel.stack_type = null // Tables with null-stacktype materials cannot be deconstructed
			material = material_holographic_steel
			..()

	woodentable/holotable
		icon_state = "holo_preview"
		New()
			if(!material_holographic_wood)
				material_holographic_wood = new /material/wood
				material_holographic_wood.stack_type = null // Tables with null-stacktype materials cannot be deconstructed
			material = material_holographic_wood
			..()

/*

/obj/structure/table/holotable
	name = "table"
	desc = "A square piece of metal standing on four metal legs. It can not move."
	icon = 'icons/obj/structures.dmi'
	icon_state = "table"
	density = 1
	anchored = 1.0
	layer = 2.8
	throwpass = 1	//You can throw objects over this, despite it's density.

/obj/structure/table/holotable/attack_hand(mob/user as mob)
	return // HOLOTABLE DOES NOT GIVE A FUCK


/obj/structure/table/holotable/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/wrench))
		user << "It's a holotable!  There are no bolts!"
		return

	if(isrobot(user))
		return

	..()

/obj/structure/table/woodentable/holotable
	name = "table"
	desc = "A square piece of wood standing on four wooden legs. It can not move."
	icon = 'icons/obj/structures.dmi'
	icon_state = "wood_table"


/obj/structure/table/rack/holorack
	name = "rack"
	desc = "Different from the Middle Ages version."
	icon = 'icons/obj/objects.dmi'
	icon_state = "rack"

/obj/structure/table/rack/holorack/attack_hand(mob/user as mob)
	return

/obj/structure/table/rack/holorack/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/wrench))
		user << "It's a holorack!  You can't unwrench it!"
		return


*/
