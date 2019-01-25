/datum/codex_entry/paperwork/New()
	mechanics_text = replacetext(mechanics_text, "\n", "<br/>") // Lazy add breaklines.
	. = ..()

/datum/codex_entry/paperwork/pen
	associated_paths = list(/obj/item/weapon/pen)
	mechanics_text = {"This is an item for writing down your thoughts, on paper or elsewhere. The following special commands are available:
Pen and crayon commands
\[br\] : Creates a linebreak.
\[center\] - \[/center\] : Centers the text.
\[h1\] - \[/h1\] : Makes the text a first level heading.
\[h2\] - \[/h2\] : Makes the text a second level heading.
\[h3\] - \[/h3\] : Makes the text a third level heading.
\[b\] - \[/b\] : Makes the text bold.
\[i\] - \[/i\] : Makes the text italic.
\[u\] - \[/u\] : Makes the text underlined.
\[large\] - \[/large\] : Increases the size of the text.
\[sign\] : Inserts a signature of your name in a foolproof way.
\[field\] : Inserts an invisible field which lets you start type from there. Useful for forms.
\[date\] : Inserts today's station date.
\[time\] : Inserts the current station time.
Pen exclusive commands
\[small\] - \[/small\] : Decreases the size of the text.
\[list\] - \[/list\] : A list.
\[*\] : A dot used for lists.
\[hr\] : Adds a horizontal rule."}

/datum/codex_entry/paperwork/text_files
	display_name = "Digital Text Files"
	associated_paths = list(/datum/computer_file/data/text)
	mechanics_text = {"Digital text files is the logical step from traditional pen and paper to transcribe your thoughts.
	The following special commands are available:
	\[br\] : Creates a linebreak.
	\[center\] - \[/center\] : Centers the text.
	\[h1\] - \[/h1\] : First level heading.
	\[h2\] - \[/h2\] : Second level heading.
	\[h3\] - \[/h3\] : Third level heading.
	\[b\] - \[/b\] : Bold.
	\[i\] - \[/i\] : Italic.
	\[u\] - \[/u\] : Underlined.
	\[small\] - \[/small\] : Decreases the size of the text.
	\[large\] - \[/large\] : Increases the size of the text.
	\[field\] : Inserts a blank text field, which can be filled later. Useful for forms.
	\[date\] : Current station date.
	\[time\] : Current station time.
	\[list\] - \[/list\] : Begins and ends a list.
	\[*\] : A list item.
	\[hr\] : Horizontal rule.
	\[table\] - \[/table\] : Creates table using \[row\] and \[cell\] tags.
	\[grid\] - \[/grid\] : Table without visible borders, for layouts.
	\[row\] - New table row.
	\[cell\] - New table cell.
	\[logo\] - Inserts EXO logo image.
	\[ntlogo\] - Inserts the NT logo image.
	\[bluelogo\] - Inserts blue NT logo image.
	\[solcrest\] - Inserts SCG crest image.
	\[eclogo\] - Inserts the Expeditionary Corps logo.
	\[daislogo\] - Inserts the Deimos Advanced Information Systems logo.
	\[xynlogo\] - Inserts the Xyngergy logo.
	\[iccgseal\] - Inserts ICCG seal
	\[fleetlogo\] - Inserts the logo of the SCG Fleet"}
