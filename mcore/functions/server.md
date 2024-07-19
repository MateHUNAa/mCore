# Server

## **Get Shared Object**

***

Retrieve the shared object for accessing core functions.

```lua
mCore = exports["mateExports"]:getSharedObj()
```

## mCore**.**getDiscordToken

***

```lua
local botToken = exports["mateExports"]:getDiscordToken()
```

## mCore.versionCheck

***

Checking the github repositories latest version.

```lua
mCore.versionCheck("MateHUNAa/mCore")
```

## mCore.createSQLColumnToUsers <a href="#createsqlcolumntousers" id="createsqlcolumntousers"></a>

***

Example:

```lua
mCore.createSQLColumnToUsers("new_column", "VARCHAR", 255):next(function(success)
    if success then
        print("Column added successfully.")
    else
        print("Column already exists.")
    end
end)
```



## mCore.createSQLTable

***

This function creates a new SQL table with the specified name and columns if it does not already exist.

**Parameters**

* `tableName` (string): The name of the table to be created.
* `tableRows` (table): A table containing the column definitions.

### Returns

* An object with the properties:
  * `exists`   (boolean): `true` if the table already exists, `false` otherwise.
  * `created` (boolean): `true` if the table was created, `false` if the creation failed.
  * `success` (boolean): `true` if the operation succeeded, `false` otherwise.

Example

```lua
local tableRows = {
    "`id` INT AUTO_INCREMENT PRIMARY KEY",
    "`name` VARCHAR(255) NOT NULL",
    "`email` VARCHAR(255) NOT NULL"
}

mCore.createSQLTable("new_table", tableRows):next(function(result)
    if result.exists then
        print("Table already exists.")
    elseif result.created then
        print("Table created successfully.")
    else
        print("Failed to create table.")
    end
end)
```

## mCore.getPlayers

***

### Description

The `mCore.getPlayers` function gathers and returns a list of all active players in the ESX framework. It includes detailed information such as the player's source ID, identifier, name, job, Discord ID, admin status, and VIP status (if the VIP system is present).

### Returns

* A table (`mPlayers`) containing information about each player with the following fields:
  * `source` (number): The player's source ID.
  * `identifier` (string): The player's unique identifier.
  * `name` (string): The player's name.
  * `job` (string): The player's job title.
  * `vip` (string or nil): The player's VIP status if the VIP system is available; otherwise, `nil`.
  * `discordId` (string): The player's Discord ID.
  * `isAdmin` (string or nil): The player's admin status if the admin system is available; otherwise, `nil`.

### Usage

Here is how you can use the `mCore.getPlayers` function in your script:

```lua
local players = mCore.getPlayers()

for _, player in ipairs(players) do
    print(("Source: %d, Name: %s, Job: %s, Discord ID: %s, Admin: %s, VIP: %s"):format(
        player.source,
        player.name,
        player.job,
        player.discordId,
        player.isAdmin or "None",
        player.vip or "None"
    ))
end
```

## mCore.mPlayer

***

### Description

Retrieves information about a specific player by their source ID from the list of active players.

### Returns

A table of the player's details or `nil` if not found.

### Usage

```lua
local player = mCore.mPlayer(playerId)
if player then
    print(("Source: %d, Name: %s, Job: %s, Discord ID: %s, Admin: %s, VIP: %s"):format(
        player.source,
        player.name,
        player.job,
        player.discordId,
        player.isAdmin or "None",
        player.vip or "None"
    ))
else
    print("Player not found.")
end
```

## mCore.getXPlayer

***

### Description

Retrieves an `xPlayer` object from the ESX framework using the player's source ID. This function waits until the `xPlayer` object is available.

### Parameters

`source` (number): The player's source ID.

### Returns

The `xPlayer` object associated with the given source ID.

### Usage

```lua
local xPlayer = mCore.getXPlayer(playerId)

if xPlayer then
    print(("Source: %d, Name: %s, Job: %s"):format(
        xPlayer.source,
        xPlayer.getName(),
        xPlayer.getJob().label
    ))
else
    print("xPlayer not found.")
end
```

## mCore.GetDiscord

***

### Description

Retrieves Discord information for a player based on their source ID. This includes the Discord image URL, name, and ID, which are queried from the database.

### Parameters

* `src` (number): The player's source ID.
* `cb` (function): A callback function that will be called with the result object.

### Returns

* `img` (string or nil): The URL of the Discord profile image.
* `name` (string or nil): The Discord username.
* `id` (string or nil): The Discord ID.
* `dUser` (table or nil): A nested table with Discord user details.
* `error` (string or nil): Error message if the user was not found or if the response is nil.
* `errCode` (number): Error code (0 for success, 1 for failure).

### Usage

```lua
mCore.GetDiscord(playerId, function(res)
    if not res.errCode == 0 then
        return mCore.error(res.error)
    end

    -- dUser interface can be found on Downloands: snippet.json
    local dUser = res.dUser
    
       print(("Discord Name: %s, ID: %s, Image URL: %s"):format(
            dUser.name,
            dUser.id,
            dUser.img
        ))
end)
```

## mCore.GetDiscordByIdentifier

***

### Description

Retrieves Discord information for a user based on their identifier. This includes the Discord profile image URL, name, and ID, which are queried from the database.

### Parameters

* `identifier` (string): The user's unique identifier.
* `cb` (function): A callback function that will be called with the result object.

### Returns

* `img` (string or nil): The URL of the Discord profile image.
* `name` (string or nil): The Discord username.
* `id` (string or nil): The Discord ID.
* `error` (string or nil): Error message if the Discord user cannot be retrieved.
* `errCode` (number): Error code (0 for success, 1 for failure).

### Usage

<pre class="language-lua"><code class="lang-lua">mCore.GetDiscordByIdentifier(playerIdentifier, function(result)
        if not res.errCode == 0 then
            return mCore.error(res.error)
        end

        -- dUser interface can be found on Downloands: snippet.json
        local dUser = res.dUser

    
<strong>    print(("Discord Name: %s, ID: %s, Image URL: %s")
</strong>        :format(
        dUser.name, 
        dUser.id, 
        dUser.img
        )
    )
end)
</code></pre>

## mCore.RequestWebhook

### Description

Retrieves the URL of a specified webhook from the `mCore.webhooks` table. If the specified webhook name does not exist in the table, it returns a default webhook URL from `Config.Webhook`.

### Parameters

* `webhookName` (string): The name of the webhook to retrieve. The function performs a case-insensitive match.

### Returns

* The URL of the webhook if found in the `mCore.webhooks` table.
* The default URL from `Config.Webhook` if the webhook name is not found.

### Usage

```lua
local webhookURL = mCore.RequestWebhook("exampleWebhookName")
print("Webhook URL: " .. webhookURL)
```

## mCore.sendMessage

***

### Description

Sends a message to a Discord webhook using default or specified webhook URL and bot name. This function wraps around `sendMessage` and provides default values for the webhook URL and bot name.

### Parameters

* `message:` (string): The content of the message to be sent.
* `webhook?:` (string): The URL of the Discord webhook. If not specified, it uses the default from `Config.Webhook`.
* `botName?:` (string,): The name to be displayed as the message sender. Defaults to `"mateExports"` if not specified.

### Usage

```lua
local webhook = mCore.RequestWebhook("money")
mCore.sendMessage("Here's a test message being sent through the money webhook.", webhook, "CustomBotName")
```

## mCore.sendEmbed

***

### Description

Sends an embedded message to a specified Discord webhook. This function posts an embed to the Discord webhook URL with a given name and embed content.

### Parameters

* `Webhook` (string): The URL of the Discord webhook to which the embed will be sent.
* `name` (string): The name to be displayed as the message sender.
* `embed` (table): The embed content to be sent. This must be a table formatted according to Discord's embed structure.

### Usage

<pre class="language-lua"><code class="lang-lua">local webhook = mCore.RequestWebhook("global")
<strong>sendEmbed(webhook, "CustomBotName", {
</strong>    {
        title = "Example Embed",
        description = "This is an example embed description.",
        color = 123456,
        fields = {
            { name = "Field 1", value = "Value 1", inline = true },
            { name = "Field 2", value = "Value 2", inline = true }
        }
    }
})
</code></pre>

## mCore.getVIPUser

***

### Description

Retrieves VIP status information for a player based on their player ID. This function uses Discord ID to check VIP status and level from the `mate-vipsystem` resource.

### Parameters

* `pid` (number): The player's ID.
* `cb` (function): A callback function that will be called with the result object.

### Returns

The callback function receives an object with the following fields:

* `errCode` (number): Error code (0 for success, 1 for failure).
* `message` (string): Success or error message.
* `vipUser` (table): VIP information, including:
  * `isVip` (boolean): Indicates if the player is a VIP.
  * `level` (number): The VIP level of the player.

### Dependencies

`mate-vipsystem`: This resource must be available and properly configured.

### Usage

<pre class="language-lua"><code class="lang-lua">mCore.getVIPUser(playerId, function(result)

 if not res.errCore == 0 then
        return mCore.error(res.message)
    end
    
     -- vipUser interface can be found on Downloands: snippet.json
    local vipUser = res.vipUser
<strong>    print(("VIP Status: %s, Level: %d"):format(
</strong>            vipUser.isVip and "Yes" or "No",
            vipUser.level
        ))
end)

</code></pre>
