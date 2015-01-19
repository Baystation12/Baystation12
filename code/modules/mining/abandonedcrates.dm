/obj/structure/closet/crate/secure/loot
	name = "abandoned crate"
	desc = "What could be inside?"
	icon_state = "securecrate"
	icon_opened = "securecrateopen"
	icon_closed = "securecrate"
	var/code = null
	var/lastattempt = null
	var/attempts = 10
	var/codelen = 4
	locked = 1

/obj/structure/closet/crate/secure/loot/New()
	..()
	var/list/digits = list("1", "2", "3", "4", "5", "6", "7", "8", "9", "0")
	
	code = ""
	for(var/i = 0, i < codelen, i++)
		var/dig = pick(digits)
		code += dig
		digits -= dig  // Player can enter codes with matching digits, but there are never matching digits in the answer
	
	var/loot = rand(1, 13)
	switch(loot)
		if(1)
			new/obj/item/weapon/reagent_containers/food/drinks/bottle/rum(src)
			new/obj/item/weapon/reagent_containers/food/snacks/grown/ambrosiadeus(src)
			new/obj/item/weapon/reagent_containers/food/drinks/bottle/whiskey(src)
			new/obj/item/weapon/flame/lighter/zippo(src)
		if(2)
			new/obj/item/weapon/pickaxe/drill(src)
			new/obj/item/device/taperecorder(src)
			new/obj/item/clothing/suit/space(src)
			new/obj/item/clothing/head/helmet/space(src)
		if(3)
			new/obj/item/weapon/reagent_containers/glass/beaker/bluespace(src)
		if(4 to 5)
			for(var/i = 0, i < 10, i++)
				new/obj/item/weapon/ore/diamond(src)
		if(6)
			for(var/i = 0, i < 3, i++)
				new/obj/machinery/portable_atmospherics/hydroponics(src)
		if(7)
			for(var/i = 0, i < 3, i++)
				new/obj/item/weapon/reagent_containers/glass/beaker/noreact(src)
		if(8 to 10)
			new/obj/item/weapon/melee/classic_baton(src)
		if(11)
			new/obj/item/clothing/under/chameleon(src)
			for(var/i = 0, i < 7, i++)
				new/obj/item/clothing/tie/horrible(src)
		if(12)
			new/obj/item/clothing/under/shorts(src)
			new/obj/item/clothing/under/shorts/red(src)
			new/obj/item/clothing/under/shorts/blue(src)
		if(13)
			new/obj/item/weapon/melee/baton(src)

/obj/structure/closet/crate/secure/loot/togglelock(mob/user as mob)
	if(locked)
		user << "<span class='notice'>The crate is locked with a Deca-code lock.</span>"
		var/input = input(usr, "Enter [codelen] digits.", "Deca-Code Lock", "") as text
		if(in_range(src, user))
			if (input == code)
				user << "<span class='notice'>The crate unlocks!</span>"
				locked = 0
				overlays.Cut()
				overlays += greenlight
			else if (input == null || length(input) != codelen)
				user << "<span class='notice'>You leave the crate alone.</span>"
			else
				user << "<span class='warning'>A red light flashes.</span>"
				lastattempt = input
				attempts--
				if (attempts == 0)
					user << "<span class='danger'>The crate's anti-tamper system activates!</span>"
					var/turf/T = get_turf(src.loc)
					explosion(T, 0, 0, 0, 1)
					del(src)
					return
		else
			user << "<span class='notice'>You attempt to interact with the device using a hand gesture, but it appears this crate is from before the DECANECT came out.</span>"
			return
	else
		return ..()

/obj/structure/closet/crate/secure/loot/attackby(obj/item/weapon/W as obj, mob/user as mob)
	if(locked)
		if (istype(W, /obj/item/weapon/card/emag))
			user << "<span class='notice'>The crate unlocks!</span>"
			locked = 0
		if (istype(W, /obj/item/device/multitool)) // Greetings Urist McProfessor, how about a nice game of cows and bulls?
			user << "<span class='notice'>DECA-CODE LOCK REPORT:</span>"
			if (attempts == 1)
				user << "<span class='warning'>* Anti-Tamper Bomb will activate on next failed access attempt.</span>"
			else
				user << "<span class='notice'>* Anti-Tamper Bomb will activate after [src.attempts] failed access attempts.</span>"
			if (lastattempt != null)
				var/list/guess = list()
				var/bulls = 0
				var/cows = 0
				for(var/i = 1, i < codelen + 1, i++)
					var/a = copytext(lastattempt, i, i+1) // Stuff the code into the list
					guess += a
					guess[a] = i
				for(var/i in guess) // Go through list and count matches
					var/a = findtext(code, i)
					if(a == guess[i])
						++bulls
					else if(a)
						++cows
				user << "<span class='notice'>Last code attempt had [bulls] correct digits at correct positions and [cows] correct digits at incorrect positions.</span>"
		else ..()
	else ..()
