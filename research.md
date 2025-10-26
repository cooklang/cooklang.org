# Cooklang Use Cases Research for Homepage

## Current Use Cases on Homepage
- Import from anywhere (from hundreds of websites)
- CLI tools
- Mobile & Desktop apps
- Editor support
- Web server
- Community

## Existing Documented Use Cases
1. **Importing Recipes** - Convert from websites to Cooklang format
2. **Meal Planning** - Plan weekly meals, generate shopping lists
3. **Pantry Management** - Track ingredients, expiration dates, low stock alerts
4. **Reports** - Generate recipe analytics and statistics
5. **Shopping Lists** - Automatic generation from recipes
6. **Cookbook Creation** - Generate PDFs and printed cookbooks
7. **Raspberry Pi Setup** - Self-host recipe server on RPi

## Advanced/Tricky Use Cases to Highlight

### 1. Git Version Control for Recipes
- Track recipe evolution over time
- Collaborate on family cookbooks
- See who changed what and when
- Fork and merge recipe variations
- Link: `/docs/use-cases/version-control/` (needs creation)

### 2. Menu Planning & Batch Cooking
- Plan entire weeks with menu files
- Calculate batch cooking quantities
- Track leftovers and meal prep
- Compile shopping lists from menu plans
- Link: `/docs/use-cases/meal-planning/`

### 3. Recipe Scaling & Fixed Quantities
- Scale recipes for different party sizes
- Lock certain ingredients (e.g., salt to taste)
- Smart scaling that doesn't scale timers
- Link: `/docs/spec/#scaling-and-servings`

### 4. Multi-Recipe Dependencies
- Reference other recipes as ingredients
- Build complex meals from components
- Manage sauce and base recipes
- Link: `/docs/spec/#referencing-other-recipes`

### 5. Nutrition Tracking & Analysis
- Export to nutrition analysis tools
- Track dietary restrictions
- Generate nutrition reports
- Link: `/docs/use-cases/nutrition/` (needs creation)

### 6. CI/CD for Recipe Testing
- Validate recipe syntax automatically
- Check ingredient availability
- Generate recipe documentation
- Link: `/docs/for-developers/`

### 7. Export Formats
- Generate LaTeX cookbooks
- Export to JSON/Schema.org
- Create printable recipe cards
- Link: `/docs/use-cases/cookbook-creation/`

### 8. Home Automation Integration
- Set timers on smart devices
- Display recipes on kitchen tablets
- Voice assistant integration
- Link: `/docs/use-cases/smart-home/` (needs creation)

## Recommended Additions for Homepage

Based on the research, I suggest adding a new section called "Advanced Use Cases" or "Power User Features" with these items:

1. **Version Control** - Most unique differentiator vs other recipe apps
2. **Menu Planning** - Addresses the "meal planning as compilation" concept
3. **Recipe Scaling** - Common pain point for home cooks
4. **Cookbook Creation** - Appeals to content creators
5. **Raspberry Pi Setup** - DIY/self-hosting community
6. **Nutrition Analysis** - Health-conscious users

These highlight Cooklang's technical advantages while addressing real cooking challenges.

## Layout Suggestion

Add a new grid section after the current "Ecosystem" section but before "Why Choose Cooklang?" with 6 cards highlighting these advanced features. Each card should:
- Have an icon
- Brief description (2-3 lines)
- Link to documentation or blog post
- Focus on the technical/power-user angle

This positions Cooklang as both beginner-friendly AND powerful for advanced users.