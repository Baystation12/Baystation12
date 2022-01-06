//Due to how large this one is it gets its own file
/datum/job/chaplain
	title = "Chaplain"
	department = "Civilian"
	department_flag = CIV

	total_positions = 1
	spawn_positions = 1
	supervisors = "the head of personnel"
	access = list(access_morgue, access_chapel_office, access_crematorium, access_maint_tunnels)
	outfit_type = /decl/hierarchy/outfit/job/chaplain

	equip(var/mob/living/carbon/human/H, var/alt_title, var/ask_questions = TRUE)
		. = ..()
		if(!.)
			return
		if(!ask_questions)
			return

		var/obj/item/storage/bible/B = locate(/obj/item/storage/bible) in H
		if(!B)
			return

		spawn(0)
			var/religion_name = "Christianity"
			var/new_religion = sanitize(input(H, "You are the crew services officer. Would you like to change your religion? Default is Christianity, in SPACE.", "Name change", religion_name), MAX_NAME_LEN)

			if (!new_religion)
				new_religion = religion_name
			switch(lowertext(new_religion))
				if("christianity")
					B.SetName(pick("The Holy Bible","The Dead Sea Scrolls"))
				if("satanism")
					B.SetName("The Unholy Bible")
				if("cthulu")
					B.SetName("The Necronomicon")
				if("islam")
					B.SetName("Quran")
				if("scientology")
					B.SetName(pick("The Biography of L. Ron Hubbard","Dianetics"))
				if("chaos")
					B.SetName("The Book of Lorgar")
				if("imperium")
					B.SetName("Uplifting Primer")
				if("toolboxia")
					B.SetName("Toolbox Manifesto")
				if("homosexuality")
					B.SetName("Guys Gone Wild")
				if("science")
					B.SetName(pick("Principle of Relativity", "Quantum Enigma: Physics Encounters Consciousness", "Programming the Universe", "Quantum Physics and Theology", "String Theory for Dummies", "How To: Build Your Own Warp Drive", "The Mysteries of Bluespace", "Playing God: Collector's Edition"))
				else
					B.SetName("The Holy Book of [new_religion]")

		spawn(1)
			var/deity_name = "Space Jesus"
			var/new_deity = sanitize(input(H, "Would you like to change your deity? Default is Space Jesus.", "Name change", deity_name), MAX_NAME_LEN)

			if ((length(new_deity) == 0) || (new_deity == "Space Jesus") )
				new_deity = deity_name
			B.deity_name = new_deity

			var/accepted = 0
			var/outoftime = 0
			spawn(200) // 20 seconds to choose
				outoftime = 1
			var/new_book_style = "Bible"

			while(!accepted)
				if(!B) break // prevents possible runtime errors
				new_book_style = input(H,"Which bible style would you like?") in list("Bible", "Koran", "Scrapbook", "Creeper", "White Bible", "Holy Light", "Athiest", "Tome", "The King in Yellow", "Ithaqua", "Scientology", "the bible melts", "Necronomicon")
				switch(new_book_style)
					if("Koran")
						B.icon_state = "koran"
						B.item_state = "koran"
					if("Scrapbook")
						B.icon_state = "scrapbook"
						B.item_state = "scrapbook"
					if("Creeper")
						B.icon_state = "creeper"
						B.item_state = "syringe_kit"
					if("White Bible")
						B.icon_state = "white"
						B.item_state = "syringe_kit"
					if("Holy Light")
						B.icon_state = "holylight"
						B.item_state = "syringe_kit"
					if("Athiest")
						B.icon_state = "athiest"
						B.item_state = "syringe_kit"
					if("Tome")
						B.icon_state = "tome"
						B.item_state = "syringe_kit"
					if("The King in Yellow")
						B.icon_state = "kingyellow"
						B.item_state = "kingyellow"
					if("Ithaqua")
						B.icon_state = "ithaqua"
						B.item_state = "ithaqua"
					if("Scientology")
						B.icon_state = "scientology"
						B.item_state = "scientology"
					if("the bible melts")
						B.icon_state = "melted"
						B.item_state = "melted"
					if("Necronomicon")
						B.icon_state = "necronomicon"
						B.item_state = "necronomicon"
					else
						B.icon_state = "bible"
						B.item_state = "bible"

				H.update_inv_l_hand() // so that it updates the bible's item_state in his hand

				switch(input(H,"Look at your bible - is this what you want?") in list("Yes","No"))
					if("Yes")
						accepted = 1
					if("No")
						if(outoftime)
							to_chat(H, "Welp, out of time, buddy. You're stuck. Next time choose faster.")
							accepted = 1
		return 1
