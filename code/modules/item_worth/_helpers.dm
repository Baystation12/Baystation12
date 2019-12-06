//Workaround by Ginja due to the fact initial(parent_type) does not work.

#define PARENT(x) text2path(replacetext("[x]", regex("/\[^/\]+$"), ""))