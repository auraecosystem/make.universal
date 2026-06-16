#!/usr/bin/env node

import { createProject, deployProject } from "../src/index.js";

const args = process.argv.slice(2);
const command = args[0];

function help() {
  console.log(`
makeuniversal CLI

Commands:
  create <name>     Create a new Web4 project
  deploy <name>     Deploy project scaffold
  help              Show this help
  `);
}

switch (command) {
  case "create":
    createProject(args[1]);
    break;

  case "deploy":
    deployProject(args[1]);
    break;

  default:
    help();
}
