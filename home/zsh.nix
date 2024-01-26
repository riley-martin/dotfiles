{ pkgs, ... }: {
	  programs.zsh = {
    enable = true;
    defaultKeymap = "viins";
    autocd = true;
    # enableVteIntegration = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    initExtraFirst = ''
      export PATH="$HOME/bin:$HOME/.cargo/bin:$HOME/.ghcup/bin:$PATH"
      # zmodload zsh/zprof
    '';
    initExtra = ''
      # zprof
      eval "$(direnv hook zsh)"
    '';
    sessionVariables = {
      EDITOR = "hx";
      PATH = "$HOME/bin:$HOME/.cargo/bin:$PATH";
    };
    shellAliases = {
      ls = "lsd -A";
      lsd = "lsd -A";
      
    };
    plugins = [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.5.0";
          sha256 = "0za4aiwwrlawnia4f29msk822rj9bgcygw6a8a6iikiwzjjz0g91";
        };
      }
    ];
  };
}
