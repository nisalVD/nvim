return {
  {
    "stevearc/overseer.nvim",
    cmd = {
      "OverseerOpen",
      "OverseerClose",
      "OverseerToggle",
      "OverseerRun",
      "OverseerBuild",
    },
    opts = {
      templates = {
        "builtin",
        "user.cpp_build",
      },
    },
  },
}
