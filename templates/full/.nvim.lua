local lspconfig = require('lspconfig')

local old = lspconfig.nixd

lspconfig.nixd.setup({
    cmd = old.cmd,
    settings = {
        nixd = {
            nixpkgs = {
                expr = 'import (builtins.getFlake ("git+file://" + toString ./.)).inputs.nixpkgs {}',
            },
            formatting = {
                command = { "alejandra" },
            },
            options = {
                nixos = {
                    expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.ragnarok.options',
                },
                home_manager = {
                    expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."py@ragnarok".options'
                },
            },
        },
    },
})
