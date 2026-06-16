import fs from "fs";
import path from "path";
import { loadTemplate } from "./template-loader.js";

function replaceVars(content, vars) {
    return content.replace(/\{\{(.*?)\}\}/g, (_, key) => {
        return vars[key.trim()] || "";
    });
}

export function generateProject(template, projectName, vars = {}) {
    const files = loadTemplate(template);

    const outDir = path.join(process.cwd(), projectName);
    fs.mkdirSync(outDir, { recursive: true });

    files.forEach(file => {
        const output = replaceVars(file.content, {
            project_name: projectName,
            ...vars
        });

        const outFile = file.name.replace(".tpl", "");
        fs.writeFileSync(path.join(outDir, outFile), output);
    });

    console.log(`✔ Generated project: ${projectName}`);
}
