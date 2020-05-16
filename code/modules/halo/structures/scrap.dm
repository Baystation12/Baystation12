
/obj/item/salvage
	name = "%REPLACETEXT% trash"
	desc = "Some ruined %REPLACETEXT% that could be salvaged with a welder."
	icon = 'code/modules/halo/structures/trash.dmi'
	icon_state = "base1"
	var/salvage_material_name = "steel"

/obj/item/salvage/New()
	. = ..()
	icon_state = "base[pick(1,2,5,6,8,9,11,12,13,16)]"
	desc = replacetext(desc, "%REPLACETEXT%", salvage_material_name)
	name = replacetext(name, "%REPLACETEXT%", salvage_material_name)

/obj/item/salvage/attackby(obj/item/W as obj, mob/user as mob)

	if(salvage_material_name && istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.remove_fuel(1, user))
			var/material/M = name_to_material[salvage_material_name]
			new M.stack_type(get_turf(src))
			qdel(src)
		else
			to_chat(user, "<span class='warning'>You need more fuel.</span>")
	else
		return ..()

/obj/item/salvage/metal
	name = "%REPLACETEXT% scraps"
	icon = 'code/modules/halo/structures/vehicle.dmi'

/obj/item/salvage/metal/New()
	. = ..()
	icon_state = "base[rand(1,7)]"

/obj/item/salvage/plastic
	icon_state = "base1"
	salvage_material_name = "plastic"

/obj/item/salvage/plastic/New()
	. = ..()
	icon_state = "base[pick(14,17,18)]"

/obj/item/salvage/wood
	icon_state = "base1"
	salvage_material_name = "wood"

/obj/item/salvage/wood/New()
	. = ..()
	icon_state = "base[pick(3,4,7,10,15)]"



/* MATERIALS */

/material/steel
	shard_type = /obj/item/salvage/metal

/material/wood
	shard_type = /obj/item/salvage/wood

/material/plastic
	shard_type = /obj/item/salvage/plastic
