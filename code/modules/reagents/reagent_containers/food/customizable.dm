/obj/item/weapon/reagent_containers/food/snacks/breadslice/attackby(obj/item/W as obj, mob/user as mob)

	if(istype(W,/obj/item/weapon/shard) || istype(W,/obj/item/weapon/reagent_containers/food/snacks))
		var/obj/item/weapon/reagent_containers/food/snacks/customizable/S = new(get_turf(user))
		S.attackby(W,user)
		del(src)
/obj/item/weapon/reagent_containers/food/snacks/bun/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/shard) || istype(W,/obj/item/weapon/reagent_containers/food/snacks))
		var/obj/item/weapon/reagent_containers/food/snacks/customizable/burger/S = new(get_turf(user))
		S.attackby(W,user)
		del(src)
	..()

/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/shard) || istype(W,/obj/item/weapon/reagent_containers/food/snacks))
		var/obj/item/weapon/reagent_containers/food/snacks/customizable/pizza/S = new(get_turf(user))
		S.attackby(W,user)
		del(src)
	..()

/obj/item/weapon/reagent_containers/food/snacks/boiledspagetti/attackby(obj/item/W as obj, mob/user as mob)

	if(istype(W,/obj/item/weapon/shard) || istype(W,/obj/item/weapon/reagent_containers/food/snacks))
		var/obj/item/weapon/reagent_containers/food/snacks/customizable/pasta/S = new(get_turf(user))
		S.attackby(W,user)
		del(src)

/obj/item/trash/bowl
	name = "bowl"
	desc = "An empty bowl. Put some food in it to start making a soup."
	icon = 'icons/obj/food.dmi'
	icon_state = "soup"

/obj/item/trash/bowl/attackby(obj/item/W as obj, mob/user as mob)

	if(istype(W,/obj/item/weapon/shard) || istype(W,/obj/item/weapon/reagent_containers/food/snacks))
		var/obj/item/weapon/reagent_containers/food/snacks/customizable/soup/S = new(get_turf(user))
		S.attackby(W,user)
		del(src)
	..()

/obj/item/weapon/reagent_containers/food/snacks/customizable
	name = "sandwich"
	desc = "A sandwich! A timeless classic."
	icon_state = "breadslice"
	var/baseicon = "sandwich"
	var/basename = "sandwich"
	var/top = 1	//Do we have a top?
	var/add_overlays = 1	//Do we stack?
//	var/offsetstuff = 1 //Do we offset the overlays?
	var/sandwich_limit = 3
	trash = /obj/item/trash/plate
	bitesize = 2

	var/list/ingredients = list()

/obj/item/weapon/reagent_containers/food/snacks/customizable/pizza
	name = "personal pizza"
	desc = "A personalized pan pizza meant for only one person."
	icon_state = "personal_pizza"
	baseicon = "personal_pizza"
	basename = "personal pizza"
	add_overlays = 0
	top = 0

/obj/item/weapon/reagent_containers/food/snacks/customizable/pasta
	name = "spagetti"
	desc = "Noodles. With stuff. Delicious."
	icon_state = "pasta_bot"
	baseicon = "pasta_bot"
	basename = "spagetti"
	add_overlays = 0
	top = 0

/obj/item/weapon/reagent_containers/food/snacks/customizable/soup
	name = "soup"
	desc = "A bowl with liquid and... stuff in it."
	icon_state = "soup"
	baseicon = "soup"
	basename = "soup"
	add_overlays = 0
	trash = /obj/item/trash/bowl
	top = 0

/obj/item/weapon/reagent_containers/food/snacks/customizable/burger
	name = "burger bun"
	desc = "A bun for a burger. Delicious."
	icon_state = "burger"
	baseicon = "burger"
	basename = "burger"
	trash = null

/obj/item/weapon/reagent_containers/food/snacks/customizable/attackby(obj/item/W as obj, mob/user as mob)

	var/sandwich_limit = 4
	for(var/obj/item/O in ingredients)
		if(istype(O,/obj/item/weapon/reagent_containers/food/snacks/breadslice))
			sandwich_limit += 4

	if(src.contents.len > sandwich_limit)
		user << "<span class='warning'>If you put anything else on [src] it's going to collapse. Try adding some more bread slices.</span>"
		return
	else if(istype(W,/obj/item/weapon/shard))
		user << "<span class='notice'> You hide [W] in [src].</span>"
		user.drop_item()
		W.loc = src
		update()
		return
	else if(istype(W,/obj/item/weapon/reagent_containers/food/snacks))
		user << "<span class='notice'> You add [W] to [src].</span>"
		var/obj/item/weapon/reagent_containers/F = W
		F.reagents.trans_to(src, F.reagents.total_volume)
		user.drop_item()
		W.loc = src
		ingredients += W
		update()
		return
	..()

/obj/item/weapon/reagent_containers/food/snacks/customizable/proc/update()
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

		var/image/I = new(src.icon, "[baseicon]_filling")
		I.color = O.filling_color
		if(add_overlays)
			I.pixel_x = pick(list(-1,0,1))
			I.pixel_y = (i*2)+1
		overlays += I

	if(top)
		var/image/T = new(src.icon, "[baseicon]_top")
		T.pixel_x = pick(list(-1,0,1))
		T.pixel_y = (ingredients.len * 2)+1
		overlays += T

	name = lowertext("[fullname] [basename]")
	if(length(name) > 80) name = "[pick(list("absurd","colossal","enormous","ridiculous","massive","oversized","cardiac-arresting","pipe-clogging","edible but sickening","sickening","gargantuan","mega","belly-burster","chest-burster"))] [basename]"
	w_class = n_ceil(Clamp((ingredients.len/2),1,3))

/obj/item/weapon/reagent_containers/food/snacks/customizable/Del()
	for(var/obj/item/O in ingredients)
		del(O)
	..()

/obj/item/weapon/reagent_containers/food/snacks/customizable/examine()
	..()
	var/whatsinside = pick(ingredients)

	usr << "<span class='notice'> You think you can see [whatsinside] in there.</span>"

/obj/item/weapon/reagent_containers/food/snacks/customizable/attack(mob/M as mob, mob/user as mob, def_zone)

	var/obj/item/shard
	for(var/obj/item/O in contents)
		if(istype(O,/obj/item/weapon/shard))
			shard = O
			break

	var/mob/living/H
	if(istype(M,/mob/living))
		H = M

	if(H && shard && M == user) //This needs a check for feeding the food to other people, but that could be abusable.
		H << "<span class='warning'> You lacerate your mouth on a [shard.name] in the [src.basename]!</span>"
		H.adjustBruteLoss(5) //TODO: Target head if human.
	..()
