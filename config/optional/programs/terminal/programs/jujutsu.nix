{self, ...}: {
  hjem.extraModules = [self.hjemModules.jujutsu];
  hj.rum.programs.jujutsu = {
    enable = true;
  };
}
