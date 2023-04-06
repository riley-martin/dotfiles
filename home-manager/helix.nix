{lib, pkgs, ...}: {
  programs.helix = {
    enable = true;
    # package = (pkgs.callPackage ./pkgs/helix.nix {});
    languages = [
      {
        name = "rust";
        config = {
          checkOnSave = { command = "clippy"; };
          cargo = { allFeatures = true; };
          procMacro = { enable = true; };
          auto-format = true;
        };
        language-server = {
          command = "rust-analyzer";
          # command = lib.getExe pkgs.rustup;
          # args = ["run" "stable" "rust-analyzer" ];
        };
      }
      {
        name = "nix";
        language-server = { command = lib.getExe pkgs.nil; };
        formatter = { command = "${pkgs.nix}/bin/nix fmt"; };
      }
    ];
    settings = {
      theme = "ayu_dark";
      editor = {
        bufferline = "multiple";
        scrolloff = 4;
        shell = [ "zsh" ];
        color-modes = true;
        idle-timeout = 200;
        cursorline = true;
        indent-guides = { character = "│"; render = true; };
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
