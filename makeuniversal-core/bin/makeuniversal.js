#!/usr/bin/env node

import { generateProject } from "../core/generator.js";

const [cmd, template, name] = process.argv.slice(2);

if (cmd === "create") {
    if (!template || !name) {
        console.log("Usage: makeuniversal create <template> <name>");
        process.exit(1);
    }

    generateProject(template, name, {
        port: 8000
    });
}
