//////////////////////////////////////////
//          Thank you Urist <3          //
//////////////////////////////////////////

//All of the scissor stuff
/obj/item/weapon/scissors
	name = "scissors"
	desc = "Those are scissors. Don't run with them!"
	icon = 'icons/moraak/items/improvised.dmi'
	icon_state = "scissor"
	item_state = "scissor"
	force = 5
	sharp = 1
	edge = 1
	w_class = 2
	matter = list("metal" = 12000)
	origin_tech = "materials=1"
	attack_verb = list("slices", "cuts", "stabs", "jabs")

	suicide_act(mob/user)
		viewers(user) << pick("\red <b>[user] is slitting \his wrists with the [src]! It looks like \he's trying to commit suicide.</b>", \
							"\red <b>[user] is slitting \his throat with the [src]! It looks like \he's trying to commit suicide.</b>")
		return (BRUTELOSS)

/obj/item/weapon/scissors/attackby(var/obj/item/I, mob/user as mob) //Seperation of the scissors
	if(istype(I, /obj/item/weapon/screwdriver))

		var/obj/item/weapon/improvised/scissorknife/N = new /obj/item/weapon/improvised/scissorknife
		var/obj/item/weapon/improvised/scissorknife/N2 = new /obj/item/weapon/improvised/scissorknife

		user.before_take_item(src)

		user.put_in_hands(N)
		user.put_in_hands(N2)
		user << "<span class='notice'>You seperate the parts of the [src]</span>"

		del(src)
	..()

/obj/item/weapon/scissors/assembly //So you can put it together!
	name = "scissor Assembly"
	desc = "Two parts of a scissor loosely combined"
	force = 3

/obj/item/weapon/scissors/assembly/attackby(var/obj/item/I, mob/user as mob) //Putting it together
	if(istype(I, /obj/item/weapon/screwdriver))

		var/obj/item/weapon/scissors/N = new /obj/item/weapon/scissors

		user.before_take_item(src)

		user.put_in_hands(N)
		user << "<span class='notice'>You tighten the screw on the screwdriver assembley</span>"

		del(src)
	..()

//Papercrafts definition
/obj/item/weapon/papercrafts
	w_class = 1
	icon = 'icons/moraak/items/papercrafts.dmi'

/obj/item/weapon/papercrafts/proc/fold(var/obj/item/weapon/papercrafts/N, var/foldText, mob/user as mob) //So i don't have to write this over and over again
	user.before_take_item(src)
	user.put_in_hands(N)
	user << foldText
	del(src)
	return

/obj/item/weapon/papercrafts/square
	name = "paper square"
	icon_state = "paperSquare"
	item_state = "paper"

//What happens on a paper square
/obj/item/weapon/papercrafts/square/attack_self(mob/user as mob)
	var/want = input("Choose what you want to make", "Your Choice", "Cancel") in list ("Cancel", "Paper Swan", "Paper Plane", "Paper Box", "Paper Shuriken", "Paper Mask", "Paper Flower")
	switch(want)
		if("Cancel")
			return
		if("Paper Swan")
			var/obj/item/weapon/papercrafts/oragami/swan/N = new /obj/item/weapon/papercrafts/oragami/swan
			fold(N, "<span class='alert'>You fold the square into a swan.</span>", user)
		if("Paper Plane")
			var/obj/item/weapon/papercrafts/airplane/N = new /obj/item/weapon/papercrafts/airplane
			fold(N, "<span class='alert'>You fold the square into a paper airplane</span>", user)
		if("Paper Box")
			var/obj/item/weapon/storage/box/papercrafts/N = new /obj/item/weapon/storage/box/papercrafts
			fold(N, "<span class='alert'>You fold the square into a box</span>", user)
		if("Paper Shuriken")
			var/obj/item/weapon/papercrafts/oragami/shuriken/N = new /obj/item/weapon/papercrafts/oragami/shuriken
			fold(N, "<span class='alert'>You fold the square into a shuriken</span>", user)
		if("Paper Flower")
			var/obj/item/clothing/mask/flower/N = new /obj/item/clothing/mask/flower
			fold(N, "<span class='alert'>You fold the paper into a flower</span>", user)
		else
			return

//Oragami
/obj/item/weapon/papercrafts/oragami
	name = "Oragami"
	desc = "A Piece of Oragami"
	var/has_animate = 0 //If the thing has animations
	var/animated_state = "" //The animated icon to display to the person
	var/animated_message = "" //The animated message to display to the person

//Helper
/obj/item/weapon/papercrafts/oragami/attack_self(mob/user as mob)

	if(!ishuman(user)) //I don't want dogs or monkeys using the oragami
		return

	if(has_animate == 1) //If it has an animation
		flick(animated_state, src)  // I JUST FOUND THIS PROC AND I AM HAPPY !!!!1!!!
		playsound(src.loc, 'sound/effects/pageturn2.ogg', 50, 1) //Plays the paper shuffling sound
		user << animated_message //Send the animated message
	else
		return

//Paper Swan...
/obj/item/weapon/papercrafts/oragami/swan
	name = "paper swan"
	desc = "An origami Swan."
	icon_state = "swan"
	item_state = "swan"
	has_animate = 1
	animated_state = "swan_move"
	animated_message = "You pull the swan's head, moving the wings."

//Paper Airplane
/obj/item/weapon/papercrafts/airplane
	name = "paper airplane"
	desc = "A paper airplane. Don't poke people's eyes out!"
	icon_state = "airplane"
	item_state = "airplane"
	force = 1 //It's made to be more annoying than anything
	throwforce = 2
	throw_speed = 1 //Makes a nice slow movement
	throw_range = 15 //Airplanes go a decent distance

//Paper Shuriken
/obj/item/weapon/papercrafts/oragami/shuriken
	name = "paper shuriken"
	desc = "A Paper Shuriken."
	icon_state = "shuriken"
	item_state = "paper"
	force = 1
	throwforce = 5
	throw_speed = 2
	throw_range = 5

//Paper Box
/obj/item/weapon/storage/box/papercrafts
	name = "paper box"
	desc = "A paper box. Store stuff in it!"
	icon_state = "box"
	foldable = /obj/item/weapon/papercrafts/square //Turns into a square paper when unfolded

//What happens on paper
/obj/item/weapon/paper/attackby(var/obj/item/I, mob/user as mob)
	if(istype(I, /obj/item/weapon/scissors))
		var/want = input("Choose what you want to make", "Your Choice", "Cancel") in list ("Cancel", "Paper Square", "Paper Hat")
		switch(want)
			if("Cancel")
				return
			if("Paper Square")
				var/obj/item/weapon/papercrafts/square/S = new /obj/item/weapon/papercrafts/square
				user.before_take_item(src)
				user.put_in_hands(S)
				user << "<span class='notice'>You trim the paper into a square</span>"
				del(src)
			if("Paper Hat")
				var/obj/item/clothing/head/papercrown/C = new /obj/item/clothing/head/papercrown
				user.before_take_item(src)
				user.put_in_hands(C)
				user << "<span class='notice'>You make a paper hat fit for a king!</span>"
				del(src)
			else
				return
	..()