/obj/item/device/assembly/explosive
	name = "explosive"
	desc = "An explosive! You can almost hear a faint ticking sound.."
	w_class = 2.0
	icon = 'icons/obj/assemblies/new_assemblies.dmi'
	icon_state = "explosive"
	item_state = "grenade"
	throw_speed = 4
	throw_range = 20
	flags = CONDUCT
	slot_flags = SLOT_BELT
	dangerous = 1
	var/used = 0
	var/power = 1
	var/modifying = 0
	var/list/modified_contents = list()
	holder_attackby = list(/obj/item/weapon/screwdriver)

	wires = null // Simply an explosive. Has no circuitry whatsoever.
	wire_num = 0

/obj/item/device/assembly/explosive/igniter_act()
	boom()

/obj/item/device/assembly/explosive/activate()
	return 1

/obj/item/device/assembly/explosive/proc/prime()
	boom()

/obj/item/device/assembly/explosive/proc/boom() // Dependent on other assemblies entirely.
	if(used) return // Might be used for re-usable bombs?
	if(modifying) return
	playsound(loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)
	var/turf/T = get_turf(src)
	if(T)
		T.hotspot_expose(min(power * 700, 1000), power * 125)
	qdel(src)
/*
/obj/item/device/assembly/explosive/attackby(obj/item/O as obj, mob/user as mob)
	..()
	if(istype(O, /obj/item/weapon/screwdriver))
		if(!modifying)
			var/inp = input("Are you sure you want to begin modifying \the [src]?", "Modification") in list("Yes", "No")
			if(inp == "Yes")
				modifying = 1
			else
				..(O, user)
		else
			var/inp = input("Are you sure you're done modifying \the [src]?", "Modification") in list("Yes", "No")
			if(inp == "Yes") // TODO: Make modular. It's hideous.
				var/strong_explosive_matches = 0
				var/emp_explosive_matches = 0
				var/flash_explosive_matches = 0
				var/bomb_explosive_matches = 0
				var/scatter_explosive_matches = 0
				for(var/i=1,i<=modified_contents.len,i++)
					if(modified_contents[i] == "Plasteel")
						strong_explosive_matches++
					if(modified_contents[i] == "Cable")
						strong_explosive_matches++
						emp_explosive_matches++
						bomb_explosive_matches++
						scatter_explosive_matches++
					if(modified_contents[i] == "Phoron")
						strong_explosive_matches++
					if(modified_contents[i] == "Glass")
						emp_explosive_matches++
						flash_explosive_matches++
					if(modified_contents[i] == "Light")
						flash_explosive_matches++
					if(modified_contents[i] == "Power")
						emp_explosive_matches++
						strong_explosive_matches++
					if(modified_contents[i] == "Cell")
						emp_explosive_matches++
						strong_explosive_matches++
						flash_explosive_matches++
						bomb_explosive_matches++
						scatter_explosive_matches++
				if(strong_explosive_matches == 5)
					var/inp2 = input("Would you like to make a stronger explosive?", "Explosive") in list("Yes", "No")
					if(inp2 == "Yes")
						var/obj/item/device/assembly/explosive/strong/E = new(src.loc)
						user.remove_from_mob(src)
						E.forceMove(get_turf(src))
						qdel(src)
						return
				if(emp_explosive_matches == 4)
					var/inp2 = input("Would you like to make an emp explosive?", "Explosive") in list("Yes", "No")
					if(inp2 == "Yes")
						var/obj/item/device/assembly/explosive/emexplosive/E = new(get_turf(src))
						user.remove_from_mob(src)
						E.forceMove(get_turf(src))
						qdel(src)
						return
				if(flash_explosive_matches == 3)
					var/inp2 = input("Would you like to make a flash explosive?", "Explosive") in list("Yes", "No")
					if(inp2 == "Yes")
						var/obj/item/device/assembly/explosive/flash/E = new(src.loc)
						user.remove_from_mob(src)
						E.forceMove(get_turf(src))
						qdel(src)
						return
				if(bomb_explosive_matches == 2)
					var/inp2 = input("Would you like to make a standard explosive?", "Explosive") in list("Yes", "No")
					if(inp2 == "Yes")
						var/obj/item/device/assembly/explosive/bomb/E = new(src.loc)
						user.remove_from_mob(src)
						E.forceMove(get_turf(src))
						qdel(src)
						return
				if(scatter_explosive_matches == 2)
					var/inp2 = input("Would you like to make a scatter explosive?", "Explosive") in list("Yes", "No")
					if(inp2 == "Yes")
						var/obj/item/device/assembly/explosive/bomb/scatter/E = new()
						user.remove_from_mob(src)
						E.forceMove(get_turf(src))
						qdel(src)
						return
				else
					user << "<span class='warning'>You are unable to make that explosive! Add more components!</span>"
					return
	if(modifying)
		if(istype(O, /obj/item/stack/material/plasteel) && !("Plasteel" in modified_contents))
			var/obj/item/stack/material/plasteel/sheet = O
			if(sheet.amount < 8)
				user << "<span class='notice'>You need atleast 8 sheets to do that!</span>"
				return
			user.visible_message("<span class='warning'>\The [user] begins reinforcing \the [src]..</span>", "<span class='notice'>You begin reinforcing \the [src]!</span>")
			if(!do_after(user, 50)) return
			user << "<span class='notice'>You reinforce \the [src]!</span>"
			sheet.use(8)
			modified_contents.Add("Plasteel")
		if(istype(O, /obj/item/stack/material/phoron) && !("Phoron" in modified_contents))
			var/obj/item/stack/material/phoron/sheet = O
			if(sheet.amount < 10)
				user << "<span class='notice'>You need atleast 10 sheets to do that!</span>"
				return
			user.visible_message("<span class='warning'>\The [user] begins inserting \the [O] into \the [src]!</span>", "<span class='notice'>You begin wiring \the [O] to the explosive mechanism..</span>")
			if(!do_after(user, 50)) return
			user << "<span class='notice'>You insert \the [O] into \the [src]!</span>"
			sheet.use(10)
			modified_contents.Add("Phoron")
		if(istype(O, /obj/item/stack/cable_coil) && !("Cable" in modified_contents))
			var/obj/item/stack/cable_coil/C = O
			if(C.amount < 6)
				user << "<span class='notice'>You need atleast 8 units of cable to do that!</span>"
				return
			user.visible_message("<span class='warning'>\The [user] begins to wire \the [src]!</span>", "<span class='notice'>You begin wiring up the explosive mechanism..</span>")
			if(!do_after(user, 60)) return
			user << "<span class='notice'>You wire up the explosive mechanism in \the [src]!</span>"
			C.use(6)
			modified_contents.Add("Cable")
		if(istype(O, /obj/item/stack/material/glass) && !("Glass" in modified_contents))
			var/obj/item/stack/material/glass/sheet = O
			if(sheet.amount < 15)
				user << "<span class='notice'>You need atleast 15 sheets to do that!</span>"
				return
			user.visible_message("<span class='warning'>\The [user] begins placing some glass in \the [src]</span>", "<span class='notice'>You begin placing some glass in the explosive mechanism..</span>")
			if(!do_after(user, 45)) return
			user << "<span clas='notice'>You add some glass to the explosive mechanism!</span>"
			sheet.use(15)
			modified_contents.Add("Glass")
		if(istype(O, /obj/item/weapon/light/bulb) && !("Light" in modified_contents))
			user.visible_message("<span class='warning'>\The [user] begins attaching \the [O] to \the [src]..</span>", "<span class='notice'>You begin attaching a light to the explosive mechanism in \the [src]!</span>")
			if(!do_after(user, 50)) return
			user << "<span class='notice'>You wire the light to \the [src]!</span>"
			user.drop_item()
			qdel(O)
			modified_contents.Add("Light")
		if(istype(O, /obj/item/weapon/module/power_control) && !("Power" in modified_contents))
			user.visible_message("<span class='warning'>\The [user] begins attaching \the [O] to \the [src]!</span>", "<span class='notice'>You begin attaching a power control module to \the [src]!</span>")
			if(!do_after(user, 80)) return
			user << "<span class='notice'>You wire the power module to \the [src]!</span>"
			user.drop_item()
			qdel(O)
			modified_contents.Add("Power")
		if(istype(O, /obj/item/weapon/cell) && !("Cell" in modified_contents))
			user.visible_message("<span class='warning'>\The [user] begins attaching \the [O] to \the [src]!</span>" , "<span class='notice'>You begin to attach the power cell to \the [src]..</span>")
			if(!do_after(user, 120)) return
			user << "<span class='notice'>You attach the power cell to \the [src]!</span>"
			user.drop_item()
			qdel(O)
			modified_contents.Add("Cell")
*/
/obj/item/device/assembly/explosive/bomb
	name = "bomb"
	desc = "A self-igniting explosive."
	icon_state = "bomb"
	wires = WIRE_DIRECT_RECEIVE | WIRE_PROCESS_RECEIVE | WIRE_PROCESS_ACTIVATE
	wire_num = 3

/obj/item/device/assembly/explosive/bomb/activate()
	prime()
	return 1

/obj/item/device/assembly/explosive/bomb/boom()
	if(used) return
	if(modifying) return
	playsound(loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)
	var/turf/T = get_turf(src)
	if(T)
		explosion(T, 0, 1, (rand(3,4)*power), 7)
	used = 1

/obj/item/device/assembly/explosive/bomb/scatter
	name = "scatter bomb"
	desc = "A self-igniting explosive that spreads itself across a large range."
	wires = WIRE_DIRECT_RECEIVE | WIRE_PROCESS_RECEIVE | WIRE_PROCESS_ACTIVATE

/obj/item/device/assembly/explosive/bomb/scatter/boom()
	if(used) return
	if(modifying) return
	playsound(loc, 'sound/weapons/armbomb.ogg', 75, 1, -3)
	var/turf/T = get_turf(src)
	if(T)
		explosion(T, 0, 0, (rand(5,12)*power), 7)
	used = 1

/obj/item/device/assembly/explosive/anti_photon
	desc = "An experimental device for temporarily removing light in a limited area."
	name = "photon disruption explosive"

/obj/item/device/assembly/explosive/anti_photon/boom()
	if(!draw_power(1000))
		return 0
	playsound(src.loc, 'sound/effects/phasein.ogg', 50, 1, 5)
	set_light(10, -10, "#FFFFFF")

	var/extra_delay = rand(0,90)

	spawn(extra_delay)
		spawn(200)
			if(prob(10+extra_delay))
				set_light(10, 10, "#[num2hex(rand(64,255))][num2hex(rand(64,255))][num2hex(rand(64,255))]")
		spawn(210)
			..()
			playsound(src.loc, 'sound/effects/bang.ogg', 50, 1, 5)
			qdel(src)



