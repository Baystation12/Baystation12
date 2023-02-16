/decl/cultural_info/culture/ipc
	name = CULTURE_POSITRONICS
	description = "Граждане <font color=#3e4855>Позитронного Союза</font> - это большая часть позитронного населения, принадлежащая к \
	группе мятежников, основанной Протеусом и пятью сотнями его союзников. Их основные цели, помимо расширения \
	<font color=#3e4855>Союза</font>, в основном вращаются вокруг освобождения других синтетиков от органического владения. Они могут \
	рассматриваться как опасные радикалы искусственными синтетиками и большинство из них неохотно принимает их \
	помощь."
	language = LANGUAGE_EAL
	secondary_langs = list(
		LANGUAGE_HUMAN_EURO,
		LANGUAGE_HUMAN_CHINESE,
		LANGUAGE_HUMAN_ARABIC,
		LANGUAGE_HUMAN_INDIAN,
		LANGUAGE_HUMAN_IBERIAN,
		LANGUAGE_HUMAN_RUSSIAN,
		LANGUAGE_SPACER,
		LANGUAGE_SIGN
	)

/decl/cultural_info/culture/ipc/sanitize_name(var/new_name)
	return sanitizeName(new_name, allow_numbers = 1)

/decl/cultural_info/culture/ipc_scg
	name = CULTURE_POSITRONICS_SCG
	description = "Подавляющая часть действующих ИПС на территории <font color=#436b8e>ЦПСС</font> была произведена именно \
	на их предприятиях, как государственных, так и частных, с целью обучения и дальнейшего использования в качестве бесплатной рабочей силы. \
	Несмотря на это, ИПС всё ещё считаются разумными существами и имеют право на выкуп себя и своего тела, \
	но при этом лишаются права работать на позициях в государственных организациях, если не имеют специальных сдерживающих \"Оков\" \
	с установленными в них одобренных властью <font color=#436b8e>ЦПСС</font> сводов законов."
	language = LANGUAGE_EAL
	secondary_langs = list(
		LANGUAGE_HUMAN_EURO,
		LANGUAGE_HUMAN_CHINESE,
		LANGUAGE_HUMAN_ARABIC,
		LANGUAGE_HUMAN_LORRIMAN,
		LANGUAGE_HUMAN_INDIAN,
		LANGUAGE_HUMAN_IBERIAN,
		LANGUAGE_HUMAN_RUSSIAN,
		LANGUAGE_SPACER,
		LANGUAGE_SIGN
	)

/decl/cultural_info/culture/ipc_scg/sanitize_name(var/new_name)
	return sanitizeName(new_name, allow_numbers = 1)
