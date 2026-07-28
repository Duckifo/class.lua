-- class.lua under MIT Licence.
-- * source from: github.com/duckifo/class.lua
--
-- Copyright 2026 duckifo <duckifo@github.com>
--
-- Permission is hereby granted, free of charge, to any
-- person obtaining a copy of this software and associated
-- documentation files (the “Software”), to deal in the
-- Software without restriction, including without
-- limitation the rights to use, copy, modify, merge,
-- publish, distribute, sublicense, and/or sell copies of
-- the Software, and to permit persons to whom the Software
-- is furnished to do so, subject to the following
-- conditions:
--
-- The above copyright notice and this permission notice
-- shall be included in all copies or substantial portions
-- of the Software.
--
-- THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY
-- KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
-- THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
-- PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
-- THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
-- DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
-- CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
-- CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
-- IN THE SOFTWARE.
--

--- Class interface, tries to stay minimal with
--- functionality staying inside the Class-Module.
---@class Class  -- USER-NOTE: worth name spacing this. 
---
--- A reference to the actual class instance / constructor.
--- Used to uniquely identify and track relations between classes.
---@field class Class
---
--- A human readable id of the class.
---@field type string
---
local Class = {}
Class.__index = Class
Class.class = Class
Class.type = "Class"

--- Creates and returns a new instance of the current class,
--- forwards arguments to class Init implementation.
--- @return self
function Class:New(...)
    local obj = setmetatable({}, self) 
    obj:Init(...)
    return obj
end

--- Interface method, meant to be overridden by deriving
--- instances of class.
function Class:Init(...) end

--- The Class-Module implements functionality for the Class
--- object, the distinction between functionality and Object
--- is to keep the Class namespace minimal.
local ClassModule = {}

--- The base of all classes.
ClassModule.RootClass = Class

--- Defines a new class deriving from the seconds parameter,
--- or base class if no second parameter passed.
---@param name string Name of the new class.
---@param extending Class?
---@return Class
function ClassModule.Define(name, extending)
    extending = extending or Class

    local cls = setmetatable({}, extending)
    cls.__index = cls
    cls.class = cls
    cls.type = extending.type .. "." .. name

    return cls
end

--- Returns true if passed parameter has properties of a
--- class object.
---@param value any
---@return boolean
---@return_cast value +Class
function ClassModule.IsClassObject(value)
    if type(value) ~= "table" then return false end
    if type(value["class"]) ~= "table" then return false end
    if type(value["type"]) ~= "string" then return false end

    -- Edge case for RootClass as it doesn't have a
    -- metatable but is still considered a class.
    if value.class == ClassModule.RootClass then
        return true
    end

    local hasMetaTable = getmetatable(value) ~= nil  
    if not hasMetaTable then 
        return false
    end

    return true
end

--- Returns the super class of the passed class. Returns nil
--- on cases like RootClass where the class doesn't own a
--- metatable.
--- @param cls Class
--- @return Class?
function ClassModule.Super(cls)
    return getmetatable(cls.class)
end

--- Returns true if the second passed class derives from the
--- first passed class, otherwise returns false.
--- @generic T: Class
--- @param a Class Base class 
--- @param b T Derived class
--- @return boolean
function ClassModule.IsOf(a, b)
    -- Edge case if base is found to be RootClass. Because
    -- later loop will not catch it.
    if a.class == ClassModule.RootClass then return true end

    while b ~= nil do
        if b.class == a.class then return true end
        b = ClassModule.Super(b)
    end

    return false
end

return ClassModule
