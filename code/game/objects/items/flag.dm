/obj/item/flag
	icon = 'icons/obj/flag.dmi'
	w_class = 4.0
	var/lit = 0
	var/burntime = 30

/obj/item/flag/fire_act(null, temperature, volume)
	if(!lit)
		Ignite()
		return

/obj/item/flag/proc/Ignite()
	if(lit) return
	lit = 1
	update_icons()
	processing_objects.Add(src)

/obj/item/flag/process()
	burntime--
	if(burntime < 1)
		processing_objects.Remove(src)
		if(istype(src.loc,/turf))
			new /obj/effect/decal/cleanable/ash(src.loc)
			new /obj/item/stack/rods(src.loc)
			del(src)
			return
		if(istype(src.loc,/mob/living/carbon))
			var/mob/living/carbon/C = src.loc
			var/turf/location = get_turf(C)
			new /obj/effect/decal/cleanable/ash(location)
			new /obj/item/stack/rods(location)
			del(src)
			return
		else
			del(src)
			return

/obj/item/flag/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/weapon/weldingtool))
		var/obj/item/weapon/weldingtool/WT = W
		if(WT.isOn())//Badasses dont get blinded while lighting their cig with a welding tool
			light("<span class='notice'>[user] casually lights the [name] with [W], what a badass.</span>")

	else if(istype(W, /obj/item/weapon/lighter/zippo))
		var/obj/item/weapon/lighter/zippo/Z = W
		if(Z.lit)
			light("<span class='rose'>With a single flick of their wrist, [user] smoothly lights the [name] with their [W]. Damn they're cool.</span>")

	else if(istype(W, /obj/item/weapon/lighter))
		var/obj/item/weapon/lighter/L = W
		if(L.lit)
			light("<span class='notice'>After some fiddling, [user] manages to light the [name] with [W].</span>")

	else if(istype(W, /obj/item/weapon/match))
		var/obj/item/weapon/match/M = W
		if(M.lit)
			light("<span class='notice'>[user] lights the [name] with their [W].</span>")

	else if(istype(W, /obj/item/weapon/melee/energy/sword))
		var/obj/item/weapon/melee/energy/sword/S = W
		if(S.active)
			light("<span class='warning'>[user] swings their [W], barely missing their nose. They light the [name] in the process.</span>")

	else if(istype(W, /obj/item/device/assembly/igniter))
		light("<span class='notice'>[user] fiddles with [W], and manages to light the [name].</span>")

/obj/item/flag/proc/light(var/flavor_text = "[usr] lights the [name].")
	if(!src.lit)
		src.lit = 1
		var/turf/T = get_turf(src)
		T.visible_message(flavor_text)
		update_icons()
		processing_objects.Add(src)

/obj/item/flag/proc/update_icons()
	overlays = null
	overlays += image('icons/obj/flag.dmi', src , "fire")
	item_state = "[icon_state]_fire"

/obj/item/flag/nt
	name = "Nanotrasen flag"
	desc = "A flag proudly boasting the logo of NT."
	icon_state = "ntflag"

/obj/item/flag/grey
	name = "Greytide flag"
	desc = "A banner made from an old grey jumpsuit."
	icon_state = "greyflag"

/obj/item/flag/clown
	name = "Clown Planet flag"
	desc = "The banner of His Majesty, King Squiggles the Eighth."
	icon_state = "clownflag"

/obj/item/flag/mime
	name = "Mime Revolution flag"
	desc = "The banner of the glorious revolutionary forces fighting the oppressors on Clown Planet."
	icon_state = "mimeflag"

/obj/item/flag/syndi
	name = "Syndicate flag"
	desc = "A flag proudly boasting the logo of the Syndicate, in defiance of NT."
	icon_state = "syndiflag"

/obj/item/flag/ninja
	name = "Spider Clan flag"
	desc = "A flag proudly boasting the logo of the Spider Clan, in defiance of NT."
	icon_state = "ninjaflag"

/obj/item/flag/wiz
	name = "Wizard Federation flag"
	desc = "A flag proudly boasting the logo of the Wizard Federation, sworn enemies of NT."
	icon_state = "wizflag"

/obj/item/flag/pony
	name = "Equestria flag"
	desc = "The flag of the independant, sovereign nation of Equestria, whatever the fuck that is."
	icon_state = "ponyflag"


//Species flags

/obj/item/flag/slime
	name = "Slime People flag"
	desc = "A flag proudly proclaiming the superior heritage of Slime People."
	icon_state = "slimeflag"

/obj/item/flag/skrell
	name = "Skrell flag"
	desc = "A flag proudly proclaiming the superior heritage of Skrell."
	icon_state = "skrellflag"

/obj/item/flag/vox
	name = "Vox flag"
	desc = "A flag proudly proclaiming the superior heritage of Vox."
	icon_state = "voxflag"


//Nations/Department flags

/obj/item/flag/nation/cargo
	name = "Cargonia flag"
	desc = "The flag of the independant, sovereign nation of Cargonia."
	icon_state = "cargoflag"

/obj/item/flag/nation/med
	name = "Medistan flag"
	desc = "The flag of the independant, sovereign nation of Medistan."
	icon_state = "medflag"

/obj/item/flag/nation/sec
	name = "Brigston flag"
	desc = "The flag of the independant, sovereign nation of Brigston."
	icon_state = "secflag"

/obj/item/flag/nation/rnd
	name = "Scientopia flag"
	desc = "The flag of the independant, sovereign nation of Scientopia."
	icon_state = "rndflag"

/obj/item/flag/nation/atmos
	name = "Atmosia flag"
	desc = "The flag of the independant, sovereign nation of Atmosia."
	icon_state = "atmosflag"