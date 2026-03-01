local M = SMODS.current_mod

M.always_enabled = UTILS.tbl_merge(
    'force',
    false,
    {
        c_base = true,
        soul = true,
        undiscovered_joker = true,
        undiscovered_tarot = true,
        e_base = true,
        bl_small = true,
        bl_big = true,
        ['High Card'] = true,
    }
)

M.defaults = UTILS.tbl_merge(
    'force',
    false,
    {
        Tarot = 'c_strength',
        Planet = 'c_pluto',
        Spectral = 'c_incantation',
        Joker = 'j_joker',
        Voucher = 'v_blank',
        Tag = 'tag_handy',
        Sticker = 'eternal',
        Booster = 'p_buffoon_normal_1',
        Seal = 'Red',
        Enhanced = 'm_stone',
    },
    M.config.defaults
)

for _, k in pairs(M.defaults) do
    M.always_enabled[k] = true
end

UTILS.require('lib', 'overrides')
