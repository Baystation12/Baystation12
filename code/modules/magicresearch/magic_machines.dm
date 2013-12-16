/obj/machinery/magic
	icon = 'icons/obj/cult.dmi'
	anchored = 1
	density = 1

/obj/machinery/magic/proc/createresidue(var/increase_amount = 0)
	var/area/A = src.loc
	A = A.loc
	if (!( istype(A, /area) ))
		return
	A.increaseresidue(increase_amount)

/obj/machinery/magic/proc/destroyresidue(var/decrease_amount = 0)
	var/area/A = src.loc
	A = A.loc
	if (!( istype(A, /area) ))
		return
	A.decreaseresidue(decrease_amount)
	if(A.decreaseresidue())
		return 1

/obj/machinery/magic/writingaltar
	icon_state = "tomealtar"
	name = "Writing Table"
	desc = "A table for writing."
	var/list/nondiscoveredtheroies = list()
	var/list/discoveredtheroies = list()
	var/discovering = 0

/obj/machinery/magic/writingaltar/New()
	..()
	nondiscoveredtheroies = list(typesof(/obj/item/magic_research/theory))

/obj/machinery/magic/writingaltar/attackby(obj/item/W as obj, mob/living/user as mob)
	if(istype(W, /obj/item/weapon/paper))
		if(nondiscoveredtheroies && !discovering)
			user << "You set the paper down on the table, and odd symbols start being scribbled down on it by an unseen force."
			del(W)
			discovering = 1
			sleep(300)
			var/createdtheory = pick(typesof(/obj/item/magic_research/theory))
			new createdtheory(src.loc)
			discoveredtheroies.Add(createdtheory)
			playsound(src.loc, 'sound/machines/ding.ogg', 75, 0)
			createresidue(5)
			discovering = 0
			return
		else
			user << "You have discovered all known theroies."

/obj/machinery/magic/forge
	icon_state = "forge"
	name = "Magical Forge"
	desc = "A forge powered by magic."
	var/constructlearned
	var/soulstonelearned
/obj/machinery/magic/forge/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/weapon/shard))
		if(soulstonelearned)
			del(W)
			new /obj/item/device/soulstone(src.loc)
			createresidue(5)
			user << "You fashion a soul stone out of the metal."
	if(istype(W, /obj/item/stack/sheet/metal))
		if(constructlearned)
			del(W)
			new /obj/structure/constructshell(src.loc)
			createresidue(5)
			user << "You fashion a construct shell out of the metal."
	if(istype(W, /obj/item/magic_research/theory))
		if(istype(W, /obj/item/magic_research/theory/construct) && !constructlearned)
			if(W:discovered)
				constructlearned = 1
				del(W)
				user << "You teach the forge how to create construct shells."
		if(istype(W, /obj/item/magic_research/theory/soulstone) && !soulstonelearned)
			if(W:discovered)
				soulstonelearned = 1
				del(W)
				user << "You teach the forge how to create soul stones."

/obj/machinery/magic/itemaltar
	icon_state = "itemaltar"
	name = "Item Altar"
	desc = "An altar for creating magical items."
	var/magicwandlearned
	var/swearrodlearned
/obj/machinery/magic/itemaltar/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/stack/sheet/wood))
		if(magicwandlearned)
			del(W)
			new /obj/item/magic_research/magic_wand(src.loc)
			user << "You fashion the wood into a wand, and enchant it."
			createresidue(5)
	if(istype(W, /obj/item/stack/rods))
		if(swearrodlearned)
			del(W)
			new /obj/item/magic_research/swearrod(src.loc)
			user << "You enchant the rod with mystic powers, creating a swearing rod."
			createresidue(5)
	if(istype(W, /obj/item/magic_research/theory/swearrod))
		if(W:discovered)
			del(W)
			user << "You use the theroy to teach the altar how to create a swearing rod."
			swearrodlearned = 1
	if(istype(W, /obj/item/magic_research/theory/magic_wand))
		if(W:discovered)
			del(W)
			user << "You use the theroy to teach the altar how to create a magic wand."
			magicwandlearned = 1

/obj/machinery/magic/portalaltar
	icon_state = "portalaltar"
	name = "Portal Altar"
	desc = "A portal to another realm with scribes capable of translating the incomprehensible gibberish created by your research."
/obj/machinery/magic/portalaltar/attackby(obj/item/magic_research/theory/W as obj, mob/user as mob)
	if(istype(W, /obj/item/magic_research/theory))
		W.loc = src.loc
		W.icon_state = ""
		user << "You stuff the scroll through the portal, for translation."
		sleep(300)
		user << "The scroll pops back through, labeled as a '[W:scrollname]'"
		W.discovered = 1
		W.icon_state = "scroll"
		playsound(src.loc, 'sound/machines/ding.ogg', 75, 0)
		createresidue(10)
		W.loc = src.loc

/obj/machinery/magic/potteryaltar
	icon_state = "potteryaltar"
	name = "Pottery Altar"
	desc = "An altar for making magic infused pottery."
/obj/machinery/magic/potteryaltar/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/stack/sheet/mineral/sandstone))
		user << "You fashion the sandstone into a perfect sphere."
		del(W)
		new /obj/item/magic_research/stone(src.loc)
/obj/machinery/magic/cleanser
	icon_state = "areacleanser"
	name = "Residue Cleanser"
	desc = "A magical device capable of being dragged around to remove residue in areas."
	var/residueabsorbed = 0
	anchored = 0

/obj/machinery/magic/cleanser/process()
	destroyresidue(1)
	if(destroyresidue())
		residueabsorbed++
	if(residueabsorbed == 10)
		new /obj/item/magic_research/canister/residue(src.loc)
		residueabsorbed = 0