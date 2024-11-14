.PHONY: nixos build-hm hm nix-on-droid

build-nixos: ## Build NixOS config
	nix build .#nixosConfigurations.ragnarok.config.system.build.toplevel

nixos: ## nixos-rebuild switch
	sudo nix run nixpkgs#nixos-rebuild -- switch --flake . -L

build-hm: ## Build HM config
	nix build nixpkgs#homeConfigurations."py@archbox".activationPackage -L

hm: ## Switch HM config
	nix run nixpkgs#home-manager -- switch --impure --flake . -L --show-trace

nix-on-droid: ## nix-on-droid switch
	nix-on-droid switch --flake .

surface-kernel:
	nix build .\#ghActionsBuilder2 --print-out-paths --option cores "$$(($$(nproc) - 2))" | cachix push horriblename

# Hint: suppress override warnings by prepending "-" to the rule
# e.g.
# -hm:
#  	...
#
# Optional include
include $(wildcard local.mk)

help: ## Prints help for targets with comments
	@cat $(MAKEFILE_LIST) | grep -E '^[a-zA-Z_-]+:.*?## .*$$' | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

