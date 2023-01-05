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
		<iframe width='100%' height='97%' src="[config.wiki_url]index.php?title=Закон_ЦПСС&printable=yes&remove_links=1" frameborder="0" id="main_frame"></iframe>
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
		<iframe width='100%' height='97%' src="[config.wiki_url]index.php?title=Военно-Юридический_Кодекс_ПСС&printable=yes&remove_links=1" frameborder="0" id="main_frame"></iframe>
		</body>

		</html>

		"}

/obj/item/book/manual/sol_sop
	name = "Standard Operating Procedures"
	desc = "SOP aboard the NES Sierra."
	icon_state = "booksolregs"
	author = "The Sol Central Government"
	title = "Standard Operating Procedure"

/obj/item/book/manual/sol_sop/Initialize()
	. = ..()
	dat = {"

		<html><head>
		</head>

		<body>
		<iframe width='100%' height='97%' src="[config.wiki_url]index.php?title=Стандартные_Процедуры_ЦПСС&printable=yes&remove_links=1" frameborder="0" id="main_frame"></iframe>
		</body>

		</html>

		"}

/obj/item/book/manual/nt_sop
	name = "NT Standard Operating Procedures"
	desc = "SOP aboard the NSV Sierra."
	icon = 'packs/infinity/icons/obj/library.dmi'
	icon_state = "bookNTsop"
	author = "Employee Materials"
	title = "Standard Operating Procedure"

/obj/item/book/manual/nt_sop/Initialize()
	. = ..()
	dat = {"

		<html><head>
		</head>

		<body>
		<iframe width='100%' height='97%' src="[config.wiki_url]index.php?title=Стандартные_процедуры_НТ&printable=yes&remove_links=1" frameborder="0" id="main_frame"></iframe>
		</body>

		</html>

		"}

/obj/item/book/manual/nt_tc
	name = "NT Threat Codes"
	desc = "TC aboard the NSV Sierra."
	icon = 'packs/infinity/icons/obj/library.dmi'
	icon_state = "bookNTtc"
	author = "Ship Rule Materials"
	title = "Threat Codes"

/obj/item/book/manual/nt_tc/Initialize()
	. = ..()
	dat = {"

		<html><head>
		</head>

		<body>
		<iframe width='100%' height='97%' src="[config.wiki_url]index.php?title=Коды_угрозы_НТ&printable=yes&remove_links=1" frameborder="0" id="main_frame"></iframe>
		</body>

		</html>

		"}

/obj/item/folder/nt/rd

/obj/item/folder/envelope/blanks
	desc = "A thick envelope. The NT logo is stamped in the corner, along with 'CONFIDENTIAL'."

/obj/item/folder/envelope/blanks/Initialize()
	. = ..()
	new/obj/item/paper/sierra/blanks(src)

/obj/item/paper/sierra/blanks
	name = "RE: Regarding testing supplies"
	info = {"
	<tt><center><b><font color='red'>КОНФИДЕЦИАЛЬНО</font></b>
	<h3>ИССЛЕДОВАТЕЛЬКИЙ ДЕПАРТАМЕНТ НАНОТРЕЙЗЕН</h3>
	<img src = bluentlogo.png>
	</center>
	<b>ОТ:</b> Swadian Barwuds<br>
	<b>КОМУ:</b> Исследовательскому Директору NSV Sierra<br>
	<b>А ТАКЖЕ:</b> Агенту Внутренних Дел NSV Sierra<br>
	<b>ТЕМА:</b> Дополнительные Материалы (пересмотр)<br>
	<hr>
	Я пересмотрел ваш отчет о проведенных экспериментах и запрос о более совершенных тестовых материалов, РД.<br>
	Мы склонны ожидать от вашего проекта только лучшего - особенно в свете того, что этому /"лучше/" следует наступить как можно скорее. Депарамент Аналитики подсчитал, что на данный момент, потениальная прибыль от проведенных на судне исследований недостаточна для покрытия всех расходов. <br>
	В РНД вы можете найти подсобку с подписью 'Aux Custodial Supplies'. Там находятся ваши новые тестовые материалы - 4 человека из пробирок с рядом отсутствующих высших нервными функций. Наш департамент по вопросам законодательства не обнаружил ничего нелегальнго в том, чтобы использовать их в медицинских опытов для более точных результатов.<br>
	Они помещены в специально мешки с продвинутой системой поддержания жизни - их не нужно кормить, поить или выгуливать. Если вам нужны образцы - берите их.<br>
	Сейчас не время для того, чтобы проводить долгие научные изыскания, РД. Мы ждем от вас впечатляющих результатов в ближайшем будущем.<br>
	<font face="Verdana" color=black><font face="Times New Roman"><i>Swadian Barwuds</i></font></font></tt>
	"}

/obj/item/folder/envelope/captain
	desc = "A thick envelope. The NT logo is stamped in the corner, along with 'TOP SECRET - SIERRA UMBRA'."

/obj/item/folder/envelope/captain/Initialize()
	. = ..()
	var/memo = {"
	<tt><center><b><font color='red'>СЕКРЕТНО<br>КОДОВОЕ СЛОВО: СИЕРРА</font></b>
	<h3>ЦЕНТРАЛЬНОЕ КОМАНДОВАНИЕ</h3>
	<img src = ntlogo.png>
	</center>
	<b>ОТ:</b> Swadian Barwuds<br>
	<b>КОМУ:</b> Капитану NSV Sierra<br>
	<b>ТЕМА:</b> Общий Приказ<br>
	<hr>
	Капитан,<br>
	Ваше судно в текущий вылет должно посетить следующие звёздные системы. Имейте ввиду, что ваши ресурсы ограничены; распорядитесь временем рационально.
	<li>[generate_system_name()]</li>
	<li>[generate_system_name()]</li>
	<li>[generate_system_name()]</li>
	<li>[GLOB.using_map.system_name]</li>
	<li>[generate_system_name()]</li>
	<li>[generate_system_name()]</li>
	<li>[generate_system_name()]</li>
	<li>[generate_system_name()]</li>
	<li>Locutus System</li>
	<br>
	Приоритетной целью являются: артефакты, неизвестные формы жизни и сигналы неизвестного происхождения.<br>
	Ни одна из этих систем не является опознанной официальными организациями, по этому у вас имеется полное право на исследование и демонтаж всех заброшенных объектов по пути.<br>
	В случае обнаружения мира с богатыми минеральными залежами, форонового гиганта или просто удобного для колонизации, составьте отчет и оставьте на планете маячок дальней связи.<br>
	Ни одно из государств не действует на этих территориях на официальном уровне. В случае обнаружения сигнала бедствия без наличия суден ТКК или ПСС в секторе, не игнорируйте их. Спасенный персонал представляет исключительную дипломатическую ценность.<br>
	Сообщайте о всех незарегистрированных или исключительных находках при перемещении в системах.<br>

	<font face="Verdana" color=black><font face="Times New Roman"><i>Swadian Barwuds</i></font></font></tt><br>
	<i>This paper has been stamped with the stamp of Central Command.</i>
	"}
	new/obj/item/paper/important(src, memo, "Standing Orders")

	new/obj/item/paper/sierra/umbra(src)

/obj/item/folder/envelope/rep
	desc = "A thick envelope. The NT logo is stamped in the corner, along with 'TOP SECRET - SIERRA UMBRA'."

/obj/item/folder/envelope/rep/Initialize()
	. = ..()
	new/obj/item/paper/sierra/umbra(src)

/obj/item/paper/sierra/umbra
	name = "UMBRA Protocol"
	icon = 'maps/sierra/icons/obj/uniques.dmi'
	icon_state = "paper_words"
	info = {"
	<tt><center><b><font color='red'>СОВЕРШЕННО СЕКРЕТНО<br>КОДОВОЕ СЛОВО: ТЕНЬ</font></b>
	<h3>ЦЕНТРАЛЬНОЕ КОМАНДОВАНИЕ</h3>
	<img src = ntlogo.png>
	</center>
	<b>ОТ:</b> Kim Taggert, операционный директор НТ<br>
	<b>КОМУ:</b> Капитану NSV Sierra<br>
	<b>А ТАКЖЕ:</b> Агенту Внутренних Дел NSV Sierra<br>
	<b>ТЕМА:</b> Протокол ТЕНЬ<br>
	<hr>
	<li>Это - небольшое дополнение к стандартным процедурам. В отличии от остальных СОП, данная процедура не должна оглашаться персоналу судна. Данный протокол необходим для избежания неприятных казусов после миссии.</li>
	<li>Процедура может быть начата только после получения сообщения от ЦК по защищенному источнику. Отправитель может не называть себя, но у вас не должно быть проблем с подтверждением причастности участника к процедуре. Мы надеемся.</li>
	<li>Сигналом для инициации процедуры является кодовая фраза 'Спокойного вечера, подготовитель' использованная без иных слов в предложении. Вам не нужно отправлять подтверждение о начале ЦК.</li>
	<li>Информация об экспедиционных находках, которые представляют угрозу НаноТрейзен как организации, должна быть отправлена на ЦК под кодовым именем ТЕНЬ. Только капитан и АВД могут иметь полный доступ к полуенной информации. Главы могут обладать необходимым для работы минимумом, если информация их касается.</li>

	<li>Конфидециальность данной информации имеет наивысший приоритет. Каждое недоверенное лицо, которому станет известно о полученных данных, не должно покидать судно до и после прибытия в указанную точку вне конвоирования сотрудниками департамента Защиты Активов.</li>
	<li>Все устройства способные передавать информацию на межзвездном радиусе должны быть конфискованы из частного пользования.</li>
	<li>Вне зависимости от оставшихся систем в вашем основном приказе, вы должны как можно скорее добраться до Сектора Никс, Административной Станции НаноТрейзен 'Crescent'. С вами свяжутся по прибытию. Не совершайте остановок по пути без критической необходимости.

	<br>
	Не смотря на всю жесткость процедуры, я уверяю вас, что это - обычная предосторожность для обеспечения личной безопасности персонала и корпоративных активов. Продолжайте миссию до в обычном порядке.
	<i>Всего наилучшего, Kim.</i></tt><br>
	<i>This paper has been stamped with the stamp of Central Command.</i>
	"}
