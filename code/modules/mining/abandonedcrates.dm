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

	var/loot = rand(1, 100)
	switch(loot)
		if(1 to 5) // Common things go, 5%
			new/obj/item/weapon/reagent_containers/food/drinks/bottle/rum(src)
			new/obj/item/weapon/reagent_containers/food/drinks/bottle/whiskey(src)
			new/obj/item/weapon/reagent_containers/food/snacks/grown/ambrosiadeus(src)
			new/obj/item/weapon/flame/lighter/zippo(src)
		if(6 to 10)
			new/obj/item/weapon/pickaxe/drill(src)
			new/obj/item/device/taperecorder(src)
			new/obj/item/clothing/suit/space(src)
			new/obj/item/clothing/head/helmet/space(src)
		if(11 to 15)
			new/obj/item/weapon/reagent_containers/glass/beaker/bluespace(src)
		if(16 to 20)
			for(var/i = 0, i < 10, i++)
				new/obj/item/weapon/ore/diamond(src)
		if(21 to 25)
			for(var/i = 0, i < 3, i++)
				new/obj/machinery/portable_atmospherics/hydroponics(src)
		if(26 to 30)
			for(var/i = 0, i < 3, i++)
				new/obj/item/weapon/reagent_containers/glass/beaker/noreact(src)
		if(31 to 35)
			spawn_money(rand(300,800), src)
		if(36 to 40)
			new/obj/item/weapon/melee/baton(src)
		if(41 to 45)
			new/obj/item/clothing/under/shorts/red(src)
			new/obj/item/clothing/under/shorts/blue(src)
		if(46 to 50)
			new/obj/item/clothing/under/chameleon(src)
			for(var/i = 0, i < 7, i++)
				new/obj/item/clothing/accessory/horrible(src)
		if(51 to 52) // Uncommon, 2% each
			new/obj/item/weapon/melee/classic_baton(src)
		if(53 to 54)
			new/obj/item/latexballon(src)
		if(55 to 56)
			var/newitem = pick(typesof(/obj/item/toy/prize) - /obj/item/toy/prize)
			new newitem(src)
		if(57 to 58)
			new/obj/item/toy/syndicateballoon(src)
		if(59 to 60)
			new/obj/item/weapon/rig(src)
		if(61 to 62)
			for(var/i = 0, i < 12, ++i)
				new/obj/item/clothing/head/kitty(src)
		if(63 to 64)
			var/t = rand(4,7)
			for(var/i = 0, i < t, ++i)
				var/newcoin = pick(/obj/item/weapon/coin/silver, /obj/item/weapon/coin/silver, /obj/item/weapon/coin/silver, /obj/item/weapon/coin/iron, /obj/item/weapon/coin/iron, /obj/item/weapon/coin/iron, /obj/item/weapon/coin/gold, /obj/item/weapon/coin/diamond, /obj/item/weapon/coin/phoron, /obj/item/weapon/coin/uranium, /obj/item/weapon/coin/platinum)
				new newcoin(src)
		if(65 to 66)
			new/obj/item/clothing/suit/ianshirt(src)
		if(67 to 68)
			var/t = rand(4,7)
			for(var/i = 0, i < t, ++i)
				var/newitem = pick(typesof(/obj/item/weapon/stock_parts) - /obj/item/weapon/stock_parts - /obj/item/weapon/stock_parts/subspace)
				new newitem(src)
		if(69 to 70)
			new/obj/item/weapon/pickaxe/silver(src)
		if(71 to 72)
			new/obj/item/weapon/pickaxe/drill(src)
		if(73 to 74)
			new/obj/item/weapon/pickaxe/jackhammer(src)
		if(75 to 76)
			new/obj/item/weapon/pickaxe/diamond(src)
		if(77 to 78)
			new/obj/item/weapon/pickaxe/diamonddrill(src)
		if(79 to 80)
			new/obj/item/weapon/pickaxe/gold(src)
		if(81 to 82)
			new/obj/item/weapon/pickaxe/plasmacutter(src)
		if(83 to 84)
			new/obj/item/toy/katana(src)
		if(85 to 86)
			new/obj/item/seeds/random(src)
		if(87) // Rarest things, some are unobtainble otherwise, some are just robust,  1% each
			new/obj/item/weed_extract(src)
		if(88)
			new/obj/item/xenos_claw(src)
		if(89)
			new/obj/item/organ/xenos/plasmavessel(src)
		if(90)
			new/obj/item/organ/heart(src)
		if(91)
			new/obj/item/device/soulstone(src)
		if(92)
			new/obj/item/weapon/katana(src)
		if(93)
			new/obj/item/weapon/dnainjector/xraymut(src) // Probably the least OP
		if(94) // Why the hell not
			new/obj/item/weapon/storage/backpack/clown(src)
			new/obj/item/clothing/under/rank/clown(src)
			new/obj/item/clothing/shoes/clown_shoes(src)
			new/obj/item/device/pda/clown(src)
			new/obj/item/clothing/mask/gas/clown_hat(src)
			new/obj/item/weapon/bikehorn(src)
			//new/obj/item/weapon/stamp/clown(src) I'd add it, but only clowns can use it
			new/obj/item/toy/crayon/rainbow(src)
			new/obj/item/toy/waterflower(src)
		if(95)
			new/obj/item/clothing/under/mime(src)
			new/obj/item/clothing/shoes/black(src)
			new/obj/item/device/pda/mime(src)
			new/obj/item/clothing/gloves/white(src)
			new/obj/item/clothing/mask/gas/mime(src)
			new/obj/item/clothing/head/beret(src)
			new/obj/item/clothing/suit/suspenders(src)
			new/obj/item/toy/crayon/mime(src)
			new/obj/item/weapon/reagent_containers/food/drinks/bottle/bottleofnothing(src)
		if(96)
			new/obj/item/weapon/vampiric(src)
		if(97)
			new/obj/item/weapon/archaeological_find(src)
		if(98)
			new/obj/item/weapon/melee/energy/sword(src)
		if(99)
			new/obj/item/weapon/storage/belt/champion(src)
			new/obj/item/clothing/mask/luchador(src)
		if(100)
			new/obj/item/clothing/head/bearpelt(src)

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
