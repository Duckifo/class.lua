-- Busted tests for class.lua

local ClassModule = require("class")

describe("ClassModule.Define", function()
    it("creates a class with the correct type string", function()
        local Animal = ClassModule.Define("Animal")
        assert.are.equal("Class.Animal", Animal.type)
    end)

    it("derives from RootClass by default", function()
        local Animal = ClassModule.Define("Animal")
        assert.is_true(ClassModule.IsOf(ClassModule.RootClass, Animal))
    end)

    it("doesn't back derive from RootClass.", function()
        local Animal = ClassModule.Define("Animal")
        assert.is_false(ClassModule.IsOf(Animal,ClassModule.RootClass))
    end)

    it("supports multi-level inheritance", function()
        local Animal = ClassModule.Define("Animal")
        local Dog = ClassModule.Define("Dog", Animal)
        assert.is_true(ClassModule.IsOf(Animal, Dog))
        assert.is_true(ClassModule.IsOf(ClassModule.RootClass, Dog))
    end)

    it("does not consider unrelated classes as related", function()
        local Animal = ClassModule.Define("Animal")
        local Vehicle = ClassModule.Define("Vehicle")
        assert.is_false(ClassModule.IsOf(Animal, Vehicle))
    end)
end)

describe("Class:New", function()
    it("calls Init with forwarded arguments", function()
        local Point = ClassModule.Define("Point")
        function Point:Init(x, y)
            self.x = x
            self.y = y
        end

        local p = Point:New(3, 4)
        assert.are.equal(3, p.x)
        assert.are.equal(4, p.y)
    end)
end)

describe("ClassModule.IsClassObject", function()
    it("returns true for class instances", function()
        local Point = ClassModule.Define("Point")
        local p = Point:New()
        assert.is_true(ClassModule.IsClassObject(p))
    end)

    it("returns false for plain tables", function()
        assert.is_false(ClassModule.IsClassObject({}))
    end)

    it("returns false for non-table values", function()
        assert.is_false(ClassModule.IsClassObject(42))
        assert.is_false(ClassModule.IsClassObject("string"))
        assert.is_false(ClassModule.IsClassObject(nil))
    end)
end)
