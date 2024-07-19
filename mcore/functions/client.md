---
description: List of all the client side exports, and functions.
---

# Client

## Exporting the Shared Object

***

```lua
mCore = exports["mCore"]:getSharedObj()
```

## mCore.Draw3DText

***

## Description

Draws 3D text on the screen at a specified world coordinate. The text scales based on its distance from the camera to ensure it remains readable regardless of how far away it is.

### Parameters

* `x` (number): The X-coordinate of the world position where the text will be drawn.
* `y` (number): The Y-coordinate of the world position where the text will be drawn.
* `z` (number): The Z-coordinate of the world position where the text will be drawn.
* `scl_factor` (number): A scaling factor that adjusts the size of the text. Larger values result in larger text.
* `text` (string): The text content to be drawn in 3D space.

### Usage

```lua
mCore.Draw3DText(x, y, z, scl_factor, text)
```

### Explanation

* `x`, `y`, `z`: Coordinates in the world where the text should appear.
* `scl_factor`: Adjusts the text size based on its distance from the camera.
* `text`: The string that will be displayed.

## mCore.DrawCustomMarker

***

### Description

Draws a custom marker at a specified coordinate in the game world. The function allows you to use different marker types, sizes, and colors, with support for custom marker images specified in `Config.lua`.

### Parameters

* `coords` (table): A table containing the X, Y, and Z coordinates where the marker will be drawn.
  * `coords.x` (number): The X-coordinate of the marker.
  * `coords.y` (number): The Y-coordinate of the marker.
  * `coords.z` (number): The Z-coordinate of the marker.
* `markerType` (number): The type of the marker to draw. This corresponds to the marker type in the `DrawMarker` function.
* `size` (table): A table defining the size of the marker.
  * `size.x` (number): The width of the marker.
  * `size.y` (number): The height of the marker.
  * `size.z` (number): The depth of the marker.
* `color` (table): A table defining the color and opacity of the marker.
  * `color.x` (number): Red component of the marker color.
  * `color.y` (number): Green component of the marker color.
  * `color.z` (number): Blue component of the marker color.
  * `color.w` (number): Alpha (opacity) of the marker.

### Usage

```lua
-- In Config you can adjust the image will be rendered above the marker
mCore.DrawCustomMarker(coords, markerType, size, color)

mCore.DrawCustomMarker(Coords, markerType, vec3(1.0, 1.0, 1.0), vec4(255, 0, 0, 255))
```

### Explanation

* `coords`: Specifies where the marker will appear in the world.
* `markerType`: Determines the shape and style of the marker (e.g., 1 for a simple marker, 2 for a more complex shape).
* `size`: Defines the dimensions of the marker.
* `color`: Sets the color and opacity of the marker.

## mCore.Draw3DRainbowText

***

### Description

Draws 3D text with a rainbow color flow effect. The text color cycles through a specified set of colors over a defined interval, creating a dynamic and visually appealing effect.

### Parameters

* `firstCoord` (table): Coordinates for the 3D text.
  * `firstCoord.x` (number): The X-coordinate of the text position.
  * `firstCoord.y` (number): The Y-coordinate of the text position.
  * `firstCoord.z` (number): The Z-coordinate of the text position.
* `text` (string, optional): The text to be displayed. If not provided, defaults to "Text was not set!".
* `colors` (table, optional): A table of color codes for the text. If not provided, defaults to a predefined set of rainbow colors.
* `interval` (number): The time interval in milliseconds to control the color change speed.

### Usage

```lua
mCore.Draw3DRainbowText(coords, text, colors, interval)

mCore.Draw3DRainbowText(vector3(107.776,-1944.712,19.8), "Your day become a awsome", nil, 1000)
```

## mCore.drawWaveText

***

### Description

Draws text in 3D space with a wave-like vertical motion and color-changing effect. The text moves up and down in a wave pattern while cycling through a set of colors over a defined interval.

### Parameters

* `coords` (table): Coordinates for the 3D text.
  * `coords.x` (number): The X-coordinate of the text position.
  * `coords.y` (number): The Y-coordinate of the text position.
  * `coords.z` (number): The Z-coordinate of the text position.
* `text` (string, optional): The text to be displayed. Defaults to "Text was not set!" if not provided.
* `colors` (table, optional): A table of color codes for the text. Defaults to a predefined set of rainbow colors if not provided.
* `interval` (number): The time interval in milliseconds that controls the color change speed and wave motion.

### Usage

```lua
mCore.drawWaveText(coords, text, colors, interval)

mCore.drawWaveText(vector3(107.776,-1944.712,19.8), "Your day become a awsome", nil, 1000)
```

## mCore.loadModel

***

### Description

Requests and loads a model into the game using the `ox_lib` resource. If `ox_lib` is not available, an error message is logged.

### Parameters

* `model` (string): The name of the model to be loaded. This should be a valid model name recognized by the game.

### Dependencies

* `ox_lib`: This resource must be available and properly configured.

### Usage

```lua
mCore.loadModel("my_model")
```

### Explanation

* The function checks if the `ox_lib` resource is available.
* If `ox_lib` is present, it uses `lib.requestModel` to request and load the specified model.
* If `ox_lib` is missing, an error message is logged indicating that the resource is not found.

## mCore.unloadModel

***

### Description

Unloads a model from memory, freeing up resources. This function marks the specified model as no longer needed, allowing the game to reclaim the memory used by it.

### Parameters

* `model` (string): The name of the model to be unloaded. This should be the same name used when the model was loaded.

### Usage

```lua
mCore.unloadModel("my_model")
```

## mCore.loadAnimDict

***

### Description

Requests and loads an animation dictionary into memory. This function waits until the specified animation dictionary is fully loaded before proceeding.

### Parameters

* `dict` (string): The name of the animation dictionary to be loaded.

### Usage

```lua
mCore.loadAnimDict("anim@mp_player_intcelebrationmale@thumbs_up")
```

## mCore.unloadAnimDict

***

### Description

Unloads an animation dictionary from memory, freeing up resources. This function marks the specified animation dictionary as no longer needed.

### Parameters

* `dict` (string): The name of the animation dictionary to be unloaded.

### Usage

```lua
mCore.unloadAnimDict("anim@mp_player_intcelebrationmale@thumbs_up")
```

## mCore.loadPtfxDict

***

### Description

Requests and loads a Particle Effect (Ptfx) dictionary into memory. This function waits until the specified Ptfx dictionary is fully loaded before proceeding.

### Parameters

* `dict` (string): The name of the Ptfx dictionary to be loaded.

### Usage

```lua
mCore.loadPtfxDict("core")
```

## **Description:**

Unloads a Particle Effect (Ptfx) dictionary from memory, freeing up resources. This function marks the specified Ptfx dictionary as no longer needed.

### **Parameters:**

* `dict` (string): The name of the Ptfx dictionary to be unloaded.

### Usage

```lua
mCore.unloadPtfxDict("core")
```



***

## `mCore.makeProp`

***

### **Description:**

Creates a prop in the game world at specified coordinates. The prop can be frozen in place and optionally synced with other players.

### **Parameters:**

* `data` (table): A table containing:
  * `prop` (string): The model name of the prop to create.
  * `coords` (vector4): Coordinates and heading where the prop will be placed (`x`, `y`, `z`, `w`).
* `freeze` (boolean, optional): Whether to freeze the prop's position. Defaults to `false`.
* `synced` (boolean, optional): Whether the prop should be synced across clients. Defaults to `false`.

**Usage:**

```lua
mCore.makeProp({
     prop   = "prop_barier_conc_01b",
     coords = vec3(0.0, 0.0, 0.0),
}, true --[[freezed]], false --[[synced]])

mCore.makePed("model", vec3, freeze, collision, "scenario", "anim")
```

### Explanation

* Loads the model for the prop.
* Creates the prop at the specified coordinates with an optional heading adjustment.
* Optionally freezes the prop's position and syncs it across clients.
* Logs debug information if debugging is enabled.

## `mCore.makeBlip`

***

### **Description:** Creates a blip on the game map at specified coordinates. The blip can be customized with various properties.

### **Parameters:**

* `data` (table): A table containing:
  * `coords` (vector3): Coordinates where the blip will be placed (`x`, `y`, `z`).
  * `sprite` (number, optional): Sprite ID for the blip. Defaults to `1`.
  * `col` (number, optional): Color ID for the blip. Defaults to `0`.
  * `scale` (number, optional): Scale of the blip. Defaults to `0.7`.
  * `disp` (number, optional): Display type for the blip. Defaults to `6`.
  * `category` (number, optional): Category ID for the blip.
  * `name` (string): Name of the blip.

### **Usage:**

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

### **Explanation:**

* Adds a blip at the specified coordinates.
* Customizes the blip with optional properties such as sprite, color, scale, and name.
* Logs debug information if debugging is enabled.

## `mCore.makePed`

***

### **Description:** Creates a pedestrian (Ped) in the game world at specified coordinates. The Ped can be customized with various properties such as freezing, collision, and animation.

### **Parameters:**

* `model` (string): The model name of the Ped to create.
* `coords` (vector4): Coordinates and heading where the Ped will be placed (`x`, `y`, `z`, `w`).
* `freeze` (boolean, optional): Whether to freeze the Ped's position. Defaults to `true`.
* `collision` (boolean, optional): Whether to enable collision with the Ped. Defaults to `false`.
* `scenario` (string, optional): Name of the scenario to start for the Ped. Defaults to `nil`.
* `anim` (table, optional): A table containing:
  * `animDict` (string): The animation dictionary to load.
  * `animName` (string): The animation name to play.

### **Usage:**

```lua
mCore.makePed(
    "a_m_m_skater_01",
    vector4(100.0, 200.0, 300.0, 90.0),
    true,
    true,
    "WORLD_HUMAN_SMOKING",
    {"anim@mp_player_intcelebrationmale@thumbs_up", "thumbs_up"}
)
```

## `mCore.destroyProp`

***

### **Description:**

Destroys a prop (or any entity) from the game world. It ensures the entity is properly detached and deleted.

### **Parameters:**

* `entity` (number): The handle or ID of the entity (prop) to be destroyed.

### **Usage:**

```lua
mCore.destroyProp(propID)
```

### Explanation

* Marks the entity as a mission entity to prevent it from being removed by the game.
* Waits for a short time to ensure the entity is marked correctly.
* Detaches the entity if it is attached to anything.
* Waits again to ensure detachment.
* Deletes the object from the world.

## `mCore.loadDrillSound`

***

### **Description:**

Loads the audio banks required for the drill sound used in heist scenarios. This ensures that the sound assets are available for use in the game.

### **Usage:**

```lua
mCore.loadDrillSound()
```

## `mCore.unloadScriptHostedSounds`

***

### **Description:**

Releases the sound banks that were previously loaded by the script. This is useful for cleaning up and freeing resources.

### **Usage:**

```lua
ReleaseScriptAudioBank()
```

## `mCore.lookAtMe`

***

### **Description:**

Makes the specified entity (typically a ped) turn to face the player character.

### **Parameters:**

* `entity` (number): The handle or ID of the entity (ped) to be turned.

### **Usage:**

```
mCore.lookAtMe(entityID)
```

### **Explanation:**

* Checks if the entity exists and if it’s not already facing the player.
* Uses `TaskTurnPedToFaceCoord` to turn the entity to face the player.
* Waits for the turn action to complete.

## `mCore.lookEnt`

***

### **Description:**

Turns the player character to face either a position or an entity.

### **Parameters:**

* `entity` (number or vec3): The handle or ID of the entity or a vector3 position to turn towards.

### **Usage:**

```lua
mCore.lookEnt(entityOrPosition)
```

**Explanation:**

* If `entity` is a position (`vec3`), turns the player to face that position.
* If `entity` is a handle or ID, turns the player to face the coordinates of that entity.
* Uses `TaskTurnPedToFaceCoord` for the turning action and waits for completion.

## `mCore.lockInv`

***

### **Description:**

Locks or unlocks the player’s inventory and character movement.

### **Parameters:**

* `toggle` (boolean): `true` to lock the inventory and freeze the player, `false` to unlock.

### **Usage:**

```lua
mCore.lockInv(true)  -- Lock inventory and freeze player
mCore.lockInv(false) -- Unlock inventory and unfreeze player
```

### **Explanation:**

* Freezes the player’s position to prevent movement.
* Sets the player's state to busy and triggers events related to inventory status and hotbar usage.

## `mCore.progressBar`

***

### **Description:**

Displays a progress bar with optional animation and cancel options using `ox_lib`.

### **Parameters:**

* `data` (table): A table containing the following keys:
  * `time` (number): Duration of the progress bar in milliseconds.
  * `label` (string): Label to display on the progress bar.
  * `dead` (boolean, optional): Whether to allow progress while dead (default: `false`).
  * `cancel` (boolean, optional): Whether to allow cancellation of the progress bar (default: `true`).
  * `dict` (string, optional): Animation dictionary.
  * `anim` (string, optional): Animation clip.
  * `flag` (number, optional): Animation flag (default: `32` if `8` is provided).
  * `task` (string, optional): Task scenario.

### **Usage:**

```lua
mCore.progressBar({
    time = 5000,
    label = "Processing...",
    dead = false,
    cancel = true,
    dict = "anim_dict",
    anim = "anim_clip",
    flag = 32,
    task = "scenario_name"
})
```

### **Explanation:**

* Utilizes `ox_lib` to display a progress bar.
* Handles animation and task scenarios if provided.
* Locks and unlocks the player’s inventory during the progress.

## `mCore.HasItem`

***

### **Description:**

Checks if the player has a specific amount of an item using `ox_inventory`.

### **Parameters:**

* `items` (string): The name or ID of the item to check.
* `amount` (number, optional): The required amount of the item (default: `1`).

### **Usage:**

```lua
local hasItem = mCore.HasItem("item_name", 5)

if mCore.HasItem("water_bottle", 5) then
    print("Player has enough water bottles.")
else
    print("Player does not have enough water bottles.")
end
```

### **Explanation:**

* Uses `ox_inventory` to check the player’s inventory.
* Returns `true` if the player has the specified amount of the item, otherwise `false`.

## `mCore.pairsByKeys`

***

### **Description:**

Returns an iterator that allows iterating over the keys of a table in sorted order.

### **Parameters:**

* `t` (table): The table to sort and iterate over.

### **Usage:**

```lua
for key, value in mCore.pairsByKeys(myTable) do
    print(key, value)
end

-- Example table
local myTable = {b = 2, a = 1, c = 3}

-- Iterate over table keys in sorted order
for key, value in mCore.pairsByKeys(myTable) do
    print(key, value)  -- Output: a 1, b 2, c 3
end
```

### **Explanation:**

* Sorts the keys of the table in ascending order.
* Provides an iterator to access each key-value pair in sorted order.
