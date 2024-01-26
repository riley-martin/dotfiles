{ ... }: {
  programs.rio = {
    enable = true;
    settings = {
      cursor = "|";
      editor = "hx";
      hide-cursor-when-typing = false;
      padding-x = 8;
      window = {
        background-opacity = 0.7;
        decorations = "Disabled";
      };
      fonts = {
        size = 18;
        regular = {
          family = "Victor Mono";
          style = "Regular";
        };
        bold = {
          family = "Victor Mono";
          style = "Bold";
        };
        italic = {
          family = "Victor Mono";
          style = "Italic";
        };
        bold-italic = {
          family = "Victor Mono";
          style = "Bold Italic";
        };
      };
    };
  };
}
