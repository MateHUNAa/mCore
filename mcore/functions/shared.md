# Shared

## Logging Functions

***

## mCore.log

***

### Description

Logs general messages to the console with the resource name as a prefix.

### Parameters

* `message` (string): The message to be logged.

### Usage

```lua
mCore.log("This is a general log message.")
```

### Output Example

```markdown
[ ^4your-resource-name^0 ]: This is a general log message.
```

## mCore.error

***

### Description

Logs error messages to the console. If an invoking resource is specified, it is used in the log prefix; otherwise, the current resource is used.

### Parameters

* `message` (string): The error message to be logged.
* `invoke` (string, optional): The invoking resource name. If not provided, the current resource is used.

### Usage

```lua
mCore.error("This is an error message.")
```

```lua
mCore.error("This is an error message with a specified invoking resource.", "other-resource")
```

### Output Example

```markdown
[ ^4your-resource-name^0 ]: ^1[Err]:^0 This is an error message.
```

```markdown
[ ^4other-resource^0 ]: ^1[Err]:^0 This is an error message with a specified invoking resource.
```

## mCore.debug.log

***

### Description

Logs debugging messages to the console if debugging mode is enabled. This function is useful for verbose output during development.

### Parameters

* `message` (string): The debug message to be logged.

### Usage

```lua
mCore.debug.log("This is a debug message.")
```

### Output Example (when debugging is enabled)

```markdown
[ ^4your-resource-name^0 ]: This is a debug message.
```

## mCore.debug.error

***

### Description

Logs debugging error messages to the console if debugging mode is enabled. This function provides additional information about errors during development.

### Parameters

* `message` (string): The debug error message to be logged.

### Usage

```lua
mCore.debug.error("This is a debug error message.")
```

### **Output Example (when debugging is enabled):**

```markdown
[ ^4your-resource-name^0 ]: ^1[Err]:^0 This is a debug error message.
```



## Note

***

Debugging messages are only printed if the `debug` variable is set to `true`. Ensure that `debug` is properly configured in your script.



## Enableing Debug mode

Put this into your server.cfg to enable debug mode.

```properties
setr matehun:global_debug 1
```

