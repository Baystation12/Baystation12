//Consolidated burger file.
/obj/item/weapon/reagent_containers/food/snacks/cheeseburger
	name = "cheeseburger"
	desc = "The cheese adds a good flavor."
	icon_state = "cheeseburger"
	center_of_mass = "x=16;y=11"
	nutriment_desc = list("cheese" = 2, "bun" = 2)
	nutriment_amt = 2


/obj/item/weapon/reagent_containers/food/snacks/cheeseburger/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 2)

/obj/item/weapon/reagent_containers/food/snacks/meatburger
	name = "burger"
	desc = "The cornerstone of every nutritious breakfast."
	icon_state = "hburger"
	filling_color = "#d63c3c"
	center_of_mass = "x=16;y=11"
	nutriment_desc = list("bun" = 2)
	nutriment_amt = 3


/obj/item/weapon/reagent_containers/food/snacks/meatburger/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 3)

/obj/item/weapon/reagent_containers/food/snacks/plainburger
	name = "burger"
	desc = "The cornerstone of every nutritious breakfast."
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "burger"
	filling_color = "#d63c3c"
	center_of_mass = "x=16;y=11"
	nutriment_desc = list("bun" = 2)
	nutriment_amt = 3


/obj/item/weapon/reagent_containers/food/snacks/plainburger/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 3)


/obj/item/weapon/reagent_containers/food/snacks/hamburger
	name = "hamburger"
	desc = "The cornerstone of every nutritious breakfast, now with ham!"
	icon = 'icons/obj/food_ingredients.dmi'
	icon_state = "hamburger"
	filling_color = "#d63c3c"
	center_of_mass = "x=16;y=11"
	nutriment_desc = list("bun" = 2)
	nutriment_amt = 3


/obj/item/weapon/reagent_containers/food/snacks/hamburger/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 5)


/obj/item/weapon/reagent_containers/food/snacks/fishburger
	name = "fillet -o- carp sandwich"
	desc = "Almost like a carp is yelling somewhere... Give me back that fillet -o- carp, give me that carp."
	icon_state = "fishburger"
	filling_color = "#ffdefe"
	center_of_mass = "x=16;y=10"
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/fishburger/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 6)


/obj/item/weapon/reagent_containers/food/snacks/tofuburger
	name = "tofu Burger"
	desc = "What.. is that meat?"
	icon_state = "tofuburger"
	filling_color = "#fffee0"
	center_of_mass = "x=16;y=10"
	nutriment_desc = list("bun" = 2, "pseudo-soy meat" = 3)
	nutriment_amt = 6


/obj/item/weapon/reagent_containers/food/snacks/roburger
	name = "roburger"
	desc = "The lettuce is the only organic component. Beep."
	icon_state = "roburger"
	filling_color = "#cccccc"
	center_of_mass = "x=16;y=11"
	nutriment_desc = list("bun" = 2, "metal" = 3)
	nutriment_amt = 2


/obj/item/weapon/reagent_containers/food/snacks/roburger/Initialize()
	. = ..()
	if(prob(5))
		reagents.add_reagent(/datum/reagent/nanites, 2)


/obj/item/weapon/reagent_containers/food/snacks/roburgerbig
	name = "roburger"
	desc = "This massive patty looks like poison. Beep."
	icon_state = "roburger"
	filling_color = "#cccccc"
	volume = 100
	center_of_mass = "x=16;y=11"
	bitesize = 0.1

/obj/item/weapon/reagent_containers/food/snacks/roburgerbig/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nanites, 100)


/obj/item/weapon/reagent_containers/food/snacks/xenoburger
	name = "xenoburger"
	desc = "Smells caustic. Tastes like heresy."
	icon_state = "xburger"
	filling_color = "#43de18"
	center_of_mass = "x=16;y=11"


/obj/item/weapon/reagent_containers/food/snacks/xenoburger/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 8)


/obj/item/weapon/reagent_containers/food/snacks/clownburger
	name = "\improper Clown Burger"
	desc = "This tastes funny..."
	icon_state = "clownburger"
	filling_color = "#ff00ff"
	center_of_mass = "x=17;y=12"
	nutriment_desc = list("bun" = 2, "clown shoe" = 3)
	nutriment_amt = 6

/obj/item/weapon/reagent_containers/food/snacks/mimeburger
	name = "\improper Mime Burger"
	desc = "Its taste defies language."
	icon_state = "mimeburger"
	filling_color = "#ffffff"
	center_of_mass = "x=16;y=11"
	nutriment_desc = list("bun" = 2, "mime paint" = 3)
	nutriment_amt = 6

/obj/item/weapon/reagent_containers/food/snacks/brainburger
	name = "brainburger"
	desc = "A strange looking burger. It looks almost sentient."
	icon_state = "brainburger"
	filling_color = "#f2b6ea"
	center_of_mass = "x=15;y=11"

/obj/item/weapon/reagent_containers/food/snacks/brainburger/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 6)
	reagents.add_reagent(/datum/reagent/alkysine, 6)

/obj/item/weapon/reagent_containers/food/snacks/ghostburger
	name = "ghost burger"
	desc = "Spooky! It doesn't look very filling."
	icon_state = "ghostburger"
	filling_color = "#fff2ff"
	center_of_mass = "x=16;y=11"
	nutriment_desc = list("buns" = 3, "spookiness" = 3)
	nutriment_amt = 2


/obj/item/weapon/reagent_containers/food/snacks/jellyburger
	name = "Jelly Burger"
	desc = "Culinary delight..?"
	icon_state = "jellyburger"
	filling_color = "#b572ab"
	center_of_mass = "x=16;y=11"
	nutriment_desc = list("buns" = 5)
	nutriment_amt = 5


/obj/item/weapon/reagent_containers/food/snacks/jellyburger/slime/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/slimejelly, 5)

/obj/item/weapon/reagent_containers/food/snacks/jellyburger/cherry/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/cherryjelly, 5)

/obj/item/weapon/reagent_containers/food/snacks/superbiteburger
	name = "Super Bite Burger"
	desc = "This is a mountain of a burger. FOOD!"
	icon_state = "superbiteburger"
	filling_color = "#cca26a"
	center_of_mass = "x=16;y=3"
	nutriment_desc = list("buns" = 25)
	nutriment_amt = 25
	bitesize = 10

/obj/item/weapon/reagent_containers/food/snacks/superbiteburger/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 25)


/obj/item/weapon/reagent_containers/food/snacks/human/burger //Why must this exist?
	name = "-burger"
	desc = "A bloody burger."
	icon_state = "hburger"
	center_of_mass = "x=16;y=11"

/obj/item/weapon/reagent_containers/food/snacks/human/burger/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 6)


/obj/item/weapon/reagent_containers/food/snacks/bigbiteburger
	name = "Big Bite Burger"
	desc = "Forget the Big Mac. THIS is the future!"
	icon_state = "bigbiteburger"
	filling_color = "#e3d681"
	center_of_mass = "x=16;y=11"
	nutriment_desc = list("buns" = 4)
	nutriment_amt = 4
	bitesize = 3

/obj/item/weapon/reagent_containers/food/snacks/bigbiteburger/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/nutriment/protein, 10)


/obj/item/weapon/reagent_containers/food/snacks/spellburger
	name = "Spell Burger"
	desc = "This is absolutely Ei Nath."
	icon_state = "spellburger"
	filling_color = "#d505ff"
	nutriment_desc = list("magic" = 3, "buns" = 3)
	nutriment_amt = 6
