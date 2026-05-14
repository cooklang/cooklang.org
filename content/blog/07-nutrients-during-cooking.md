---
title: "What Recipe Software Should Tell You About Nutrition"
date: 2024-12-16
weight: 80
summary: "Cooking method changes nutrition as much as the ingredients do. Recipe apps know neither. Here's what structured recipe data could finally make possible."
description: "Cooking method changes nutrition as much as the ingredients do. Recipe apps know neither. Here's what structured recipe data could finally make possible."
---

Steamed broccoli has more bioavailable sulforaphane than raw. Sautéed spinach delivers more usable vitamin A than boiled. Boiling broccoli for 10 minutes destroys roughly 50% of its vitamin C; steaming for 5 destroys almost none.

Your recipe app knows none of this. It can't tell you that the recipe you're about to cook trades nutrition for convenience, or suggest a method change that would keep more of what's in the food. The bottleneck isn't the science — the cooking chemistry is well understood. It's that recipes are unstructured prose, and there's nothing for software to reason over.

Here's the gap, why it persists, and what structured recipe data could finally make possible.

## What Recipe Apps Are Missing

Most recipes optimize for flavor. Some optimize for speed. Almost none optimize for nutrition — and the reason isn't a lack of demand. It's that recipe data is too unstructured for software to do anything intelligent with.

If a recipe knows it contains spinach and the cooking method is boiling, it could suggest: "Steam instead to retain 40% more vitamin C." If it detects iron-rich ingredients without a vitamin C source, it could prompt: "Consider adding lemon juice to improve iron absorption." If it sees garlic added directly to a hot pan, it could note that crushing it 10 minutes before cooking activates allicin.

None of this exists today, because the building blocks aren't there. A recipe written as prose — "a few cloves of garlic, sautéed" — cannot be queried, paired, or substituted. You need typed ingredients, quantities as data, and cookware/method tags. That's the foundation [Cooklang](/docs/spec/) provides: structured annotations (`@spinach{200%g}`, `~{5%minutes}`) inside natural recipe text. Every ingredient has a known quantity. Every cooking action has metadata.

We haven't built nutritional analysis into [CookCLI](/cli/) yet. But the structured data is already there in every Cooklang recipe — it's a tooling problem, not a format problem.

## Why Cooking Method Matters

The science behind why software *should* care about cooking method. The trade-offs are specific to each nutrient and each method:

**Boiling** leaches water-soluble vitamins (C, B vitamins, folate) into the cooking water. If you drink the water — soups, stews — you keep the nutrients. If you drain it, you lose up to 50% of vitamin C and 35% of B vitamins. This is why broccoli boiled for 10 minutes retains far less vitamin C than broccoli steamed for 5.

**Steaming** is gentler. Food doesn't sit in water, so water-soluble vitamins stay in the food. Steamed broccoli retains about 80% of its vitamin C compared to raw. It's the best method for preserving heat-sensitive nutrients in vegetables.

**Sautéing and frying** in fat increase absorption of fat-soluble vitamins (A, D, E, K) and carotenoids. This is why spinach sautéed in olive oil delivers more usable vitamin A than raw spinach. The fat acts as a carrier. The trade-off: you're adding calories from the cooking fat.

**Roasting** concentrates flavors through Maillard reactions and caramelization. Nutrient loss is moderate — less than boiling, more than steaming. Roasted tomatoes have increased lycopene bioavailability compared to raw, because heat breaks down cell walls and releases the compound.

**Grilling** at very high temperatures can create heterocyclic amines (HCAs) on charred meat — compounds linked to health risks in high amounts. Lower-temperature grilling and shorter cooking times reduce HCA formation.

## Nutrient Pairing

Beyond cooking method, ingredient combinations matter — and they're another thing structured recipe data could surface:

- **Iron + vitamin C.** Plant-based iron (from spinach, lentils) is poorly absorbed on its own. Adding a vitamin C source — lemon juice, tomatoes, bell peppers — can increase iron absorption by 2-3x. A squeeze of lemon on your lentil soup isn't just flavor; it's nutrition engineering.

- **Fat + carotenoids.** Beta-carotene (carrots, sweet potatoes), lycopene (tomatoes), and lutein (spinach, kale) are fat-soluble. Cook them with a small amount of fat and you absorb significantly more. This is why traditional Mediterranean cooking pairs tomatoes with olive oil — the combination is nutritionally synergistic.

- **Allicin activation.** Garlic's beneficial compound, allicin, forms when you crush or chop garlic and let it sit for 10 minutes before cooking. Adding garlic directly to a hot pan deactivates the enzyme that produces allicin. Chop first, wait, then cook.

Each of these is a rule a recipe app could apply automatically — *if* it could read the recipe.

## What's Needed to Close the Gap

A nutrition-aware recipe tool needs three things:

1. **Structured recipe data.** Ingredients as typed values with quantities. Cooking actions taggable. Timers with units. Cooklang already provides this.

2. **A nutrient database with cooking-method modifiers.** Existing nutrient databases (USDA FoodData Central, etc.) are largely flat — they list nutrients per 100g of an ingredient. They don't model how method changes the result. This is the missing piece, and it's data work, not parser work.

3. **A rule engine.** Map ingredient + method + quantity to nutritional impact. Detect missing pairings (iron without C). Suggest method swaps that preserve more of what matters.

The structured-recipe foundation is the prerequisite. Without typed ingredients and tagged methods, none of the rest is buildable. With them, this becomes a tractable engineering problem — not a research one.

## Until Then: Practical Cooking Takeaways

The science is what it is. While the tooling catches up, the rules to follow as a cook:

- **Steam vegetables instead of boiling them.** If you do boil, use the cooking water in a sauce or soup.
- **Add fat to carotenoid-rich foods.** A drizzle of olive oil on roasted carrots or sautéed spinach increases absorption of vitamins A and E.
- **Crush garlic and wait before cooking.** Ten minutes of air exposure activates allicin. Then cook it however you want.
- **Don't overcook.** Shorter cooking times at moderate temperatures preserve more nutrients across the board. This also usually produces better texture and flavor — nutrition and quality align more often than you'd expect.
- **Eat a mix of raw and cooked.** Some nutrients are better raw (vitamin C), others cooked (lycopene, beta-carotene). A varied diet covers more ground than committing to either extreme.

These are easy rules for a human to remember. They're also exactly the kind of rules a structured recipe tool could surface automatically — once recipes are data, not just text.

-Alexey
