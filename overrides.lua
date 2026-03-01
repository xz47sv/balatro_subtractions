local M = SMODS.current_mod

local POOL_TYPE = nil
local POOL = nil

local get_new_state = function(cards)
    return not UTILS.list_any(
        cards, function(card) return M.config.keys[M.get_key(card)] end
    )
end

local get_visible_cards = function()
    local cards = {}
    for _, area in ipairs(G.your_collection) do
        UTILS.list_extend(cards, area.cards)
    end

    return cards
end

local save = function(super)
    POOL = nil
    POOL_TYPE = nil
    SMODS.save_mod_config(M)
end

UTILS.g_func_wrap('exit_overlay_menu', function(super)
    save()
    super()
end)

UTILS.create_box_wrap('your_collection', function(super)
    save()
    return super()
end)

UTILS.func_wrap(SMODS, 'card_collection_UIBox', function(super, _pool, ...)
    POOL_TYPE = 'cards'
    POOL = SMODS.collection_pool(_pool)

    for _, center in ipairs(POOL) do
        M.key_set_disabled(center.key, M.config.keys[center.key])
    end

    return super(_pool, ...)
end)

UTILS.func_wrap(Card, 'click', function(super, self)
    if UTILS.in_game() or not POOL_TYPE then
        super(self)
        return
    end

    M.key_toggle_disabled(M.get_key(self))
end)

UTILS.func_wrap(Card, 'set_seal', function(super, self, seal, ...)
    if G.GAME.banned_keys[seal] then
        return
    end

    super(self, seal, ...)
end)

SMODS.DrawStep({
    key = 'sub_card_disabled',
    order = 100,
    func = function(self)
        if POOL_TYPE == 'cards' and M.config.keys[M.get_key(self)]
        then
            self.children.center:draw_shader(
                'debuff', nil, self.ARGS.send_to_shader
            )
        end
    end
})

UTILS.Mousebind({
    button = 2,
    event = 'pressed',
    action = function()
        if UTILS.in_game() or not POOL then return end

        if POOL_TYPE == 'cards' then
            local cards = get_visible_cards()
            local state = get_new_state(cards)

            for _, card in ipairs(cards) do
                M.card_set_disabled(card, state)
            end
        end
    end
})

UTILS.Mousebind({
    button = 3,
    event = 'pressed',
    action = function()
        if UTILS.in_game() or not POOL then return end

        if POOL_TYPE == 'cards' then
            local state = get_new_state(get_visible_cards())

            for _, center in ipairs(POOL) do
                M.key_set_disabled(center.key, state)
            end
        end
    end
})

UTILS.Starthook({
    action = function()
        POOL = nil
        POOL_TYPE = nil

        -- apply Cryptids banished keys if they exist
        for k, v in pairs(G.GAME.cry_banished_keys or {}) do
            G.GAME.banned_keys[k] = v
        end

        for k, v in pairs(M.config.keys) do
            if v then
                G.GAME.banned_keys[k] = true
            end
        end

        for k in pairs(M.always_enabled) do
            G.GAME.banned_keys[k] = nil
        end
    end
})
