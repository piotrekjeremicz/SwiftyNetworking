import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

enum RequestMacroError: CustomStringConvertible, Error {
    case onlyApplicableToStruct, canNotFindBodyVariable
    
    var description: String {
        switch self {
        case .canNotFindBodyVariable: "Can not find in struc a body variable"
        case .onlyApplicableToStruct: "@StructInit can only be applied to a structure"
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

@main
struct MyMacroPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        RequestMacro.self,
    ]
}
