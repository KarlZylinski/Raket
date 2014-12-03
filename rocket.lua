require "shared/tuple"
require "thruster"

local apply_gravity, apply_thrust, calculate_rotation, calculate_thrust, limit_velocity, limit_horizontal_velocity, limit_vertical_velocity, read_input

Rocket = class(Rocket)

function Rocket:init()
    self._thruster = Thruster()
    self._velocity = Vector2(0, 0)
end

function Rocket:spawn(world)
    self._entity = Entity.create(world)
    SpriteRenderer.create(self._entity, Vector2(0,0), Vector2(45, 128))
    local material = Engine.load_resource("material", "sprites/rocket.material")
    SpriteRenderer.set_material(self._entity, material)
    Transform.set_position(self._entity, Vector2(200, 0))
    Transform.set_pivot(self._entity, Vector2(22.5, 64))
    self._thruster:spawn(world)
    self._thruster:set_parent(self._entity)
end

function Rocket:update(dt, view_size)
    local input = read_input()
    local rotation = calculate_rotation(Transform.rotation(self._entity), input, dt)
    Transform.set_rotation(self._entity, rotation)
    self._velocity = apply_gravity(self._velocity, dt)
    self._thruster:update(input, dt)
    self._velocity = apply_thrust(self._velocity, self._thruster:thrust(), rotation, dt)
    self._velocity = limit_velocity(self._velocity)
    local new_pos = Transform.position(self._entity) + self._velocity * dt
    local sprite_size = Tuple.second(SpriteRenderer.rect(self._entity))

    if new_pos.y > view_size.y - sprite_size.y then
        new_pos.y = view_size.y - sprite_size.y
        self._velocity = Vector2(0, 0)
    end

    Transform.set_position(self._entity, new_pos)
end

function Rocket:position()
    return Transform.position(self._entity)
end

apply_gravity = function(current_velocity, dt)
    return current_velocity + Vector2(0, 9.82 * 300 * dt);
end

apply_thrust = function(current_velocity, current_thrust, rotation, dt)
    local vertical_velocity_change = current_thrust * dt
    return current_velocity + Vector2(-vertical_velocity_change * math.sin(rotation),
        vertical_velocity_change * math.cos(rotation))
end

calculate_rotation = function(current_rotation, input, dt)
    return current_rotation + input.x * 5 * dt
end

limit_velocity = function(current_velocity)
    return Vector2(limit_horizontal_velocity(current_velocity.x), limit_vertical_velocity(current_velocity.y))
end

limit_horizontal_velocity = function(current_horizontal_velocity)
    if current_horizontal_velocity < -500 then
        return -500
    elseif current_horizontal_velocity > 500 then
        return 500
    end

    return current_horizontal_velocity
end

limit_vertical_velocity = function(current_vertical_velocity)
    if current_vertical_velocity < -1000 then
        return -1000
    elseif current_vertical_velocity > 1000 then
        return 1000
    end

    return current_vertical_velocity
end

read_input = function()
    local input = Vector2(0, 0)

    if Keyboard.held("Up") then
        input.y = -1
    end

    if Keyboard.held("Down") then
        input.y = 1
    end

    if Keyboard.held("Left") then
        input.x = input.x - 1
    end

    if Keyboard.held("Right") then
        input.x = input.x + 1
    end

    return input
end

return Rocket
