//Consolidated sandwich file.
/obj/item/weapon/reagent_containers/food/snacks/sandwich
	name = "Sandwich"
	desc = "A grand creation of meat, cheese, bread, and several leaves of lettuce! Arthur Dent would be proud."
	icon_state = "sandwich"
	trash = /obj/item/trash/plate
	filling_color = "#d9be29"
	center_of_mass = "x=16;y=4"
	nutriment_desc = list("bread" = 3, "cheese" = 3)
	nutriment_amt = 3


/obj/item/weapon/reagent_containers/food/snacks/sandwich/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 3)


/obj/item/weapon/reagent_containers/food/snacks/toastedsandwich
	name = "Toasted Sandwich"
	desc = "Now if you only had a pepper bar."
	icon_state = "toastedsandwich"
	trash = /obj/item/trash/plate
	filling_color = "#d9be29"
	center_of_mass = "x=16;y=4"
	nutriment_desc = list("toasted bread" = 3, "cheese" = 3)
	nutriment_amt = 3


/obj/item/weapon/reagent_containers/food/snacks/toastedsandwich/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 3)
	reagents.add_reagent(/datum/reagent/carbon, 2)


/obj/item/weapon/reagent_containers/food/snacks/grilledcheese
	name = "Grilled Cheese Sandwich"
	desc = "Goes great with Tomato soup!"
	icon_state = "toastedsandwich"
	trash = /obj/item/trash/plate
	filling_color = "#d9be29"
	nutriment_desc = list("toasted bread" = 3, "cheese" = 3)
	nutriment_amt = 3


/obj/item/weapon/reagent_containers/food/snacks/grilledcheese/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 4)


/obj/item/weapon/reagent_containers/food/snacks/slice/bread/attackby(obj/item/W as obj, mob/user as mob)

	if(istype(W,/obj/item/weapon/material/shard) || istype(W,/obj/item/weapon/reagent_containers/food/snacks))
		var/obj/item/weapon/reagent_containers/food/snacks/csandwich/S = new(get_turf(src))
		S.attackby(W,user)
		qdel(src)
	..()

/obj/item/weapon/reagent_containers/food/snacks/jellysandwich
	name = "Jelly Sandwich"
	desc = "You wish you had some peanut butter to go with this..."
	icon_state = "jellysandwich"
	trash = /obj/item/trash/plate
	filling_color = "#9e3a78"
	center_of_mass = "x=16;y=8"
	nutriment_desc = list("bread" = 2)
	nutriment_amt = 2
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/jellysandwich/slime/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/slimejelly, 5)

/obj/item/weapon/reagent_containers/food/snacks/jellysandwich/cherry/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/cherryjelly, 5)

/obj/item/weapon/reagent_containers/food/snacks/cubancarp
	name = "Cuban Carp"
	desc = "A sandwich that burns your tongue and then leaves it numb!"
	icon_state = "cubancarp"
	trash = /obj/item/trash/plate
	filling_color = "#e9adff"
	center_of_mass = "x=12;y=5"
	nutriment_desc = list("toasted bread" = 3)
	nutriment_amt = 3
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/cubancarp/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 3)
	reagents.add_reagent(/datum/reagent/capsaicin, 3)


//Custom sandwiches.
/obj/item/weapon/reagent_containers/food/snacks/csandwich
	name = "sandwich"
	desc = "The best thing since sliced bread."
	icon_state = "breadslice"
	trash = /obj/item/trash/plate


	var/list/ingredients = list()

/obj/item/weapon/reagent_containers/food/snacks/csandwich/attackby(obj/item/W as obj, mob/user as mob)

	var/sandwich_limit = 4
	for(var/obj/item/O in ingredients)
		if(istype(O,/obj/item/weapon/reagent_containers/food/snacks/slice/bread))
			sandwich_limit += 4

	if(src.contents.len > sandwich_limit)
		to_chat(user, "<span class='wwarning'>If you put anything else on \the [src] it's going to collapse.</span>")
		return
	else if(istype(W,/obj/item/weapon/material/shard))
		to_chat(user, "<span class='warning'>You hide [W] in \the [src].</span>")
		user.drop_item()
		W.loc = src
		update()
		return
	else if(istype(W,/obj/item/weapon/reagent_containers/food/snacks))
		to_chat(user, "<span class='warning'>You layer [W] over \the [src].</span>")
		var/obj/item/weapon/reagent_containers/F = W
		F.reagents.trans_to_obj(src, F.reagents.total_volume)
		user.drop_item()
		W.loc = src
		ingredients += W
		update()
		return
	..()

/obj/item/weapon/reagent_containers/food/snacks/csandwich/proc/update()
	var/fullname = "" //We need to build this from the contents of the var.
	var/i = 0

	overlays.Cut()

	for(var/obj/item/weapon/reagent_containers/food/snacks/O in ingredients)

		i++
		if(i == 1)
			fullname += "[O.name]"
		else if(i == ingredients.len)
			fullname += " and [O.name]"
		else
			fullname += ", [O.name]"

		var/image/I = new(src.icon, "sandwich_filling")
		I.color = O.filling_color
		I.pixel_x = pick(list(-1,0,1))
		I.pixel_y = (i*2)+1
		overlays += I

	var/image/T = new(src.icon, "sandwich_top")
	T.pixel_x = pick(list(-1,0,1))
	T.pixel_y = (ingredients.len * 2)+1
	overlays += T

	SetName(lowertext("[fullname] sandwich"))
	if(length(name) > 80) SetName("[pick(list("absurd","colossal","enormous","ridiculous"))] sandwich")
	w_class = n_ceil(Clamp((ingredients.len/2),2,4))

/obj/item/weapon/reagent_containers/food/snacks/csandwich/Destroy()
	for(var/obj/item/O in ingredients)
		qdel(O)
	..()

/obj/item/weapon/reagent_containers/food/snacks/csandwich/examine(mob/user)
	. = ..(user)
	var/obj/item/O = pick(contents)
	to_chat(user, "<span class='warning'>You think you can see [O.name] in there.</span>")

/obj/item/weapon/reagent_containers/food/snacks/csandwich/attack(mob/M as mob, mob/user as mob, def_zone)

	var/obj/item/shard
	for(var/obj/item/O in contents)
		if(istype(O,/obj/item/weapon/material/shard))
			shard = O
			break

	var/mob/living/H
	if(istype(M,/mob/living))
		H = M

	if(H && shard && M == user) //This needs a check for feeding the food to other people, but that could be abusable.
		to_chat(H, "<span class='warning'>You lacerate your mouth on a [shard.name] in the sandwich!</span>")
		H.adjustBruteLoss(5) //TODO: Target head if human.
	..()
