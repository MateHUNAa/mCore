## mCore Framework

`mCore` is a Lua-based framework designed for use in FiveM, a multiplayer modification framework for GTA V. This framework provides various utilities and functions to enhance your development process, including notification systems, 3D text rendering, debug logging, model handling, and more.

# Features

- Shared Object Exporting: Easily export the shared object for global access.
- Notification System: Custom notifications with configurable titles, messages, types, and durations.
- 3D Text Rendering: Draw 3D text in the game world with support for scaling and positioning.
- Custom Markers: Draw custom markers in the game world.
- Rainbow and Wave Text Effects: Create dynamic, colorful text effects.
- Debug Logging: Log messages and errors locally or send them to a server.
- Model and Animation Handling: Load and unload models and animation dictionaries.
- Prop and Ped Creation: Create and manage props and pedestrians with various options.
- Blip Creation: Add blips to the map with custom properties.
- Inventory Locking: Lock and unlock player inventory.
- Progress Bar: Display a progress bar with optional animations and scenarios.
- Item Checking: Check if a player has specific items.
- Utility Functions: Various utility functions including sorted table iteration.

# Usage
Exporting the Shared Object
```lua
mCore = exports["mCore"]:getSharedObj()
```

Notification System
```lua
mCore.Notify(title, message, type, duration)
```
3D Text Rendering
```lua
mCore.Draw3DText(x, y, z, scl_factor, text)
```
Custom Markers
```lua
-- In Config you can adjust the image will be rendered above the marker
mCore.DrawCustomMarker(coords, markerType, size, color)
```
Rainbow and Wave Text Effects
```lua
mCore.Draw3DRainbowText(coords, text, colors, interval)

mCore.drawWaveText(coords, text, colors, interval)
```
Logging & Debug logging
```lua
mCore.log(message)
mCore.error(errorMessage)

mCore.debug.log(message, isLocal--[[if true then this will get's printed out on client side console]])
mCore.debug.error(message, isLocal--[[if true then this will get's printed out on client side console]])
```
Model and Animation Handling
```lua
mCore.loadModel(model)
mCore.unloadModel(model)

mCore.loadAnimDict(dict)
mCore.unloadAnimDict(dict)
```
Prop and Ped Creation
```lua
mCore.makeProp({
     prop   = "prop_barier_conc_01b",
     coords = vec3(0.0, 0.0, 0.0),
}, true --[[freezed]], false --[[synced]])

mCore.makePed("model", vec3, freeze, collision, "scenario", "anim")
```
Blip Creation
```lua
mCore.makeBlip({
     coords = vec3(0.0, 0.0, 0.0),
     sprite = 1,
     col    = 0,
     scale  = 0.7,
     disp   = 6,
     name   = "mCore Blip",
})
```
Inventory Locking
```lua
mCore.lockInv(toggle)
```
Progress Bar
```
if mCore.progressBar({
         time   = mCore.isDebug() and 1500 or 5000,
         label  = "Displayed_Message",
         dead   = true,
         cancel = true,
         dict   = dict,
         anim   = anim,
         task   = "scenario",
    }) then
     -- After Finish
end
```
Item Checking
```lua
mCore.HasItem("itemName", 1)
```
Utility Functions
```
mCore.pairsByKeys(table)
```

# License
This project is licensed under the MIT License. See the LICENSE file for details.

# Contributing
Contributions are welcome! Please open an issue or submit a pull request for any changes.

<p>All the server side exports and stuff will be listed in another file.</p>
