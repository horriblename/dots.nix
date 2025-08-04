.PHONY: nixos build-hm hm nix-on-droid

build-nixos: ## Build NixOS config
	nix build .#nixosConfigurations.$$(hostname).config.system.build.toplevel

nixos: ## nixos-rebuild switch
	IMPURITY_PATH="$$PWD" nh os switch . -- --impure -L --show-trace

build-hm: ## Build HM config
	nix build .#homeConfigurations."$$(whoami)@$$(hostname)".activationPackage -L

hm: ## Switch HM config
	IMPURITY_PATH="$$PWD" nh home switch . -- --impure -L --show-trace

nix-on-droid: ## nix-on-droid switch
	nix-on-droid switch --flake .

surface-kernel: ## surface kernel
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

