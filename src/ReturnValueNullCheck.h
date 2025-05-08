#ifndef LLVM_CLANG_TOOLS_EXTRA_CLANG_TIDY_CSUPPORT_RETURN_VALUE_NULLCHECK_H
#define LLVM_CLANG_TOOLS_EXTRA_CLANG_TIDY_CSUPPORT_RETURN_VALUE_NULLCHECK_H

#include <clang-tidy/ClangTidyCheck.h>

namespace clang::tidy::csupport {

/// check the function's return value which may be NULL is 'NULL checked'.
class ReturnValueNullCheck : public ClangTidyCheck {
public:
  ReturnValueNullCheck(StringRef Name, ClangTidyContext *Context);
  void registerMatchers(ast_matchers::MatchFinder *Finder) override;
  void check(const ast_matchers::MatchFinder::MatchResult &Result) override;

private:
  /// check whether function's next line is
  ///   `if (return_value_var == NULL)` or `if (NULL == return_value_var)`
  bool isNullCheckedWithIfStmtVarEqNull(
      const ast_matchers::MatchFinder::MatchResult &Result);
  /// check whether function's next line is
  ///   `if (return_value_var == 0)` or `if (0 == return_value_var)`
  bool isNullCheckedWithIfStmtVarEq0(
      const ast_matchers::MatchFinder::MatchResult &Result);
  /// check whether function's next line is
  ///   `if (!return_value_var)`
  bool isNullCheckedWithIfStmtNotVar(
      const ast_matchers::MatchFinder::MatchResult &Result);
  /// check if the function statement is enclosed within if condition (or while
  /// condition, do-while condition) like these.
  ///   `if ((return_value_var = func()))`
  ///   `if ((return_value_var = func()) != NULL)`
  ///   `if (NULL != (return_value_var = func()))`
  ///   `if ((return_value_var = func()) != 0)`
  ///   `if (0 != (return_value_var = func()))`
  ///   etc
  ///
  /// Only simple conditions are supported. If you need support for complex
  /// conditions, please write an issue.
  ///
  /// !!! This function is experimental. !!!
  /// The specifications for this function have not been finalized.
  bool isNullCheckedWithCondStmtThatSetVar(
      const ast_matchers::MatchFinder::MatchResult &Result);
  /// get return_value_var's VarDecl node
  const VarDecl *getVarDeclOfReturnValueVar(
      const ast_matchers::MatchFinder::MatchResult &Result);
  /// get matched function's Stmt node
  const Stmt *
  getFuncLineStmt(const ast_matchers::MatchFinder::MatchResult &Result);
  ///
  void print_diag(const ast_matchers::MatchFinder::MatchResult &Result,
                  const char *message);
};

} // namespace clang::tidy::csupport

#endif /* LLVM_CLANG_TOOLS_EXTRA_CLANG_TIDY_CSUPPORT_RETURN_VALUE_NULLCHECK_H  \
        */
