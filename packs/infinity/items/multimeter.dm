#if FALSE

// SIERRA TODO: multimeter

#define METER_MESURING "Measuring"
#define METER_CHECKING "Checking"

#define isMultimeter(A)   (A && A.ismultimeter())

/obj/item/device/multitool/multimeter
	name = "multimeter"
	desc = "Используется для измерения потребления электроэнергии оборудования и прозвонки проводов. Рекомендуется докторами."
	icon = 'infinity/icons/obj/items.dmi'
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

			if(href_list["check"])
				if(isMultimeter(I) || isMultimeter(offhand_item))
					var/obj/item/device/multitool/multimeter/O = L.get_active_hand()
					if (L.skill_check(SKILL_ELECTRICAL, SKILL_BASIC))
						if(O.mode == METER_CHECKING)
							to_chat(L, "<span class='notice'>Перебираем провода...</span>")
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
											playsound(O.loc, 'infinity/sound/machines/mbeep.ogg', 20, 1)
										else
											to_chat(L, "the [colour] wire not connected")
									else
										to_chat(L, "the [colour] wire not connected")
							//to_chat(L, "<span class='notice'>[all_solved_wires[holder_type]]</span>")
						else
							to_chat(L, "<span class='notice'>Переключите мультиметр в режим прозвонки.</span>")
					else
						to_chat(L, "<span class='notice'>Вы не знаете как с этим работать.</span>")
				else
					to_chat(L, "<span class='warning'>Вам нужен мультиметр.</span>")

#endif
