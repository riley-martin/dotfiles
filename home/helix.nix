{lib, pkgs, ...}: {
  programs.helix = {
    enable = true;
    # package = (pkgs.callPackage ./pkgs/helix.nix {});
    languages = { 
      language-server.rust-analyzer = {
        command = "rust-analyzer";
        config = {
          checkOnSave = { command = "clippy"; };
          cargo = { allFeatures = true; };
          procMacro = { enable = true; };
          auto-format = true;
        };
      };
      language-server.nil = {
        command = lib.getExe pkgs.nil;
      };
      language = [
        {
          name = "rust";
          language-servers = [{
            name = "rust-analyzer";
          }];
        }
        {
          name = "nix";
          language-servers = [{ name = "nil"; }];
          formatter = { command = "${pkgs.nix}/bin/nix fmt"; };
        }
      ];
    };
    settings = {
      theme = "dracula_at_night";
      editor = {
        bufferline = "multiple";
        scrolloff = 4;
        shell = [ "zsh" ];
        color-modes = true;
        idle-timeout = 200;
        cursorline = true;
        indent-guides = { character = "⏐"; render = true; };
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        file-picker.hidden = false;
        lsp.display-messages = true;
        search.smart-case = false;
        statusline = {
          separator = "│";
          left = [
            "spinner"
            "mode"
            "diagnostics"
          ];
          center = [
            "file-name"
            "separator"
            "file-line-ending"
            "file-type"
            "file-encoding"
          ];
          right = [
            "selections"
            "position"
            "total-line-numbers"
          ];
        };
      };
    };
  };
}
