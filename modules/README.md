# NixOS modules

These are the BigBlueButton NixOS modules.
Since they partly depend on helsinki modules, we provide some of them (and stubs) in the `helsinki/` directory.
Since you're probably not using helsinki, you probably need something like:
```nix
{
  imports = [
    "${path/to/bbb4nix}/modules"
    "${path/to/bbb4nix}/modules/helsinki"
  ];
```

`lib.nix` contains some library functions we share across modules.

Every BigBlueButton component (and also stuff that's not in nixpkgs 20.03) has its own module.
There is also the `simple` module (`simple.nix`) which configures the modules for running a BigBlueButton instance on a single host.
