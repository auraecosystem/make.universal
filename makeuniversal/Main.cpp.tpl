#include <iostream>
#include <vector>
#include <string>
#include <memory>

#include "ElfWrapper.h"
#include "CRAXExpr.h"

using namespace kubu;

static void log(const std::string& tag, const std::string& msg) {
    std::cout << "[" << tag << "] " << msg << "\n";
}

int main(int argc, char** argv) {

    if (argc < 2) {
        std::cerr << "Usage: {{project_name}} <elf-file>\n";
        return 1;
    }

    try {
        ElfWrapper elf(argv[1]);

        if (!elf.loaded()) {
            std::cerr << "ELF load failed\n";
            return 1;
        }

        elf.setBase(0x400000);
        elf.setVarPrefix("{{project_name}}");

        auto base = klee::ConstantExpr::create(elf.getBase(), klee::Expr::Int64);

        // =========================
        // Symbol analysis
        // =========================
        std::string symbol = "read";

        auto symMap = elf.symbols();
        auto it = symMap.find(symbol);

        if (it != symMap.end()) {

            auto off = klee::ConstantExpr::create(it->second, klee::Expr::Int64);

            auto expr = BaseOffsetExpr::alloc(
                base,
                off,
                elf.getVarPrefix() + "_base",
                elf.getVarPrefix() + ".sym['" + symbol + "']"
            );

            auto boe = klee::dyn_cast<BaseOffsetExpr>(expr.get());

            if (boe) {
                log("BaseOffsetExpr", boe->toString());
                std::cout << "0x" << std::hex << boe->getZExtValue() << "\n";
            }
        } else {
            log("WARN", "Symbol not found: " + symbol);
        }

        // =========================
        // BSS region
        // =========================
        {
            auto off = klee::ConstantExpr::create(elf.bss(), klee::Expr::Int64);

            auto expr = BaseOffsetExpr::alloc(
                base,
                off,
                elf.getVarPrefix() + "_base",
                elf.getVarPrefix() + ".bss()"
            );

            auto boe = klee::dyn_cast<BaseOffsetExpr>(expr.get());
            if (boe) log("BSS", boe->toString());
        }

        // =========================
        // Payload model
        // =========================
        {
            std::vector<uint8_t> payload = {'H','e','l','l','o','!'};

            auto expr = ByteVectorExpr::create(payload);
            auto bve  = klee::dyn_cast<ByteVectorExpr>(expr.get());

            if (bve) {
                log("ByteVectorExpr", bve->toString());
            }
        }

        // =========================
        // Metadata node
        // =========================
        {
            auto expr = PlaceholderExpr<std::string>::create(
                "analysis_stage=1"
            );

            auto pe = klee::dyn_cast<PlaceholderExpr<std::string>>(expr.get());
            if (pe) log("Metadata", pe->getUserData());
        }

        // =========================
        // Runtime hook
        // =========================
        {
            auto expr = LambdaExpr::create([]() {
                std::cout << "[Runtime] Safe execution hook triggered\n";
            });

            auto le = klee::dyn_cast<LambdaExpr>(expr.get());
            if (le) (*le)();
        }

        return 0;

    } catch (const std::exception& e) {
        std::cerr << "Fatal error: " << e.what() << "\n";
        return 1;
    }
}
