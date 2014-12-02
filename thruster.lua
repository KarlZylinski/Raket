require "shared/math"

Thruster = class(Thruster)

function Thruster:init()
    self._material = Engine.load_resource("material", "fire.material")
    self._thrust = 0
    self._flare = 0
end

function Thruster:spawn(world)
    self._entity = Entity.create(world)
    SpriteRenderer.create(self._entity, Vector2(0,0), Vector2(30,80))
    local sprite_size = Tuple.second(SpriteRenderer.rect(self._entity))
    Transform.set_pivot(self._entity, Vector2(sprite_size.x * 0.5, 0))
    SpriteRenderer.set_material(self._entity, self._material)
end

function Thruster:set_parent(parent)
    Transform.set_parent(self._entity, parent)
    local sprite_size = Tuple.second(SpriteRenderer.rect(self._entity))
    local parent_size = Tuple.second(SpriteRenderer.rect(parent))
    Transform.set_position(self._entity, Vector2(0, parent_size.y * 0.5 - sprite_size.y * 0.5 - 3))
end

function Thruster:update(input, dt)
    if Keyboard.pressed("R") then
        Engine.reload_resource("shader", "background.shader")
    end

    max_thrust = 5000
    self._thrust = math.min(0, input.y) * max_thrust
    self._flare = self._flare - dt * 4
    self._flare = self._flare - input.y * dt * 20
    self._flare = clamp(self._flare, 0, 1)
    Material.set_uniform_value(self._material, "thrust", self._flare)
end

function Thruster:thrust()
    return self._thrust
end
