#include "ReturnValueNullCheck.h"

#include <clang-tidy/ClangTidyModule.h>
#include <clang-tidy/ClangTidyModuleRegistry.h>

namespace clang::tidy {
namespace csupport {

class CSupportCheckModule : public ClangTidyModule {
public:
  void addCheckFactories(ClangTidyCheckFactories &CheckFactories) override {
    CheckFactories.registerCheck<ReturnValueNullCheck>(
        "csupport-return-value-nullcheck");
  }
};

} // namespace csupport

// register CSupportCheckModule
static ClangTidyModuleRegistry::Add<csupport::CSupportCheckModule>
    X("csupport-module", "Add checks for csupport");

// This anchor is used to force the linker to link in the generated object file
// and thus register this Module
volatile int CSupportCheckModuleAnchorSource = 0;

} // namespace clang::tidy
