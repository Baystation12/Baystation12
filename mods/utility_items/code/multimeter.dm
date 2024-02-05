#define METER_MESURING "Measuring"
#define METER_CHECKING "Checking"

#define isMultimeter(A)   (A && A.ismultimeter())

/obj/item/device/multitool/multimeter
	name = "multimeter"
	desc = "Используется для измерения потребления электроэнергии оборудования и прозвонки проводов. Рекомендуется докторами."
	icon = 'mods/utility_items/icons/multimeter.dmi'
	icon_state = "multimeter"
	origin_tech = list(TECH_MAGNET = 4, TECH_ENGINEERING = 4)
	slot_flags = SLOT_BELT
	var/mode = METER_MESURING // Mode

/obj/item/device/multitool/multimeter/attack_self(mob/user)
	switch(mode)
		if(METER_MESURING)
			mode = METER_CHECKING
		if(METER_CHECKING)
			mode = METER_MESURING
	to_chat(user, "Режим сменён на: [mode].")

/obj/item/device/multitool/multimeter/ismultimeter()
	return TRUE

/atom/proc/ismultimeter()
	return FALSE

/datum/wires/Topic(href, href_list)
	. = ..()
	var/list/unsolved_wires = src.wires.Copy()
	var/colour_function
	var/solved_colour_function

	if(in_range(holder, usr) && isliving(usr))

		var/mob/living/L = usr
		if(CanUse(L) && href_list["action"])

			var/obj/item/I = L.get_active_hand()

			var/obj/item/offhand_item
			if(ishuman(usr))
				var/mob/living/carbon/human/H = usr
				offhand_item = H.wearing_rig && H.wearing_rig.selected_module

			if(href_list["pulse"])
				var/colour = href_list["pulse"]
				if(isMultimeter(I))
					var/obj/item/device/multitool/multimeter/O = L.get_active_hand()
					if(O.mode == METER_MESURING)
						if (L.skill_check(SKILL_ELECTRICAL, SKILL_TRAINED))
							to_chat(usr, SPAN_NOTICE("Вы подаёте напряжение на провод..."))
							if(!do_after(L, 50, holder))
								return
							PulseColour(colour)
							to_chat(usr,SPAN_NOTICE("Провод пропульсован."))
						else
							to_chat(L, SPAN_NOTICE ("Вы не знаете с каким напряжением работает этот провод."))
					else
						if (L.skill_check(SKILL_ELECTRICAL, SKILL_TRAINED))
							if(!do_after(L, 10, holder))
								return
							if(!IsColourCut(colour))
								colour_function = unsolved_wires[colour]
								solved_colour_function = SolveWireFunction(colour_function)
								if(solved_colour_function != "")
									to_chat(L, "the [colour] wire connected to [solved_colour_function]")
									playsound(O.loc, 'mods/utility_items/sounds/mbeep.ogg', 20, 1)
								else
									to_chat(L, "the [colour] wire not connected")
							else
								to_chat(L, "the [colour] wire not connected")
						else
							to_chat(L, SPAN_NOTICE ("Вы не умеете подключать мультиметр."))

			if(href_list["examine"])
				if(isMultimeter(I) || isMultimeter(offhand_item))
					var/obj/item/device/multitool/multimeter/O = L.get_active_hand()
					if (L.skill_check(SKILL_ELECTRICAL, SKILL_TRAINED))
						if(O.mode == METER_CHECKING)
							to_chat(L, SPAN_NOTICE ("Перебираем провода..."))
							var/name_by_type = name_by_type()
							to_chat(L, "[name_by_type] wires:")
							for(var/colour in src.wires)
								if(unsolved_wires[colour])
									if(!do_after(L, 10, holder))
										return
									if(!IsColourCut(colour))
										colour_function = unsolved_wires[colour]
										solved_colour_function = SolveWireFunction(colour_function)
										if(solved_colour_function != "")
											to_chat(L, "the [colour] wire connected to [solved_colour_function]")
											playsound(O.loc, 'mods/utility_items/sounds/mbeep.ogg', 20, 1)
										else
											to_chat(L, "the [colour] wire not connected")
									else
										to_chat(L, "the [colour] wire not connected")
						else
							to_chat(L, SPAN_NOTICE ("Переключите мультиметр в режим прозвонки."))
					else
						to_chat(L, SPAN_NOTICE ("Вы не знаете как с этим работать."))

/datum/design/item/tool/multimeter
	name = "multimeter"
	desc = "Используется для измерения потребления электроэнергии оборудования и прозвонки проводов. Рекомендуется докторами."
	id = "multimeter"
	req_tech = list(TECH_MAGNET = 4, TECH_ENGINEERING = 5, TECH_MATERIAL = 6)
	materials = list(DEFAULT_WALL_MATERIAL = 1000, MATERIAL_GLASS = 1000, MATERIAL_SILVER = 500)
	build_path = /obj/item/device/multitool/multimeter
	sort_string = "VAGAM"

// Closet unlocking

/obj/structure/closet

	var/code1[8]
	var/code2[8]
	var/validate = 0
	var/codelen

/obj/structure/closet/Initialize(mapload, need_fill)
	..()
	update_icon()
	if((setup & CLOSET_HAS_LOCK))
		verbs += /obj/structure/closet/proc/togglelock_verb

		codelen = rand(7,10)
		codelen = length(code1)
		codelen = length(code2)
		for(var/i=1 to codelen)
			code1[i] = rand(0,9)
			code2[i] = rand(0,9)

	return mapload ? INITIALIZE_HINT_LATELOAD : INITIALIZE_HINT_NORMAL

// Overrides this because otherwise this leads us to unit tests failing
/obj/structure/closet/crate/secure/loot
	codelen = 4

// Proceeding to do stuff

/obj/structure/closet/use_tool(obj/item/tool, mob/user, list/click_params)
	. = ..()
	if(setup & CLOSET_HAS_LOCK)
		if(isMultimeter(tool))
			var/obj/item/device/multitool/multimeter/O = tool
			if(O.mode != METER_CHECKING)
				to_chat(user, SPAN_NOTICE ("Переключите мультиметр."))
			else
				if (user.skill_check(SKILL_ELECTRICAL, SKILL_TRAINED))
					src.interact(usr)
				else
					to_chat(user, SPAN_NOTICE ("Вы не умеете работать с этим замком."))

/obj/structure/closet/interact(mob/user)
	add_fingerprint(user)

	var/dat = "<table style='text-align: center;'><tr>"
	for(var/i = 1 to codelen)
		dat += "<td><a href='?src=\ref[src];inc=[i]'>+</a>"
	dat += "<tr>"
	for(var/i = 1 to codelen)
		dat += "<td>[code2[i]]"
	dat += "<tr>"
	for(var/i = 1 to codelen)
		dat += "<td><a href='?src=\ref[src];dec=[i]'>-</a>"
	dat += "</table><hr><a href='?src=\ref[src];check=1'>Сопоставить код</a>"

	user.set_machine(src)
	var/datum/browser/popup = new(user, "closet", "[name]", 90 + codelen * 30, 200)
	popup.set_content(dat)
	popup.open(1)

/obj/structure/closet/Topic(href, href_list)
	if(!ishuman(usr))
		return

	var/mob/living/carbon/human/user = usr
	var/obj/item/device/multitool/multimeter/W = user.get_active_hand()
	user.set_machine(src)

	if(href_list["check"])
		if(!W.in_use)
			W.in_use = TRUE
		else
			return

		validate = 0

		if(W.mode != METER_CHECKING)
			to_chat(user, SPAN_NOTICE("Мультиметр не реагирует на подключение."))
			return

		to_chat(usr, SPAN_NOTICE ("Вы начинаете проверять замок..."))
		for(var/i = 1 to codelen)
			if(do_after(user, 10, src))
				if(code2[i] == code1[i])
					validate++
					to_chat(usr, SPAN_NOTICE ("Ключ подходит."))
					playsound(W.loc, 'mods/utility_items/sounds/mbeep.ogg', 30, 1, frequency = rand(50000, 55000))
				else
					to_chat(usr, SPAN_NOTICE ("Ключ не подходит."))
		W.in_use = FALSE

		if(validate < codelen)
			return

		locked = !locked
		update_icon()
		visible_message(SPAN_WARNING ("[user] has [locked ? "locked" : "hacked"] [src]!"))
		return

	if(href_list["inc"])
		var/inc = text2num(href_list["inc"])
		code2[inc]++
		if(code2[inc] > 9)
			code2[inc] = 0
		interact(user)

	if(href_list["dec"])
		var/inc = text2num(href_list["dec"])
		code2[inc]--
		if(code2[inc] < 0)
			code2[inc] = 9
		interact(user)

#undef METER_MESURING
#undef METER_CHECKING

#undef isMultimeter
