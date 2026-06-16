import fs from "fs";
import path from "path";

export function loadTemplate(templateName) {
    const base = path.join(process.cwd(), "templates", templateName);
    return fs.readdirSync(base).map(file => ({
        name: file,
        content: fs.readFileSync(path.join(base, file), "utf8")
    }));
}
