-- Copyright (c) 2018 Capital-Ex

-- Permission is hereby granted, free of charge, to any person obtaining a copy of
-- this software and associated documentation files (the "Software"), to deal in
-- the Software without restriction, including without limitation the rights to
-- use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
-- of the Software, and to permit persons to whom the Software is furnished to do
-- so, subject to the following conditions:

-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.

-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.

local Signal = {}
local signals = {}

function Signal.emit(name, ...)
    if signals[name] then
        local signal = signals[name]

        for listener, method in pairs(signal.listeners) do
            if type(listener) == "table" then
                listener[method](listener, ...)
            elseif type(listener) == "function" then
                listener(...)
            end
        end
    end
end

function Signal.register(name)
    signals[name] = setmetatable({listeners = {}}, {__mode = "k"})
end

function Signal.connect(name, object, method)
    signals[name].listeners[object] = method
end

function Signal.disconnect(name, object, method)
    signal[name].listeners[object] = nil
end


return Signal
