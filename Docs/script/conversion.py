import os

DOT_FILE = "web4_build.dot"

# -------- DOT → Mermaid (simple heuristic converter) --------
def dot_to_mermaid(dot_text):
    lines = dot_text.splitlines()
    edges = []

    for line in lines:
        line = line.strip()

        if "->" in line or "--" in line:
            line = line.replace(";", "")

            if "->" in line:
                a, b = line.split("->")
            else:
                a, b = line.split("--")

            a = a.strip()
            b = b.strip()

            edges.append(f"    {a} --> {b}")

    mermaid = "flowchart LR\n" + "\n".join(edges)
    return mermaid


with open(DOT_FILE, "r") as f:
    dot = f.read()

# Generate Mermaid
mermaid = dot_to_mermaid(dot)

with open("web4.mmd", "w") as f:
    f.write(mermaid)

print("✔ Mermaid generated: web4.mmd")

# Optional: call Graphviz if installed
os.system("dot -Tsvg web4_build.dot -o web4.svg")

print("✔ SVG generated: web4.svg")
