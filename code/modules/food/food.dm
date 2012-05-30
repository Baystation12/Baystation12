
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

/obj/item/weapon/reagent_containers/food/snacks/attack_animal(var/mob/M)
	if(isanimal(M))
		if(iscorgi(M))
			if(bitecount == 0 || prob(50))
				M.emote("nibbles away at the [src]")
			bitecount++
			if(bitecount >= 5)
				var/sattisfaction_text = pick("burps from enjoyment", "yaps for more", "woofs twice", "looks at the area where the [src] was")
				if(sattisfaction_text)
					M.emote("[sattisfaction_text]")
				del(src)
		else
			if(bitecount == 0 || prob(50))
				M.emote("nibbles away at the [src]")

/obj/item/weapon/reagent_containers/food/snacks/candy
	name = "candy"
	desc = "Nougat love it or hate it."
	icon_state = "candy"
	trash = "candy"
	New()
		..()
		reagents.add_reagent("nutriment", 1)
		reagents.add_reagent("sugar", 3)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/candy_corn
	name = "candy corn"
	desc = "It's a handful of candy corn. Can be stored in a detective's hat."
	icon_state = "candy_corn"
	New()
		..()
		reagents.add_reagent("nutriment", 4)
		reagents.add_reagent("sugar", 2)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/chips
	name = "chips"
	desc = "Commander Riker's What-The-Crisps"
	icon_state = "chips"
	trash = "chips"
	New()
		..()
		reagents.add_reagent("nutriment", 3)
		bitesize = 1

/obj/item/weapon/reagent_containers/food/snacks/chocolatebar
	name = "Chocolate Bar"
	desc = "Such, sweet, fattening food."
	icon_state = "chocolatebar"
	New()
		..()
		reagents.add_reagent("nutriment", 2)
		reagents.add_reagent("sugar", 2)
		reagents.add_reagent("coco", 2)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/chocolateegg
	name = "Chocolate Egg"
	desc = "Such, sweet, fattening food."
	icon_state = "chocolateegg"
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
	New()
		..()
		reagents.add_reagent("nutriment", 3)
		reagents.add_reagent("sprinkles", 1)
		src.bitesize = 3
		if(prob(30))
			src.icon_state = "donut2"
			src.name = "frosted donut"
			reagents.add_reagent("sprinkles", 2)

/obj/item/weapon/reagent_containers/food/snacks/chaosdonut
	name = "Chaos Donut"
	desc = "Like life, it never quite tastes the same."
	icon_state = "donut1"
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
				reagents.add_reagent("plasma", 3)
			if(6)
				reagents.add_reagent("coco", 3)
			if(7)
				reagents.add_reagent("metroid", 3)
			if(8)
				reagents.add_reagent("banana", 3)
			if(9)
				reagents.add_reagent("berryjuice", 3)
			if(10)
				reagents.add_reagent("tricordrazine", 3)
		if(prob(30))
			src.icon_state = "donut2"
			src.name = "Frosted Chaos Donut"
			reagents.add_reagent("sprinkles", 2)

/obj/item/weapon/reagent_containers/food/snacks/jellydonut
	name = "Jelly Donut"
	desc = "You jelly?"
	icon_state = "jdonut1"
	New()
		..()
		reagents.add_reagent("nutriment", 3)
		reagents.add_reagent("sprinkles", 1)
		reagents.add_reagent("berryjuice", 5)
		bitesize = 5
		if(prob(30))
			src.icon_state = "jdonut2"
			src.name = "Frosted Jelly Donut"
			reagents.add_reagent("sprinkles", 2)

/obj/item/weapon/reagent_containers/food/snacks/egg
	name = "egg"
	desc = "An egg!"
	icon_state = "egg"
	New()
		..()
		reagents.add_reagent("nutriment", 1)

	throw_impact(atom/hit_atom)
		..()
		new/obj/effect/decal/cleanable/egg_smudge(src.loc)
		src.visible_message("\red [src.name] has been squashed.","\red You hear a smack.")
		del(src)

/obj/item/weapon/reagent_containers/food/snacks/friedegg
	name = "Fried egg"
	desc = "A fried egg, with a touch of salt and pepper."
	icon_state = "friedegg"
	New()
		..()
		reagents.add_reagent("nutriment", 2)
		reagents.add_reagent("sodiumchloride", 1)
		reagents.add_reagent("blackpepper", 1)
		bitesize = 1

/obj/item/weapon/reagent_containers/food/snacks/boiledegg
	name = "Boiled egg"
	desc = "A hard boiled egg."
	icon_state = "egg"
	New()
		..()
		reagents.add_reagent("nutriment", 2)

/obj/item/weapon/reagent_containers/food/snacks/flour
	name = "flour"
	desc = "Some flour"
	icon_state = "flour"
	New()
		..()
		reagents.add_reagent("nutriment", 1)

/obj/item/weapon/reagent_containers/food/snacks/sliceable/meat
	name = "meat"
	desc = "A slab of meat"
	icon_state = "meat"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/rawcutlet
	slices_num = 3
	health = 180

	New()
		..()
		reagents.add_reagent("nutriment", 3)
		src.bitesize = 3
		processing_objects.Add(src)

	Del()
		processing_objects.Remove(src)
		..()

/*	process()
		var/turf/location = get_turf(src.loc)
		var/datum/gas_mixture/environment = location.return_air()
		switch(environment.temperature)
			if(0 to T0C)
			if(T0C to (T0C + 100))
				health = max(0, health - 1)
		if(health <= 0)
			name = "rotten meat"
			desc = "A slab of meat. It looks rotten."
			var/toxin_amount = reagents.get_reagent_amount("nutriment") * 3
			reagents.add_reagent("toxin",toxin_amount)
			processing_objects.Remove(src) */

/obj/item/weapon/reagent_containers/food/snacks/sliceable/meat/syntiflesh
	name = "synthetic meat"
	desc = "A synthetic slab of flesh."

/*	process()
		var/turf/location = get_turf(src.loc)
		var/datum/gas_mixture/environment = location.return_air()
		switch(environment.temperature)
			if(0 to T0C)
			if(T0C to (T0C + 100))
				health = max(0, health - 1)
		if(health <= 0)
			name = "rotten synthetic meat"
			desc = "A slab of synthetic meat. It looks rotten."
			var/toxin_amount = reagents.get_reagent_amount("nutriment") * 3
			reagents.add_reagent("toxin",toxin_amount)
			processing_objects.Remove(src)

/obj/item/weapon/reagent_containers/food/snacks/appendix //yes, this is the same as meat. I might do something different in future
	name = "appendix"
	desc = "An appendix which looks perfectly healthy."
	icon_state = "appendix"
	New()
		..()
		reagents.add_reagent("nutriment", 3)
		src.bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/appendixinflamed
	name = "inflamed appendix"
	desc = "An appendix which appears to be inflamed."
	icon_state = "appendixinflamed"
	New()
		..()
		reagents.add_reagent("nutriment", 1)
		src.bitesize = 1
*/
/obj/item/weapon/reagent_containers/food/snacks/sliceable/meat/human
	name = "-meat"
	var/subjectname = ""
	var/subjectjob = null

/*	process()
		var/turf/location = get_turf(src.loc)
		var/datum/gas_mixture/environment = location.return_air()
		switch(environment.temperature)
			if(0 to T0C)
			if(T0C to (T0C + 100))
				health = max(0, health - 1)
		if(health <= 0)
			name = "-rotten meat"
			desc = "A slab of meat. It looks rotten."
			var/toxin_amount = reagents.get_reagent_amount("nutriment") * 3
			reagents.add_reagent("toxin",toxin_amount)
			processing_objects.Remove(src)
*/
//Useful in later patch ~Hawk
/obj/item/weapon/reagent_containers/food/snacks/sliceable/meat/monkey
	//same as plain meat

/obj/item/weapon/reagent_containers/food/snacks/tofu
	name = "Tofu"
	icon_state = "tofu"
	desc = "We all love tofu."
	New()
		..()
		reagents.add_reagent("nutriment", 3)
		src.bitesize = 3


/obj/item/weapon/reagent_containers/food/snacks/carpmeat
	name = "carp fillet"
	desc = "A fillet of spess carp meat"
	icon_state = "fishfillet"
	New()
		..()
		reagents.add_reagent("nutriment", 3)
		reagents.add_reagent("carpotoxin", 3)
		src.bitesize = 6

/obj/item/weapon/reagent_containers/food/snacks/fishfingers
	name = "Fish Fingers"
	desc = "A finger of fish."
	icon_state = "fishfingers"
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		reagents.add_reagent("carpotoxin", 3)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/hugemushroomslice
	name = "huge mushroom slice"
	desc = "A slice from a huge mushroom."
	icon_state = "hugemushroomslice"
	New()
		..()
		reagents.add_reagent("nutriment", 3)
		reagents.add_reagent("psilocybin", 3)
		src.bitesize = 6

/obj/item/weapon/reagent_containers/food/snacks/tomatomeat
	name = "tomato slice"
	desc = "A slice from a huge tomato"
	icon_state = "tomatomeat"
	New()
		..()
		reagents.add_reagent("nutriment", 3)
		src.bitesize = 6

/obj/item/weapon/reagent_containers/food/snacks/bearmeat
	name = "bear meat"
	desc = "A very manly slab of meat."
	icon_state = "bearmeat"
	New()
		..()
		reagents.add_reagent("nutriment", 12)
		reagents.add_reagent("hyperzine", 5)
		src.bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/xenomeat
	name = "meat"
	desc = "A slab of meat"
	icon_state = "xenomeat"
	New()
		..()
		reagents.add_reagent("nutriment", 3)
		src.bitesize = 6

/obj/item/weapon/reagent_containers/food/snacks/faggot
	name = "meatball"
	desc = "A great meal all round."
	icon_state = "faggot"
	New()
		..()
		reagents.add_reagent("nutriment", 3)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sausage
	name = "Sausage"
	desc = "A piece of mixed, long meat."
	icon_state = "sausage"
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/donkpocket
	name = "Donk-pocket"
	desc = "The food of choice for the seasoned traitor."
	icon_state = "donkpocket"
	New()
		..()
		reagents.add_reagent("nutriment", 4)

	var/warm = 0
	proc/cooltime() //Not working, derp?
		if (src.warm)
			spawn( 4200 )
				src.warm = 0
				src.reagents.del_reagent("tricordrazine")
				src.name = "donk-pocket"
		return

/obj/item/weapon/reagent_containers/food/snacks/burger
	name = "burger"
	desc = "The cornerstone of every nutritious breakfast."
	icon_state = "burger"
	bitesize = 2
	New()
		..()
		reagents.add_reagent("nutriment", 6)

/obj/item/weapon/reagent_containers/food/snacks/burger/cheese
	name = "cheeseburger"
	desc = "The cheese adds a good flavor."
	icon_state = "cheeseburger"
	New()
		..()
		reagents.add_reagent("nutriment", 2)

/obj/item/weapon/reagent_containers/food/snacks/burger/brain
	name = "brainburger"
	desc = "A strange looking burger. It looks almost sentient."
	icon_state = "brainburger"
	New()
		..()
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/ghostburger
	name = "Ghost Burger"
	desc = "Spooky! It doesn't look very filling."
	icon_state = "ghostburger"
	New()
		..()
		reagents.add_reagent("nutriment", 2)
		bitesize = 2


/obj/item/weapon/reagent_containers/food/snacks/human
	var/hname = ""
	var/job = null

/obj/item/weapon/reagent_containers/food/snacks/human/burger
	name = "-burger"
	desc = "A bloody burger."
	icon_state = "burger"
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/burger/fish
	name = "Fillet -o- Carp Sandwich"
	desc = "Almost like a carp is yelling somewhere... Give me back that fillet -o- carp, give me that carp."
	icon_state = "fishburger"
	New()
		..()
		reagents.add_reagent("carpotoxin", 3)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/burger/tofu
	name = "Tofu Burger"
	desc = "What.. is that meat?"
	icon_state = "tofuburger"

/obj/item/weapon/reagent_containers/food/snacks/burger/ro
	name = "roburger"
	desc = "The lettuce is the only organic component. Beep."
	icon_state = "roburger"
	New()
		..()
		reagents.add_reagent("nanites", 2)

/obj/item/weapon/reagent_containers/food/snacks/burger/ro_big
	name = "roburger"
	desc = "This massive patty looks like poison. Beep."
	icon_state = "roburger"
	volume = 100
	New()
		..()
		reagents.add_reagent("nanites", 100)
		bitesize = 0.1

/obj/item/weapon/reagent_containers/food/snacks/burger/xeno
	name = "xenoburger"
	desc = "Smells caustic. Tastes like heresy."
	icon_state = "xburger"
	New()
		..()
		reagents.add_reagent("nutriment", 2)

/obj/item/weapon/reagent_containers/food/snacks/burger/clown
	name = "Clown Burger"
	desc = "This tastes funny..."
	icon_state = "clownburger"
/*	New()
		..()

		var/datum/disease/F = new /datum/disease/pierrot_throat(0)
		var/list/data = list("viruses"= list(F))
		reagents.add_reagent("blood", 4, data)
*/

/obj/item/weapon/reagent_containers/food/snacks/burger/mime
	name = "Mime Burger"
	desc = "Its taste defies language."
	icon_state = "mimeburger"

/obj/item/weapon/reagent_containers/food/snacks/omelette
	name = "Omelette Du Fromage"
	desc = "That's all you can say!"
	icon_state = "omelette"
	trash = "plate"
	//var/herp = 0
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 1

/obj/item/weapon/reagent_containers/food/snacks/muffin
	name = "Muffin"
	desc = "A delicious and spongy little cake"
	icon_state = "muffin"
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/pie
	name = "Banana Cream Pie"
	desc = "Just like back home, on clown planet! HONK!"
	icon_state = "pie"
	trash = "plate"
	New()
		..()
		reagents.add_reagent("nutriment", 4)
		reagents.add_reagent("banana",5)
		bitesize = 3

	throw_impact(atom/hit_atom)
		..()
		new/obj/effect/decal/cleanable/pie_smudge(src.loc)
		src.visible_message("\red [src.name] splats.","\red You hear a splat.")
		del(src)

/obj/item/weapon/reagent_containers/food/snacks/berryclafoutis
	name = "Berry Clafoutis"
	desc = "No black birds, this is a good sign."
	icon_state = "berryclafoutis"
	trash = "plate"
	New()
		..()
		reagents.add_reagent("nutriment", 4)
		reagents.add_reagent("berryjuice", 5)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/waffles
	name = "waffles"
	desc = "Mmm, waffles"
	icon_state = "waffles"
	trash = "waffles"
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/eggplantparm
	name = "Eggplant Parmigiana"
	desc = "The only good recipe for eggplant."
	icon_state = "eggplantparm"
	trash = "plate"
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/soylentgreen
	name = "Soylent Green"
	desc = "Not made of people. Honest." //Totally people.
	icon_state = "soylent_green"
	trash = "waffles"
	New()
		..()
		reagents.add_reagent("nutriment", 14)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/soylenviridians
	name = "Soylen Virdians"
	desc = "Not made of people. Honest." //Actually honest for once.
	icon_state = "soylent_yellow"
	trash = "waffles"
	New()
		..()
		reagents.add_reagent("nutriment", 10)
		bitesize = 2


/obj/item/weapon/reagent_containers/food/snacks/meatpie
	name = "Meat-pie"
	icon_state = "meatpie"
	desc = "An old barber recipe, very delicious!"
	trash = "plate"
	New()
		..()
		reagents.add_reagent("nutriment", 10)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/tofupie
	name = "Tofu-pie"
	icon_state = "meatpie"
	desc = "A delicious tofu pie."
	trash = "plate"
	New()
		..()
		reagents.add_reagent("nutriment", 10)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/amanita_pie
	name = "amanita pie"
	desc = "Sweet and tasty poison pie."
	icon_state = "amanita_pie"
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
	New()
		..()
		if(prob(10))
			name = "exceptional plump pie"
			desc = "Microwave is taken by a fey mood! It has cooked an exceptional plump pie!"
			reagents.add_reagent("nutriment", 15)
			reagents.add_reagent("tricordrazine", 5)
			bitesize = 2
		else
			reagents.add_reagent("nutriment", 10)
			bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/xemeatpie
	name = "Xeno-pie"
	icon_state = "xenomeatpie"
	desc = "A delicious meatpie. Probably heretical."
	trash = "plate"
	New()
		..()
		reagents.add_reagent("nutriment", 10)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/wingfangchu
	name = "Wing Fang Chu"
	desc = "A savory dish of alien wing wang in soy."
	icon_state = "wingfangchu"
	trash = "snack_bowl"
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2


/obj/item/weapon/reagent_containers/food/snacks/human/kabob
	name = "-kabob"
	icon_state = "kabob"
	desc = "A human meat, on a stick."
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 2
	On_Consume()
		if(!reagents.total_volume)
			var/mob/M = usr
			var/obj/item/stack/rods/W = new /obj/item/stack/rods( M )
			M << "\blue You lick clean the rod."
			M.put_in_hand(W)

/obj/item/weapon/reagent_containers/food/snacks/monkeykabob
	name = "Meat-kabob"
	icon_state = "kabob"
	desc = "Delicious meat, on a stick."
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 2
	On_Consume()
		if(!reagents.total_volume)
			var/mob/M = usr
			var/obj/item/stack/rods/W = new /obj/item/stack/rods( M )
			M << "\blue You lick clean the rod."
			M.put_in_hand(W)

/obj/item/weapon/reagent_containers/food/snacks/tofukabob
	name = "Tofu-kabob"
	icon_state = "kabob"
	desc = "Vegan meat, on a stick."
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 2
	On_Consume()
		if(!reagents.total_volume)
			var/mob/M = usr
			var/obj/item/stack/rods/W = new /obj/item/stack/rods( M )
			M << "\blue You lick clean the rod."
			M.put_in_hand(W)

/obj/item/weapon/reagent_containers/food/snacks/cubancarp
	name = "Cuban Carp"
	desc = "A grifftastic sandwich that burns your tongue and then leaves it numb!"
	icon_state = "cubancarp"
	trash = "plate"
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		reagents.add_reagent("carpotoxin", 3)
		reagents.add_reagent("capsaicin", 3)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/popcorn
	name = "Popcorn"
	desc = "Now let's find some cinema."
	icon_state = "popcorn"
	trash = "popcorn"
	var/unpopped = 0
	New()
		..()
		unpopped = rand(1,10)
		reagents.add_reagent("nutriment", 2)
		bitesize = 0.1 //this snack is supposed to be eating during looooong time. And this it not dinner food! --rastaf0
	On_Consume()
		if(prob(unpopped))
			usr << "\red You bite down on an un-popped kernel!"
			unpopped = max(0, unpopped-1)
		..()


/obj/item/weapon/reagent_containers/food/snacks/sosjerky
	name = "Scaredy's Private Reserve Beef Jerky"
	icon_state = "sosjerky"
	desc = "Beef jerky made from the finest space cows."
	trash = "sosjerky"
	New()
		..()
		reagents.add_reagent("nutriment", 4)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/no_raisin
	name = "4no Raisins"
	icon_state = "4no_raisins"
	desc = "Best raisins in the universe. Not sure why."
	trash = "raisins"
	New()
		..()
		reagents.add_reagent("nutriment", 6)

/obj/item/weapon/reagent_containers/food/snacks/spacetwinkie
	name = "Space Twinkie"
	icon_state = "space_twinkie"
	desc = "Guaranteed to survive longer then you will."
	New()
		..()
		reagents.add_reagent("sugar", 4)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/cheesiehonkers
	name = "Cheesie Honkers"
	icon_state = "cheesie_honkers"
	desc = "Bite sized cheesie snacks that will honk all over your mouth"
	trash = "cheesie"
	New()
		..()
		reagents.add_reagent("nutriment", 4)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/syndicake
	name = "Syndi-Cakes"
	icon_state = "syndi_cakes"
	desc = "An extremely moist snack cake that tastes just as good after being nuked."
	trash = "syndi_cakes"
	New()
		..()
		reagents.add_reagent("nutriment", 4)
		reagents.add_reagent("syndicream", 2)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/loadedbakedpotato
	name = "Loaded Baked Potato"
	desc = "Totally baked."
	icon_state = "loadedbakedpotato"
	trash = "loadedbakedpotato"
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/fries
	name = "Space Fries"
	desc = "AKA: French Fries, Freedom Fries, etc"
	icon_state = "fries"
	trash = "plate"
	New()
		..()
		reagents.add_reagent("nutriment", 4)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/soydope
	name = "Soy Dope"
	desc = "Dope from a soy."
	icon_state = "soydope"
	trash = "plate"
	New()
		..()
		reagents.add_reagent("nutriment", 2)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/spagetti
	name = "Spagetti"
	desc = "Now thats a nice pasta!"
	icon_state = "spagetti"
	New()
		..()
		reagents.add_reagent("nutriment", 1)
		bitesize = 1

/obj/item/weapon/reagent_containers/food/snacks/cheesyfries
	name = "Cheesy Fries"
	desc = "Fries. Covered in cheese. Duh."
	icon_state = "cheesyfries"
	trash = "plate"
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/fortunecookie
	name = "Fortune cookie"
	desc = "A true prophecy in each cookie!"
	icon_state = "fortune_cookie"
	New()
		..()
		reagents.add_reagent("nutriment", 3)
		bitesize = 2
	On_Consume()
		if(!reagents.total_volume)
			var/mob/M = usr
			var/obj/item/weapon/paper/paper = locate() in src
			if(paper)
				M.visible_message( \
					"\blue [M] takes a piece of paper from the cookie!", \
					"\blue You take a piece of paper from the cookie! Read it!" \
				)
				M.put_in_hand(paper)
				paper.add_fingerprint(M)

/obj/item/weapon/reagent_containers/food/snacks/badrecipe
	name = "Burned mess"
	desc = "Someone should be demoted from chef for this."
	icon_state = "badrecipe"
	New()
		..()
		reagents.add_reagent("toxin", 1)
		reagents.add_reagent("carbon", 3)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/meatsteak
	name = "Meat steak"
	desc = "A piece of hot spicy meat."
	icon_state = "meatstake"
	trash = "plate"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/cutlet
	slices_num = 3
	New()
		..()
		reagents.add_reagent("nutriment", 4)
		reagents.add_reagent("sodiumchloride", 1)
		reagents.add_reagent("blackpepper", 1)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/sliceable/cookedmeat
	name = "Simple, cooked meat"
	desc = "A chunk of meat."
	icon_state = "meatstake"
	trash = "plate"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/cutlet
	slices_num = 3
	New()
		..()
		reagents.add_reagent("nutriment", 3)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/spacylibertyduff
	name = "Spacy Liberty Duff"
	desc = "Jello gelatin, from Alfred Hubbard's cookbook"
	icon_state = "spacylibertyduff"
	trash = "snack_bowl"
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		reagents.add_reagent("psilocybin", 6)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/amanitajelly
	name = "Amanita Jelly"
	desc = "Looks curiously toxic"
	icon_state = "amanitajelly"
	trash = "snack_bowl"
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
	New()
		..()
		reagents.add_reagent("nutriment", 5)
		bitesize = 2


/obj/item/weapon/reagent_containers/food/snacks/meatballsoup
	name = "Meatball soup"
	desc = "You've got balls kid, BALLS!"
	icon_state = "meatballsoup"
	trash = "snack_bowl"
	New()
		..()
		reagents.add_reagent("nutriment", 10)
		reagents.add_reagent("water", 10)
		bitesize = 5

/obj/item/weapon/reagent_containers/food/snacks/metroidsoup
	name = "Metroid soup"
	desc = "Tasty"
	icon_state = "metroidsoup"
	New()
		..()
		reagents.add_reagent("metroid", 5)
		reagents.add_reagent("water", 10)
		bitesize = 5

/obj/item/weapon/reagent_containers/food/snacks/bloodsoup
	name = "Meatball soup"
	desc = "Smells like copper"
	icon_state = "meatballsoup"
	New()
		..()
		reagents.add_reagent("nutriment", 2)
		reagents.add_reagent("blood", 15)
		reagents.add_reagent("water", 5)
		bitesize = 5

/obj/item/weapon/reagent_containers/food/snacks/clownstears
	name = "Clown's Tears"
	desc = "Not very funny."
	icon_state = "clownstears"
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
	trash = "snack_bowl"
	New()
		..()
		reagents.add_reagent("nutriment", 10)
		reagents.add_reagent("water", 5)
		bitesize = 5

/obj/item/weapon/reagent_containers/food/snacks/nettlesoup
	name = "Nettle soup"
	desc = "To think, the botanist would've beat you to death with one of these."
	icon_state = "nettlesoup"
	trash = "snack_bowl"
	New()
		..()
		reagents.add_reagent("nutriment", 10)
		reagents.add_reagent("water", 5)
		reagents.add_reagent("tricordrazine", 5)
		bitesize = 5

/obj/item/weapon/reagent_containers/food/snacks/mysterysoup
	name = "Mystery soup"
	desc = "The mystery is, why aren't you eating it?"
	icon_state = "mysterysoup"
	trash = "snack_bowl"
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
				reagents.add_reagent("metroid", 10)
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
	trash = "snack_bowl"
	New()
		..()
		reagents.add_reagent("water", 10)
		bitesize = 5
		if(prob(25))
			src.desc = "A wish come true!"
			reagents.add_reagent("nutriment", 10)

/obj/item/weapon/reagent_containers/food/snacks/hotchili
	name = "Hot Chili"
	desc = "A five alarm Texan Chili!"
	icon_state = "hotchili"
	trash = "snack_bowl"
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		reagents.add_reagent("capsaicin", 3)
		reagents.add_reagent("tomatojuice", 2)
		bitesize = 5


/obj/item/weapon/reagent_containers/food/snacks/coldchili
	name = "Cold Chili"
	desc = "This slush is barely a liquid!"
	icon_state = "coldchili"
	trash = "snack_bowl"
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		reagents.add_reagent("frostoil", 3)
		reagents.add_reagent("tomatojuice", 2)
		bitesize = 5

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


/obj/item/weapon/reagent_containers/food/snacks/monkeycube
	name = "monkey cube"
	desc = "Just add water!"
	icon_state = "monkeycube"
	bitesize = 12
	var/wrapped = 0

	New()
		..()
		reagents.add_reagent("nutriment",12)

	afterattack(obj/O as obj, mob/user as mob)
		if(istype(O,/obj/machinery/sink) && !wrapped)
			user << "You place [name] under a stream of water..."
			loc = get_turf(O)
			return Expand()
		..()

	attack_self(mob/user as mob)
		if(wrapped)
			Unwrap(user)

	proc/Expand()
		for(var/mob/M in viewers(src,7))
			M << "\red The monkey cube expands!"
		new /mob/living/carbon/monkey(get_turf(src))
		del(src)

	proc/Unwrap(mob/user as mob)
		icon_state = "monkeycube"
		desc = "Just add water!"
		user << "You unwrap the cube."
		wrapped = 0
		return

	wrapped
		desc = "Still wrapped in some paper."
		icon_state = "monkeycubewrap"
		wrapped = 1


/obj/item/weapon/reagent_containers/food/snacks/spellburger
	name = "Spell Burger"
	desc = "This is absolutely Ei Nath."
	icon_state = "spellburger"
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/bigbiteburger
	name = "Big Bite Burger"
	desc = "Forget the Big Mac. THIS is the future!"
	icon_state = "bigbiteburger"
	New()
		..()
		reagents.add_reagent("nutriment", 14)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/enchiladas
	name = "Enchiladas"
	desc = "Viva La Mexico!"
	icon_state = "enchiladas"
	trash = "tray"
	New()
		..()
		reagents.add_reagent("nutriment",8)
		reagents.add_reagent("capsaicin", 6)
		bitesize = 4

/obj/item/weapon/reagent_containers/food/snacks/monkeysdelight
	name = "monkey's Delight"
	desc = "Eeee Eee!"
	icon_state = "monkeysdelight"
	trash = "tray"
	New()
		..()
		reagents.add_reagent("nutriment", 14)
		reagents.add_reagent("banana", 5)
		reagents.add_reagent("blackpepper", 1)
		reagents.add_reagent("sodiumchloride", 1)
		bitesize = 6

/obj/item/weapon/reagent_containers/food/snacks/baguette
	name = "Baguette"
	desc = "Bon appetit!"
	icon_state = "baguette"
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
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		reagents.add_reagent("carpotoxin", 3)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/sandwich
	name = "Sandwich"
	desc = "A grand creation of meat, cheese, bread and several leafs oflettuce! Arthur Dent would be proud."
	icon_state = "sandwich"
	trash = "plate"
	New()
		..()
		reagents.add_reagent("nutriment", 11)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/toastedsandwich
	name = "Toasted Sandwich"
	desc = "Now if you only had a pepper bar."
	icon_state = "toastedsandwich"
	trash = "plate"
	New()
		..()
		reagents.add_reagent("nutriment", 12)
		reagents.add_reagent("carbon", 2)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/grilledcheese
	name = "Grilled Cheese Sandwich"
	desc = "Goes great with Tomato soup!"
	icon_state = "toastedsandwich"
	trash = "plate"
	New()
		..()
		reagents.add_reagent("nutriment", 7)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/tomatosoup
	name = "Tomato Soup"
	desc = "Drinking this feels like being a vampire! A tomato vampire..."
	icon_state = "tomatosoup"
	trash = "snack_bowl"
	New()
		..()
		reagents.add_reagent("nutriment", 5)
		reagents.add_reagent("tomatojuice", 10)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/rofflewaffles
	name = "Roffle Waffles"
	desc = "Waffles from Roffle. Co."
	icon_state = "rofflewaffles"
	trash = "waffles"
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		reagents.add_reagent("psilocybin", 8)
		bitesize = 4

/obj/item/weapon/reagent_containers/food/snacks/stew
	name = "Stew"
	desc = "A nice and warm stew. Healthy and strong."
	icon_state = "stew"
	New()
		..()
		reagents.add_reagent("nutriment", 20)
		reagents.add_reagent("tomatojuice", 5)
		reagents.add_reagent("imidazoline", 5)
		reagents.add_reagent("water", 5)
		bitesize = 10

/obj/item/weapon/reagent_containers/food/snacks/metroidtoast
	name = "Metroid Toast"
	desc = "A slice of bread covered with delicious jam."
	icon_state = "metroidtoast"
	trash = "plate"
	New()
		..()
		reagents.add_reagent("nutriment", 1)
		reagents.add_reagent("metroid", 5)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/metroidburger
	name = "Metroid Burger"
	desc = "A very toxic and tasty burger."
	icon_state = "metroidburger"
	New()
		..()
		reagents.add_reagent("nutriment", 1)
		reagents.add_reagent("metroid", 5)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/milosoup
	name = "Milosoup"
	desc = "The universes best soup! Yum!!!"
	icon_state = "milosoup"
	trash = "snack_bowl"
	New()
		..()
		reagents.add_reagent("nutriment", 12)
		reagents.add_reagent("water", 5)
		bitesize = 4

/obj/item/weapon/reagent_containers/food/snacks/stewedsoymeat
	name = "Stewed Soy Meat"
	desc = "Even non-vegetarians will LOVE this!"
	icon_state = "stewedsoymeat"
	trash = "plate"
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/boiledspagetti
	name = "Boiled Spagetti"
	desc = "A plain dish of noodles, this sucks."
	icon_state = "spagettiboiled"
	trash = "plate"
	New()
		..()
		reagents.add_reagent("nutriment", 2)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/pastatomato
	name = "Spagetti"
	desc = "Spaghetti and crushed tomatoes. Just like your abusive father used to make!"
	icon_state = "pastatomato"
	trash = "plate"
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		reagents.add_reagent("tomatojuice", 10)
		bitesize = 4

/obj/item/weapon/reagent_containers/food/snacks/meatballspagetti
	name = "Spagetti & Meatballs"
	desc = "Now thats a nic'e meatball!"
	icon_state = "meatballspagetti"
	trash = "plate"
	New()
		..()
		reagents.add_reagent("nutriment", 8)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/spesslaw
	name = "Spesslaw"
	desc = "A lawyers favourite"
	icon_state = "spesslaw"
	New()
		..()
		reagents.add_reagent("nutriment", 14)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/poppypretzel
	name = "Poppy Pretzel"
	desc = "A large soft pretzel full of POP!"
	icon_state = "poppypretzel"
	New()
		..()
		reagents.add_reagent("nutriment", 5)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/carrotfries
	name = "Carrot Fries"
	desc = "Tasty fries from fresh Carrots."
	icon_state = "carrotfries"
	trash = "plate"
	New()
		..()
		reagents.add_reagent("nutriment", 3)
		reagents.add_reagent("imidazoline", 3)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/superbiteburger
	name = "Super Bite Burger"
	desc = "This is a mountain of a burger. FOOD!"
	icon_state = "superbiteburger"
	New()
		..()
		reagents.add_reagent("nutriment", 40)
		bitesize = 10

/obj/item/weapon/reagent_containers/food/snacks/candiedapple
	name = "Candied Apple"
	desc = "An apple coated in sugary sweetness."
	icon_state = "candiedapple"
	New()
		..()
		reagents.add_reagent("nutriment", 3)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/applepie
	name = "Apple Pie"
	desc = "A pie containing sweet sweet love...or apple."
	icon_state = "applepie"
	New()
		..()
		reagents.add_reagent("nutriment", 4)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/twobread
	name = "Two Bread"
	desc = "It is very bitter and winy."
	icon_state = "twobread"
	New()
		..()
		reagents.add_reagent("nutriment", 2)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/metroidsandwich
	name = "Metroid Sandwich"
	desc = "A sandwich is green stuff."
	icon_state = "metroidsandwich"
	trash = "plate"
	New()
		..()
		reagents.add_reagent("nutriment", 2)
		reagents.add_reagent("metroid", 5)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/boiledmetroidcore
	name = "Boiled Metroid Core"
	desc = "A boiled red thing."
	icon_state = "boiledmetroidcore"
	New()
		..()
		reagents.add_reagent("metroid", 5)
		bitesize = 3


/obj/item/weapon/reagent_containers/food/snacks/mushroomsoup
	name = "chantrelle soup"
	desc = "A delicious and hearty mushroom soup."
	icon_state = "mushroomsoup"
	trash = "snack_bowl"
	New()
		..()
		reagents.add_reagent("nutriment", 10)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/plumphelmetbiscuit
	name = "plump helmet biscuit"
	desc = "This is a finely-prepared plump helmet biscuit. The ingredients are exceptionally minced plump helmet, and well-minced dwarven wheat flour."
	icon_state = "phelmbiscuit"
	New()
		..()
		if(prob(10))
			name = "exceptional plump helmet biscuit"
			desc = "Microwave is taken by a fey mood! It has cooked an exceptional plump helmet biscuit!"
			reagents.add_reagent("nutriment", 15)
			reagents.add_reagent("tricordrazine", 5)
			bitesize = 2
		else
			reagents.add_reagent("nutriment", 5)
			bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/chawanmushi
	name = "chawanmushi"
	desc = "A legendary egg custard that makes friends out of enemies. Probably too hot for a cat to eat."
	icon_state = "chawanmushi"
	trash = "snack_bowl"
	New()
		..()
		reagents.add_reagent("nutriment", 5)
		bitesize = 1

/obj/item/weapon/reagent_containers/food/snacks/beetsoup
	name = "beet soup"
	desc = "Wait, how do you spell it, again..?"
	icon_state = "beetsoup"
	trash = "snack_bowl"
	New()
		..()
		switch(rand(1,6))
			if(1)
				name = "borsch"
			if(2)
				name = "bortsch"
			if(3)
				name = "borstch"
			if(4)
				name = "borsh"
			if(5)
				name = "borshch"
			if(6)
				name = "borscht"
		reagents.add_reagent("nutriment", 8)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/liquidfood
	name = "\improper \"LiquidFood\" ration"
	icon_state = "liquidfood"
	desc = "A bland, tasteless pulp of what you need to survive. Packaged in a airtight bag, which you can drink through a straw. Strangely crunchy."
	trash = "liquidfood"
	var/flavored = 0
	New()
		..()
		reagents.add_reagent("nutriment", 5)
		reagents.add_reagent("water", 5)
		reagents.add_reagent("tricordrazine", 2)
		bitesize = 6

/////////////////////////////////////////////////Sliceable////////////////////////////////////////
// All the food items that can be sliced into smaller bits like Meatbread and Cheesewheels

/obj/item/weapon/reagent_containers/food/snacks/sliceable/meatbread
	name = "meatbread loaf"
	desc = "The culinary base of every self-respecting eloquen/tg/entleman."
	icon_state = "meatbread"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/meatbreadslice
	slices_num = 5
	New()
		..()
		reagents.add_reagent("nutriment", 40)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/meatbreadslice
	name = "meatbread slice"
	desc = "A slice of delicious meatbread."
	icon_state = "meatbreadslice"
	trash = "plate"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/xenomeatbread
	name = "xenomeatbread loaf"
	desc = "The culinary base of every self-respecting eloquen/tg/entleman. Extra Heretical."
	icon_state = "xenomeatbread"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/xenomeatbreadslice
	slices_num = 5
	New()
		..()
		reagents.add_reagent("nutriment", 40)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/xenomeatbreadslice
	name = "xenomeatbread slice"
	desc = "A slice of delicious meatbread. Extra Heretical."
	icon_state = "xenobreadslice"
	trash = "plate"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/bananabread
	name = "Banana-nut bread"
	desc = "A heavenly and filling treat."
	icon_state = "bananabread"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/bananabreadslice
	slices_num = 5
	New()
		..()
		reagents.add_reagent("banana", 20)
		reagents.add_reagent("nutriment", 20)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/bananabreadslice
	name = "Banana-nut bread slice"
	desc = "A slice of delicious banana bread."
	icon_state = "bananabreadslice"
	trash = "plate"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/tofubread
	name = "Tofubread"
	icon_state = "Like meatbread but for vegetarians. Not guaranteed to give superpowers."
	icon_state = "tofubread"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/tofubreadslice
	slices_num = 5
	New()
		..()
		reagents.add_reagent("nutriment", 40)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/tofubreadslice
	name = "Tofubread slice"
	desc = "A slice of delicious tofubread."
	icon_state = "tofubreadslice"
	trash = "plate"
	bitesize = 2


/obj/item/weapon/reagent_containers/food/snacks/sliceable/carrotcake
	name = "Carrot Cake"
	desc = "A favorite desert of a certain wascally wabbit. Not a lie."
	icon_state = "carrotcake"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/carrotcakeslice
	slices_num = 5
	New()
		..()
		reagents.add_reagent("nutriment", 30)
		reagents.add_reagent("imidazoline", 10)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/carrotcakeslice
	name = "Carrot Cake slice"
	desc = "Carrotty slice of Carrot Cake, carrots are good for your eyes! Also not a lie."
	icon_state = "carrotcake_slice"
	trash = "plate"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/braincake
	name = "Brain Cake"
	desc = "A squishy cake-thing."
	icon_state = "braincake"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/braincakeslice
	slices_num = 5
	New()
		..()
		reagents.add_reagent("nutriment", 28)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/braincakeslice
	name = "Brain Cake slice"
	desc = "Lemme tell you something about prions. THEY'RE DELICIOUS."
	icon_state = "braincakeslice"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/cheesecake
	name = "Cheese Cake"
	desc = "DANGEROUSLY cheesy."
	icon_state = "cheesecake"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/cheesecakeslice
	slices_num = 5
	New()
		..()
		reagents.add_reagent("nutriment", 30)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/cheesecakeslice
	name = "Cheese Cake slice"
	desc = "Slice of pure cheestisfaction"
	icon_state = "cheesecake_slice"
	trash = "plate"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/plaincake
	name = "Vanilla Cake"
	desc = "A plain cake, not a lie."
	icon_state = "plaincake"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/plaincakeslice
	slices_num = 5
	New()
		..()
		reagents.add_reagent("nutriment", 25)

/obj/item/weapon/reagent_containers/food/snacks/plaincakeslice
	name = "Vanilla Cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "plaincake_slice"
	trash = "plate"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/orangecake
	name = "Orange Cake"
	desc = "A cake with added orange."
	icon_state = "orangecake"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/orangecakeslice
	slices_num = 5
	New()
		..()
		reagents.add_reagent("nutriment", 27)

/obj/item/weapon/reagent_containers/food/snacks/orangecakeslice
	name = "Orange Cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "orangecake_slice"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/limecake
	name = "Lime Cake"
	desc = "A cake with added lime."
	icon_state = "limecake"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/limecakeslice
	slices_num = 5
	New()
		..()
		reagents.add_reagent("nutriment", 27)

/obj/item/weapon/reagent_containers/food/snacks/limecakeslice
	name = "Lime Cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "limecake_slice"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/lemoncake
	name = "Lemon Cake"
	desc = "A cake with added lemon."
	icon_state = "lemoncake"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/lemoncakeslice
	slices_num = 5
	New()
		..()
		reagents.add_reagent("nutriment", 27)

/obj/item/weapon/reagent_containers/food/snacks/lemoncakeslice
	name = "Lemon Cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "lemoncake_slice"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/chocolatecake
	name = "Chocolate Cake"
	desc = "A cake with added chocolate"
	icon_state = "chocolatecake"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/chocolatecakeslice
	slices_num = 5
	New()
		..()
		reagents.add_reagent("nutriment", 27)

/obj/item/weapon/reagent_containers/food/snacks/chocolatecakeslice
	name = "Chocolate Cake slice"
	desc = "Just a slice of cake, it is enough for everyone."
	icon_state = "chocolatecake_slice"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/cheesewheel
	name = "Cheese wheel"
	desc = "A big wheel of delcious Cheddar."
	icon_state = "cheesewheel"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	slices_num = 5
	New()
		..()
		reagents.add_reagent("nutriment", 20)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/cheesewedge
	name = "Cheese wedge"
	desc = "A wedge of delicious Cheddar. The cheese wheel it was cut from can't have gone far."
	icon_state = "cheesewedge"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/birthdaycake
	name = "Birthday Cake"
	desc = "Happy Birthday little clown..."
	icon_state = "birthdaycake"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/birthdaycakeslice
	slices_num = 5
	New()
		..()
		reagents.add_reagent("nutriment", 30)
		reagents.add_reagent("sprinkles", 10)
		bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/birthdaycakeslice
	name = "Birthday Cake slice"
	desc = "A slice of your birthday"
	icon_state = "birthdaycakeslice"
	trash = "plate"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/bread
	name = "Bread"
	icon_state = "Some plain old Earthen bread."
	icon_state = "bread"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/breadslice
	slices_num = 5
	New()
		..()
		reagents.add_reagent("nutriment", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/breadslice
	name = "Bread slice"
	desc = "A slice of home."
	icon_state = "breadslice"
	trash = "plate"
	bitesize = 2


/obj/item/weapon/reagent_containers/food/snacks/sliceable/creamcheesebread
	name = "Cream Cheese Bread"
	desc = "Yum yum yum!"
	icon_state = "creamcheesebread"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/creamcheesebreadslice
	slices_num = 5
	New()
		..()
		reagents.add_reagent("nutriment", 20)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/creamcheesebreadslice
	name = "Cream Cheese Bread slice"
	desc = "A slice of yum!"
	icon_state = "creamcheesebreadslice"
	trash = "plate"
	bitesize = 2


/obj/item/weapon/reagent_containers/food/snacks/grown/watermelon
	name = "Watermelon"
	icon_state = "A juicy watermelon"
	icon_state = "watermelon"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/watermelonslice
	slices_num = 5
	New()
		..()
		reagents.add_reagent("nutriment", 10)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/watermelonslice
	name = "Watermelon Slice"
	desc = "A slice of watery goodness."
	icon_state = "watermelonslice"
	bitesize = 2


/obj/item/weapon/reagent_containers/food/snacks/sliceable/applecake
	name = "Apple Cake"
	desc = "A cake centred with Apple"
	icon_state = "applecake"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/applecakeslice
	slices_num = 5
	New()
		..()
		reagents.add_reagent("nutriment", 29)

/obj/item/weapon/reagent_containers/food/snacks/applecakeslice
	name = "Apple Cake slice"
	desc = "A slice of heavenly cake."
	icon_state = "applecakeslice"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/pumpkinpie
	name = "Pumpkin Pie"
	desc = "A delicious treat for the autumn months."
	icon_state = "pumpkinpie"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/pumpkinpieslice
	slices_num = 5
	New()
		..()
		reagents.add_reagent("nutriment", 29)

/obj/item/weapon/reagent_containers/food/snacks/pumpkinpieslice
	name = "Pumpkin Pie slice"
	desc = "A slice of pumpkin pie, with whipped cream on top. Perfection."
	icon_state = "pumpkinpieslice"
	bitesize = 2



/////////////////////////////////////////////////PIZZA////////////////////////////////////////

/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza
	slices_num = 6

/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/margherita
	name = "Margherita"
	desc = "The most cheezy pizza in galaxy"
	icon_state = "pizzamargherita"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/margheritaslice
	slices_num = 6
	New()
		..()
		reagents.add_reagent("nutriment", 40)
		reagents.add_reagent("tomatojuice", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/margheritaslice
	name = "Margherita slice"
	desc = "A slice of the most cheezy pizza in galaxy"
	icon_state = "pizzamargheritaslice"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/meatpizza
	name = "Meatpizza"
	desc = "" //TODO:
	icon_state = "meatpizza"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/meatpizzaslice
	slices_num = 6
	New()
		..()
		reagents.add_reagent("nutriment", 50)
		reagents.add_reagent("tomatojuice", 6)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/meatpizzaslice
	name = "Meatpizza slice"
	desc = "A slice of " //TODO:
	icon_state = "meatpizzaslice"
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
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/mushroompizzaslice
	name = "Mushroompizza slice"
	desc = "Maybe it is the last slice of pizza in your life."
	icon_state = "mushroompizzaslice"
	bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza/vegetablepizza
	name = "Vegetable pizza"
	desc = "No one of Tomatos Sapiens were harmed during making this pizza"
	icon_state = "vegetablepizza"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/vegetablepizzaslice
	slices_num = 6
	New()
		..()
		reagents.add_reagent("nutriment", 30)
		reagents.add_reagent("tomatojuice", 6)
		reagents.add_reagent("imidazoline", 12)
		bitesize = 2

/obj/item/weapon/reagent_containers/food/snacks/vegetablepizzaslice
	name = "Vegetable pizza slice"
	desc = "A slice of the most green pizza of all pizzas not containing green ingredients "
	icon_state = "vegetablepizzaslice"
	bitesize = 2

///////////////////////////////////////////
// new food stuff from bs12
///////////////////////////////////////////

// Flour + egg = dough
/obj/item/weapon/reagent_containers/food/snacks/flour/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/reagent_containers/food/snacks/egg))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/weapon/reagent_containers/food/snacks/dough(spawnloc)
		user << "You make some dough."
		del(W)
		del(src)

/obj/item/weapon/reagent_containers/food/snacks/dough
	name = "dough"
	desc = "A dough."
	icon = 'food_ingredients.dmi'
	icon_state = "dough"
	bitesize = 2
	New()
		..()
		reagents.add_reagent("nutriment", 5)

// Dough + rolling pin = flat dough
/obj/item/weapon/reagent_containers/food/snacks/dough/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/kitchen/rollingpin))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough(spawnloc)
		user << "You flatten the dough."
		del(src)

// slicable into 3xdoughslices
/obj/item/weapon/reagent_containers/food/snacks/sliceable/flatdough
	name = "flat dough"
	desc = "A flattened dough."
	icon = 'food_ingredients.dmi'
	icon_state = "flat dough"
	slice_path = /obj/item/weapon/reagent_containers/food/snacks/doughslice
	slices_num = 3
	New()
		..()
		reagents.add_reagent("nutriment", 3)

/obj/item/weapon/reagent_containers/food/snacks/doughslice
	name = "dough slice"
	desc = "Make your magic."
	icon = 'food_ingredients.dmi'
	icon_state = "doughslice"
	New()
		..()
		bitesize = 2
		reagents.add_reagent("nutriment", 2)

/obj/item/weapon/reagent_containers/food/snacks/bun
	name = "bun"
	desc = "A base for any self-respecting burger."
	icon = 'food_ingredients.dmi'
	icon_state = "bun"
	bitesize = 2
	New()
		..()
		reagents.add_reagent("nutriment", 4)

/obj/item/weapon/reagent_containers/food/snacks/bun/attackby(obj/item/weapon/W as obj, mob/user as mob)
	// Bun + meatball = burger
	if(istype(W,/obj/item/weapon/reagent_containers/food/snacks/faggot))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/weapon/reagent_containers/food/snacks/burger(spawnloc)
		user << "You make a burger."
		del(W)
		del(src)

	// Bun + cutlet = hamburger
	else if(istype(W,/obj/item/weapon/reagent_containers/food/snacks/cutlet))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/weapon/reagent_containers/food/snacks/burger(spawnloc)
		user << "You make a burger."
		del(W)
		del(src)

	// Bun + sausage = hotdog
	else if(istype(W,/obj/item/weapon/reagent_containers/food/snacks/sausage))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/weapon/reagent_containers/food/snacks/hotdog(spawnloc)
		user << "You make a hotdog."
		del(W)
		del(src)

// Burger + cheese wedge = cheeseburger
/obj/item/weapon/reagent_containers/food/snacks/burger/attackby(obj/item/weapon/reagent_containers/food/snacks/cheesewedge/W as obj, mob/user as mob)
	if(istype(W) && !istype(src,/obj/item/weapon/reagent_containers/food/snacks/burger/cheese))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/weapon/reagent_containers/food/snacks/burger/cheese(spawnloc)
		user << "You make a cheeseburger."
		del(W)
		del(src)
		return
	else
		..()

// Human Burger + cheese wedge = cheeseburger
/obj/item/weapon/reagent_containers/food/snacks/human/burger/attackby(obj/item/weapon/reagent_containers/food/snacks/cheesewedge/W as obj, mob/user as mob)
	if(istype(W))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/weapon/reagent_containers/food/snacks/burger/cheese(spawnloc)
		user << "You make a cheeseburger."
		del(W)
		del(src)
		return
	else
		..()

// Cheese burger + cheeseburger = big bite burger
/obj/item/weapon/reagent_containers/food/snacks/burger/cheese/attackby(obj/item/weapon/reagent_containers/food/snacks/burger/cheese/W as obj, mob/user as mob)
	if(istype(W))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/weapon/reagent_containers/food/snacks/bigbiteburger(spawnloc)
		user << "You make a big bite burger."
		del(W)
		del(src)
		return
	else
		..()

// Big bite burger + Big bite burger = unfinished super bite burger
/obj/item/weapon/reagent_containers/food/snacks/bigbiteburger/attackby(obj/item/weapon/reagent_containers/food/snacks/bigbiteburger/W as obj, mob/user as mob)
	if(istype(W))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/weapon/reagent_containers/food/snacks/unfinished_superbiteburger(spawnloc)
		user << "You start to make a super bite burger. It could use more ingredients."
		del(W)
		del(src)
		return
	else
		..()

// Liquidfood + Flavoring = Flavored Liquidfood! :P
/obj/item/weapon/reagent_containers/food/snacks/liquidfood/attackby(obj/item/weapon/flavor/W as obj, mob/user as mob)
	// Check if already flavored
	if(istype(W))
		if (flavored)
			user << "You cannot add flavoring to an already flavored ration, however bland it may be."
			return

		user.visible_message("\The [user] adds [prob(30) ? "some of" : ""] \a [W] to \a [src], mixing it into [W.decriptor] gruel.",\
		"You add \the [W] into your bland [src].  As you mix it into a grotesquely [W.color] paste, you reflect that this was not a wise decision.",\
		"You hear a small tinfoil package being ripped open, then the sound of a thick paste being mixed.")
		name = "[W.color] \"LiquidFood\" ration"
		icon_state = "liquidfood-[W.color]"
		desc = "A flavored pulp of nutritional essentials. [W.newDesc]"
		flavored = 1

		del(W)
		return

	return ..()

/obj/item/weapon/reagent_containers/food/snacks/taco
	name = "taco"
	desc = "Take a bite!"
	icon_state = "taco"
	bitesize = 3
	New()
		..()
		reagents.add_reagent("nutriment", 7)

/obj/item/weapon/reagent_containers/food/snacks/rawcutlet
	name = "raw cutlet"
	desc = "A thin piece of meat."
	icon = 'food_ingredients.dmi'
	icon_state = "rawcutlet"
	bitesize = 1
	New()
		..()
		reagents.add_reagent("nutriment", 1)

/obj/item/weapon/reagent_containers/food/snacks/cutlet
	name = "cutlet"
	desc = "A tasty meat slice - 'Bacon'."
	icon = 'food_ingredients.dmi'
	icon_state = "cutlet"
	bitesize = 2
	New()
		..()
		reagents.add_reagent("nutriment", 2)

/obj/item/weapon/reagent_containers/food/snacks/rawfaggot
	name = "raw meatball"
	desc = "A raw meatball."
	icon = 'food_ingredients.dmi'
	icon_state = "rawmeatball"
	bitesize = 2
	New()
		..()
		reagents.add_reagent("nutriment", 2)

/obj/item/weapon/reagent_containers/food/snacks/hotdog
	name = "hotdog"
	desc = "Unrelated to dogs."
	icon_state = "hotdog"
	bitesize = 2
	New()
		..()
		reagents.add_reagent("nutriment", 6)

/obj/item/weapon/reagent_containers/food/snacks/flatbread
	name = "flatbread"
	desc = "Bland but filling."
	icon = 'food_ingredients.dmi'
	icon_state = "flatbread"
	bitesize = 2
	New()
		..()
		reagents.add_reagent("nutriment", 3)

// potato + knife = raw sticks
/obj/item/weapon/reagent_containers/food/snacks/grown/potato/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(istype(W,/obj/item/weapon/kitchen/utensil/knife))
		var/turf/spawnloc = foodloc(user, src)
		new /obj/item/weapon/reagent_containers/food/snacks/rawsticks(spawnloc)
		user << "You cut the potato."
		del(src)
	else
		..()

/obj/item/weapon/reagent_containers/food/snacks/rawsticks
	name = "raw potato sticks"
	desc = "Maybe you should cook it first?"
	icon = 'food_ingredients.dmi'
	icon_state = "rawsticks"
	bitesize = 2
	New()
		..()
		reagents.add_reagent("nutriment", 3)

/obj/item/weapon/reagent_containers/food/snacks/mint
	name = "mint"
	desc = "Minty fresh!"
	icon_state = "mint"
	trash = "plate"
	bitesize = 3
	New()
		..()
		reagents.add_reagent("sugar", 2)
		reagents.add_reagent("frostoil", 1)

/obj/item/weapon/reagent_containers/food/snacks/unfinished_superbiteburger
	name = "Unfinished Super Bite Burger"
	desc = "This is a mountain of a burger. Could be bigger."
	icon_state = "superbiteburger"
	New()
		..()
		reagents.add_reagent("nutriment", 30)
		bitesize = 10
