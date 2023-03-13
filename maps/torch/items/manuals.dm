/obj/item/book/manual/solgov_law
	name = "Sol Central Government Law"
	desc = "A brief overview of SolGov Law."
	icon_state = "bookSolGovLaw"
	author = "The Sol Central Government"
	title = "Sol Central Government Law"

/obj/item/book/manual/solgov_law/Initialize()
	. = ..()
	dat = {"

		<html><head>
		</head>

		<body>
		<iframe width='100%' height='97%' src="[config.wiki_url]Sol_Central_Government_Law&printable=yes&remove_links=1" frameborder="0" id="main_frame"></iframe>
		</body>

		</html>

		"}


/obj/item/book/manual/military_law
	name = "The Sol Code of Military Justice"
	desc = "A brief overview of military law."
	icon_state = "bookSolGovLaw"
	author = "The Sol Central Government"
	title = "The Sol Code of Military Justice"

/obj/item/book/manual/military_law/Initialize()
	. = ..()
	dat = {"

		<html><head>
		</head>

		<body>
		<iframe width='100%' height='97%' src="[config.wiki_url]Sol_Gov_Military_Justice&printable=yes&remove_links=1" frameborder="0" id="main_frame"></iframe>
		</body>

		</html>

		"}

/obj/item/book/manual/sol_sop
	name = "Standard Operating Procedure"
	desc = "SOP aboard the SEV Torch."
	icon_state = "booksolregs"
	author = "The Sol Central Government"
	title = "Standard Operating Procedure"

/obj/item/book/manual/sol_sop/Initialize()
	. = ..()
	dat = {"

		<html><head>
		</head>

		<body>
		<iframe width='100%' height='97%' src="[config.wiki_url]Standard_Operating_Procedure&printable=yes&remove_links=1" frameborder="0" id="main_frame"></iframe>
		</body>

		</html>

		"}

/obj/item/folder/nt/rd

/obj/item/folder/envelope/captain
	desc = "A thick envelope. The SCG crest is stamped in the corner, along with 'TOP SECRET - TORCH UMBRA'."

/obj/item/folder/envelope/captain/Initialize()
	..()
	return INITIALIZE_HINT_LATELOAD

/obj/item/folder/envelope/captain/LateInitialize()
	..()
	var/obj/effect/overmap/visitable/torch = map_sectors["[z]"]
	var/memo = {"
	<tt><center><b><font color='red'>СЕКРЕТНО - КОДОВОЕ СЛОВО: ФАКЕЛ</font></b>
	<h3>ЭКСПЕДИЦИОННОЕ КОМАНДОВАНИЕ ЦЕНТРАЛЬНОГО ПРАВИТЕЛЬСТВА СОЛНЕЧНОЙ СИСТЕМЫ</h3>
	<img src = sollogo.png>
	</center>
	<b>ОТПРАВИТЕЛЬ:</b> Адмирал Уильям Лау<br>
	<b>ПОЛУЧАТЕЛЬ:</b> Командующий офицер ГЭК "Факел"<br>
	<b>ТЕМА:</b> Текущие приказы<br>
	<hr>
	Капитан.<br>
	Вам приказанно посетить следующие звёздные системы. Имейте в виду, что ваши запасы ограничены; распоряжайтесь своим временем с умом.
	<li>[generate_system_name()]</li>
	<li>[generate_system_name()]</li>
	<li>[generate_system_name()]</li>
	<li>[generate_system_name()]</li>
	<li>[generate_system_name()]</li>
	<li>[GLOB.using_map.system_name]</li>
	<li>[generate_system_name()]</li>
	<li>[generate_system_name()]</li>
	<li>[generate_system_name()]</li>
	<br>
	Приоритетными целями являются артефакты ещё невстреченых инопланетных видов и сигналы неизвестного происхождения.<br>
	Ни на одну из этих систем не претендует какая-либо организация, признанная ЦПСС, поэтому у вас есть полные права на утилизацию любых обнаруженных объектов.<br>
	Исследуйте и обозначайте перспективные миры для колонизации согласно стандартным процедурам.<br>
	В этих системах не присутствуют силы ЦПСС. В случае обнаружения сигнала бедствия, Вы будете единственным доступным судном; не игнорируйте их. Мы не можем больше позволить себе чёрного пиара.<br>
	Текущий код стыковки: [torch.docking_codes]<br>
	Докладывайте обо всех находках при помощи блюспейс телекоммуникаций при совершенни меж-системных прыжков.<br>

	<i>Адмирал Лау.</i></tt>
	<i>This paper has been stamped with the stamp of SCG Expeditionary Command.</i>
	"}
	new/obj/item/paper(src, memo, "Standing Orders")
	new/obj/item/paper/umbra(src)

/obj/item/folder/envelope/rep
	desc = "A thick envelope. The SCG crest is stamped in the corner, along with 'TOP SECRET - TORCH UMBRA'."

/obj/item/folder/envelope/rep/Initialize()
	. = ..()
	new/obj/item/paper/umbra(src)

/obj/item/paper/umbra
	name = "UMBRA Protocol"
	info = {"
	<tt><center><b><font color='red'>СОВЕРШЕННО СЕКРЕТНО - КОДОВОЕ СЛОВО: ФАКЕЛ ТЕНЬ</font></b>
	<h3>ОФИС ГЕНЕРАЛЬНОГО СЕКРЕТАРЯ ЦЕНТРАЛЬНОГО ПРАВИТЕЛЬСТВА СОЛНЕЧНОЙ СИСТЕМЫ</h3>
	<img src = sollogo.png>
	</center>
	<b>ОТПРАВИТЕЛЬ:</b> Джонатан Смитерсон, специальный помощник Генерального секретаря<br>
	<b>ПОЛУЧАТЕЛЬ:</b> Командующий офицер ГЭК "Факел"<br>
	<b>ТАКЖЕ:</b> Военный прокурор на борту ГЭК "Факел"<br>
	<b>ТЕМА:</b> Протокол ТЕНЬ<br>
	<hr>
	Это небольшое дополнение к обычным стандартным процедурам. В отличии от остальных СОП, это дополнение не находится под юрисдикцией Командующего офицера и является обязательным. Каким бы неудобным это ни было бы, мы сочли, что это необходимо для бесперебойного выполнения данной миссии.<br>
	Процедура может быть инцированна только при помощи трансляции от Экспедиционного Командования ЦПСС через защищённый канал. Отправитель может не раскрывать свою личность, но у Вас не должно быть проблем с подверждением источника трансляции, я надеюсь.<br>
	Сигналом к иницированию процедуры являются кодовая фраза 'СПОКОЙНОЙ НОЧИ, МИР' использованная именно в этом порядке как одна фраза. Вам не нужно отправлять подтверждение.
	<li>Информация о находках этой экспедиции должна рассматриваться как секретная и жизненно важная для национальной безопасности ЦПСС, и защищена кодовым словом ТЕНЬ. Только государственным служащим ЦПСС и гражданам Скрелльской империи на борту ГЭК "Факел" разрешен доступ к этой информации по мере необходимости.</li>
	<li>Данная информация должна быть засекреченна задним числом. Любой персонал, не имеющий необходимого доступа, который был ознакомлен с такой информацией, должен быть задержан и передан Оборонно Разведывательному Управлению по прибытии в порт приписки.</li>
	<li>Любые устройства, способные передавать или принимать инфофрмацию в межзвёздном радиусе должны быть конфискованны из личного пользования.</li>
	<li>Не обращайте внимания на все системы, оставшиеся в вашем плане полета, и возьмите курс на Солнечную Систему, орбиту Нептуна. С вами свяжутся по прибытии. Не делайте остановок в портах по пути без крайней необходимости.</li>
	<br>
	Хотя это и радикально, я уверяю вас, что это простая мера предосторожности, чтобы избежать каких-либо проблем. Просто оставьте этот вариант открытым и продолжайте выполнять свои обычные обязанности.
	<i>С уважением, Джон.</i></tt>
	<i>This paper has been stamped with the stamp of Office of the General Secretary of SCG.</i>
	"}
