local M = SMODS.current_mod

M.get_key = function(card)
    local key = card.config.center.key

    if key == 'c_base' then
        if card.seal then
            return card.seal
        end

        for _, sticker in pairs(SMODS.Stickers) do
            if card.ability[sticker.key] then
                return sticker.key
            end
        end
    end

    return key
end

M.get_default = function(_type)
    return M.defaults[_type]
end

M.key_set_disabled = function(key, state)
    if M.always_enabled[key] then
        M.config.keys[key] = nil
    else
        if state == nil then state = false end
        M.config.keys[key] = state
    end
end

M.key_toggle_disabled = function(key)
    M.key_set_disabled(key, not M.config.keys[key])
end

M.card_set_disabled = function(card, state)
    M.key_set_disabled(M.get_key(card), state)
end
