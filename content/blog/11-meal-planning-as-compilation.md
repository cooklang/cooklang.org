---
title: "Meal Planning as Compilation"
date: 2025-09-05
description: "Why planning meals is like compiling code, and why most people are still using interpreters"
weight: 70
---

I used to think meal planning was for people with too much time. Then I realized I was spending more time not planning meals than it would take to plan them.

Let me be clear: what I'm about to describe isn't fully built yet. It's how I want meal planning to work, how it should work. Some pieces exist in Cooklang today, others are still being developed. Think of this as a design document for the future of meal planning, not a manual for current software.

Every evening around 5 PM, the same ritual: stare into the fridge, evaluate ingredients like a puzzle, realize I'm missing something crucial, order takeout. I was treating cooking like an interpreted language - parsing each meal at runtime. What I needed was compilation.

## The Interpreter Problem

Most people cook in interpreted mode. You decide what to eat when you're hungry. You check what you have. You discover you're missing ingredients. You adapt or abandon. This works, technically, the same way you can write production systems in bash scripts. But why would you?

The cognitive load is enormous. Every meal requires real-time decision making under the worst possible conditions - when you're tired and hungry. It's like debugging code while the server is down. You make bad decisions because you have to make them fast.

Here's what changed everything: I started treating meal planning like program compilation. Once a week, I write the source code. The compiler (my planning system) turns it into executable instructions. During the week, I just execute.

## The Menu File

A Cooklang menu file is source code for a week of eating. Here's an actual one I use:

```cooklang
---
servings: 2
---

==Monday==

Breakfast:
- @oatmeal{2%bowls} with @blueberries{100%g} and @honey
- @coffee{2%cups}

Lunch:
- @./Soups/Minestrone{4%servings} --make double batch

Dinner:
- @./Mains/Sheet-Pan Chicken{2} with @./Sides/Roasted Vegetables{}
- @./Salads/Simple Green{2%servings}

==Tuesday==

Breakfast:
- @yogurt{2%cups} with @granola{100%g} and @banana{2}
- @coffee{2%cups}

Lunch:
- @./Soups/Minestrone{}(leftover from Monday)

Dinner:
- @./Pastas/Aglio e Olio{2} 
- @./Salads/Caesar{2}

-- date night, make something nice

==Wednesday==

Breakfast:
- @scrambled eggs{4} with @toast{4%slices}
- @coffee{2%cups}

Lunch:
- @./Sandwiches/Grilled Cheese{2} with @tomato soup{1%can}

Dinner:
- @./Mains/Thai Green Curry{3} --freeze 1 portion
- @jasmine rice{2%cups}(cooked)

== Snacks ==
- @apples{6}
- @almonds{200%g}
- @hummus{1%container} with @carrots{500%g}
- @greek yogurt{4%cups}
- @dark chocolate{1%bar}
```

This isn't a wish list. It's a program. Each `@` reference either pulls in a full recipe or declares a simple ingredient. The system knows that `@./Soups/Minestrone{4%servings}` means look up that recipe, scale it to 4 servings, add all its ingredients to the shopping list.

## The Compilation Step

Sunday afternoon, I compile the week. The system reads the menu file and generates:

1. A shopping list with exact quantities
2. A prep schedule (what needs making when)
3. Reminders (defrost chicken Tuesday morning)
4. Portion calculations (that double batch of minestrone covers two lunches)

The magic is that compilation catches errors before they matter. Missing recipe file? Find out Sunday, not Wednesday at 6 PM. Ingredient conflict? (Need all the onions for curry but also for soup?) Resolve it now, when you have options.

## The Snack Buffer Problem

Here's what everyone forgets: snacks. You plan three perfect meals, execute flawlessly, then destroy your budget and health with convenience store runs because you didn't plan for reality - humans snack.

The `== Snacks ==` section isn't an afterthought. It's a buffer, like allocating extra memory for unexpected operations. Without it, your perfectly planned system fails when real life happens. Kid needs a snack for school. You're hungry at 3 PM. Partner wants something while watching Netflix.

Planning snacks does three things. First, it makes them visible in your shopping list. Those six apples and container of hummus get purchased with everything else, not grabbed desperately from a gas station at three times the price. Second, it provides known-good options when hunger strikes between meals. The decision is pre-made: apple with almonds, not vending machine cookies. Third, it prevents the cascade failure where unplanned snacking ruins dinner appetite, which shifts the whole schedule.

The quantities matter. Six apples for two people for three days - that's one per person per day. The 200g of almonds portions out to reasonable daily amounts. The dark chocolate bar isn't denial of pleasure; it's planned pleasure. You're going to eat chocolate anyway. Plan for it or pretend you won't and pay more at checkout.

## The Batch Processing Insight

The notation `--make double batch` next to Monday's minestrone isn't a comment - it's an optimization directive. Like loop unrolling in compiler optimization, cooking in batches amortizes fixed costs.

Chopping onions for one soup takes 5 minutes. Chopping for two takes 6. The oven preheats once whether you're roasting vegetables for two or six. The dishwasher runs regardless. Batch processing in the kitchen follows the same economics as batch processing in computing.

The `--freeze 1 portion` notation on Wednesday's curry is forward planning. Future me will thank current me when Thursday is insane and there's curry in the freezer.

## Dependencies and Scheduling

Meal planning reveals dependency chains you never noticed. That bread for Wednesday's grilled cheese needs to be fresh. The chicken for Monday needs defrosting Sunday night. The minestrone tastes better on day two, so make it Sunday for Monday.

This is a directed acyclic graph problem. Each meal has dependencies (ingredients, prep time, equipment). The compiler resolves these into a valid execution order. Sunday: make minestrone, prep vegetables. Monday morning: start slow cooker. Monday evening: just assemble.

## The Constraint Solver

Real meal planning works with constraints:
- Budget: $150/week
- Time: 30 minutes on weeknights, 2 hours on Sunday
- Nutrition: protein at each meal, vegetables twice daily
- Variety: no repeating main proteins consecutive days
- Reality: kids won't eat mushrooms, partner hates cilantro

These aren't preferences; they're system requirements. And here's where Cooklang's report system becomes powerful - it can enforce these constraints programmatically.

Using templates and the database system, you can validate your menu against reality. The budget constraint becomes a calculation in your template:

```jinja2
{%- set total_cost = namespace(value=0) %}
{%- for ingredient in ingredients %}
{%- set item_cost = db(underscore(ingredient.name) ~ ".cost.per_unit", 0) * ingredient.quantity %}
{%- set total_cost.value = total_cost.value + item_cost %}
{%- endfor %}

{% if total_cost.value > 150 %}
WARNING: Week exceeds budget at ${{ "%.2f"|format(total_cost.value) }}
{% endif %}
```

Nutrition constraints check themselves:

```jinja2
{%- for meal in daily_meals %}
{%- set protein = calculate_macros(meal, 'protein') %}
{% if protein < 20 %}
WARNING: {{ meal.name }} lacks adequate protein ({{ protein }}g)
{% endif %}
{%- endfor %}
```

The variety constraint becomes a simple validation:

```jinja2
{%- set proteins = [] %}
{%- for day in menu %}
{%- set main_protein = extract_protein(day.dinner) %}
{% if main_protein in proteins[-1:] %}
ERROR: Repeating {{ main_protein }} on consecutive days
{% endif %}
{%- set proteins = proteins + [main_protein] %}
{%- endfor %}
```

The "reality" constraints live in your database as ingredient metadata - mark mushrooms as "kid_friendly: false" and the system can warn when Tuesday's dinner won't work for the whole family.

This isn't theoretical. The report system with its Jinja2 templates and database integration makes these validations real. Run `cook report -t validate-menu.jinja 'weekly.menu' -d ./db` and get immediate feedback on whether your plan survives contact with reality.

The menu file respects constraints or compilation fails. Better to fail at planning time than dinnertime.

## The Leftovers Protocol

That `--leftover from Monday` annotation isn't laziness - it's resource management. In programming, we cache expensive computations. In cooking, we cache expensive preparations.

But leftovers need protocol. Three days for cooked grains. Five for soups and stews. Seven for pickled anything. Beyond that, you're not saving money; you're growing bacteria.

The menu system tracks this. Tuesday's leftover minestrone is fine. Friday's would be flagged as unsafe. The compiler won't let you food poison yourself.

## Error Handling

What happens when Tuesday's plan fails? You're exhausted, skip the aglio e olio, order pizza. The system doesn't break. Wednesday's ingredients are still there. Thursday's prep still makes sense. 

This is graceful degradation. One failed execution doesn't crash the whole week. You can resume from any point because each day's plan is independent enough to stand alone but connected enough to share resources.

## The Psychological Compiler

The deepest benefit isn't efficiency - it's removing decision fatigue. Steve Jobs wore the same outfit to save cognitive resources for important decisions. Meal planning is the same principle applied to food.

When you know Tuesday is aglio e olio, that's not a constraint - it's freedom. Freedom from standing in front of the fridge at 6:30 PM trying to be creative. Freedom from the guilt of another takeout order. Freedom from the stress of improvisation.

## Implementation

Start with three days, not seven. A long compilation unit is harder to debug. Get three days working, then expand. Use real recipes you actually cook, not aspirational ones. The fanciest meal plan you don't execute is worth less than the simple one you do.

Write it down. The format matters less than the practice. Cooklang menu files, spreadsheets, paper - pick one and commit. The act of planning is more important than the tool.

Review and refactor weekly. What worked? What didn't? That Thai curry you planned for 30 minutes took an hour - update the time estimate. The kids loved the sheet pan chicken - add it to regular rotation.

## The Payoff

Six months into this system, I spend 30 minutes planning and save 5 hours of deciding. Groceries cost 30% less because I buy what I need, not what I might need. Food waste approaches zero because everything has a purpose.

But the real payoff is peace. At 5 PM on Thursday, I'm not solving problems. I'm executing a plan. The cognitive load of "what's for dinner?" has been paid once, on Sunday, not seven times at the worst possible moment.

Your meals are going to happen regardless. You can compile them once or interpret them repeatedly. The computer science is clear on which is more efficient.

Plan your meals. Not because you're organized. Because you're lazy in the good way - the way that makes you optimize repetitive tasks so you can focus on what matters.

That's not meal prep. That's engineering.
