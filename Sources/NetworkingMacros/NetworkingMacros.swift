import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

enum RequestMacroError: CustomStringConvertible, Error {
    case onlyApplicableToStruct, canNotFindBodyVariable, canNotFindFunctionCallExpression
    
    var description: String {
        switch self {
        case .canNotFindBodyVariable: "Can not find in struc a body variable"
        case .onlyApplicableToStruct: "@StructInit can only be applied to a structure"
        case .canNotFindFunctionCallExpression: "Can not find any function caller (modifier) in expression"
        }
    }
}

public struct RequestMacro: MemberMacro {
    public static func expansion(of node: SwiftSyntax.AttributeSyntax, providingMembersOf declaration: some SwiftSyntax.DeclGroupSyntax, in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.DeclSyntax] {
        guard let structDeclaration = declaration.as(StructDeclSyntax.self) else {
            throw RequestMacroError.onlyApplicableToStruct
        }
        
        let variableDeclaration = structDeclaration.memberBlock.members.compactMap({ $0.decl.as(VariableDeclSyntax.self) })
        
        guard
            let bodyPatternSyntax = variableDeclaration.compactMap({ $0.bindings }).first(where: {
                if let pattern = $0.first?.pattern.as(IdentifierPatternSyntax.self) {
                    return pattern.identifier.text == "body"
                } else {
                    return false
                }
            })
        else {
            throw RequestMacroError.canNotFindBodyVariable
        }
        
        guard
            let patternBindingSyntax = bodyPatternSyntax.first?.as(PatternBindingSyntax.self),
            let functionCallExpression = patternBindingSyntax.accessorBlock?.accessors.as(CodeBlockItemListSyntax.self)?.first(where: { $0.is(CodeBlockItemSyntax.self) })?.item.as(FunctionCallExprSyntax.self)
        else {
            throw RequestMacroError.canNotFindFunctionCallExpression
        }

        let types = RequestMacro.analyze(syntax: functionCallExpression)

        let responseBodyTypealiasDeclSyntax = try TypeAliasDeclSyntax(
            SyntaxNodeString(
                stringLiteral: "typealias ResponseBody = \(types.literalResponseBodyTypeName ?? "Empty")"
            )
        )
        
        let responseErrorTypealiasDeclSyntax = try TypeAliasDeclSyntax(
            SyntaxNodeString(
                stringLiteral: "typealias ResponseError = \(types.literalResponseErrorTypeName ?? "Empty")"
            )
        )
        
        return [DeclSyntax(responseBodyTypealiasDeclSyntax), DeclSyntax(responseErrorTypealiasDeclSyntax)]
    }
    
    private static func analyze(syntax: FunctionCallExprSyntax) -> (literalResponseBodyTypeName: String?, literalResponseErrorTypeName: String?) {

        var literalResponseBodyTypeName: String? = nil
        var literalResponseErrorTypeName: String? = nil

        if 
            let declNameString = syntax
                .calledExpression.as(MemberAccessExprSyntax.self)?
                .declName.baseName.text,
            let declReferenceNameString = syntax
                .arguments.first(where: { $0.is(LabeledExprSyntax.self) })?.as(LabeledExprSyntax.self)?
                .expression.as(MemberAccessExprSyntax.self)?
                .base?.as(DeclReferenceExprSyntax.self)?
                .baseName.text
        {
            switch declNameString {
            case "responseBody":
                literalResponseBodyTypeName = declReferenceNameString
            case "responseError":
                literalResponseErrorTypeName = declReferenceNameString
            default: break
            }
        }

        if let nextFunctionCallExpression = syntax
            .calledExpression.as(MemberAccessExprSyntax.self)?
            .base?.as(FunctionCallExprSyntax.self)
        {
            let (bodyTypeName, errorTypeName) = RequestMacro.analyze(syntax: nextFunctionCallExpression)

            return (
                literalResponseBodyTypeName ?? bodyTypeName ?? nil,
                literalResponseErrorTypeName ?? errorTypeName ?? nil
            )
        }

        return (
            literalResponseBodyTypeName  ?? nil,
            literalResponseErrorTypeName ?? nil
        )
    }
}

extension RequestMacro: ExtensionMacro {
    public static func expansion(of node: SwiftSyntax.AttributeSyntax, attachedTo declaration: some SwiftSyntax.DeclGroupSyntax, providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol, conformingTo protocols: [SwiftSyntax.TypeSyntax], in context: some SwiftSyntaxMacros.MacroExpansionContext) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
        
        let requestExtension = try ExtensionDeclSyntax("extension \(type.trimmed): Request {}")        
        return [requestExtension]
    }
}

@main
struct MyMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        RequestMacro.self,
    ]
}
