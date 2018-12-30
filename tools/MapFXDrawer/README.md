## MapFXDrawer
GUI app to render maps into proper images.

#### Instruction
Start with `start` script. Then select files you need and set up additional configuration if needed.

<details>
    <summary>Detailed instruction</summary>
    
![GUI](https://i.imgur.com/xnK20sq.png)

1 - Environment menu. Here you choose `dme` file which will be parsed.<br>
1.1 - Click this button to select `dme` file.<br>
1.2 - Using special json declaration (example below) you can modify parsed environment with custom variables.

2 - Map menu.<br>
2.1 - Button to select map to render.

3 - Additional configuration menu (fully optional).<br>
3.1 - Map region to render. Description of fields in order: `min X, min Y, max X, max Y`.<br>
By default will have next values: `1`, `1`, `max X` and `max Y` of current map. <br>
*WARNING: byond coordinate system starts from bottom to top, so the bottom-left tile has `0,0` coords.*<br>
3.2 - Filter mods used during render.<br>
`NONE` - no filtering at all.<br>
`IGNORE` - all provided types and subtypes of them won't be rendered.<br>
`INCLUDE` - **only** provided types and subtypes of them will be rendered.<br>
`EQUAL` - **only** provided types **without** subtypes will be rendered.<br>
3.3 - Text area to provide types to filter. All types should be separated by new line:
```
/obj/area
/obj/item
```

4 - Button to render map. Will be available after selection of `dme` and `dmm` files.

</details><br>

#### JSON configuration
Application able to consume json files with special declaration to override objects variables. Predefined configurations could be found in `configs` folder.

<hr>

Source Code: https://github.com/SpaiR/MapFXDrawer
