#include "ReturnValueNullCheck.h"

#include <vector>

using namespace clang::ast_matchers;

namespace clang::tidy::csupport {

///
ReturnValueNullCheck::ReturnValueNullCheck(StringRef Name,
                                           ClangTidyContext *Context)
    : ClangTidyCheck(Name, Context) {}

///
void ReturnValueNullCheck::registerMatchers(MatchFinder *Finder) {
  // If a function is not cast, there are functions for which implicit type
  // conversion occurs and functions for which it does not.
  //
  // - each functions' Clang AST without casting
  // malloc, etc ... return_value_var(※ 1) has ImplicitCastExpr(※ 2)
  // fopen, etc  ... return_value_var(※ 1) doesn't have ImplicitCastExpr(※ 2)
  // ※ 1 function return variable
  // ※ 2 implicit type conversion node
  //
  // - each functions' Clang AST with casting
  // all funcs   ... return_value_var(※ 1) has cStyleCastExpr(※ 3)
  // ※ 3 C-style casting node
  //
  // As you know, for example, the `fopen` function is not often cast, but
  // `ReturnValueNullCheck` needs to be independent of the casting situation of
  // such functions, so it provides match conditions both with and without
  // casting.

  // functions which have ImplicitCastExpr, without casting
  std::vector<llvm::StringRef> Funcs1 = {"malloc", "realloc", "calloc"};
  // functions which does not have ImplicitCastExpr, without casting
  std::vector<llvm::StringRef> Funcs2 = {"fopen"};

  // Futhermore, there're two separate cases depending on how the variables are
  // initialized.

  // CASE1: return_value_var is the VarDecl node
  //
  // \code
  //    char* p = malloc(n);
  // \endcode
  //
  // When the variable `p` is initialized in one line, the variable `p`,
  // return_value_var, is the VarDecl node.
  Finder->addMatcher(
      declStmt(
          has(varDecl(hasInitializer(anyOf(
                          cStyleCastExpr(hasSourceExpression(callExpr(
                              callee(functionDecl(hasAnyName(Funcs1)))))),
                          implicitCastExpr(hasSourceExpression(callExpr(
                              callee(functionDecl(hasAnyName(Funcs1)))))),
                          cStyleCastExpr(hasSourceExpression(callExpr(
                              callee(functionDecl(hasAnyName(Funcs2)))))),
                          callExpr(callee(functionDecl(hasAnyName(Funcs2)))))),
                      hasType(pointerType()))
                  .bind("returnValueVar")))
          .bind("funcLineStmt"),
      this);

  // CASE2: return_value_var is the DeclRefExpr node
  //
  // \code
  //    char* p;
  //    p = malloc(n);
  // \endcode
  //
  // When the variable `p` is initialized in two separate lines as above, the
  // variable `p` in the first line is the VarDecl node, and the variable `p` in
  // the second line, return_value_var, is the VarRefExpr node.
  Finder->addMatcher(
      binaryOperator(
          hasLHS(declRefExpr(to(varDecl(hasType(pointerType()))))
                     .bind("returnValueVar")),
          hasRHS(anyOf(cStyleCastExpr(hasSourceExpression(
                           callExpr(callee(functionDecl(hasAnyName(Funcs1)))))),
                       implicitCastExpr(hasSourceExpression(
                           callExpr(callee(functionDecl(hasAnyName(Funcs1)))))),
                       cStyleCastExpr(hasSourceExpression(
                           callExpr(callee(functionDecl(hasAnyName(Funcs2)))))),
                       callExpr(callee(functionDecl(hasAnyName(Funcs2)))))))
          .bind("funcLineStmt"),
      this);
}

///
void ReturnValueNullCheck::check(const MatchFinder::MatchResult &Result) {

  if (isNullCheckedWithIfStmtVarEqNull(Result) ||
      isNullCheckedWithIfStmtVarEq0(Result) ||
      isNullCheckedWithIfStmtNotVar(Result) ||
      isNullCheckedWithCondStmtThatSetVar(Result)) {
    return;
  }

  print_diag(Result, "Need null check. The return value may be NULL.");
}

/// check whether function's next line is
///   `if (return_value_var == NULL)` or `if (NULL == return_value_var)`
///
/// Note that NULL here means ((void*)0) internally.
/// The case where NULL internally refers to 0 is implemented in the
/// `isNullCheckedWithIfStmtVarEq0` function to separate the explanation of
/// Clang AST.
///
/// ------------------------
/// - Sample C Code
/// ------------------------
/// \code
/// char* buf = (char*)malloc(5);
/// if (buf == NULL) ...
/// \endcode
///
/// ------------------------
/// - Clang AST
/// ------------------------
/// CompoundStmt ................ Compound Statement (Code Block) node
/// |-Stmt ......................   Stmt node bound to `funcLineStmt`
/// |  - (node)..................     var `buf`, node bound to `returnValueVar`
/// |    ...
/// |-IfStmt ....................   If Statement node
/// | |-BinaryOperator '==' ....
/// | |  -ImplicitCastExpr ......     implicit type conversion node
/// | |    -DeclRefExpr .........     reference to the variable `buf`
/// | |  -ImplicitCastExpr ......     implicit type conversion node
/// | |    -ParenExpr ...........     parentheses node
/// | |      -CStyleCastExpr ....     C-style cast (void*) <NullToPointer>
/// | |        -IntegerLiteral ..     integer 0
/// |    ...
///
/// MEMO: To get Clang AST, please use `(node)->dump()` which outputs
/// the node's Clang AST to stdout.
bool ReturnValueNullCheck::isNullCheckedWithIfStmtVarEqNull(
    const MatchFinder::MatchResult &Result) {

  // get VarDecl node bound to `returnValueVar`
  const VarDecl *VarDeclNodeOfReturnValueVar =
      getVarDeclOfReturnValueVar(Result);
  if (!VarDeclNodeOfReturnValueVar)
    return false;

  // get Stmt node bound to `funcLineStmt`
  const Stmt *FuncLineStmtNode = getFuncLineStmt(Result);
  if (!FuncLineStmtNode)
    return false;

  // get code block (CompoundStmt) node which has FuncLineStmtNode
  const CompoundStmt *CompoundStmtNode;
  {
    auto CompoundParents = Result.Context->getParents(*FuncLineStmtNode);
    if (CompoundParents.empty())
      return false;

    CompoundStmtNode = CompoundParents[0].get<CompoundStmt>();
  }
  if (!CompoundStmtNode)
    return false;

  // check this is not end of code block
  auto It = std::find(CompoundStmtNode->body_begin(),
                      CompoundStmtNode->body_end(), FuncLineStmtNode);
  if (It == CompoundStmtNode->body_end() ||
      (It + 1) == CompoundStmtNode->body_end())
    return false;

  // get next line's IfStmt node
  const Stmt *NextStmt = *(It + 1);
  const IfStmt *IfStmtNode = dyn_cast<IfStmt>(NextStmt);
  if (!IfStmtNode)
    return false;

  // check IfStmt's condition is
  // `return_value_var == NULL` or `NULL == return_value_var`
  const Expr *Cond = IfStmtNode->getCond();
  if (const BinaryOperator *BinOp = dyn_cast_or_null<BinaryOperator>(Cond)) {
    if (BinOp->getOpcode() == BO_EQ) {
      const auto *LHS = BinOp->getLHS()->IgnoreParenImpCasts();
      const auto *RHS = BinOp->getRHS()->IgnoreParenImpCasts();

      // CASE: `return_value_var == NULL`
      if (isa<DeclRefExpr>(LHS) && isa<CStyleCastExpr>(RHS)) {
        const auto *DeclRef = dyn_cast<DeclRefExpr>(LHS);
        const auto *Cast = dyn_cast<CStyleCastExpr>(RHS);
        if (DeclRef->getDecl() == VarDeclNodeOfReturnValueVar &&
            Cast->getCastKind() == CK_NullToPointer) {
          return true;
        }
      }

      // CASE: `NULL == return_value_var`
      if (isa<CStyleCastExpr>(LHS) && isa<DeclRefExpr>(RHS)) {
        const auto *Cast = dyn_cast<CStyleCastExpr>(LHS);
        const auto *DeclRef = dyn_cast<DeclRefExpr>(RHS);
        if (Cast->getCastKind() == CK_NullToPointer &&
            DeclRef->getDecl() == VarDeclNodeOfReturnValueVar) {
          return true;
        }
      }
    }
  }

  // IfStmt's condition do not match the above
  return false;
}

/// check whether function's next line is
///   `if (return_value_var == 0)` or `if (0 == return_value_var)`
///
/// ------------------------
/// - Sample C Code
/// ------------------------
/// \code
/// char* buf = (char*)malloc(5);
/// if (buf == 0) ...
/// \endcode
///
/// ------------------------
/// - Clang AST
/// ------------------------
/// CompoundStmt ................ Compound Statement (Code Block) node
/// |-Stmt ......................   Stmt node bound to `funcLineStmt`
/// |  - (node)..................     var `buf`, node bound to `returnValueVar`
/// |    ...
/// |-IfStmt ....................   If Statement node
/// | |-BinaryOperator '==' ....
/// | |  -ImplicitCastExpr ......     implicit type conversion node
/// | |    -DeclRefExpr .........     reference to the variable `buf`
/// | |  -ImplicitCastExpr ......     implicit type conversion node
/// | |    -IntegerLiteral ......     integer 0
/// |    ...
///
/// MEMO: To get Clang AST, please use `(node)->dump()` which outputs
/// the node's Clang AST to stdout.
bool ReturnValueNullCheck::isNullCheckedWithIfStmtVarEq0(
    const MatchFinder::MatchResult &Result) {

  // get VarDecl node bound to `returnValueVar`
  const VarDecl *VarDeclNodeOfReturnValueVar =
      getVarDeclOfReturnValueVar(Result);
  if (!VarDeclNodeOfReturnValueVar)
    return false;

  // get Stmt node bound to `funcLineStmt`
  const Stmt *FuncLineStmtNode = getFuncLineStmt(Result);
  if (!FuncLineStmtNode)
    return false;

  // get code block (CompoundStmt) node which has FuncLineStmtNode
  const CompoundStmt *CompoundStmtNode;
  {
    auto CompoundParents = Result.Context->getParents(*FuncLineStmtNode);
    if (CompoundParents.empty())
      return false;

    CompoundStmtNode = CompoundParents[0].get<CompoundStmt>();
  }
  if (!CompoundStmtNode)
    return false;

  // check this is not end of code block
  auto It = std::find(CompoundStmtNode->body_begin(),
                      CompoundStmtNode->body_end(), FuncLineStmtNode);
  if (It == CompoundStmtNode->body_end() ||
      (It + 1) == CompoundStmtNode->body_end())
    return false;

  // get next line's IfStmt node
  const Stmt *NextStmt = *(It + 1);
  const IfStmt *IfStmtNode = dyn_cast<IfStmt>(NextStmt);
  if (!IfStmtNode)
    return false;

  // check IfStmt's condition is
  // `return_value_var == 0` or `0 == return_value_var`
  const Expr *Cond = IfStmtNode->getCond();
  if (const BinaryOperator *BinOp = dyn_cast_or_null<BinaryOperator>(Cond)) {
    if (BinOp->getOpcode() == BO_EQ) {
      const auto *LHS = BinOp->getLHS()->IgnoreParenImpCasts();
      const auto *RHS = BinOp->getRHS()->IgnoreParenImpCasts();

      // CASE: `return_value_var == 0`
      if (isa<DeclRefExpr>(LHS) && isa<IntegerLiteral>(RHS)) {
        const auto *DeclRef = dyn_cast<DeclRefExpr>(LHS);
        const auto *IntLit = dyn_cast<IntegerLiteral>(RHS);
        if (DeclRef->getDecl() == VarDeclNodeOfReturnValueVar &&
            IntLit->getValue() == 0) {
          return true;
        }
      }

      // CASE: `0 == return_value_var`
      if (isa<IntegerLiteral>(LHS) && isa<DeclRefExpr>(RHS)) {
        const auto *IntLit = dyn_cast<IntegerLiteral>(LHS);
        const auto *DeclRef = dyn_cast<DeclRefExpr>(RHS);
        if (IntLit->getValue() == 0 &&
            DeclRef->getDecl() == VarDeclNodeOfReturnValueVar) {
          return true;
        }
      }
    }
  }

  // IfStmt's condition do not match the above
  return false;
}

/// check whether function's next line is
///   `if (!return_value_var)`
///
/// ------------------------
/// - Sample C Code
/// ------------------------
/// \code
/// char* buf = (char*)malloc(5);
/// if (!buf) ...
/// \endcode
///
/// ------------------------
/// - Clang AST
/// ------------------------
/// CompoundStmt ................ Compound Statement (Code Block) node
/// |-Stmt ......................   Stmt node bound to `funcLineStmt`
/// |  - (node)..................     var `buf`, node bound to `returnValueVar`
/// |    ...
/// |-IfStmt ....................   If Statement node
/// | |-UnaryOperator '!' .......
/// | |  -ImplicitCastExpr ......     implicit type conversion node
/// | |    -DeclRefExpr .........     reference to the variable `buf`
///
/// MEMO: To get Clang AST, please use `(node)->dump()` which outputs
/// the node's Clang AST to stdout.
bool ReturnValueNullCheck::isNullCheckedWithIfStmtNotVar(
    const MatchFinder::MatchResult &Result) {

  // get VarDecl node bound to `returnValueVar`
  const VarDecl *VarDeclNodeOfReturnValueVar =
      getVarDeclOfReturnValueVar(Result);
  if (!VarDeclNodeOfReturnValueVar)
    return false;

  // get Stmt node bound to `funcLineStmt`
  const Stmt *FuncLineStmtNode = getFuncLineStmt(Result);
  if (!FuncLineStmtNode)
    return false;

  // get code block (CompoundStmt) node which has FuncLineStmtNode
  const CompoundStmt *CompoundStmtNode;
  {
    auto CompoundParents = Result.Context->getParents(*FuncLineStmtNode);
    if (CompoundParents.empty())
      return false;

    CompoundStmtNode = CompoundParents[0].get<CompoundStmt>();
  }
  if (!CompoundStmtNode)
    return false;

  // check this is not end of code block
  auto It = std::find(CompoundStmtNode->body_begin(),
                      CompoundStmtNode->body_end(), FuncLineStmtNode);
  if (It == CompoundStmtNode->body_end() ||
      (It + 1) == CompoundStmtNode->body_end())
    return false;

  // get next line's IfStmt node
  const Stmt *NextStmt = *(It + 1);
  const IfStmt *IfStmtNode = dyn_cast<IfStmt>(NextStmt);
  if (!IfStmtNode)
    return false;

  // check IfStmt's condition is `!return_value_var`
  const Expr *Cond = IfStmtNode->getCond();
  if (const UnaryOperator *UO = dyn_cast<UnaryOperator>(Cond)) {
    if (UO->getOpcode() == UO_LNot) {
      const Expr *Inner = UO->getSubExpr()->IgnoreParenImpCasts();
      if (const DeclRefExpr *DRE = dyn_cast<DeclRefExpr>(Inner)) {
        if (DRE->getDecl() == VarDeclNodeOfReturnValueVar) {
          return true;
        }
      }
    }
  }

  // IfStmt's condition do not match the above
  return false;
}

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
bool ReturnValueNullCheck::isNullCheckedWithCondStmtThatSetVar(
    const ast_matchers::MatchFinder::MatchResult &Result) {

  // get VarDecl node bound to `returnValueVar`
  const VarDecl *VarDeclNodeOfReturnValueVar =
      getVarDeclOfReturnValueVar(Result);
  if (!VarDeclNodeOfReturnValueVar)
    return false;

  // get Stmt node bound to `funcLineStmt`
  const Stmt *FuncLineStmtNode = getFuncLineStmt(Result);
  if (!FuncLineStmtNode)
    return false;

  // get parent Stmt (exclude ParenExpr) node which has FuncLineStmtNode
  const Stmt *TmpStmtNode = FuncLineStmtNode;
  do {
    auto Parents = Result.Context->getParents(*TmpStmtNode);
    if (Parents.empty())
      return false;
    TmpStmtNode = Parents[0].get<Stmt>();
  } while (isa<ParenExpr>(TmpStmtNode));
  const Stmt *ParentStmtNode = TmpStmtNode;

  //
  // check parent Stmt's node
  //

  // parent Stmt node is IfStmt node
  // CASE: `if ((p = func()))`
  if (isa<IfStmt>(ParentStmtNode)) {
    return true;
  }

  // parent Stmt node is WhileStmt node
  // CASE: `while ((p = func()))`
  if (isa<WhileStmt>(ParentStmtNode)) {
    return true;
  }

  // parent Stmt node is DoStmt node
  // CASE: `do {
  //          // do something
  //        } while ((p = func()))`
  if (isa<DoStmt>(ParentStmtNode)) {
    return true;
  }

  // parent Stmt node is BinaryOperator node
  // CASE: `((p = func()) != NULL)`, `(NULL != (p = func()))`,
  //       `((p = func()) != 0)`, `(0 != (p = func()))`
  //
  // In some cases, the IfStmt (WhileStmt, DoStmt) node has other
  // BinaryOperators or UnaryOperators. For example.
  // \code
  // if ((p = func() != NULL) && (do something)) ...
  // \endcode
  // \code
  // if (!((p = func()) != NULL)) ...
  // \endcode
  // In these cases, return_value_var is already null checked. So return `true`,
  // no matter what other BinaryOperators or UnaryOperators do.
  //
  // Additionally, it may be implicitly assumed that the ParentStmtNode's
  // ancestor node have an IfStmt (WhileStmt, DoStmt) node in most cases. This
  // implicit assumption simplify code, but needs to be tested by more people.
  if (isa<BinaryOperator>(ParentStmtNode)) {
    const BinaryOperator *BinOp = dyn_cast<BinaryOperator>(ParentStmtNode);

    if (BinOp->getOpcode() == BO_NE) {
      const auto *LHS = BinOp->getLHS()->IgnoreParenImpCasts();
      const auto *RHS = BinOp->getRHS()->IgnoreParenImpCasts();

      // CASE: `((p = func()) != NULL)`
      if (isa<BinaryOperator>(LHS) && isa<CStyleCastExpr>(RHS)) {
        const auto *BO = dyn_cast<BinaryOperator>(LHS);
        const auto *DRE =
            dyn_cast<DeclRefExpr>(BO->getLHS()->IgnoreParenImpCasts());
        if (!DRE)
          return false;
        const auto *Cast = dyn_cast<CStyleCastExpr>(RHS);
        if (DRE->getDecl() == VarDeclNodeOfReturnValueVar &&
            Cast->getCastKind() == CK_NullToPointer) {
          return true;
        }
      }

      // CASE: `(NULL != (p = func()))`
      if (isa<CStyleCastExpr>(LHS) && isa<BinaryOperator>(RHS)) {
        const auto *Cast = dyn_cast<CStyleCastExpr>(LHS);
        const auto *BO = dyn_cast<BinaryOperator>(RHS);
        const auto *DRE =
            dyn_cast<DeclRefExpr>(BO->getLHS()->IgnoreParenImpCasts());
        if (!DRE)
          return false;
        if (Cast->getCastKind() == CK_NullToPointer &&
            DRE->getDecl() == VarDeclNodeOfReturnValueVar) {
          return true;
        }
      }

      // CASE: `((p = func()) != 0)`
      if (isa<BinaryOperator>(LHS) && isa<IntegerLiteral>(RHS)) {
        const auto *BO = dyn_cast<BinaryOperator>(LHS);
        const auto *DRE =
            dyn_cast<DeclRefExpr>(BO->getLHS()->IgnoreParenImpCasts());
        if (!DRE)
          return false;
        const auto *IntLit = dyn_cast<IntegerLiteral>(RHS);
        if (DRE->getDecl() == VarDeclNodeOfReturnValueVar &&
            IntLit->getValue() == 0) {
          return true;
        }
      }

      // CASE: `(0 != (p = func()))`
      if (isa<IntegerLiteral>(LHS) && isa<BinaryOperator>(RHS)) {
        const auto *IntLit = dyn_cast<IntegerLiteral>(LHS);
        const auto *BO = dyn_cast<BinaryOperator>(RHS);
        const auto *DRE =
            dyn_cast<DeclRefExpr>(BO->getLHS()->IgnoreParenImpCasts());
        if (!DRE)
          return false;
        if (IntLit->getValue() == 0 &&
            DRE->getDecl() == VarDeclNodeOfReturnValueVar) {
          return true;
        }
      }
    }
  }

  // In other case, like this.
  // \code
  // if ((p = func()) && (do something)) ...
  // \endcode
  //
  // In this case, return_value_var is already null checked. So return `true`,
  // no matter what other BinaryOperators do.
  //
  // Additionally, it may be implicitly assumed that the ParentStmtNode's
  // ancestor node have an IfStmt (WhileStmt, DoStmt) node in most cases. This
  // implicit assumption simplify code, but needs to be tested by more people.
  if (isa<BinaryOperator>(ParentStmtNode)) {
    const BinaryOperator *BinOp = dyn_cast<BinaryOperator>(ParentStmtNode);

    // `&&` or `||`
    if (BinOp->getOpcode() == BO_LAnd || BinOp->getOpcode() == BO_LOr) {
      return true;
    }
  }

  // In other case, like this.
  // \code
  // if (!(p=func())) ...
  // \endcode
  //
  // In this case, return_value_var is already null checked. But, obviously,
  // the result is not used. So, this case has nothing to do, only returns
  // `false`.
  // if (isa<UnaryOperator>(ParentStmtNode)) {
  //    // nothing to do
  // }

  // parent Stmt's condition do not match the above
  return false;
}

/// get return_value_var's VarDecl node
const VarDecl *ReturnValueNullCheck::getVarDeclOfReturnValueVar(
    const ast_matchers::MatchFinder::MatchResult &Result) {

  const VarDecl *ReturnValueVarDeclNode;
  if (const DeclRefExpr *VRE =
          Result.Nodes.getNodeAs<DeclRefExpr>("returnValueVar")) {
    ReturnValueVarDeclNode = dyn_cast<VarDecl>(VRE->getDecl());
  } else {
    ReturnValueVarDeclNode = Result.Nodes.getNodeAs<VarDecl>("returnValueVar");
  }

  return ReturnValueVarDeclNode;
}

/// get function's Stmt node
const Stmt *ReturnValueNullCheck::getFuncLineStmt(
    const ast_matchers::MatchFinder::MatchResult &Result) {

  return Result.Nodes.getNodeAs<Stmt>("funcLineStmt");
}

///
void ReturnValueNullCheck::print_diag(
    const ast_matchers::MatchFinder::MatchResult &Result, const char *message) {

  if (const auto *VRE = Result.Nodes.getNodeAs<DeclRefExpr>("returnValueVar")) {
    diag(VRE->getLocation(), message);
  }
  if (const auto *VD = Result.Nodes.getNodeAs<VarDecl>("returnValueVar")) {
    diag(VD->getLocation(), message);
  }
}

} // namespace clang::tidy::csupport
