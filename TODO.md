# To Do

This lists the currently open to do items in no particular order.

## Open
- [ ] Icon for "Mouse Position" input.
- [ ] Add a C# API.
- [ ] Documentation
	- [ ] document customizing the input prompt rendering
	- [ ] document input remapping
- [ ] Prepare for asset library (git attributes, page, etc.)
- [ ] Idea: tracked variable modifier. A modifier that is updated by input and returns its value. Could be useful for a 3D position, rotation, etc.
 
## Done
- [x] document all possible inputs and how they map to action values
- [x] Add icon/text renderers for PS/XBOX/Nintendo controllers
- [x] Make the fallback icons less ugly.
- [x] Add functionality for runtime re-binding.
- [x] Fix icon/text for Any input
- [x] Fix remapping of WASD to ESDF
- [x] Implement input consumption and action prioritization.
- [x] Fix "incomplete format" error popping up when rendering an input icon.
- [x] Implement elapsed/triggered time.
- [x] Make an editor for setting up the system. The inspector is atrocious.
- [x] Decide whether to convert into C++ after the prototyping phase is done (decided against it, GDScript is fast enough, easier to maintain and works on all platforms out of the box).
- [x] Remove get_action_value_xxx from Action (replaced by value_xxx property)

