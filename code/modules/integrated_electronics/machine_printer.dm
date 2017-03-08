var/list/integrated_circuit_blacklist = list(/obj/item/integrated_circuit, /obj/item/integrated_circuit/arithmetic, /obj/item/integrated_circuit/converter,
										/obj/item/integrated_circuit/filter, /obj/item/integrated_circuit/filter/ref, /obj/item/integrated_circuit/input,
										/obj/item/integrated_circuit/output, /obj/item/integrated_circuit/manipulation, /obj/item/integrated_circuit/sensor,
										/obj/item/integrated_circuit/time, /obj/item/integrated_circuit/manipulation/grenade/frag, /obj/item/integrated_circuit/manipulation/locomotion)

/obj/machinery/integrated_circuit_printer
	name = "integrated circuit printer"
	desc = "A large machine made to print tiny things out of metal."
	icon = 'icons/obj/machines/research.dmi'
	icon_state = "integrated"
	density = 1
	anchored = 1
	var/metal = 0
	var/maxMetal = 100
	var/metal_mult = 0.5
	use_power = 1
	idle_power_usage = 30
	active_power_usage = 2500
	var/static/list/recipe_list
	var/mode = "Circuits"

/obj/machinery/integrated_circuit_printer/New()
	..()
	if(!recipe_list)
		recipe_list = list("Circuits" = typesof(/obj/item/integrated_circuit) - integrated_circuit_blacklist,
						"Assemblies" = typesof(/obj/item/device/electronic_assembly))

	component_parts = list()
	component_parts += new /obj/item/weapon/circuitboard/integrated_printer(src)
	component_parts += new /obj/item/weapon/stock_parts/matter_bin(src)
	component_parts += new /obj/item/weapon/stock_parts/manipulator(src)
	component_parts += new /obj/item/weapon/stock_parts/micro_laser(src)
	RefreshParts()

/obj/machinery/integrated_circuit_printer/attackby(var/obj/item/O, var/mob/user)
	if(istype(O,/obj/item/stack/material))
		var/obj/item/stack/material/stack = O
		if(stack.material.name == DEFAULT_WALL_MATERIAL)
			var/num = Clamp(round(input("How many sheets do you want to add?") as num), 0, min(maxMetal - metal, stack.amount))
			if(num && stack.use(num))
				to_chat(user, "<span class='notice'>You add [num] sheet\s to \the [src].</span>")
				metal += num
				updateUsrDialog()
				return 1
	if(default_deconstruction_screwdriver(user, O))
		new /obj/item/stack/material/steel(get_turf(loc), metal)
		metal = 0
		return
	if(default_deconstruction_crowbar(user, O))
		return
	if(istype(O,/obj/item/integrated_circuit))
		to_chat(user, "<span class='notice'>You insert the circuit into [src]. </span>")
		user.unEquip(O)
		qdel(O)
		metal = min(metal+1,maxMetal)
		return 1
	return ..()

/obj/machinery/integrated_circuit_printer/attack_hand(var/mob/user)
	user.set_machine(src)
	var/dat = "<center><b>Integrated Circuit Printer<br>\
				Metal: [metal]/[maxMetal]</b><br>\
				<a href='?src=\ref[src];mode=Circuits'>Circuits</a>	<a href='?src=\ref[src];mode=Assemblies'>Assemblies</a></center><br><br>"
	for(var/type in recipe_list[mode])
		var/obj/O = type
		dat += "<A href='?src=\ref[src];build=[type]'>[initial(O.name)]</A>: [initial(O.desc)]<br>"

	show_browser(user,dat,"window=integrated")

/obj/machinery/integrated_circuit_printer/Topic(href, href_list)
	if(..())
		return 1

	add_fingerprint(usr)

	if(href_list["mode"])
		mode = href_list["mode"]
	else
		var/build_type = text2path(href_list["build"])
		if(!build_type || !ispath(build_type))
			return 1
		var/cost = 1
		if(ispath(build_type, /obj/item/device/electronic_assembly))
			var/obj/item/device/electronic_assembly/E = build_type
			cost = round((initial(E.max_complexity) + initial(E.max_components))*metal_mult)
		if(metal - cost < 0)
			to_chat(usr, "<span class='warning'>You need [cost] metal to build that!.</span>")
			return 1
		metal -= cost
		new build_type(get_turf(loc))
	updateUsrDialog()

/obj/machinery/integrated_circuit_printer/RefreshParts()
	maxMetal = 0
	metal_mult = 0
	for(var/obj/item/weapon/stock_parts/S in component_parts)
		if(istype(S,/obj/item/weapon/stock_parts/matter_bin))
			maxMetal += 100 * S.rating
		else
			metal_mult += 0.25/S.rating

/obj/machinery/integrated_circuit_printer/update_icon()
	if(panel_open)
		icon_state = "integrated_open"
	else
		icon_state = "integrated"