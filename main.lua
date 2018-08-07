rules = love.graphics.newShader [[
    uniform vec2 normalized;
    const vec4 ON    = vec4(1.0, 1.0, 1.0, 1.0);
    const vec4 OFF     = vec4(0.0, 0.0, 0.0, 1.0);

    vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
        bool left = Texel(texture, texture_coords + vec2( -1.0,  0.0) * normalized) == ON;
        bool middle = Texel(texture, texture_coords) == ON;
        bool right = Texel(texture, texture_coords + vec2( 1.0,  0.0) * normalized) == ON;

        if ((texture_coords.y + normalized.y) >= 1.0) {
            //111, 100, 000
            if ((left && middle && right) || (left && !middle && !right) || (!left && !middle && !right)) {
                return OFF;
            }
            //001, 010, 011, 101, 110
            return ON;
        }
        //If the pixel is not part of the tape, copy from position in the row below
        return Texel(texture, texture_coords + vec2(0.0, 1.0) * normalized);

    }
]]
board = love.graphics.newCanvas(500, 500)
rules:send("normalized", {1 / board:getWidth(), 1 / board:getHeight()})

function love.draw()
    love.graphics.setCanvas(board)
    love.graphics.draw(love.graphics.newImage("seed.png"))
    love.graphics.setCanvas()
    love.draw = function()
        next = love.graphics.newImage(board:newImageData())
        love.graphics.setCanvas(board)
        love.graphics.setShader(rules)
        love.graphics.draw(next)
        love.graphics.setShader()
        love.graphics.setCanvas()
        love.graphics.draw(board)
    end
end
