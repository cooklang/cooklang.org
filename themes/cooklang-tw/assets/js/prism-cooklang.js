/**
 * Prism.js language definition for Cooklang
 * Based on the official VSCode extension and spec
 */

(function (Prism) {
    Prism.languages.cooklang = {
        // Front matter YAML - must come first
        'frontmatter': {
            pattern: /^---[\s\S]*?^---/m,
            inside: {
                'punctuation': /^---|---$/m,
                'content': {
                    pattern: /[\s\S]+/,
                    inside: Prism.languages.yaml || {}
                }
            }
        },

        // Comments - must come early to prevent false matches
        'comment': [
            {
                pattern: /\[-[\s\S]*?-\]/,
                greedy: true
            },
            {
                pattern: /--.*$/m,
                greedy: true
            }
        ],
        
        // Metadata lines (>> key: value)
        'metadata': {
            pattern: /^>>.+$/m,
            inside: {
                'punctuation': /^>>/,
                'property': {
                    pattern: /[^:\s]+(?=:)/,
                    alias: 'attr-name'
                },
                'punctuation-colon': /:/,
                'value': {
                    pattern: /[^:]+$/,
                    alias: 'attr-value'
                }
            }
        },

        // Sections (= Section Name =)
        'section': {
            pattern: /^=+.*?=*$/m,
            alias: 'title'
        },

        // Notes (lines starting with >)
        'note': {
            pattern: /^>.+$/m,
            alias: 'blockquote'
        },
        
        // Ingredients with amounts and/or modifiers
        'ingredient-complex': {
            pattern: /@[a-zA-Z0-9]+(?:\s+[a-zA-Z0-9]+)*(?:\{[^}]*\})?(?:\([^)]*\))?/,
            alias: 'ingredient',
            inside: {
                'punctuation': /[@{}()]/,
                'number': /\d+(?:[./]\d+)?/,
                'unit': /%[^}%]+/,
                'operator': /[|*/]/
            }
        },
        
        // Simple ingredients (just the word, no braces or parens following)
        'ingredient-simple': {
            pattern: /@[a-zA-Z0-9]+\b(?!\s*[{(])/,
            alias: 'ingredient'
        },
        
        // Cookware with details or multiword with empty braces
        'cookware-complex': {
            pattern: /#[a-zA-Z0-9]+(?:\s+[a-zA-Z0-9]+)*(?:\{[^}]*\})/,
            alias: 'cookware',
            inside: {
                'punctuation': /[#{}]/
            }
        },
        
        // Simple cookware (just the word, no braces following)
        'cookware-simple': {
            pattern: /#[a-zA-Z0-9]+\b(?!\s*\{)/,
            alias: 'cookware'
        },
        
        // Timers
        'timer': {
            pattern: /~[a-zA-Z0-9]*\{[^}]+\}/,
            inside: {
                'punctuation': /[~{}]/,
                'number': /\d+(?:[./]\d+)?/,
                'unit': /%?[^}%0-9]+/
            }
        }
    };

    // Alias for common use
    Prism.languages.cook = Prism.languages.cooklang;
}(Prism));