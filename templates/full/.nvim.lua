vim.lsp.config("nixd", {
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
					expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."py@ragnarok".options',
				},
			},
		},
	},
})
