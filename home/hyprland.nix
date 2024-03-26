{ inputs, pkgs, ... }: let 
  swaylock = "swaylock -f -c 000000";
in {
  imports = [ inputs.hyprland-nix.homeManagerModules.default ];
  wayland.windowManager.hyprland = {
    enable = true;
    reloadConfig = true;
    systemdIntegration = true;
    config = {
      general = {
        layout = "dwindle";
        border_size = 2;
        gaps_inside = 4;
        gaps_outside = 8;
        active_border_color = "#aabbcc";
        inactive_border_color = "#aaaaaa";
        cursor_inactive_timeout = 4;
        resize_on_border = true;
        extend_border_grab_area = 4;
      };
      decoration = {
        rounding = 8;
        shadow_range = 8;
        shadow_render_power = 2;
        active_shadow_color = "0x111111";
        inactive_shadow_color = "0x222222";
        blur = {
          size = 4;
          passes = 1;
          ignore_opacity = false;
          xray = true;
          noise = 6.3e-2;
          contrast = 0.75;
          brightness = 0.8;
        };
      };
      input = {
        follow_mouse = 1;
      };
      binds = {};
      gestures =  {
        workspace_swipe = {
          enable = true;
          invert = false;
          min_speed_to_force = 20;
          cancel_ratio = 0.65;
          create_new = true;
          forever = false;
        };
      };
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        force_default_wallpaper = 0;
        key_press_enables_dpms = true;
        mouse_move_enables_dpms = true;
      };
    };
    keyBinds = {
      bind = {
        "SUPER_SHIFT, M" = "exit,";
        "SUPER, R" = "exec, rofi -show run";
        "SUPER, Space" = "exec, rofi -show drun -show-icons";
        "SUPER, Return" = "exec, wezterm";
      };
    };
  };
}
# wayland.windowManager.hyprland = {
#     enable = true;
#     # recommendedEnvironment = true;

#     plugins = [
#         # self.inputs.hyprland-plugins.packages.${pkgs.system}.hyprwinwrap
#     ];

#     settings = {

#         bind = [
#             "ALT,h,movefocus,l"
#             "ALT,l,movefocus,r"
#             "ALT,k,movefocus,u"
#             "ALT,j,movefocus,d"
#         ];

#         monitor = ", preferred, auto, 1";

#         general = {
#             layout = "dwindle";
#             gaps_in = 2;
#             gaps_out = 4;
#             border_size = 2;
#             # col.active_border = 0xa62fd0ff
#             # col.inactive_border = 0x66333333
#             # col.active_border = 0xff5e81ac
#             "col.active_border" = "0xff5e81ac 0xff3edd99 45deg";
#             "col.inactive_border" = "0x66333333";
#             no_cursor_warps = false;
#             cursor_inactive_timeout = 4;

#             apply_sens_to_raw = 0;

#         };

#         input = {
#             # kb_file =
#             kb_layout = "us";
#             # kb_variant = dvp
#             # kb_model =
#             # kb_options = caps:swapescape, shift:both_capslock_cancel
#             kb_options = "compose:menu";
#             # kb_rules =

#             follow_mouse = 1;
#             natural_scroll = true;
#             scroll_method = "2fg";

#             touchpad = {
#               natural_scroll = true;
#               disable_while_typing = true;
#             };

#             sensitivity = 0.40; # -1.0 < sensitivity < 1.0, 0 means no modification.
#         };

#         decoration = {
#             rounding = 8;
#             dim_inactive = false;
#             #screen_shader = /home/riley/.config/hypr/nightlight.frag
#             blur = {
#                 enabled = true;
#                 size = 8;
#                 passes = 2;
#             };
#         };
#         blurls = [ "waybar" "gtk-layer-shell" ];

#         animations = {
#             bezier = "xyz, 0.05, 0.9, 0.1, 1.05";
#             enabled = 1;
#             animation = [
#                 "windows, 1, 4, xyz"
#                 "border, 1, 4, default"
#                 "fade, 1, 4, default"
#                 "workspaces, 1, 4, default"
#             ];
#         };

#         dwindle = {
#             pseudotile = 0; # enable pseudotiling on dwindle
#             preserve_split = true;
#         };

#         gestures = {
#             workspace_swipe = true;
#             workspace_swipe_distance = 200;
#             workspace_swipe_create_new = true;
#         };

#         misc = {
#             animate_manual_resizes = true;
#         };

#         debug = {
#             overlay = false;
#         };

#     };
#     extraConfig = ''
# #
# # Please note not all available settings / options are set here.
# # For a full list, see the wiki (basic and advanced configuring)
# #

# env,HYPRLAND_LOG_WLR,1;

# env,XDG_CURRENT_DESKTOP,"Hyprland";
# env,XDG_SESSION_TYPE,"wayland";
# env,XDG_SESSION_DESKTOP,"Hyprland";

# env,GDK_BACKEND,"wayland";
# env,XCURSOR_SIZE,24;
# env,QT_QPA_PLATFORM,"wayland;xcb";
# env,QT_QPA_PLATFORMTHEME,"qt5ct";
# env,WLR_DRM_NO_MODIFIERS,1;


# # monitor = HDMI-A-1, preferred, 0x0, 1
# # monitor = eDP-1, preferred, 1280x0, 1

# exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP 
# # exec-once = udiskie &
# exec-once = wpaperd
# exec-once = wluma
# exec-once = dunst
# exec-once = gestures
# exec-once = /usr/bin/pipewire & /usr/bin/pipewire-pulse & /usr/bin/wireplumber
# exec-once = eww open bar
# exec-once = swayidle -w timeout 120 'hyprctl dispatch dpms off' timeout 125 '${swaylock}' resume 'hyprctl dispatch dpms on'



# # Make rofi float because tiled launchers suck
# windowrule = float, Rofi
# windowrule = animation slide, Rofi
# windowrule = move 460 128, Rofi
# # windowrule=dimaround, Rofi
# windowrule = size 440 480, class:^(gimp.*)$, title:^(Search Actions)$
# windowrule = float, class:^(Librewolf)$, title:^(Librewolf.*Sharing Indicator)$
# windowrulev2 = rounding 2, xwayland:1
# windowrulev2 = opaque, class:^(org.freecadweb.FreeCAD)$

# # example window rules
# # for windows named/classed as abc and xyz
# #windowrule = move 69 420, abc
# #windowrule = size 420 69, abc
# #windowrule = tile, xyz
# #windowrule = float, abc
# #windowrule = pseudo, abc
# #windowrule = monitor 0, xyz

# # some binds

# $mod = ALT

# bind = $mod, RETURN, exec, alacritty
# bind = $mod, Q, killactive,
# bind = $modSHIFT, M, exit,
# bind = $mod, M, exec, ${swaylock} -f -c 000000
# bind = $mod, E, exec, pcmanfm-t
# bind = $mod, V, togglefloating,
# bind = $mod, R, exec, rofi -show drun
# # bind = $mod, E, exec, rofi -show emoji
# bind = $mod, P, pseudo,
# bind = , Print, exec, grim
# bind = SHIFT, Print, exec, slurp | grim
# bind = $mod, F, fullscreen, 1
# bind = $modSHIFT, F, fullscreen, 0
# # bind = $mod, W, exec, rofi -show window

# bind = , XF86MonBrightnessUp, exec, brillo -A 5
# bind = , XF86MonBrightnessDown, exec, brillo -U 5

# # these are the media control buttons on my laptop function keys
# bindl = , 121, exec, wpctl set-mute '@DEFAULT_SINK@' toggle

# bindl = , 122, exec, wpctl set-volume '@DEFAULT_SINK@' 2%-

# bindl = , 123, exec, wpctl set-volume '@DEFAULT_SINK@' 2%+

# bind = , 255, exec, /home/riley/bin/wifi-toggle

# # mouse bindings
# bindm = $mod, mouse:272, movewindow
# bindm = $mod, mouse:273, resizewindow

# bind = $mod, T, togglegroup
# bind = $mod, Tab, changegroupactive, f
# bind = $modSHIFT, Tab, changegroupactive, b

# # Use vim-style as well as arrow keybindings
# # bind = $mod, left, movefocus, l
# # bind = $mod, H, movefocus, l
# # bind = $mod, right, movefocus, r
# # bind = $mod, L, movefocus, r
# # bind = $mod, up, movefocus, u
# # bind = $mod, K, movefocus, u
# # bind = $mod, down, movefocus, d
# # bind = $mod, J, movefocus, d

# bind = $modCTRL, left, movewindow, l
# bind = $modCTRL, H, movewindow, l
# bind = $modCTRL, right, movewindow, r
# bind = $modCTRL, L, movewindow, r
# bind = $modCTRL, up, movewindow, u
# bind = $modCTRL, K, movewindow, u
# bind = $modCTRL, down, movewindow, d
# bind = $modCTRL, J, movewindow, d

# bind = $modSHIFT, left, resizeactive, -40 0
# bind = $modSHIFT, H, resizeactive, -40 0
# bind = $modSHIFT, right, resizeactive, 40 0
# bind = $modSHIFT, L, resizeactive, 40 0
# bind = $modSHIFT, up, resizeactive, 0 -40
# bind = $modSHIFT, K, resizeactive, 0 -40
# bind = $modSHIFT, down, resizeactive, 0 40
# bind = $modSHIFT, J, resizeactive, 0 40

# bind = , F1, workspace, 1
# bind = , F2, workspace, 2
# bind = , F3, workspace, 3
# bind = , F4, workspace, 4
# bind = , F5, workspace, 5
# bind = , F6, workspace, 6
# bind = , F7, workspace, 7
# bind = , F8, workspace, 8
# bind = , F9, workspace, 9
# bind = , F10, workspace, 10

# bind = $mod, S, togglespecialworkspace, 
# bind = $modSHIFT, S, movetoworkspace, special

# bind = SHIFT, F1, movetoworkspace, 1
# bind = SHIFT, F2, movetoworkspace, 2
# bind = SHIFT, F3, movetoworkspace, 3
# bind = SHIFT, F4, movetoworkspace, 4
# bind = SHIFT, F5, movetoworkspace, 5
# bind = SHIFT, F6, movetoworkspace, 6
# bind = SHIFT, F7, movetoworkspace, 7
# bind = SHIFT, F8, movetoworkspace, 8
# bind = SHIFT, F9, movetoworkspace, 9
# bind = SHIFT, F10, movetoworkspace, 10

# bind = $mod, mouse_down, workspace, e+1
# bind = $mod, mouse_up, workspace, e-1

# bind = $mod, escape, submap, fkey

# submap = fkey
# bind = , escape, submap, reset
# submap = reset
#     '';
#   };
# }
