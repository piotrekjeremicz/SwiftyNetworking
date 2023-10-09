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

        let types = try RequestMacro.revealResponseTypes(for: bodyPatternSyntax.description)
        let responseBodyTypealiasDeclSyntax = try TypeAliasDeclSyntax(
            SyntaxNodeString(
                stringLiteral: "typealias ResponseBody = \(types.literalResponseBody)"
            )
        )
        
        let responseErrorTypealiasDeclSyntax = try TypeAliasDeclSyntax(
            SyntaxNodeString(
                stringLiteral: "typealias ResponseError = \(types.literalResponseError)"
            )
        )
        
        return [DeclSyntax(responseBodyTypealiasDeclSyntax), DeclSyntax(responseErrorTypealiasDeclSyntax)]
    }
    
    private static func revealResponseTypes(for bodyDescription: String) throws -> (literalResponseBody: String, literalResponseError: String) {
        let responseBodyRegex = try Regex(#"\.responseBody\((.*?)\.self\)"#)
        let responseErrorRegex = try Regex(#"\.responseError\((.*?)\.self\)"#)
                
        let literalResponseBody = bodyDescription.matches(of: responseBodyRegex).last?.last?.value
        let literalResponseError = bodyDescription.matches(of: responseErrorRegex).last?.last?.value
        
        return ("\(literalResponseBody ?? "Empty")", "\(literalResponseError ?? "Empty")" )
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
