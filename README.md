# <center> class.lua </center>

A minimal, single-file class system for Lua, built on metatables. Supports single inheritance, runtime type introspection, and works across Lua 5.1–5.4 and LuaJIT.

## Features

- **Single file, zero dependencies** — just copy `class.lua` into your project.
- **Single inheritance** via metatable chaining.
- **Type introspection** — check whether a value is a class instance (`IsClassObject`) or whether one class derives from another (`IsOf`).
- Fully annotated with EmmyLua annotations for editor autocompletion.

## Installation

### Copy the file

Since it's a single file with no dependencies, you can just drop `class.lua` into your project:
```bash
curl -O https://raw.githubusercontent.com/duckifo/class.lua/main/class.lua
```

## Usage

### Defining a class.

```lua
local Class = require("class")
local Animal = Class.Define("Animal")

function Animal:Init(name)
    self.name = name
end

function Animal:Speak()
    print(self.name .. " makes a sound.")
end
```

### Creating an class instance from a class.

```lua
local rex = Animal:New("Rex")
rex:Speak() -- "Rex makes a sound."
```

### Inheritance

```lua
local Dog = Class.Define("Dog", Animal)

function Dog:Init(name, toys)
    Animal.Init(self, name) -- Call super class Init method with self.
    self.toys = toys or {}
end

function Dog:Play()
    if #self.toys == 0 then
        print(self.name.." doesn't have any toys to play with :(").
        return
    end

    local toy = self.toys[math.randint(1, #self.toys)]
    print(self.name.." played with their "..toy.." toy.")
end

local dave = Dog:New("Dave", { "ball", "rope" })
dave:Speak() -- "Dave makes a sound."
dave:Play()  -- "Dave played with their ball toy."
```

### Runtime checking.

```lua
Class.IsClassObject(dave)      --> true
Class.IsClassObject({})        --> false

Class.IsOf(Animal, dave)       --> true  (Dog derives from Animal)
Class.IsOf(Dog, rex)           --> false (Animal does not derive from Dog)
Class.IsOf(Class.RootClass, dave) --> true (everything derives from RootClass)
```

### Finding a superclass

```lua
local Super = Class.Super(Dog) -- returns Animal
```

## API Reference

| Function | Description |
|---|---|
| `Class.Define(name, extending?)` | Defines a new class. `extending` defaults to the root class if omitted. |
| `Class:New(...)` | Creates a new instance, forwarding arguments to `Init`. |
| `Class:Init(...)` | Interface method meant to be overridden by class. |
| `ClassModule.IsClassObject(value)` | Returns `true` if `value` is a class instance. |
| `ClassModule.IsOf(base, derived)` | Returns `true` if `derived` is, or derives from, `base`. |
| `ClassModule.Super(cls)` | Returns the superclass of `cls`, or `nil` for the root class. |
| `ClassModule.RootClass` | The base class all classes ultimately derive from. |

## License

MIT — see [LICENSE](LICENSE) for the full text.

## Contributing

Issues and pull requests are welcome.
