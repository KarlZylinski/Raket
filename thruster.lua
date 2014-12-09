require "shared/math"

Thruster = class(Thruster)

function Thruster:init()
    self.material = Engine.load_resource("material", "fire.material")
    self.force = 0
    self.throttle = 0
    self.flare = 0
end

function Thruster:spawn(world)
    self.entity = Entity.create(world)
    SpriteRenderer.create(self.entity, Vector2(0,0), Vector2(30,80))
    local sprite_size = Tuple.second(SpriteRenderer.rect(self.entity))
    Transform.set_pivot(self.entity, Vector2(sprite_size.x * 0.5, 0))
    SpriteRenderer.set_material(self.entity, self.material)
end

function Thruster:set_parent(parent)
    Transform.set_parent(self.entity, parent)
    local sprite_size = Tuple.second(SpriteRenderer.rect(self.entity))
    local parent_size = Tuple.second(SpriteRenderer.rect(parent))
    Transform.set_position(self.entity, Vector2(0, parent_size.y * 0.5 - sprite_size.y * 0.5 - 3))
end

function Thruster:update(input, dt)
    if Keyboard.pressed("R") then
        Engine.reload_resource("shader", "background.shader")
    end

    max_throttle = 5000
    self.throttle = math.max(0, input.y) * max_throttle

    if self.throttle > 0 then
        self.force = self.force + self.throttle * dt
    else
        self.force = self.force * 0.3 * dt
    end

    self.flare = self.flare - dt * 4
    self.flare = self.flare + input.y * dt * 20
    self.flare = clamp(self.flare, 0, 1)
    Material.set_uniform_value(self.material, "thrust", self.flare)
end

