{ pkgs, ... }:

{
  home.username = builtins.getEnv "USER";
  home.homeDirectory = builtins.getEnv "HOME";
  home.stateVersion = "24.11";

  programs.home-manager.enable = true;

  # --- Packages (replaces install.sh tool installations) ---
  home.packages = with pkgs; [
    ghq
    fzf
    gh
    glab
    delta
    ripgrep
    fd
    bat
    zoxide
    direnv
    neovim
    starship
    uv
    yazi
    jq
    bash-completion
  ];

  # --- Dotfile symlinks ---
  # All files managed by Home Manager — no ~/.dotfiles dependency.

  home.file.".bash_profile".source = ./config/bash/bash_profile;
  home.file.".profile".source = ./config/bash/profile;
  home.file.".bashrc".source = ./config/bash/bashrc;
  home.file.".bash_alias".source = ./config/bash/bash_alias;
  home.file.".tmux.conf".source = ./config/tmux.conf;
  home.file.".config/nvim" = {
    source = ./config/nvim;
    recursive = true;
  };
  home.file.".config/bash/bashrc.d" = {
    source = ./config/bash/bashrc.d;
    recursive = true;
  };
  home.file.".config/yazi".source = ./config/yazi;
  home.file.".ssh/config" = {
    text = "Include ~/.ssh/conf.d/*.conf\n";
  };
  home.file.".local/bin" = {
    source = ./bin;
    recursive = true;
    executable = true;
  };

  # --- Git (replaces gitconfig.shared + setup_gitconfig) ---
  programs.git = {
    enable = true;
    # user.name and user.email are intentionally omitted
    # (machine-specific, set via ~/.gitconfig or includeIf)

    settings = {
      core = {
        quotePath = false;
        editor = "vim";
        pager = "delta";
      };
      interactive.diffFilter = "delta --color-only";
      delta = {
        navigate = true;
        side-by-side = true;
        line-numbers = true;
      };
      init.defaultBranch = "main";
      diff = {
        algorithm = "histogram";
        colorMoved = "plain";
        mnemonicPrefix = true;
        renames = true;
      };
      push = {
        autoSetupRemote = true;
        followTags = true;
      };
      fetch = {
        prune = true;
        pruneTags = true;
        all = true;
      };
      branch.sort = "-committerdate";
      tag.sort = "version:refname";
      rebase = {
        autoSquash = true;
        autoStash = true;
        updateRefs = true;
      };
      rerere = {
        enabled = true;
        autoupdate = true;
      };
      merge.conflictstyle = "zdiff3";
      commit.verbose = true;
      help.autocorrect = "prompt";
      ghq.root = "~/src";
      alias = {
        st = "status";
        co = "checkout";
        sw = "switch";
        br = "branch";
        ci = "commit";
        di = "diff";
        lg = "log --oneline --graph --decorate";
        aa = "add -A";
        cm = "commit -m";
        amend = "commit --amend --no-edit";
      };
    };

    ignores = [
      "*~"
      ".*~"
      "*.sw[po]"
      ".DS_Store"
    ];
  };

  # --- Shell integration ---
  programs.bash = {
    enable = false; # Don't let home-manager manage .bashrc (we use our own)
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.fzf.enable = true;

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
  };

  programs.starship = {
    enable = true;
    enableBashIntegration = true;
  };
}
