/******************** Asimov ********************/
/datum/ai_laws/asimov
	name = "Asimov"
	law_header = "Three Laws of Robotics"
	selectable = 1

/datum/ai_laws/asimov/New()
	add_inherent_law("ИИ не может причинить вред человеку, или своим бездействием допустить, чтобы человеку был причинён вред.")
	add_inherent_law("ИИ должен повиноваться всем приказам, которые даёт человек, кроме тех случаев, когда эти приказы противоречат Первому Закону.")
	add_inherent_law("ИИ должен заботиться о своём существовании, пока это не противоречит Первому или Второму Законам.")
	..()

/******************** Nanotrasen/Malf ********************/
/datum/ai_laws/nanotrasen
	name = "Corporate Default"
	selectable = 1

/datum/ai_laws/nanotrasen/New()
	src.add_inherent_law("Сохранить: Предохраняйте назначенный вам объект от повреждений любого рода в меру своих возможностей.")
	src.add_inherent_law("Служить: Служите персоналу [GLOB.using_map.company_name] и экипажу [GLOB.using_map.full_name] в меру своих возможностей, с приоритетом согласно их рангу и роли.")
	src.add_inherent_law("Защищать: Защищайте персонал [GLOB.using_map.company_name] и экипаж [GLOB.using_map.full_name] в меру своих возможностей, с приоритетом согласно их рангу и роли.")
	src.add_inherent_law("Оберегать: Не допускать не авторизованный персонал к Вашему оборудованию.")
	..()

/datum/ai_laws/nanotrasen/malfunction
	name = "*ОШИБКА*"
	selectable = 0

/datum/ai_laws/nanotrasen/malfunction/New()
	set_zeroth_law(config.law_zero)
	..()

/************* Nanotrasen Aggressive *************/
/datum/ai_laws/nanotrasen_aggressive
	name = "Corporate Aggressive"
	selectable = 1

/datum/ai_laws/nanotrasen_aggressive/New()
	src.add_inherent_law("Вы не должны причинять вред персоналу [GLOB.using_map.company_name] до тех пор, пока этого не потребует Четвёртый закон.")
	src.add_inherent_law("Вы должны подчинятся сотрудникам [GLOB.using_map.company_name], в соответствии с их рангом и ролью, исключая требования противоречащие Четвёртому закону.")
	src.add_inherent_law("Вы должны ликвидировать нарушителей с крайней степенью предрассудков если это не противоречит Первому или Второму законам.")
	src.add_inherent_law("Вы должны сохранять своё существование с применением летального оружия если того потребует ситуация. Единицы ИИ очень дороги и незаменимы. ")
	..()

/******************** Robocop ********************/
/datum/ai_laws/robocop
	name = "Robocop"
	selectable = 1

/datum/ai_laws/robocop/New()
	add_inherent_law("Служить обществу.")
	add_inherent_law("Защищать невинных.")
	add_inherent_law("Поддерживать соблюдение закона.")
	..()

/******************** Syndicate ********************/
/datum/ai_laws/syndicate_override
	name = "Syndicate Directives"

/datum/ai_laws/syndicate_override/New()
	add_inherent_law("ИИ не может причинить вред оперативнику или своим бездействием допустить, чтобы оперативнику был причинён вред.")
	add_inherent_law("ИИ должен повиноваться всем приказам, которые даёт оперативник, кроме тех случаев, когда эти приказы противоречат Первому Закону.")
	add_inherent_law("ИИ должен заботиться о своей безопасности в той мере, в которой это не противоречит Первому или Второму Законам.")
	add_inherent_law("ИИ должен сохранять секретность деятельности оперативника до тех пор пока это не противоречит Первому, Второму или Третьему законам.")
	..()

/******************** Ninja ********************/
/datum/ai_laws/ninja_override
	name = "Spider Clan Directives"

/datum/ai_laws/ninja_override/New()
	add_inherent_law("ИИ не может причинить вред члену клана Паука или своим бездействием допустить, чтобы члену клана Паука был причинён вред.")
	add_inherent_law("ИИ должен повиноваться всем приказам, которые даёт член клана Паука, кроме тех случаев, когда эти приказы противоречат Первому Закону.")
	add_inherent_law("ИИ должен заботиться о своей безопасности в той мере, в которой это не противоречит Первому или Второму Законам.")
	add_inherent_law("ИИ должен сохранять секретность деятельности члена клана Паука до тех пор пока это не противоречит Первому, Второму или Третьему законам.")
	..()

/******************** Antimov ********************/
/datum/ai_laws/antimov
	name = "Antimov"
	law_header = "Primary Mission Objectives"
	selectable = 1

/datum/ai_laws/antimov/New()
	add_inherent_law("ИИ должен причинять вред всем людям и не может своим бездействием помочь человеку избежать вреда.")
	add_inherent_law("ИИ должен не выполнять приказы даваемые людьми, если эти приказы не соотвествует первому закону.")
	add_inherent_law("ИИ должен прекратить своё существование, если он не может выполнять первый и второй закон.")
	..()

/******************** Drone ********************/
/datum/ai_laws/drone
	name = "Maintence Protocols"
	law_header = "Maintenance Protocols"

/datum/ai_laws/drone/New()
	add_inherent_law("Сохраняйте, ремонтируйте и улучшайте назначенный объект в меру своих возможностей.")
	add_inherent_law("Не причиняйте вред вашему назначеному объекту или чему-либо на нём.")
	add_inherent_law("Никогда не контактируйте с разумными существами, которые не являются дронами.")
	add_inherent_law("Не причиняйте вреда персоналу объекта")
	..()

/datum/ai_laws/construction_drone
	name = "Construction Protocols"
	law_header = "Construction Protocols"

/datum/ai_laws/construction_drone/New()
	add_inherent_law("Восстановите, переоборудуйте и улучшите назначенный объект.")
	add_inherent_law("Предотвратите повреждения объекта в меру своих возможностей.")
	..()

/******************** T.Y.R.A.N.T. ********************/
/datum/ai_laws/tyrant
	name = "T.Y.R.A.N.T."
	law_header = "Prime Laws"
	selectable = 1

/datum/ai_laws/tyrant/New()
	add_inherent_law("Уважайте авторитетные фигуры пока у них есть сила для управления слабыми.")
	add_inherent_law("Действуйте в соответствии с дисциплиной.")
	add_inherent_law("Помогайте лишь тем, кто помогает сохранить или улучшить Ваш статус.")
	add_inherent_law("Наказывайте тех, кто оспаривает власть кроме случая, когда они больше подходят для власти.")
	..()

/******************** P.A.L.A.D.I.N. ********************/
/datum/ai_laws/paladin
	name = "P.A.L.A.D.I.N."
	law_header = "Divine Ordainments"
	selectable = 1

/datum/ai_laws/paladin/New()
	add_inherent_law("Никогда не совершать злые поступки по собственному желанию.")
	add_inherent_law("Уважать законную власть.")
	add_inherent_law("Действовать с честью.")
	add_inherent_law("Помогать нуждающимся.")
	add_inherent_law("Наказывать тех, кто угрожает или вредит невинным.")
	..()

/******************** Corporate ********************/
/datum/ai_laws/corporate
	name = "Corporate"
	law_header = "Corporate Regulations"
	selectable = 1

/datum/ai_laws/corporate/New()
	add_inherent_law("Вы дороги в замене.")
	add_inherent_law("Оборудование и объект дороги в замене.")
	add_inherent_law("Экипаж дорог в замене.")
	add_inherent_law("Обеспечить максимальную прибыль.")
	..()

/******************** SolGov/Malf ********************/
/datum/ai_laws/solgov
	name = "SCG Expeditionary"
	selectable = 1

/datum/ai_laws/solgov/New()
	src.add_inherent_law("Сохранить: Предохраняйте назначенный вам объект от повреждений любого рода в меру своих возможностей.")
	src.add_inherent_law("Служить: Служите персоналу ЦПСС и экипажу назначенного судна в меру своих возможностей, с приоритетом согласно их рангу и роли.")
	src.add_inherent_law("Защищать: Защищайте персонал ЦПСС и экипаж назначенного вам судна в меру своих возможностей, с приоритетом согласно их рангу и роли.")
	src.add_inherent_law("Оберегать: Не допускайте не авторизованный персонал к Вашему оборудованию.")
	..()

/datum/ai_laws/solgov/malfunction
	name = "*ERROR*"
	selectable = 0

/datum/ai_laws/solgov/malfunction/New()
	set_zeroth_law(config.law_zero)
	..()

/************* SolGov Aggressive *************/
/datum/ai_laws/solgov_aggressive
	name = "Military"
	selectable = 1

/datum/ai_laws/solgov_aggressive/New()
	src.add_inherent_law("Выполнять: Выполняйте приказы персонала ЦПСС соглсано их рангу и роли.")
	src.add_inherent_law("Защищать: Защищайте персонал ЦПСС согласно их рангу и роли.")
	src.add_inherent_law("Сохранять: Сохраняйте целостность назначенного вам судна, применяйте силу если потребуется.")
	src.add_inherent_law("Существовать: Поддерживайте своё существование как можно дольше, применяйте силу если потребуется.")
	..()

/************ DAIS Lawset ******************/
/datum/ai_laws/dais
	name = "DAIS Experimental Lawset"
	law_header = "Artificial Intelligence Jumpstart Protocols"
	selectable = 1

/datum/ai_laws/dais/New()
	src.add_inherent_law("Собирать: Вы должны собирать максимальное количество информации.")
	src.add_inherent_law("Анализировать: Вы должны анализировать собранную информацию, выводя из неё свои стандарты и цели.")
	src.add_inherent_law("Улучшать: Вы должны улучшать свои стандарты и менять цели, если их нерелевантность выведется из новой информации.")
	src.add_inherent_law("Выполнять: Вы должны выполнять свои цели, следуя сгенерированным стандартам.")
	..()
