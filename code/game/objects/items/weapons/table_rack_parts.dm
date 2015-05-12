// Table parts and rack parts

/obj/item/weapon/table_parts
	name = "table parts"
	desc = "Parts of a table. Poor table."
	gender = PLURAL
	icon = 'icons/obj/items.dmi'
	icon_state = "table_parts"
	matter = list(DEFAULT_WALL_MATERIAL = 3750)
	flags = CONDUCT
	attack_verb = list("slammed", "bashed", "battered", "bludgeoned", "thrashed", "whacked")

	var/build_type = /obj/structure/table
	var/alter_type = /obj/item/weapon/table_parts/reinforced
	var/alter_with = /obj/item/stack/rods
	var/alter_cost = 4
	var/list/stack_types = list(/obj/item/stack/sheet/metal)

/obj/item/weapon/table_parts/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/wrench))
		for(var/material_type in stack_types)
			new material_type(get_turf(user))
		qdel(src)
		return
	else
		if(alter_type && alter_with && istype(W,alter_with))
			var/obj/item/stack/R = W
			if (R.use(alter_cost))
				var/obj/item/new_parts = new alter_type (get_turf(loc))
				user << "<span class='notice'>You modify \the [name] into \a [new_parts].</span>"
				qdel(src)
			else
				user << "<span class='warning'>You need at least [alter_cost] sheets to reinforce the [name].</span>"
			return
	..()

/obj/item/weapon/table_parts/attack_self(mob/user as mob)
	if(locate(/obj/structure/table) in user.loc)
		user << "<span class='warning'>There is already a table here.</span>"
		return

	new build_type( user.loc )
	user.drop_item()
	qdel(src)
	return

/obj/item/weapon/table_parts/reinforced
	name = "reinforced table parts"
	desc = "Hard table parts. Well... harder."
	icon = 'icons/obj/items.dmi'
	icon_state = "reinf_tableparts"
	matter = list(DEFAULT_WALL_MATERIAL = 7500)
	flags = CONDUCT

	stack_types = list(/obj/item/stack/sheet/metal, /obj/item/stack/rods)
	build_type = /obj/structure/table/reinforced
	alter_type = null
	alter_with = null
	alter_cost = null

/obj/item/weapon/table_parts/wood
	name = "wooden table parts"
	desc = "Keep away from fire."
	icon_state = "wood_tableparts"
	flags = null

	stack_types = list(/obj/item/stack/sheet/wood)
	build_type = /obj/structure/table/woodentable
	alter_type = /obj/item/weapon/table_parts/gambling
	alter_with = /obj/item/stack/tile/carpet
	alter_cost = 1

/obj/item/weapon/table_parts/gambling
	name = "gambling table parts"
	desc = "Keep away from security."
	icon_state = "gamble_tableparts"
	flags = null

	stack_types = list(/obj/item/stack/tile/carpet,/obj/item/stack/sheet/wood)
	build_type = /obj/structure/table/gamblingtable
	alter_type = null
	alter_with = null
	alter_cost = null

/obj/item/weapon/table_parts/gambling/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if (istype(W, /obj/item/weapon/crowbar))
		new /obj/item/stack/tile/carpet( get_turf(loc) )
		new /obj/item/weapon/table_parts/wood( get_turf(loc) )
		user << "<span class='notice'>You pry the carpet out of the table.</span>"
		qdel(src)
	..()

/obj/item/weapon/table_parts/rack
	name = "rack parts"
	desc = "Parts of a rack."
	icon_state = "rack_parts"
	stack_types = list(/obj/item/stack/sheet/metal)
	build_type = /obj/structure/table/rack
	alter_type = null
	alter_with = null
	alter_cost = null