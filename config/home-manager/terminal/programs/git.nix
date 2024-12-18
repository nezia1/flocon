{
  programs.git = {
    enable = true;
    userName = "Anthony Rodriguez";
    userEmail = "anthony@nezia.dev";
    signing = {
      signByDefault = true;
      key = "EE3BE97C040A86CE";
    };
    extraConfig = {
      push.autoSetupRemote = true;
      init = {
        defaultBranch = "main";
      };
    };
  };

  programs.lazygit = {
    enable = true;
  };

  home.shellAliases = {
    lg = "lazygit";
    g = "git";
    gs = "git status";
    gsh = "git show HEAD";
    gshs = "DELTA_FEATURES=+side-by-side git show HEAD";
    ga = "git add";
    gaa = "git add :/";
    gap = "git add -p";
    gc = "git commit";
    gca = "git commit --amend";
    gcm = "git commit --message";
    gcf = "git commit --fixup";
    gk = "git checkout";
    gkp = "git checkout -p";
    gd = "git diff";
    gds = "DELTA_FEATURES=+side-by-side git diff";
    gdc = "git diff --cached";
    gdcs = "DELTA_FEATURES=+side-by-side git diff --cached";
    gf = "git fetch";
    gl = "git log";
    glp = "git log -p";
    glps = "DELTA_FEATURES=+side-by-side git log -p";
    gp = "git push";
    gpf = "git push --force-with-lease";
    gr = "git reset";
    gra = "git reset :/";
    grp = "git reset -p";
    gt = "git stash";
    gtp = "git stash pop";
    gu = "git pull";
  };
}
