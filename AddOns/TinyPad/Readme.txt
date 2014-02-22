TinyPad 1.9

TinyPad is a notepad addon.

__ New in 1.9 __
- Ability to bookmark pages
- Shift+clicking a page turn will move the page
- Minor adjustments in button size
- Some cleanup of code

To summon: /tinypad or /pad or set a key binding.
To resize: drag the resize grip in the lower right corner of the window.

The mod should be self explanatory how to use. Mouseover buttons to see what they do.

__ Notes on link support __
- Links supported: Items, Spells, Tradeskills, Recipes, Quests and Achievements
- To add links to pages: Bring up a TinyPad page and put the blinking cursor where you want to insert a link, then shift+click an item, spell, recipe, quest or achievement as you ordinarily would to chat.  To link an entire tradeskill, click the chat bubble in the upper right of the tradeskill window, as you would for chat or macros.
- To view links: Click them.
- To send links: Shift+click to chat as you would normally.
- Links can't be copy-pasted naturally and remain clickable.  But the addon Linkerize will allow cut/pasting links with control codes.
- Links may display only a handful of characters, but they have many hidden control characters (especially tradeskills). The EditBox is not intended to handle massive amounts of text, so keep that in mind if trying to cram the entire contents of AtlasLoot into one page.

__ Notes __
- Searches are case insensitive.
- You can bind a key to search.
- Pages aren't "saved" until you leave the page, so expect Search to not find new stuff on your current page.
- While locked, the window won't go away with ESC, but you can still toggle it with /pad or a key binding.
- You can also run pages with /run TinyPad.Run(page)
- You can add a page with TinyPad.Insert("text here adds a new page")
- You can delete multiple pages with TinyPad.DeletePagesContaining("regex") NOTE: be careful with this one
- Double-clicking a word will highlight the word
- Clicking on an item link while a tradeskill window is open will jump to that item if your tradeskill can create it

v2.0, 2/4/12, cleaned up XML, shift+clicking page turns move a page, changed search method from string:lower comparisons to a [Cc][Aa][Ss][Ee]insensitive search, added bookmark system
v1.8, 1/14/12, fixes for quest/tradeskill linking, added achievement linking
v1.71, 9/28/10, removed 'arg1' from moving, added TinyPad.Insert and TinyPad.DeletePagesContaining
v1.7, 9/1/10, changed 'this' references to 'self' in xml, updated toc
v1.62, 7/8/10, actual fix for linking to chat, SetItemRef extra params
v1.61, 6/24/10, fix for linking to chat
v1.6, 12/3/08, added support for inserting/displaying links
v1.53, 8/8/08, changed toc, this to self, passed arg1s, changed getn's to #'s
v1.52, 11/1/06, UISpecialFrames added back
v1.51, 10/23/06, UISpecialFrames removed
v1.5, 10/4/06, updated for Lua 5.1
v1.4, 8/22/06, bug fix: run script saves page to run, changed: moved buttons to search panel, reduced minimum width
v1.3, 8/5/06, added undo, widened page number
v1.2, 6/23/06, added search, lock, fonts, /pad <page>, /pade run <page>
v1.1, 12/18/05, remove autofocus, added confirmation on delete
v1.0, 12/16/05, initial release

- Gello