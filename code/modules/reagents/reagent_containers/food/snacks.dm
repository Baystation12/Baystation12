//Food items that are eaten normally and don't leave anything behind.
/obj/item/weapon/reagent_containers/food/snacks
	name = "snack"
	desc = "yummy"
	icon = 'icons/obj/food.dmi'
	icon_state = null
	var/bitesize = 1
	var/bitecount = 0
	var/trash = null
	var/slice_path
	var/slices_num
	var/dried_type = null
	var/dry = 0
	center_of_mass = list("x"=15, "y"=15)
	w_class = 2

	//Placeholder for effect that trigger on eating that aren't tied to reagents.
/obj/item/weapon/reagent_containers/food/snacks/proc/On_Consume(var/mob/M)
	if(!usr)	return
	if(!reagents.total_volume)
		M.visible_message("<span class='notice'>[M] finishes eating \the [src].</span>","<span class='notice'>You finish eating \the [src].</span>")
		usr.drop_from_inventory(src)	//so icons update :[

		if(trash)
			if(ispath(trash,/obj/item))
				var/obj/item/TrashItem = new trash(usr)
				usr.put_in_hands(TrashItem)
			else if(istype(trash,/obj/item))
				usr.put_in_hands(trash)
		qdel(src)
	return

/obj/item/weapon/reagent_containers/food/snacks/attack_self(mob/user as mob)
	return

/obj/item/weapon/reagent_containers/food/snacks/attack(mob/M as mob, mob/user as mob, def_zone)

	if(!reagents.total_volume)
		user << "<span class='danger'>None of [src] left!</span>"
		user.drop_from_inventory(src)
		qdel(src)
		return 0

	if(istype(M, /mob/living/carbon))
		var/fullness = M.nutrition + (M.reagents.get_reagent_amount("nutriment") * 25)
		if(M == user)								//If you're eating it yourself
			if(istype(M,/mob/living/carbon/human))
				var/mob/living/carbon/human/H = M
				if(H.species.flags & IS_SYNTHETIC)
					H << "<span class='danger'>You have a monitor for a head, where do you think you're going to put that?</span>"
					return
			
				var/obj/item/blocked = H.check_mouth_coverage()
				if(blocked)
					user << "<span class='warning'>\The [blocked] is in the way!</span>"
					return
			
			if (fullness <= 50)
				M << "<span class='danger'>You hungrily chew out a piece of [src] and gobble it!</span>"
			if (fullness > 50 && fullness <= 150)
				M << "<span class='notice'>You hungrily begin to eat [src].</span>"
			if (fullness > 150 && fullness <= 350)
				M << "<span class='notice'>You take a bite of [src].</span>"
			if (fullness > 350 && fullness <= 550)
				M << "<span class='notice'>You unwillingly chew a bit of [src].</span>"
			if (fullness > (550 * (1 + M.overeatduration / 2000)))	// The more you eat - the more you can eat
				M << "<span class='danger'>You cannot force any more of [src] to go down your throat.</span>"
				return 0
		else
			if(istype(M,/mob/living/carbon/human))
				var/mob/living/carbon/human/H = M
				if(H.species.flags & IS_SYNTHETIC)
					user << "<span class='danger'>They have a monitor for a head, where do you think you're going to put that?</span>"
					return
				
				var/obj/item/blocked = H.check_mouth_coverage()
				if(blocked)
					user << "<span class='warning'>\The [blocked] is in the way!</span>"
					return

			if(!istype(M, /mob/living/carbon/slime))		//If you're feeding it to someone else.

				if (fullness <= (550 * (1 + M.overeatduration / 1000)))
					user.visible_message("<span class='danger'>[user] attempts to feed [M] [src].</span>")
				else
					user.visible_message("<span class='danger'>[user] cannot force anymore of [src] down [M]'s throat.</span>")
					return 0

				if(!do_mob(user, M)) return

				M.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has been fed [src.name] by [user.name] ([user.ckey]) Reagents: [reagentlist(src)]</font>")
				user.attack_log += text("\[[time_stamp()]\] <font color='red'>Fed [src.name] by [M.name] ([M.ckey]) Reagents: [reagentlist(src)]</font>")
				msg_admin_attack("[key_name(user)] fed [key_name(M)] with [src.name] Reagents: [reagentlist(src)] (INTENT: [uppertext(user.a_intent)])")

				user.visible_message("<span class='danger'>[user] feeds [M] [src].</span>")

			else
				user << "This creature does not seem to have a mouth!"
				return

		if(reagents)								//Handle ingestion of the reagent.
			playsound(M.loc,'sound/items/eatfood.ogg', rand(10,50), 1)
			if(reagents.total_volume)
				if(reagents.total_volume > bitesize)
					/*
					 * I totally cannot understand what this code supposed to do.
					 * Right now every snack consumes in 2 bites, my popcorn does not work right, so I simplify it. -- rastaf0
					var/temp_bitesize =  max(reagents.total_volume /2, bitesize)
					reagents.trans_to(M, temp_bitesize)
					*/
					reagents.trans_to_ingest(M, bitesize)
				else
					reagents.trans_to_ingest(M, reagents.total_volume)
				bitecount++
				On_Consume(M)
			return 1

	return 0

/obj/item/weapon/reagent_containers/food/snacks/examine(mob/user)
	if(!..(user, 1))
		return
	if (bitecount==0)
		return
	else if (bitecount==1)
		user << "\blue \The [src] was bitten by someone!"
	else if (bitecount<=3)
		user << "\blue \The [src] was bitten [bitecount] times!"
	else
		user << "\blue \The [src] was bitten multiple times!"

/obj/item/weapon/reagent_containers/food/snacks/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/storage))
		..() // -> item/attackby()
		return

	// Eating with forks
	if(istype(W,/obj/item/weapon/kitchen/utensil))
		var/obj/item/weapon/kitchen/utensil/U = W

		if(!U.reagents)
			U.create_reagents(5)

		if (U.reagents.total_volume > 0)
			user << "\red You already have something on your [U]."
			return

		user.visible_message( \
			"[user] scoops up some [src] with \the [U]!", \
			"\blue You scoop up some [src] with \the [U]!" \
		)

		src.bitecount++
		U.overlays.Cut()
		U.loaded = "[src]"
		var/image/I = new(U.icon, "loadedfood")
		I.color = src.filling_color
		U.overlays += I

		reagents.trans_to(U,min(reagents.total_volume,5))

		if (reagents.total_volume <= 0)
			qdel(src)
		return

	if (is_sliceable())
		//these are used to allow hiding edge items in food that is not on a table/tray
		var/can_slice_here = isturf(src.loc) && ((locate(/obj/structure/table) in src.loc) || (locate(/obj/machinery/optable) in src.loc) || (locate(/obj/item/weapon/tray) in src.loc))
		var/hide_item = !has_edge(W) || !can_slice_here

		if (hide_item)
			if (W.w_class >= src.w_class || is_robot_module(W))
				return

			user << "\red You slip [W] inside [src]."
			user.remove_from_mob(W)
			W.dropped(user)
			add_fingerprint(user)
			contents += W
			return

		if (has_edge(W))
			if (!can_slice_here)
				user << "\red You cannot slice [src] here! You need a table or at least a tray to do it."
				return

			var/slices_lost = 0
			if (W.w_class > 3)
				user.visible_message("\blue [user] crudely slices \the [src] with [W]!", "\blue You crudely slice \the [src] with your [W]!")
				slices_lost = rand(1,min(1,round(slices_num/2)))
			else
				user.visible_message("\blue [user] slices \the [src]!", "\blue You slice \the [src]!")

			var/reagents_per_slice = reagents.total_volume/slices_num
			for(var/i=1 to (slices_num-slices_lost))
				var/obj/slice = new slice_path (src.loc)
				reagents.trans_to(slice,reagents_per_slice)
			qdel(src)
			return

/obj/item/weapon/reagent_containers/food/snacks/proc/is_sliceable()
	return (slices_num && slice_path && slices_num > 0)

/obj/item/weapon/reagent_containers/food/snacks/Destroy()
	if(contents)
		for(var/atom/movable/something in contents)
			something.loc = get_turf(src)
	..()

////////////////////////////////////////////////////////////////////////////////
/// FOOD END
////////////////////////////////////////////////////////////////////////////////
/obj/item/weapon/reagent_containers/food/snacks/attack_generic(var/mob/living/user)
	if(!isanimal(user) && !isalien(user))
		return
	user.visible_message("<b>[user]</b> nibbles away at \the [src].","You nibble away at \the [src].")
	bitecount++
	if(reagents && user.reagents)
		reagents.trans_to_ingest(user, bitesize)
	spawn(5)
		if(!src && !user.client)
			user.custom_emote(1,"[pick("burps", "cries for more", "burps twice", "looks at the area where the food was")]")
			qdel(src)
	On_Consume(user)

//////////////////////////////////////////////////
////////////////////////////////////////////Snacks
//////////////////////////////////////////////////
//Items in the "Snacks" subcategory are food items that people actually eat. The key points are that they are created
//	already filled with reagents and are destroyed when empty. Additionally, they make a "munching" noise when eaten.

//Notes by Darem: Food in the "snacks" subtype can hold a maximum of 50 units Generally speaking, you don't want to go over 40
//	total for the item because you want to leave space for extra condiments. If you want effect besides healing, add a reagent for
//	it. Try to stick to existing reagents when possible (so if you want a stronger healing effect, just use Tricordrazine). On use
//	effect (such as the old officer eating a donut code) requires a unique reagent (unless you can figure out a better way).

//The nutriment reagent and bitesize variable replace the old heal_amt and amount variables. Each unit of nutriment is equal to
//	2 of the old heal_amt variable. Bitesize is the rate at which the reagents are consumed. So if you have 6 nutriment and a
//	bitesize of 2, then it'll take 3 bites to eat. Unlike the old system, the contained reagents are evenly spread among all
//	the bites. No more contained reagents = no more bites.

//Here is an example of the new formatting for anyone who wants to add more food items.
///obj/item/weapon/reagent_containers/food/snacks/xenoburger			//Identification path for the object.
//	name = "Xenoburger"													//Name that displays in the UI.
//	desc = "Smells caustic. Tastes like heresy."						//Duh
//	icon_state = "xburger"												//Refers to an icon in food.dmi
//	New()																//Don't mess with this.
//		..()															//Same here.
//		reagents.add_reagent("xenomicrobes", 10)						//This is what is in the food item. you may copy/paste
//		reagents.add_reagent("nutriment", 2)							//	this line of code for all the contents.
//		bitesize = 3													//This is the amount each bite consumes.




/obj/item/weapon/reagent_containers/food/snacks/aesirsalad
	name = "Aesir salad"
	desc = "Probably too incredible for mortal men to fully enjoy."
	icon_state = "aesirsalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#468C00"

	New()
		..()
		reagents.add_reagent("nutriment", 8)
		reagents.add_reagent("doctorsdelight", 8)
		reagents.add_reagent("tricordrazine", 8)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/candy
	name = "candy"
	desc = "Nougat, love it or hate it."
	icon_state = "candy"
	trash = /obj/item/trash/candy
	filling_color = "#7D5F46"

	New()
		..()
		reagents.add_reagent("nutriment", 1)
		reagents.add_reagent("sugar", 3)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/candy/donor
	name = "Donor Candy"
	desc = "A little treat for blood donors."
	trash = /obj/item/trash/candy
	New()
		..()
		reagents.add_reagent("nutriment", 10)
		reagents.add_reagent("sugar", 3)
		bitesize = 5

/obj/item/weapon/reagent_containers/food/snacks/candy_corn
	name = "candy corn"
	desc = "It's a handful of candy corn. Cannot be stored in a detective's hat, alas."
	icon_state = "candy_corn"
	filling_color = "#FFFCB0"

	New()
		..()
		reagents.add_reagent("nutriment", 4)
		reagents.add_reagent("sugar", 2)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/chips
	name = "chips"
	desc = "Commander Riker's What-The-Crisps"
	icon_state = "chips"
	trash = /obj/item/trash/chips
	filling_color = "#E8C31E"

	New()
		..()
		reagents.add_reagent("nutriment", 3)
		bitesize = 1

/obj/item/weapon/reagent_containers/food/snacks/cookie
	name = "cookie"
	desc = "COOKIE!!!"
	icon_state = "COOKIE!!!"
	filling_color = "#DBC94F"

	New()
		..()
		reagents.add_reagent("nutriment", 5)
		bitesize = 1

/obj/item/weapon/reagent_containers/food/snacks/chocolatebar
	name = "Chocolate Bar"
	desc = "Such sweet, fattening food."
	icon_state = "chocolatebar"
	filling_color = "#7D5F46"

	New()
		..()
		reagents.add_reagent("nutriment", 2)
		reagents.add_reagent("sugar", 2)
		reagents.add_reagent("coco", 2)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/chocolateegg
	name = "Chocolate Egg"
	desc = "Such sweet, fattening food."
	icon_state = "chocolateegg"
	filling_color = "#7D5F46"

	New()
		..()
		reagents.add_reagent("nutriment", 3)
		reagents.add_reagent("sugar", 2)
		reagents.add_reagent("coco", 2)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/donut
	name = "donut"
	desc = "Goes great with Robust Coffee."
	icon_state = "donut1"
	filling_color = "#D9C386"
	var/overlay_state = "box-donut1"

/obj/item/weapon/reagent_containers/food/snacks/donut/normal
	name = "donut"
	desc = "Goes great with Robust Coffee."
	icon_state = "donut1"
	New()
		..()
		reagents.add_reagent("nutriment", 3)
		reagents.add_reagent("sprinkles", 1)
		src.bitesize = 3
		if(prob(30))
			src.icon_state = "donut2"
			src.overlay_state = "box-donut2"
			src.name = "frosted donut"
			reagents.add_reagent("sprinkles", 2)

/obj/item/weapon/reagent_containers/food/snacks/donut/chaos
	name = "Chaos Donut"
	desc = "Like life, it never quite tastes the same."
	icon_state = "donut1"
	filling_color = "#ED11E6"

	New()
		..()
		reagents.add_reagent("nutriment", 2)
		reagents.add_reagent("sprinkles", 1)
		bitesize = 10
		var/chaosselect = pick(1,2,3,4,5,6,7,8,9,10)
		switch(chaosselect)
			if(1)
				reagents.add_reagent("nutriment", 3)
			if(2)
				reagents.add_reagent("capsaicin", 3)
			if(3)
				reagents.add_reagent("frostoil", 3)
			if(4)
				reagents.add_reagent("sprinkles", 3)
			if(5)
				reagents.add_reagent("phoron", 3)
			if(6)
				reagents.add_reagent("coco", 3)
			if(7)
				reagents.add_reagent("slimejelly", 3)
			if(8)
				reagents.add_reagent("banana", 3)
			if(9)
				reagents.add_reagent("berryjuice", 3)
			if(10)
				reagents.add_reagent("tricordrazine", 3)
		if(prob(30))
			src.icon_state = "donut2"
			src.overlay_state = "box-donut2"
			src.name = "Frosted Chaos Donut"
			reagents.add_reagent("sprinkles", 2)


/obj/item/weapon/reagent_containers/food/snacks/donut/jelly
	name = "Jelly Donut"
	desc = "You jelly?"
	icon_state = "jdonut1"
	filling_color = "#ED1169"

	New()
		..()
		reagents.add_reagent("nutriment", 3)
		reagents.add_reagent("sprinkles", 1)
		reagents.add_reagent("berryjuice", 5)
		bitesize = 5
		if(prob(30))
			src.icon_state = "jdonut2"
			src.overlay_state = "box-donut2"
			src.name = "Frosted Jelly Donut"
			reagents.add_reagent("sprinkles", 2)

/obj/item/weapon/reagent_containers/food/snacks/donut/slimejelly
	name = "Jelly Donut"
	desc = "You jelly?"
	icon_state = "jdonut1"
	filling_color = "#ED1169"

	New()
		..()
		reagents.add_reagent("nutriment", 3)
		reagents.add_reagent("sprinkles", 1)
		reagents.add_reagent("slimejelly", 5)
		bitesize = 5
		if(prob(30))
			src.icon_state = "jdonut2"
			src.overlay_state = "box-donut2"
			src.name = "Frosted Jelly Donut"
			reagents.add_reagent("sprinkles", 2)

/obj/item/weapon/reagent_containers/food/snacks/donut/cherryjelly
	name = "Jelly Donut"
	desc = "You jelly?"
	icon_state = "jdonut1"
	filling_color = "#ED1169"

	New()
		..()
		reagents.add_reagent("nutriment", 3)
		reagents.add_reagent("sprinkles", 1)
		reagents.add_reagent("cherryjelly", 5)
		bitesize = 5
		if(prob(30))
			src.icon_state = "jdonut2"
			src.overlay_state = "box-donut2"
			src.name = "Frosted Jelly Donut"
			reagents.add_reagent("sprinkles", 2)

/obj/item/weapon/reagent_containers/food/snacks/egg
	name = "egg"
	desc = "An egg!"
	icon_state = "egg"
	filling_color = "#FDFFD1"

/obj/item/weapon/reagent_containers/food/snacks/egg/New()
	..()
	reagents.add_reagent("egg", 3)

/obj/item/weapon/reagent_containers/food/snacks/egg/afterattack(obj/O as obj, mob/user as mob, proximity)
	if(istype(O,/obj/machinery/microwave))
		return ..()
	if(!(proximity && O.is_open_container()))
		return
	user << "You crack \the [src] into \the [O]."
	reagents.trans_to(O, reagents.total_volume)
	user.drop_from_inventory(src)
	qdel(src)

/obj/item/weapon/reagent_containers/food/snacks/egg/throw_impact(atom/hit_atom)
	..()
	new/obj/effect/decal/cleanable/egg_smudge(src.loc)
	src.reagents.reaction(hit_atom, TOUCH)
	src.visible_message("\red [src.name] has been squashed.","\red You hear a smack.")
	qdel(src)

/obj/item/weapon/reagent_containers/food/snacks/egg/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype( W, /obj/item/weapon/pen/crayon ))
		var/obj/item/weapon/pen/crayon/C = W
		var/clr = C.colourName

		if(!(clr in list("blue","green","mime","orange","purple","rainbow","red","yellow")))
			usr << "\blue The egg refuses to take on this color!"
			return

		usr << "\blue You color \the [src] [clr]"
		icon_state = "egg-[clr]"
	else
		..()

/obj/item/weapon/reagent_containers/food/snacks/egg/blue
	icon_state = "egg-blue"

/obj/item/weapon/reagent_containers/food/snacks/egg/green
	icon_state = "egg-green"

/obj/item/weapon/reagent_containers/food/snacks/egg/mime
	icon_state = "egg-mime"

/obj/item/weapon/reagent_containers/food/snacks/egg/orange
	icon_state = "egg-orange"

/obj/item/weapon/reagent_containers/food/snacks/egg/purple
	icon_state = "egg-purple"

/obj/item/weapon/reagent_containers/food/snacks/egg/rainbow
	icon_state = "egg-rainbow"

/obj/item/weapon/reagent_containers/food/snacks/egg/red
	icon_state = "egg-red"

/obj/item/weapon/reagent_containers/food/snacks/egg/yellow
	icon_state = "egg-yellow"

/obj/item/weapon/reagent_containers/food/snacks/friedegg
	name = "Fried egg"
	desc = "A fried egg, with a touch of salt and pepper."
	icon_state = "friedegg"
	filling_color = "#FFDF78"

	New()
		..()
		reagents.add_reagent("protein", 3)
		reagents.add_reagent("sodiumchloride", 1)
		reagents.add_reagent("blackpepper", 1)
		bitesize = 1

/obj/item/weapon/reagent_containers/food/snacks/boiledegg
	name = "Boiled egg"
	desc = "A hard boiled egg."
	icon_state = "egg"
	filling_color = "#FFFFFF"

	New()
		..()
		reagents.add_reagent("protein", 2)

/obj/item/weapon/reagent_containers/food/snacks/organ
	name = "organ"
	desc = "It's good for you."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "appendix"
	filling_color = "#E00D34"

	New()
		..()
		reagents.add_reagent("protein", rand(3,5))
		reagents.add_reagent("toxin", rand(1,3))
		src.bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/tofu
	name = "Tofu"
	icon_state = "tofu"
	desc = "We all love tofu."
	filling_color = "#FFFEE0"

	New()
		..()
		reagents.add_reagent("nutriment", 3)
		src.bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/tofurkey
	name = "Tofurkey"
	desc = "A fake turkey made from tofu."
	icon_state = "tofurkey"
	filling_color = "#FFFEE0"

	New()
		..()
		reagents.add_reagent("nutriment", 12)
		reagents.add_reagent("stoxin", 3)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/stuffing
	name = "Stuffing"
	desc = "Moist, peppery breadcrumbs for filling the body cavities of dead birds. Dig in!"
	icon_state = "stuffing"
	filling_color = "#C9AC83"

	New()
		..()
		reagents.add_reagent("nutriment", 3)
		bitesize = 1

/obj/item/weapon/reagent_containers/food/snacks/carpmeat
	name = "carp fillet"
	desc = "A fillet of spess carp meat"
	icon_state = "fishfillet"
	filling_color = "#FFDEFE"

	New()
		..()
		reagents.add_reagent("protein", 3)
		reagents.add_reagent("carpotoxin", 3)
		src.bitesize = 6

/obj/item/weapon/reagent_containers/food/snacks/fishfingers
	name = "Fish Fingers"
	desc = "A finger of fish."
	icon_state = "fishfingers"
	filling_color = "#FFDEFE"

	New()
		..()
		reagents.add_reagent("protein", 4)
		reagents.add_reagent("carpotoxin", 3)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/hugemushroomslice
	name = "huge mushroom slice"
	desc = "A slice from a huge mushroom."
	icon_state = "hugemushroomslice"
	filling_color = "#E0D7C5"

	New()
		..()
		reagents.add_reagent("nutriment", 3)
		reagents.add_reagent("psilocybin", 3)
		src.bitesize = 6

/obj/item/weapon/reagent_containers/food/snacks/tomatomeat
	name = "tomato slice"
	desc = "A slice from a huge tomato"
	icon_state = "tomatomeat"
	filling_color = "#DB0000"

	New()
		..()
		reagents.add_reagent("nutriment", 3)
		src.bitesize = 6

/obj/item/weapon/reagent_containers/food/snacks/bearmeat
	name = "bear meat"
	desc = "A very manly slab of meat."
	icon_state = "bearmeat"
	filling_color = "#DB0000"

	New()
		..()
		reagents.add_reagent("protein", 12)
		reagents.add_reagent("hyperzine", 5)
		src.bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/xenomeat
	name = "meat"
	desc = "A slab of green meat. Smells like acid."
	icon_state = "xenomeat"
	filling_color = "#43DE18"

	New()
		..()
		reagents.add_reagent("protein", 6)
		reagents.add_reagent("pacid",6)
		src.bitesize = 6

/obj/item/weapon/reagent_containers/food/snacks/meatball
	name = "meatball"
	desc = "A great meal all round."
	icon_state = "meatball"
	filling_color = "#DB0000"

	New()
		..()
		reagents.add_reagent("protein", 3)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sausage
	name = "Sausage"
	desc = "A piece of mixed, long meat."
	icon_state = "sausage"
	filling_color = "#DB0000"

	New()
		..()
		reagents.add_reagent("protein", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/donkpocket/sinpocket
	name = "\improper Sin-pocket"
	desc = "The food of choice for the veteran. Do <B>NOT</B> overconsume."
	filling_color = "#6D6D00"
	heated_reagents = list("doctorsdelight" = 5, "hyperzine" = 0.75, "synaptizine" = 0.25)
	var/has_been_heated = 0

/obj/item/weapon/reagent_containers/food/snacks/donkpocket/sinpocket/attack_self(mob/user)
	if(has_been_heated)
		user << "<span class='notice'>The heating chemicals have already been spent.</span>"
		return
	has_been_heated = 1
	user.visible_message("<span class='notice'>[user] crushes \the [src] package.</span>", "You crush \the [src] package and feel a comfortable heat build up.")
	spawn(200)
		user << "You think \the [src] is ready to eat about now."
		heat()

/obj/item/weapon/reagent_containers/food/snacks/donkpocket
	name = "Donk-pocket"
	desc = "The food of choice for the seasoned traitor."
	icon_state = "donkpocket"
	filling_color = "#DEDEAB"

	New()
		..()
		reagents.add_reagent("nutriment", 2)
		reagents.add_reagent("protein", 2)

	var/warm = 0
	var/list/heated_reagents = list("tricordrazine" = 5)
	proc/heat()
		warm = 1
		for(var/reagent in heated_reagents)
			reagents.add_reagent(reagent, heated_reagents[reagent])
		bitesize = 6
		name = "Warm " + name
		cooltime()

	proc/cooltime()
		if (src.warm)
			spawn(4200)
				src.warm = 0
				for(var/reagent in heated_reagents)
					src.reagents.del_reagent(reagent)
				src.name = initial(name)
		return

/obj/item/weapon/reagent_containers/food/snacks/brainburger
	name = "brainburger"
	desc = "A strange looking burger. It looks almost sentient."
	icon_state = "brainburger"
	filling_color = "#F2B6EA"

	New()
		..()
		reagents.add_reagent("protein", 6)
		reagents.add_reagent("alkysine", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/ghostburger
	name = "Ghost Burger"
	desc = "Spooky! It doesn't look very filling."
	icon_state = "ghostburger"
	filling_color = "#FFF2FF"

	New()
		..()
		reagents.add_reagent("nutriment", 2)
		bitesize = 2


/obj/item/weapon/reagent_containers/food/snacks/human
	var/hname = ""
	var/job = null
	filling_color = "#D63C3C"

/obj/item/weapon/reagent_containers/food/snacks/human/burger
	name = "-burger"
	desc = "A bloody burger."
	icon_state = "hburger"
	New()
		..()
		reagents.add_reagent("protein", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/cheeseburger
	name = "cheeseburger"
	desc = "The cheese adds a good flavor."
	icon_state = "cheeseburger"
	New()
		..()
		reagents.add_reagent("protein", 2)
		reagents.add_reagent("nutriment", 2)

/obj/item/weapon/reagent_containers/food/snacks/monkeyburger
	name = "burger"
	desc = "The cornerstone of every nutritious breakfast."
	icon_state = "hburger"
	filling_color = "#D63C3C"

	New()
		..()
		reagents.add_reagent("protein", 3)
		reagents.add_reagent("nutriment", 3)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/fishburger
	name = "Fillet -o- Carp Sandwich"
	desc = "Almost like a carp is yelling somewhere... Give me back that fillet -o- carp, give me that carp."
	icon_state = "fishburger"
	filling_color = "#FFDEFE"

	New()
		..()
		reagents.add_reagent("protein", 6)
		reagents.add_reagent("carpotoxin", 3)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/tofuburger
	name = "Tofu Burger"
	desc = "What.. is that meat?"
	icon_state = "tofuburger"
	filling_color = "#FFFEE0"

	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/roburger
	name = "roburger"
	desc = "The lettuce is the only organic component. Beep."
	icon_state = "roburger"
	filling_color = "#CCCCCC"

	New()
		..()
		reagents.add_reagent("nutriment", 2)
		if(prob(5))
			reagents.add_reagent("nanites", 2)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/roburgerbig
	name = "roburger"
	desc = "This massive patty looks like poison. Beep."
	icon_state = "roburger"
	filling_color = "#CCCCCC"
	volume = 100

	New()
		..()
		reagents.add_reagent("nanites", 100)
		bitesize = 0.1

/obj/item/weapon/reagent_containers/food/snacks/xenoburger
	name = "xenoburger"
	desc = "Smells caustic. Tastes like heresy."
	icon_state = "xburger"
	filling_color = "#43DE18"

	New()
		..()
		reagents.add_reagent("protein", 8)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/clownburger
	name = "Clown Burger"
	desc = "This tastes funny..."
	icon_state = "clownburger"
	filling_color = "#FF00FF"

	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/mimeburger
	name = "Mime Burger"
	desc = "Its taste defies language."
	icon_state = "mimeburger"
	filling_color = "#FFFFFF"

	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/omelette
	name = "Omelette Du Fromage"
	desc = "That's all you can say!"
	icon_state = "omelette"
	trash = /obj/item/trash/plate
	filling_color = "#FFF9A8"

	//var/herp = 0
	New()
		..()
		reagents.add_reagent("protein", 8)
		bitesize = 1

/obj/item/weapon/reagent_containers/food/snacks/muffin
	name = "Muffin"
	desc = "A delicious and spongy little cake"
	icon_state = "muffin"
	filling_color = "#E0CF9B"

	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/pie
	name = "Banana Cream Pie"
	desc = "Just like back home, on clown planet! HONK!"
	icon_state = "pie"
	trash = /obj/item/trash/plate
	filling_color = "#FBFFB8"

/obj/item/weapon/reagent_containers/food/snacks/pie/New()
	..()
	reagents.add_reagent("nutriment", 4)
	reagents.add_reagent("banana",5)
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/pie/throw_impact(atom/hit_atom)
	..()
	new/obj/effect/decal/cleanable/pie_smudge(src.loc)
	src.visible_message("\red [src.name] splats.","\red You hear a splat.")
	qdel(src)

/obj/item/weapon/reagent_containers/food/snacks/berryclafoutis
	name = "Berry Clafoutis"
	desc = "No black birds, this is a good sign."
	icon_state = "berryclafoutis"
	trash = /obj/item/trash/plate
	New()
		..()
		reagents.add_reagent("nutriment", 4)
		reagents.add_reagent("berryjuice", 5)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/waffles
	name = "waffles"
	desc = "Mmm, waffles"
	icon_state = "waffles"
	trash = /obj/item/trash/waffles
	filling_color = "#E6DEB5"

	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/eggplantparm
	name = "Eggplant Parmigiana"
	desc = "The only good recipe for eggplant."
	icon_state = "eggplantparm"
	trash = /obj/item/trash/plate
	filling_color = "#4D2F5E"

	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/soylentgreen
	name = "Soylent Green"
	desc = "Not made of people. Honest." //Totally people.
	icon_state = "soylent_green"
	trash = /obj/item/trash/waffles
	filling_color = "#B8E6B5"

	New()
		..()
		reagents.add_reagent("protein", 10)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/soylenviridians
	name = "Soylen Virdians"
	desc = "Not made of people. Honest." //Actually honest for once.
	icon_state = "soylent_yellow"
	trash = /obj/item/trash/waffles
	filling_color = "#E6FA61"

	New()
		..()
		reagents.add_reagent("nutriment", 10)
		bitesize = 2


/obj/item/weapon/reagent_containers/food/snacks/meatpie
	name = "Meat-pie"
	icon_state = "meatpie"
	desc = "An old barber recipe, very delicious!"
	trash = /obj/item/trash/plate
	filling_color = "#948051"

	New()
		..()
		reagents.add_reagent("protein", 10)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/tofupie
	name = "Tofu-pie"
	icon_state = "meatpie"
	desc = "A delicious tofu pie."
	trash = /obj/item/trash/plate
	filling_color = "#FFFEE0"

	New()
		..()
		reagents.add_reagent("nutriment", 10)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/amanita_pie
	name = "amanita pie"
	desc = "Sweet and tasty poison pie."
	icon_state = "amanita_pie"
	filling_color = "#FFCCCC"

	New()
		..()
		reagents.add_reagent("nutriment", 5)
		reagents.add_reagent("amatoxin", 3)
		reagents.add_reagent("psilocybin", 1)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/plump_pie
	name = "plump pie"
	desc = "I bet you love stuff made out of plump helmets!"
	icon_state = "plump_pie"
	filling_color = "#B8279B"

	New()
		..()
		if(prob(10))
			name = "exceptional plump pie"
			desc = "Microwave is taken by a fey mood! It has cooked an exceptional plump pie!"
			reagents.add_reagent("nutriment", 8)
			reagents.add_reagent("tricordrazine", 5)
			bitesize = 2
		else
			reagents.add_reagent("nutriment", 8)
			bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/xemeatpie
	name = "Xeno-pie"
	icon_state = "xenomeatpie"
	desc = "A delicious meatpie. Probably heretical."
	trash = /obj/item/trash/plate
	filling_color = "#43DE18"

	New()
		..()
		reagents.add_reagent("protein", 10)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/wingfangchu
	name = "Wing Fang Chu"
	desc = "A savory dish of alien wing wang in soy."
	icon_state = "wingfangchu"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#43DE18"

	New()
		..()
		reagents.add_reagent("protein", 6)
		bitesize = 2


/obj/item/weapon/reagent_containers/food/snacks/human/kabob
	name = "-kabob"
	icon_state = "kabob"
	desc = "A human meat, on a stick."
	trash = /obj/item/stack/rods
	filling_color = "#A85340"

	New()
		..()
		reagents.add_reagent("protein", 8)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/monkeykabob
	name = "Meat-kabob"
	icon_state = "kabob"
	desc = "Delicious meat, on a stick."
	trash = /obj/item/stack/rods
	filling_color = "#A85340"

	New()
		..()
		reagents.add_reagent("protein", 8)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/tofukabob
	name = "Tofu-kabob"
	icon_state = "kabob"
	desc = "Vegan meat, on a stick."
	trash = /obj/item/stack/rods
	filling_color = "#FFFEE0"

	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/cubancarp
	name = "Cuban Carp"
	desc = "A sandwich that burns your tongue and then leaves it numb!"
	icon_state = "cubancarp"
	trash = /obj/item/trash/plate
	filling_color = "#E9ADFF"

	New()
		..()
		reagents.add_reagent("protein", 3)
		reagents.add_reagent("nutriment", 3)
		reagents.add_reagent("carpotoxin", 3)
		reagents.add_reagent("capsaicin", 3)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/popcorn
	name = "Popcorn"
	desc = "Now let's find some cinema."
	icon_state = "popcorn"
	trash = /obj/item/trash/popcorn
	var/unpopped = 0
	filling_color = "#FFFAD4"

	New()
		..()
		unpopped = rand(1,10)
		reagents.add_reagent("nutriment", 2)
		bitesize = 0.1 //this snack is supposed to be eating during looooong time. And this it not dinner food! --rastaf0
	On_Consume()
		if(prob(unpopped))	//lol ...what's the point?
			usr << "\red You bite down on an un-popped kernel!"
			unpopped = max(0, unpopped-1)
		..()


/obj/item/weapon/reagent_containers/food/snacks/sosjerky
	name = "Scaredy's Private Reserve Beef Jerky"
	icon_state = "sosjerky"
	desc = "Beef jerky made from the finest space cows."
	trash = /obj/item/trash/sosjerky
	filling_color = "#631212"

	New()
		..()
		reagents.add_reagent("protein", 4)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/no_raisin
	name = "4no Raisins"
	icon_state = "4no_raisins"
	desc = "Best raisins in the universe. Not sure why."
	trash = /obj/item/trash/raisins
	filling_color = "#343834"

	New()
		..()
		reagents.add_reagent("nutriment", 6)

/obj/item/weapon/reagent_containers/food/snacks/spacetwinkie
	name = "Space Twinkie"
	icon_state = "space_twinkie"
	desc = "Guaranteed to survive longer then you will."
	filling_color = "#FFE591"

	New()
		..()
		reagents.add_reagent("sugar", 4)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/cheesiehonkers
	name = "Cheesie Honkers"
	icon_state = "cheesie_honkers"
	desc = "Bite sized cheesie snacks that will honk all over your mouth"
	trash = /obj/item/trash/cheesie
	filling_color = "#FFA305"

	New()
		..()
		reagents.add_reagent("nutriment", 4)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/syndicake
	name = "Syndi-Cakes"
	icon_state = "syndi_cakes"
	desc = "An extremely moist snack cake that tastes just as good after being nuked."
	filling_color = "#FF5D05"

	trash = /obj/item/trash/syndi_cakes
	New()
		..()
		reagents.add_reagent("nutriment", 4)
		reagents.add_reagent("doctorsdelight", 5)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/loadedbakedpotato
	name = "Loaded Baked Potato"
	desc = "Totally baked."
	icon_state = "loadedbakedpotato"
	filling_color = "#9C7A68"

	New()
		..()
		reagents.add_reagent("nutriment", 3)
		reagents.add_reagent("protein", 3)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/fries
	name = "Space Fries"
	desc = "AKA: French Fries, Freedom Fries, etc."
	icon_state = "fries"
	trash = /obj/item/trash/plate
	filling_color = "#EDDD00"

	New()
		..()
		reagents.add_reagent("nutriment", 4)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/soydope
	name = "Soy Dope"
	desc = "Dope from a soy."
	icon_state = "soydope"
	trash = /obj/item/trash/plate
	filling_color = "#C4BF76"

	New()
		..()
		reagents.add_reagent("nutriment", 2)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/spagetti
	name = "Spaghetti"
	desc = "A bundle of raw spaghetti."
	icon_state = "spagetti"
	filling_color = "#EDDD00"

	New()
		..()
		reagents.add_reagent("nutriment", 1)
		bitesize = 1

/obj/item/weapon/reagent_containers/food/snacks/cheesyfries
	name = "Cheesy Fries"
	desc = "Fries. Covered in cheese. Duh."
	icon_state = "cheesyfries"
	trash = /obj/item/trash/plate
	filling_color = "#EDDD00"

	New()
		..()
		reagents.add_reagent("protein", 2)
		reagents.add_reagent("nutriment", 4)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/fortunecookie
	name = "Fortune cookie"
	desc = "A true prophecy in each cookie!"
	icon_state = "fortune_cookie"
	filling_color = "#E8E79E"

	New()
		..()
		reagents.add_reagent("nutriment", 3)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/badrecipe
	name = "Burned mess"
	desc = "Someone should be demoted from chef for this."
	icon_state = "badrecipe"
	filling_color = "#211F02"

	New()
		..()
		reagents.add_reagent("toxin", 1)
		reagents.add_reagent("carbon", 3)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/meatsteak
	name = "Meat steak"
	desc = "A piece of hot spicy meat."
	icon_state = "meatstake"
	trash = /obj/item/trash/plate
	filling_color = "#7A3D11"

	New()
		..()
		reagents.add_reagent("protein", 4)
		reagents.add_reagent("sodiumchloride", 1)
		reagents.add_reagent("blackpepper", 1)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/spacylibertyduff
	name = "Spacy Liberty Duff"
	desc = "Jello gelatin, from Alfred Hubbard's cookbook"
	icon_state = "spacylibertyduff"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#42B873"

	New()
		..()
		reagents.add_reagent("nutriment", 6)
		reagents.add_reagent("psilocybin", 6)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/amanitajelly
	name = "Amanita Jelly"
	desc = "Looks curiously toxic"
	icon_state = "amanitajelly"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#ED0758"

	New()
		..()
		reagents.add_reagent("nutriment", 6)
		reagents.add_reagent("amatoxin", 6)
		reagents.add_reagent("psilocybin", 3)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/poppypretzel
	name = "Poppy pretzel"
	desc = "It's all twisted up!"
	icon_state = "poppypretzel"
	bitesize = 2
	filling_color = "#916E36"

	New()
		..()
		reagents.add_reagent("nutriment", 5)
		bitesize = 2


/obj/item/weapon/reagent_containers/food/snacks/meatballsoup
	name = "Meatball soup"
	desc = "You've got balls kid, BALLS!"
	icon_state = "meatballsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#785210"

	New()
		..()
		reagents.add_reagent("protein", 8)
		reagents.add_reagent("water", 5)
		bitesize = 5

/obj/item/weapon/reagent_containers/food/snacks/slimesoup
	name = "slime soup"
	desc = "If no water is available, you may substitute tears."
	icon_state = "slimesoup"
	filling_color = "#C4DBA0"

	New()
		..()
		reagents.add_reagent("slimejelly", 5)
		reagents.add_reagent("water", 10)
		bitesize = 5

/obj/item/weapon/reagent_containers/food/snacks/bloodsoup
	name = "Tomato soup"
	desc = "Smells like copper."
	icon_state = "tomatosoup"
	filling_color = "#FF0000"

	New()
		..()
		reagents.add_reagent("protein", 2)
		reagents.add_reagent("blood", 10)
		reagents.add_reagent("water", 5)
		bitesize = 5

/obj/item/weapon/reagent_containers/food/snacks/clownstears
	name = "Clown's Tears"
	desc = "Not very funny."
	icon_state = "clownstears"
	filling_color = "#C4FBFF"

	New()
		..()
		reagents.add_reagent("nutriment", 4)
		reagents.add_reagent("banana", 5)
		reagents.add_reagent("water", 10)
		bitesize = 5

/obj/item/weapon/reagent_containers/food/snacks/vegetablesoup
	name = "Vegetable soup"
	desc = "A true vegan meal" //TODO
	icon_state = "vegetablesoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#AFC4B5"

	New()
		..()
		reagents.add_reagent("nutriment", 8)
		reagents.add_reagent("water", 5)
		bitesize = 5

/obj/item/weapon/reagent_containers/food/snacks/nettlesoup
	name = "Nettle soup"
	desc = "To think, the botanist would've beat you to death with one of these."
	icon_state = "nettlesoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#AFC4B5"

	New()
		..()
		reagents.add_reagent("nutriment", 8)
		reagents.add_reagent("water", 5)
		reagents.add_reagent("tricordrazine", 5)
		bitesize = 5

/obj/item/weapon/reagent_containers/food/snacks/mysterysoup
	name = "Mystery soup"
	desc = "The mystery is, why aren't you eating it?"
	icon_state = "mysterysoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#F082FF"

	New()
		..()
		var/mysteryselect = pick(1,2,3,4,5,6,7,8,9,10)
		switch(mysteryselect)
			if(1)
				reagents.add_reagent("nutriment", 6)
				reagents.add_reagent("capsaicin", 3)
				reagents.add_reagent("tomatojuice", 2)
			if(2)
				reagents.add_reagent("nutriment", 6)
				reagents.add_reagent("frostoil", 3)
				reagents.add_reagent("tomatojuice", 2)
			if(3)
				reagents.add_reagent("nutriment", 5)
				reagents.add_reagent("water", 5)
				reagents.add_reagent("tricordrazine", 5)
			if(4)
				reagents.add_reagent("nutriment", 5)
				reagents.add_reagent("water", 10)
			if(5)
				reagents.add_reagent("nutriment", 2)
				reagents.add_reagent("banana", 10)
			if(6)
				reagents.add_reagent("nutriment", 6)
				reagents.add_reagent("blood", 10)
			if(7)
				reagents.add_reagent("slimejelly", 10)
				reagents.add_reagent("water", 10)
			if(8)
				reagents.add_reagent("carbon", 10)
				reagents.add_reagent("toxin", 10)
			if(9)
				reagents.add_reagent("nutriment", 5)
				reagents.add_reagent("tomatojuice", 10)
			if(10)
				reagents.add_reagent("nutriment", 6)
				reagents.add_reagent("tomatojuice", 5)
				reagents.add_reagent("imidazoline", 5)
		bitesize = 5

/obj/item/weapon/reagent_containers/food/snacks/wishsoup
	name = "Wish Soup"
	desc = "I wish this was soup."
	icon_state = "wishsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#D1F4FF"

	New()
		..()
		reagents.add_reagent("water", 10)
		bitesize = 5
		if(prob(25))
			src.desc = "A wish come true!"
			reagents.add_reagent("nutriment", 8)

/obj/item/weapon/reagent_containers/food/snacks/hotchili
	name = "Hot Chili"
	desc = "A five alarm Texan Chili!"
	icon_state = "hotchili"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FF3C00"

	New()
		..()
		reagents.add_reagent("protein", 3)
		reagents.add_reagent("nutriment", 3)
		reagents.add_reagent("capsaicin", 3)
		reagents.add_reagent("tomatojuice", 2)
		bitesize = 5


/obj/item/weapon/reagent_containers/food/snacks/coldchili
	name = "Cold Chili"
	desc = "This slush is barely a liquid!"
	icon_state = "coldchili"
	filling_color = "#2B00FF"

	trash = /obj/item/trash/snack_bowl
	New()
		..()
		reagents.add_reagent("protein", 3)
		reagents.add_reagent("nutriment", 3)
		reagents.add_reagent("frostoil", 3)
		reagents.add_reagent("tomatojuice", 2)
		bitesize = 5

/* No more of this
/obj/item/weapon/reagent_containers/food/snacks/telebacon
	name = "Tele Bacon"
	desc = "It tastes a little odd but it is still delicious."
	icon_state = "bacon"
	var/obj/item/device/radio/beacon/bacon/baconbeacon
	bitesize = 2
	New()
		..()
		reagents.add_reagent("nutriment", 4)
		baconbeacon = new /obj/item/device/radio/beacon/bacon(src)
	On_Consume()
		if(!reagents.total_volume)
			baconbeacon.loc = usr
			baconbeacon.digest_delay()
*/

/obj/item/weapon/reagent_containers/food/snacks/monkeycube
	name = "monkey cube"
	desc = "Just add water!"
	icon_state = "monkeycube"
	bitesize = 12
	filling_color = "#ADAC7F"

	var/wrapped = 0
	var/monkey_type = "Monkey"

	New()
		..()
		reagents.add_reagent("protein", 10)

	afterattack(obj/O as obj, mob/user as mob, proximity)
		if(!proximity) return
		if(istype(O,/obj/structure/sink) && !wrapped)
			user << "You place \the [name] under a stream of water..."
			loc = get_turf(O)
			return Expand()
		..()

	attack_self(mob/user as mob)
		if(wrapped)
			Unwrap(user)

	/*
	On_Consume(var/mob/M)
		M << "<span class = 'warning'>Something inside of you suddently expands!</span>"

		if (istype(M, /mob/living/carbon/human))
			//Do not try to understand.
			var/obj/item/weapon/surprise = new/obj/item/weapon(M)
			var/mob/ook = monkey_type
			surprise.icon = initial(ook.icon)
			surprise.icon_state = initial(ook.icon_state)
			surprise.name = "malformed [initial(ook.name)]"
			surprise.desc = "Looks like \a very deformed [initial(ook.name)], a little small for its kind. It shows no signs of life."
			surprise.transform *= 0.6
			surprise.add_blood(M)
			var/mob/living/carbon/human/H = M
			var/obj/item/organ/external/E = H.get_organ("chest")
			E.fracture()
			for (var/obj/item/organ/I in E.internal_organs)
				I.take_damage(rand(I.min_bruised_damage, I.min_broken_damage+1))

			if (!E.hidden && prob(60)) //set it snuggly
				E.hidden = surprise
				E.cavity = 0
			else 		//someone is having a bad day
				E.createwound(CUT, 30)
				E.embed(surprise)
		else if (issmall(M))
			M.visible_message("<span class='danger'>[M] suddenly tears in half!</span>")
			var/mob/living/carbon/monkey/ook = new monkey_type(M.loc)
			ook.name = "malformed [ook.name]"
			ook.transform *= 0.6
			ook.add_blood(M)
			M.gib()
		..()
	*/

	proc/Expand()
		for(var/mob/M in viewers(src,7))
			M << "\red \The [src] expands!"
		var/mob/living/carbon/human/H = new (src)
		H.set_species(monkey_type)
		qdel(src)

	proc/Unwrap(mob/user as mob)
		icon_state = "monkeycube"
		desc = "Just add water!"
		user << "You unwrap the cube."
		wrapped = 0
		return

/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped
	desc = "Still wrapped in some paper."
	icon_state = "monkeycubewrap"
	wrapped = 1

/obj/item/weapon/reagent_containers/food/snacks/monkeycube/farwacube
	name = "farwa cube"
	monkey_type = "Farwa"

/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/farwacube
	name = "farwa cube"
	monkey_type = "Farwa"

/obj/item/weapon/reagent_containers/food/snacks/monkeycube/stokcube
	name = "stok cube"
	monkey_type = "Stok"

/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/stokcube
	name = "stok cube"
	monkey_type = "Stok"

/obj/item/weapon/reagent_containers/food/snacks/monkeycube/neaeracube
	name = "neaera cube"
	monkey_type = "Neara"

/obj/item/weapon/reagent_containers/food/snacks/monkeycube/wrapped/neaeracube
	name = "neaera cube"
	monkey_type = "Neara"


/obj/item/weapon/reagent_containers/food/snacks/spellburger
	name = "Spell Burger"
	desc = "This is absolutely Ei Nath."
	icon_state = "spellburger"
	filling_color = "#D505FF"

	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/bigbiteburger
	name = "Big Bite Burger"
	desc = "Forget the Big Mac. THIS is the future!"
	icon_state = "bigbiteburger"
	filling_color = "#E3D681"

	New()
		..()
		reagents.add_reagent("protein", 10)
		reagents.add_reagent("nutriment", 4)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/enchiladas
	name = "Enchiladas"
	desc = "Viva La Mexico!"
	icon_state = "enchiladas"
	trash = /obj/item/trash/tray
	filling_color = "#A36A1F"

	New()
		..()
		reagents.add_reagent("protein", 6)
		reagents.add_reagent("nutriment",2)
		reagents.add_reagent("capsaicin", 6)
		bitesize = 4

/obj/item/weapon/reagent_containers/food/snacks/monkeysdelight
	name = "monkey's Delight"
	desc = "Eeee Eee!"
	icon_state = "monkeysdelight"
	trash = /obj/item/trash/tray
	filling_color = "#5C3C11"

	New()
		..()
		reagents.add_reagent("protein", 10)
		reagents.add_reagent("banana", 5)
		reagents.add_reagent("blackpepper", 1)
		reagents.add_reagent("sodiumchloride", 1)
		bitesize = 6

/obj/item/weapon/reagent_containers/food/snacks/baguette
	name = "Baguette"
	desc = "Bon appetit!"
	icon_state = "baguette"
	filling_color = "#E3D796"

	New()
		..()
		reagents.add_reagent("nutriment", 6)
		reagents.add_reagent("blackpepper", 1)
		reagents.add_reagent("sodiumchloride", 1)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/fishandchips
	name = "Fish and Chips"
	desc = "I do say so myself chap."
	icon_state = "fishandchips"
	filling_color = "#E3D796"

	New()
		..()
		reagents.add_reagent("protein", 3)
		reagents.add_reagent("nutriment", 3)
		reagents.add_reagent("carpotoxin", 3)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/sandwich
	name = "Sandwich"
	desc = "A grand creation of meat, cheese, bread, and several leaves of lettuce! Arthur Dent would be proud."
	icon_state = "sandwich"
	trash = /obj/item/trash/plate
	filling_color = "#D9BE29"

	New()
		..()
		reagents.add_reagent("protein", 3)
		reagents.add_reagent("nutriment", 3)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/toastedsandwich
	name = "Toasted Sandwich"
	desc = "Now if you only had a pepper bar."
	icon_state = "toastedsandwich"
	trash = /obj/item/trash/plate
	filling_color = "#D9BE29"

	New()
		..()
		reagents.add_reagent("protein", 3)
		reagents.add_reagent("nutriment", 3)
		reagents.add_reagent("carbon", 2)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/grilledcheese
	name = "Grilled Cheese Sandwich"
	desc = "Goes great with Tomato soup!"
	icon_state = "toastedsandwich"
	trash = /obj/item/trash/plate
	filling_color = "#D9BE29"

	New()
		..()
		reagents.add_reagent("protein", 4)
		reagents.add_reagent("nutriment", 3)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/tomatosoup
	name = "Tomato Soup"
	desc = "Drinking this feels like being a vampire! A tomato vampire..."
	icon_state = "tomatosoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#D92929"

	New()
		..()
		reagents.add_reagent("nutriment", 5)
		reagents.add_reagent("tomatojuice", 10)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/rofflewaffles
	name = "Roffle Waffles"
	desc = "Waffles from Roffle. Co."
	icon_state = "rofflewaffles"
	trash = /obj/item/trash/waffles
	filling_color = "#FF00F7"

	New()
		..()
		reagents.add_reagent("nutriment", 8)
		reagents.add_reagent("psilocybin", 8)
		bitesize = 4

/obj/item/weapon/reagent_containers/food/snacks/stew
	name = "Stew"
	desc = "A nice and warm stew. Healthy and strong."
	icon_state = "stew"
	filling_color = "#9E673A"

	New()
		..()
		reagents.add_reagent("protein", 4)
		reagents.add_reagent("nutriment", 6)
		reagents.add_reagent("tomatojuice", 5)
		reagents.add_reagent("imidazoline", 5)
		reagents.add_reagent("water", 5)
		bitesize = 10

/obj/item/weapon/reagent_containers/food/snacks/jelliedtoast
	name = "Jellied Toast"
	desc = "A slice of bread covered with delicious jam."
	icon_state = "jellytoast"
	trash = /obj/item/trash/plate
	filling_color = "#B572AB"

	New()
		..()
		reagents.add_reagent("nutriment", 1)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/jelliedtoast/cherry
	New()
		..()
		reagents.add_reagent("cherryjelly", 5)

/obj/item/weapon/reagent_containers/food/snacks/jelliedtoast/slime
	New()
		..()
		reagents.add_reagent("slimejelly", 5)

/obj/item/weapon/reagent_containers/food/snacks/jellyburger
	name = "Jelly Burger"
	desc = "Culinary delight..?"
	icon_state = "jellyburger"
	filling_color = "#B572AB"

	New()
		..()
		reagents.add_reagent("nutriment", 5)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/jellyburger/slime
	New()
		..()
		reagents.add_reagent("slimejelly", 5)

/obj/item/weapon/reagent_containers/food/snacks/jellyburger/cherry
	New()
		..()
		reagents.add_reagent("cherryjelly", 5)

/obj/item/weapon/reagent_containers/food/snacks/milosoup
	name = "Milosoup"
	desc = "The universes best soup! Yum!!!"
	icon_state = "milosoup"
	trash = /obj/item/trash/snack_bowl
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		reagents.add_reagent("water", 5)
		bitesize = 4

/obj/item/weapon/reagent_containers/food/snacks/stewedsoymeat
	name = "Stewed Soy Meat"
	desc = "Even non-vegetarians will LOVE this!"
	icon_state = "stewedsoymeat"
	trash = /obj/item/trash/plate
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/boiledspagetti
	name = "Boiled Spaghetti"
	desc = "A plain dish of noodles, this sucks."
	icon_state = "spagettiboiled"
	trash = /obj/item/trash/plate
	filling_color = "#FCEE81"

	New()
		..()
		reagents.add_reagent("nutriment", 2)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/boiledrice
	name = "Boiled Rice"
	desc = "A boring dish of boring rice."
	icon_state = "boiledrice"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FFFBDB"

	New()
		..()
		reagents.add_reagent("nutriment", 2)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/ricepudding
	name = "Rice Pudding"
	desc = "Where's the jam?"
	icon_state = "rpudding"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FFFBDB"

	New()
		..()
		reagents.add_reagent("nutriment", 4)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/pastatomato
	name = "Spaghetti"
	desc = "Spaghetti and crushed tomatoes. Just like your abusive father used to make!"
	icon_state = "pastatomato"
	trash = /obj/item/trash/plate
	filling_color = "#DE4545"

	New()
		..()
		reagents.add_reagent("nutriment", 6)
		reagents.add_reagent("tomatojuice", 10)
		bitesize = 4

/obj/item/weapon/reagent_containers/food/snacks/meatballspagetti
	name = "Spaghetti & Meatballs"
	desc = "Now thats a nic'e meatball!"
	icon_state = "meatballspagetti"
	trash = /obj/item/trash/plate
	filling_color = "#DE4545"

	New()
		..()
		reagents.add_reagent("protein", 4)
		reagents.add_reagent("nutriment", 4)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/spesslaw
	name = "Spesslaw"
	desc = "A lawyers favourite"
	icon_state = "spesslaw"
	filling_color = "#DE4545"

	New()
		..()
		reagents.add_reagent("protein", 4)
		reagents.add_reagent("nutriment", 4)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/poppypretzel
	name = "Poppy Pretzel"
	desc = "A large soft pretzel full of POP!"
	icon_state = "poppypretzel"
	filling_color = "#AB7D2E"

	New()
		..()
		reagents.add_reagent("nutriment", 5)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/carrotfries
	name = "Carrot Fries"
	desc = "Tasty fries from fresh Carrots."
	icon_state = "carrotfries"
	trash = /obj/item/trash/plate
	filling_color = "#FAA005"

	New()
		..()
		reagents.add_reagent("nutriment", 3)
		reagents.add_reagent("imidazoline", 3)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/superbiteburger
	name = "Super Bite Burger"
	desc = "This is a mountain of a burger. FOOD!"
	icon_state = "superbiteburger"
	filling_color = "#CCA26A"

	New()
		..()
		reagents.add_reagent("protein", 25)
		reagents.add_reagent("nutriment", 25)
		bitesize = 10

/obj/item/weapon/reagent_containers/food/snacks/candiedapple
	name = "Candied Apple"
	desc = "An apple coated in sugary sweetness."
	icon_state = "candiedapple"
	filling_color = "#F21873"

	New()
		..()
		reagents.add_reagent("nutriment", 3)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/applepie
	name = "Apple Pie"
	desc = "A pie containing sweet sweet love... or apple."
	icon_state = "applepie"
	filling_color = "#E0EDC5"

	New()
		..()
		reagents.add_reagent("nutriment", 4)
		bitesize = 3


/obj/item/weapon/reagent_containers/food/snacks/cherrypie
	name = "Cherry Pie"
	desc = "Taste so good, make a grown man cry."
	icon_state = "cherrypie"
	filling_color = "#FF525A"

	New()
		..()
		reagents.add_reagent("nutriment", 4)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/twobread
	name = "Two Bread"
	desc = "It is very bitter and winy."
	icon_state = "twobread"
	filling_color = "#DBCC9A"

	New()
		..()
		reagents.add_reagent("nutriment", 2)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/jellysandwich
	name = "Jelly Sandwich"
	desc = "You wish you had some peanut butter to go with this..."
	icon_state = "jellysandwich"
	trash = /obj/item/trash/plate
	filling_color = "#9E3A78"

	New()
		..()
		reagents.add_reagent("nutriment", 2)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/jellysandwich/slime
	New()
		..()
		reagents.add_reagent("slimejelly", 5)

/obj/item/weapon/reagent_containers/food/snacks/jellysandwich/cherry
	New()
		..()
		reagents.add_reagent("cherryjelly", 5)

/obj/item/weapon/reagent_containers/food/snacks/boiledslimecore
	name = "Boiled slime Core"
	desc = "A boiled red thing."
	icon_state = "boiledslimecore"
	New()
		..()
		reagents.add_reagent("slimejelly", 5)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/mint
	name = "mint"
	desc = "it is only wafer thin."
	icon_state = "mint"
	filling_color = "#F2F2F2"

	New()
		..()
		reagents.add_reagent("minttoxin", 1)
		bitesize = 1

/obj/item/weapon/reagent_containers/food/snacks/mushroomsoup
	name = "chantrelle soup"
	desc = "A delicious and hearty mushroom soup."
	icon_state = "mushroomsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#E386BF"

	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/plumphelmetbiscuit
	name = "plump helmet biscuit"
	desc = "This is a finely-prepared plump helmet biscuit. The ingredients are exceptionally minced plump helmet, and well-minced dwarven wheat flour."
	icon_state = "phelmbiscuit"
	filling_color = "#CFB4C4"

	New()
		..()
		if(prob(10))
			name = "exceptional plump helmet biscuit"
			desc = "Microwave is taken by a fey mood! It has cooked an exceptional plump helmet biscuit!"
			reagents.add_reagent("nutriment", 8)
			reagents.add_reagent("tricordrazine", 5)
			bitesize = 2
		else
			reagents.add_reagent("nutriment", 5)
			bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/chawanmushi
	name = "chawanmushi"
	desc = "A legendary egg custard that makes friends out of enemies. Probably too hot for a cat to eat."
	icon_state = "chawanmushi"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#F0F2E4"

	New()
		..()
		reagents.add_reagent("protein", 5)
		bitesize = 1

/obj/item/weapon/reagent_containers/food/snacks/beetsoup
	name = "beet soup"
	desc = "Wait, how do you spell it again..?"
	icon_state = "beetsoup"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#FAC9FF"

	New()
		..()
		name = pick(list("borsch","bortsch","borstch","borsh","borshch","borscht"))
		reagents.add_reagent("nutriment", 8)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/tossedsalad
	name = "tossed salad"
	desc = "A proper salad, basic and simple, with little bits of carrot, tomato and apple intermingled. Vegan!"
	icon_state = "herbsalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#76B87F"

	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/validsalad
	name = "valid salad"
	desc = "It's just a salad of questionable 'herbs' with meatballs and fried potato slices. Nothing suspicious about it."
	icon_state = "validsalad"
	trash = /obj/item/trash/snack_bowl
	filling_color = "#76B87F"

	New()
		..()
		reagents.add_reagent("protein", 2)
		reagents.add_reagent("nutriment", 6)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/appletart
	name = "golden apple streusel tart"
	desc = "A tasty dessert that won't make it through a metal detector."
	icon_state = "gappletart"
	trash = /obj/item/trash/plate
	filling_color = "#FFFF00"

	New()
		..()
		reagents.add_reagent("nutriment", 8)
		reagents.add_reagent("gold", 5)
		bitesize = 3

/////////////////////////////////////////////////Sliceable////////////////////////////////////////
// All the food items that can be sliced into smaller bits like Meatbread and Cheesewheels

// sliceable is just an organization type path, it doesn't have any additional code or variables tied to it.

/obj/item/weapon/reagent_containers/food/snacks/sliceable
	w_class = 3 //Whole pizzas and cakes shouldn't fit in a pocket, you can slice them if you want to do that.

/obj/item/weapon/reagent_containers/food/snacks/sliceable/meatbread
	name = "meatbread loaf"
	desc = "The culinary base of every self-respecting eloquen/tg/entleman."
	icon_state = "meatbread"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/meatbreadslice
	slices_num = 5
	filling_color = "#FF7575"
	New()
		..()
		reagents.add_reagent("protein", 20)
		reagents.add_reagent("nutriment", 10)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/meatbreadslice
	name = "meatbread slice"
	desc = "A slice of delicious meatbread."
	icon_state = "meatbreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#FF7575"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/xenomeatbread
	name = "xenomeatbread loaf"
	desc = "The culinary base of every self-respecting eloquent gentleman. Extra Heretical."
	icon_state = "xenomeatbread"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/xenomeatbreadslice
	slices_num = 5
	filling_color = "#8AFF75"
	New()
		..()
		reagents.add_reagent("protein", 20)
		reagents.add_reagent("nutriment", 10)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/xenomeatbreadslice
	name = "xenomeatbread slice"
	desc = "A slice of delicious meatbread. Extra Heretical."
	icon_state = "xenobreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#8AFF75"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/bananabread
	name = "Banana-nut bread"
	desc = "A heavenly and filling treat."
	icon_state = "bananabread"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/bananabreadslice
	slices_num = 5
	filling_color = "#EDE5AD"
	New()
		..()
		reagents.add_reagent("banana", 20)
		reagents.add_reagent("nutriment", 20)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/bananabreadslice
	name = "Banana-nut bread slice"
	desc = "A slice of delicious banana bread."
	icon_state = "bananabreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#EDE5AD"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/tofubread
	name = "Tofubread"
	icon_state = "Like meatbread but for vegetarians. Not guaranteed to give superpowers."
	icon_state = "tofubread"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/tofubreadslice
	slices_num = 5
	filling_color = "#F7FFE0"
	New()
		..()
		reagents.add_reagent("nutriment", 30)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/tofubreadslice
	name = "Tofubread slice"
	desc = "A slice of delicious tofubread."
	icon_state = "tofubreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#F7FFE0"
	bitesize = 2


/obj/item/weapon/reagent_containers/food/snacks/sliceable/carrotcake
	name = "Carrot Cake"
	desc = "A favorite desert of a certain wascally wabbit. Not a lie."
	icon_state = "carrotcake"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/carrotcakeslice
	slices_num = 5
	filling_color = "#FFD675"
	New()
		..()
		reagents.add_reagent("nutriment", 25)
		reagents.add_reagent("imidazoline", 10)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/carrotcakeslice
	name = "Carrot Cake slice"
	desc = "Carrotty slice of Carrot Cake, carrots are good for your eyes! Also not a lie."
	icon_state = "carrotcake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#FFD675"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/braincake
	name = "Brain Cake"
	desc = "A squishy cake-thing."
	icon_state = "braincake"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/braincakeslice
	slices_num = 5
	filling_color = "#E6AEDB"
	New()
		..()
		reagents.add_reagent("protein", 25)
		reagents.add_reagent("nutriment", 5)
		reagents.add_reagent("alkysine", 10)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/braincakeslice
	name = "Brain Cake slice"
	desc = "Lemme tell you something about prions. THEY'RE DELICIOUS."
	icon_state = "braincakeslice"
	trash = /obj/item/trash/plate
	filling_color = "#E6AEDB"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/cheesecake
	name = "Cheese Cake"
	desc = "DANGEROUSLY cheesy."
	icon_state = "cheesecake"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/cheesecakeslice
	slices_num = 5
	filling_color = "#FAF7AF"
	New()
		..()
		reagents.add_reagent("protein", 15)
		reagents.add_reagent("nutriment", 10)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/cheesecakeslice
	name = "Cheese Cake slice"
	desc = "Slice of pure cheestisfaction"
	icon_state = "cheesecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#FAF7AF"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/plaincake
	name = "Vanilla Cake"
	desc = "A plain cake, not a lie."
	icon_state = "plaincake"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/plaincakeslice
	slices_num = 5
	filling_color = "#F7EDD5"
	New()
		..()
		reagents.add_reagent("nutriment", 20)

/obj/item/weapon/reagent_containers/food/snacks/plaincakeslice
	name = "Vanilla Cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "plaincake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#F7EDD5"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/orangecake
	name = "Orange Cake"
	desc = "A cake with added orange."
	icon_state = "orangecake"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/orangecakeslice
	slices_num = 5
	filling_color = "#FADA8E"
	New()
		..()
		reagents.add_reagent("nutriment", 20)

/obj/item/weapon/reagent_containers/food/snacks/orangecakeslice
	name = "Orange Cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "orangecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#FADA8E"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/limecake
	name = "Lime Cake"
	desc = "A cake with added lime."
	icon_state = "limecake"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/limecakeslice
	slices_num = 5
	filling_color = "#CBFA8E"
	New()
		..()
		reagents.add_reagent("nutriment", 20)

/obj/item/weapon/reagent_containers/food/snacks/limecakeslice
	name = "Lime Cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "limecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#CBFA8E"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/lemoncake
	name = "Lemon Cake"
	desc = "A cake with added lemon."
	icon_state = "lemoncake"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/lemoncakeslice
	slices_num = 5
	filling_color = "#FAFA8E"
	New()
		..()
		reagents.add_reagent("nutriment", 20)

/obj/item/weapon/reagent_containers/food/snacks/lemoncakeslice
	name = "Lemon Cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "lemoncake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#FAFA8E"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/chocolatecake
	name = "Chocolate Cake"
	desc = "A cake with added chocolate"
	icon_state = "chocolatecake"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/chocolatecakeslice
	slices_num = 5
	filling_color = "#805930"
	New()
		..()
		reagents.add_reagent("nutriment", 20)

/obj/item/weapon/reagent_containers/food/snacks/chocolatecakeslice
	name = "Chocolate Cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "chocolatecake_slice"
	trash = /obj/item/trash/plate
	filling_color = "#805930"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/cheesewheel
	name = "Cheese wheel"
	desc = "A big wheel of delcious Cheddar."
	icon_state = "cheesewheel"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	slices_num = 5
	filling_color = "#FFF700"
	New()
		..()
		reagents.add_reagent("protein", 20)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	name = "Cheese wedge"
	desc = "A wedge of delicious Cheddar. The cheese wheel it was cut from can't have gone far."
	icon_state = "cheesewedge"
	filling_color = "#FFF700"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/birthdaycake
	name = "Birthday Cake"
	desc = "Happy Birthday..."
	icon_state = "birthdaycake"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/birthdaycakeslice
	slices_num = 5
	filling_color = "#FFD6D6"
	New()
		..()
		reagents.add_reagent("nutriment", 20)
		reagents.add_reagent("sprinkles", 10)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/birthdaycakeslice
	name = "Birthday Cake slice"
	desc = "A slice of your birthday."
	icon_state = "birthdaycakeslice"
	trash = /obj/item/trash/plate
	filling_color = "#FFD6D6"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/bread
	name = "Bread"
	icon_state = "Some plain old Earthen bread."
	icon_state = "bread"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/breadslice
	slices_num = 5
	filling_color = "#FFE396"

	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/breadslice
	name = "Bread slice"
	desc = "A slice of home."
	icon_state = "breadslice"
	trash = /obj/item/trash/plate
	filling_color = "#D27332"
	bitesize = 2


/obj/item/weapon/reagent_containers/food/snacks/sliceable/creamcheesebread
	name = "Cream Cheese Bread"
	desc = "Yum yum yum!"
	icon_state = "creamcheesebread"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/creamcheesebreadslice
	slices_num = 5
	filling_color = "#FFF896"
	New()
		..()
		reagents.add_reagent("protein", 15)
		reagents.add_reagent("nutriment", 5)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/creamcheesebreadslice
	name = "Cream Cheese Bread slice"
	desc = "A slice of yum!"
	icon_state = "creamcheesebreadslice"
	trash = /obj/item/trash/plate
	filling_color = "#FFF896"
	bitesize = 2


/obj/item/weapon/reagent_containers/food/snacks/watermelonslice
	name = "Watermelon Slice"
	desc = "A slice of watery goodness."
	icon_state = "watermelonslice"
	filling_color = "#FF3867"
	bitesize = 2


/obj/item/weapon/reagent_containers/food/snacks/sliceable/applecake
	name = "Apple Cake"
	desc = "A cake centred with Apple"
	icon_state = "applecake"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/applecakeslice
	slices_num = 5
	filling_color = "#EBF5B8"
	New()
		..()
		reagents.add_reagent("nutriment", 15)

/obj/item/weapon/reagent_containers/food/snacks/applecakeslice
	name = "Apple Cake slice"
	desc = "A slice of heavenly cake."
	icon_state = "applecakeslice"
	trash = /obj/item/trash/plate
	filling_color = "#EBF5B8"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/pumpkinpie
	name = "Pumpkin Pie"
	desc = "A delicious treat for the autumn months."
	icon_state = "pumpkinpie"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/pumpkinpieslice
	slices_num = 5
	filling_color = "#F5B951"

	New()
		..()
		reagents.add_reagent("nutriment", 15)

/obj/item/weapon/reagent_containers/food/snacks/pumpkinpieslice
	name = "Pumpkin Pie slice"
	desc = "A slice of pumpkin pie, with whipped cream on top. Perfection."
	icon_state = "pumpkinpieslice"
	trash = /obj/item/trash/plate
	filling_color = "#F5B951"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/cracker
	name = "Cracker"
	desc = "It's a salted cracker."
	icon_state = "cracker"
	filling_color = "#F5DEB8"

	New()
		..()
		reagents.add_reagent("nutriment", 1)



/////////////////////////////////////////////////PIZZA////////////////////////////////////////

/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza
	slices_num = 6
	filling_color = "#BAA14C"

/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/margherita
	name = "Margherita"
	desc = "The golden standard of pizzas."
	icon_state = "pizzamargherita"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/margheritaslice
	slices_num = 6
	New()
		..()
		reagents.add_reagent("nutriment", 35)
		reagents.add_reagent("protein", 5)
		reagents.add_reagent("tomatojuice", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/margheritaslice
	name = "Margherita slice"
	desc = "A slice of the classic pizza."
	icon_state = "pizzamargheritaslice"
	filling_color = "#BAA14C"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/meatpizza
	name = "Meatpizza"
	desc = "A pizza with meat topping."
	icon_state = "meatpizza"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/meatpizzaslice
	slices_num = 6
	New()
		..()
		reagents.add_reagent("protein", 50)
		reagents.add_reagent("tomatojuice", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/meatpizzaslice
	name = "Meatpizza slice"
	desc = "A slice of a meaty pizza."
	icon_state = "meatpizzaslice"
	filling_color = "#BAA14C"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/mushroompizza
	name = "Mushroompizza"
	desc = "Very special pizza"
	icon_state = "mushroompizza"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/mushroompizzaslice
	slices_num = 6
	New()
		..()
		reagents.add_reagent("nutriment", 35)
		reagents.add_reagent("protein", 5)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/mushroompizzaslice
	name = "Mushroompizza slice"
	desc = "Maybe it is the last slice of pizza in your life."
	icon_state = "mushroompizzaslice"
	filling_color = "#BAA14C"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza
	name = "Vegetable pizza"
	desc = "No one of Tomato Sapiens were harmed during making this pizza"
	icon_state = "vegetablepizza"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/vegetablepizzaslice
	slices_num = 6
	New()
		..()
		reagents.add_reagent("nutriment", 30)
		reagents.add_reagent("protein", 5)
		reagents.add_reagent("tomatojuice", 6)
		reagents.add_reagent("imidazoline", 12)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/vegetablepizzaslice
	name = "Vegetable pizza slice"
	desc = "A slice of the most green pizza of all pizzas not containing green ingredients "
	icon_state = "vegetablepizzaslice"
	filling_color = "#BAA14C"
	bitesize = 2

/obj/item/pizzabox
	name = "pizza box"
	desc = "A box suited for pizzas."
	icon = 'icons/obj/food.dmi'
	icon_state = "pizzabox1"

	var/open = 0 // Is the box open?
	var/ismessy = 0 // Fancy mess on the lid
	var/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/pizza // Content pizza
	var/list/boxes = list() // If the boxes are stacked, they come here
	var/boxtag = ""

/obj/item/pizzabox/update_icon()

	overlays = list()

	// Set appropriate description
	if( open && pizza )
		desc = "A box suited for pizzas. It appears to have a [pizza.name] inside."
	else if( boxes.len > 0 )
		desc = "A pile of boxes suited for pizzas. There appears to be [boxes.len + 1] boxes in the pile."

		var/obj/item/pizzabox/topbox = boxes[boxes.len]
		var/toptag = topbox.boxtag
		if( toptag != "" )
			desc = "[desc] The box on top has a tag, it reads: '[toptag]'."
	else
		desc = "A box suited for pizzas."

		if( boxtag != "" )
			desc = "[desc] The box has a tag, it reads: '[boxtag]'."

	// Icon states and overlays
	if( open )
		if( ismessy )
			icon_state = "pizzabox_messy"
		else
			icon_state = "pizzabox_open"

		if( pizza )
			var/image/pizzaimg = image("food.dmi", icon_state = pizza.icon_state)
			pizzaimg.pixel_y = -3
			overlays += pizzaimg

		return
	else
		// Stupid code because byondcode sucks
		var/doimgtag = 0
		if( boxes.len > 0 )
			var/obj/item/pizzabox/topbox = boxes[boxes.len]
			if( topbox.boxtag != "" )
				doimgtag = 1
		else
			if( boxtag != "" )
				doimgtag = 1

		if( doimgtag )
			var/image/tagimg = image("food.dmi", icon_state = "pizzabox_tag")
			tagimg.pixel_y = boxes.len * 3
			overlays += tagimg

	icon_state = "pizzabox[boxes.len+1]"

/obj/item/pizzabox/attack_hand( mob/user as mob )

	if( open && pizza )
		user.put_in_hands( pizza )

		user << "\red You take the [src.pizza] out of the [src]."
		src.pizza = null
		update_icon()
		return

	if( boxes.len > 0 )
		if( user.get_inactive_hand() != src )
			..()
			return

		var/obj/item/pizzabox/box = boxes[boxes.len]
		boxes -= box

		user.put_in_hands( box )
		user << "\red You remove the topmost [src] from your hand."
		box.update_icon()
		update_icon()
		return
	..()

/obj/item/pizzabox/attack_self( mob/user as mob )

	if( boxes.len > 0 )
		return

	open = !open

	if( open && pizza )
		ismessy = 1

	update_icon()

/obj/item/pizzabox/attackby( obj/item/I as obj, mob/user as mob )
	if( istype(I, /obj/item/pizzabox/) )
		var/obj/item/pizzabox/box = I

		if( !box.open && !src.open )
			// Make a list of all boxes to be added
			var/list/boxestoadd = list()
			boxestoadd += box
			for(var/obj/item/pizzabox/i in box.boxes)
				boxestoadd += i

			if( (boxes.len+1) + boxestoadd.len <= 5 )
				user.drop_item()

				box.loc = src
				box.boxes = list() // Clear the box boxes so we don't have boxes inside boxes. - Xzibit
				src.boxes.Add( boxestoadd )

				box.update_icon()
				update_icon()

				user << "\red You put the [box] ontop of the [src]!"
			else
				user << "\red The stack is too high!"
		else
			user << "\red Close the [box] first!"

		return

	if( istype(I, /obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/) ) // Long ass fucking object name

		if( src.open )
			user.drop_item()
			I.loc = src
			src.pizza = I

			update_icon()

			user << "\red You put the [I] in the [src]!"
		else
			user << "\red You try to push the [I] through the lid but it doesn't work!"
		return

	if( istype(I, /obj/item/weapon/pen/) )

		if( src.open )
			return

		var/t = sanitize(input("Enter what you want to add to the tag:", "Write", null, null) as text, 30)

		var/obj/item/pizzabox/boxtotagto = src
		if( boxes.len > 0 )
			boxtotagto = boxes[boxes.len]

		boxtotagto.boxtag = copytext("[boxtotagto.boxtag][t]", 1, 30)

		update_icon()
		return
	..()

/obj/item/pizzabox/margherita/New()
	pizza = new /obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/margherita(src)
	boxtag = "Margherita Deluxe"

/obj/item/pizzabox/vegetable/New()
	pizza = new /obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza(src)
	boxtag = "Gourmet Vegatable"

/obj/item/pizzabox/mushroom/New()
	pizza = new /obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/mushroompizza(src)
	boxtag = "Mushroom Special"

/obj/item/pizzabox/meat/New()
	pizza = new /obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/meatpizza(src)
	boxtag = "Meatlover's Supreme"

/obj/item/weapon/reagent_containers/food/snacks/dionaroast
	name = "roast diona"
	desc = "It's like an enormous, leathery carrot. With an eye."
	icon_state = "dionaroast"
	trash = /obj/item/trash/plate
	filling_color = "#75754B"

	New()
		..()
		reagents.add_reagent("nutriment", 6)
		reagents.add_reagent("radium", 2)
		bitesize = 2




///////////////////////////////////////////
// new old food stuff from bs12
///////////////////////////////////////////
/obj/item/weapon/reagent_containers/food/snacks/dough
	name = "dough"
	desc = "A piece of dough."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "dough"
	bitesize = 2
	New()
		..()
		reagents.add_reagent("protein", 1)
		reagents.add_reagent("nutriment", 3)

// Dough + rolling pin = flat dough
/obj/item/weapon/reagent_containers/food/snacks/dough/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/kitchen/rollingpin))
		new /obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough(src)
		user << "You flatten the dough."
		qdel(src)

// slicable into 3xdoughslices
/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough
	name = "flat dough"
	desc = "A flattened dough."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "flat dough"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/doughslice
	slices_num = 3
	New()
		..()
		reagents.add_reagent("protein", 1)
		reagents.add_reagent("nutriment", 3)

/obj/item/weapon/reagent_containers/food/snacks/doughslice
	name = "dough slice"
	desc = "A building block of an impressive dish."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "doughslice"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/spagetti
	slices_num = 1
	bitesize = 2
	New()
		..()
		reagents.add_reagent("nutriment", 1)

/obj/item/weapon/reagent_containers/food/snacks/bun
	name = "bun"
	desc = "A base for any self-respecting burger."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "bun"
	bitesize = 2
	New()
		..()
		reagents.add_reagent("nutriment", 4)

/obj/item/weapon/reagent_containers/food/snacks/bun/attackby(obj/item/weapon/W as obj, mob/user as mob)
	// Bun + meatball = burger
	if(istype(W,/obj/item/weapon/reagent_containers/food/snacks/meatball))
		new /obj/item/weapon/reagent_containers/food/snacks/monkeyburger(src)
		user << "You make a burger."
		qdel(W)
		qdel(src)

	// Bun + cutlet = hamburger
	else if(istype(W,/obj/item/weapon/reagent_containers/food/snacks/cutlet))
		new /obj/item/weapon/reagent_containers/food/snacks/monkeyburger(src)
		user << "You make a burger."
		qdel(W)
		qdel(src)

	// Bun + sausage = hotdog
	else if(istype(W,/obj/item/weapon/reagent_containers/food/snacks/sausage))
		new /obj/item/weapon/reagent_containers/food/snacks/hotdog(src)
		user << "You make a hotdog."
		qdel(W)
		qdel(src)

// Burger + cheese wedge = cheeseburger
/obj/item/weapon/reagent_containers/food/snacks/monkeyburger/attackby(obj/item/weapon/reagent_containers/food/snacks/cheesewedge/W as obj, mob/user as mob)
	if(istype(W))// && !istype(src,/obj/item/weapon/reagent_containers/food/snacks/cheesewedge))
		new /obj/item/weapon/reagent_containers/food/snacks/cheeseburger(src)
		user << "You make a cheeseburger."
		qdel(W)
		qdel(src)
		return
	else
		..()

// Human Burger + cheese wedge = cheeseburger
/obj/item/weapon/reagent_containers/food/snacks/human/burger/attackby(obj/item/weapon/reagent_containers/food/snacks/cheesewedge/W as obj, mob/user as mob)
	if(istype(W))
		new /obj/item/weapon/reagent_containers/food/snacks/cheeseburger(src)
		user << "You make a cheeseburger."
		qdel(W)
		qdel(src)
		return
	else
		..()

/obj/item/weapon/reagent_containers/food/snacks/taco
	name = "taco"
	desc = "Take a bite!"
	icon_state = "taco"
	bitesize = 3
	New()
		..()
		reagents.add_reagent("protein", 3)
		reagents.add_reagent("nutriment", 4)

/obj/item/weapon/reagent_containers/food/snacks/rawcutlet
	name = "raw cutlet"
	desc = "A thin piece of raw meat."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "rawcutlet"
	bitesize = 1
	New()
		..()
		reagents.add_reagent("protein", 1)

/obj/item/weapon/reagent_containers/food/snacks/cutlet
	name = "cutlet"
	desc = "A tasty meat slice."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "cutlet"
	bitesize = 2
	New()
		..()
		reagents.add_reagent("protein", 2)

/obj/item/weapon/reagent_containers/food/snacks/rawmeatball
	name = "raw meatball"
	desc = "A raw meatball."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "rawmeatball"
	bitesize = 2
	New()
		..()
		reagents.add_reagent("protein", 2)

/obj/item/weapon/reagent_containers/food/snacks/hotdog
	name = "hotdog"
	desc = "Unrelated to dogs, maybe."
	icon_state = "hotdog"
	bitesize = 2
	New()
		..()
		reagents.add_reagent("protein", 6)

/obj/item/weapon/reagent_containers/food/snacks/flatbread
	name = "flatbread"
	desc = "Bland but filling."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "flatbread"
	bitesize = 2
	New()
		..()
		reagents.add_reagent("nutriment", 3)

// potato + knife = raw sticks
/obj/item/weapon/reagent_containers/food/snacks/grown/potato/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/kitchen/utensil/knife))
		new /obj/item/weapon/reagent_containers/food/snacks/rawsticks(src)
		user << "You cut the potato."
		qdel(src)
	else
		..()

/obj/item/weapon/reagent_containers/food/snacks/rawsticks
	name = "raw potato sticks"
	desc = "Raw fries, not very tasty."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "rawsticks"
	bitesize = 2
	New()
		..()
		reagents.add_reagent("nutriment", 3)

/obj/item/weapon/reagent_containers/food/snacks/liquidfood
	name = "\improper LiquidFood Ration"
	desc = "A prepackaged grey slurry of all the essential nutrients for a spacefarer on the go. Should this be crunchy?"
	icon_state = "liquidfood"
	trash = /obj/item/trash/liquidfood
	filling_color = "#A8A8A8"

	New()
		..()
		reagents.add_reagent("nutriment", 20)
		reagents.add_reagent("iron", 3)
		bitesize = 4


/obj/item/weapon/reagent_containers/food/snacks/tastybread
	name = "bread tube"
	desc = "Bread in a tube. Chewy...and surprisingly tasty."
	icon_state = "tastybread"
	trash = /obj/item/trash/tastybread
	filling_color = "#A66829"

	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/skrellsnacks
	name = "\improper SkrellSnax"
	desc = "Cured fungus shipped all the way from Jargon 4, almost like jerky! Almost."
	icon_state = "skrellsnacks"
	filling_color = "#A66829"

	New()
		..()
		reagents.add_reagent("nutriment", 10)
		bitesize = 3
