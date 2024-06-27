{ config, pkgs, ... }:
{
wayland.windowManager.hyprland = {
  # Whether to enable Hyprland wayland compositor
  enable = true;
  # The hyprland package to use
  package = pkgs.hyprland;
  # Whether to enable XWayland
  xwayland.enable = true;
  # Whether to enable hyprland-session.target on hyprland startup
  systemd.enable = true;
  decoration = {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more
    rounding = 10;
 
    blur = {
        enabled = true;
        size = 3;
        passes = 1;
    };
 
    drop_shadow = "yes";
    shadow_range = 4;
    shadow_render_power = 3;
    "col.shadow" = "rgba(1a1a1aee)";
  };
 
  windowrule = [
    "float       , pavucontrol"
    "move 1140 40, pavucontrol"
    "size 40% 40%      , pavucontrol"
    "opacity 0.9 override 0.2, pavucontrol" 
    #"opacity 0.8 override 0.2, firefox-wayland" funzt nicht
  ];
 
  workspace = [
    "1,  monitor:HDMI-A-1, default"
    "2,  monitor:HDMI-A-1"
    "3,  monitor:HDMI-A-2, default"
    "4,  monitor:HDMI-A-2"
    "5,  monitor:HDMI-A-2"
  ];
 
  animations = {
    enabled = "yes";
    bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";
    
    animation = [
      "windows, 1, 7, myBezier"
      "windowsOut, 1, 7, default, popin 80%"
      "border, 1, 10, default"
      "borderangle, 1, 8, default"
      "fade, 1, 7, default"
      "workspaces, 1, 6, default"
    ];
  };

  exec-once = [
    "waybar"
    "hyprpaper"
  ];

  input =  {
    kb_layout = "en";
    follow_mouse = 1;
    touchpad = {
      natural_scroll = "no";
    };
    sensitivity = 0 ;# -1.0 - 1.0, 0 means no modification.
  };

  general = {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more
 
    gaps_in = 5;
    gaps_out = 15;
    border_size = 2;
    "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
    "col.inactive_border" = "rgba(595959aa)";
    layout = "dwindle";
    # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
    allow_tearing = false;
  };

  dwindle = {
    # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
    pseudotile = "yes"; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
    preserve_split = "yes"; # you probably want this
  };

  "$mod" = "SUPER";
  bind = [
    "$mod, F, exec, firefox"
    "$mod, Q, killactive"
    "$mod, T, exec, kitty"
    "$mod, E, exec, nautilus"
    "$mod, O, exec, wlogout"
    "$mod, D, exec, obsidian"
    "$mod, V, togglefloating"
    "$mod,  J, togglesplit"
    "$mod, B, exec, brave"
    "$mod, S, exec, steam"
    "$mod, mouse:272, movewindow"
    "$mod, mouse_down, workspace, e+1"
    "$mod, mouse_up, workspace, e-1"
  ] ++ (
    # workspaces
    # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
    builtins.concatLists (builtins.genList (
      x: let
        ws = let
        c = (x + 1) / 10;
        in
          builtins.toString (x + 1 - (c * 10));
        in [
          "$mod, ${ws}, workspace, ${toString (x + 1)}"
          "$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
        ]
      )
      10
    )
  );      
 
  bindm = [
    "$mod, mouse:272, movewindow"
    "$mod, mouse:273, resizewindow"
  ];
}
