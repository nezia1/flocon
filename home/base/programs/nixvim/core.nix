{ ... }:

{
  programs.nixvim = {
    enable = true;

    viAlias = true;
    vimAlias = true;

    performance.byteCompileLua.enable = true;

    clipboard.providers.wl-copy.enable = true;

    globals.mapleader = " ";

    opts = { 
      smartindent = false;
      relativenumber = true;
      clipboard = "unnamedplus";
    };

    files = {
      "ftplugin/nix.lua" = {
        opts = {
          expandtab = true;
          shiftwidth = 2;
          tabstop = 2;
        };
      };
    };
  };
}