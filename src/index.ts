import express from "express";
import simpleGit from "simple-git";

import { asyncHandler } from "./asyncHandler";

const app = express();
const git = simpleGit();
const repoPath = "/workspace";

app.get("/hello", (_req, res) => {
  res.send("Hello, world!");
});

app.get(
  "/push",
  asyncHandler(async (_req, res) => {
    try {
      // // Check if the directory is a git repository
      // if (!fs.existsSync(path.join(repoPath, ".git"))) {
      //   // Initialize a new git repository
      //   await git.init(true, { repoPath });
      // }

      // Set up git configuration
      await git.cwd(repoPath);

      // Set up git configuration
      await git.addConfig("user.name", "glyphyai-hub[bot]");
      await git.addConfig("user.email", "team@glyphy.ai");

      // Perform git operations
      await git.add("./*");
      await git.commit("Automated commit message");
      await git.push("git@github.com:GlyphyAI-Hub/test-repo.git", "main");

      res.send("Code pushed successfully!");
    } catch (err) {
      console.error("Error pushing code:", err);
      res.status(500).send("Failed to push code");
    }
  }),
);

app.listen(3000, () => {
  console.log("Server is running on port 3000");
});
