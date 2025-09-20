---
title: "Why Plain Text Recipes Beat Databases Every Time"
date: 2025-01-20
weight: 70
summary: "After years of building recipe apps with databases, I discovered that plain text files solve the real problems better. Here's why the future of digital recipes isn't in the cloud - it's in your text editor."
---

You know what file format has survived since the 1960s? Plain text. You know what hasn't? Every recipe database format from the past 20 years.

There's a disturbing pattern in recipe apps: MacGourmet (abandoned by Mariner Software), Panna (absorbed by Food Network 2020), Yummly (acquired by Whirlpool 2017), Evernote Food (killed 2015), ChefTap (shut down 2023). Each transition forced users to export, migrate, or lose their recipes entirely. Meanwhile, my grandmother's index cards from 1962 still work perfectly.

After using recipe apps for a decade, I discovered something counterintuitive: the most advanced way to store recipes isn't in a database at all. Here's why treating recipes as plain text files is paradoxically more powerful than any app.

## The Database Trap

Traditional recipe apps store your recipes like this:

```sql
recipes_table: id, title, prep_time, cook_time...
ingredients_table: id, recipe_id, name, quantity, unit...
instructions_table: id, recipe_id, step_number, text...
recipe_tags_table: recipe_id, tag_id...
```

Looks organized, right? It is. For computers. For humans, it's a disaster.

Here's the same recipe in Cooklang:

```cooklang
---
title: Simple Pasta
prep_time: 5 minutes
cook_time: 15 minutes
tags: [italian, quick, vegetarian]
---

Boil @water{2%L} with @salt{1%tsp} in a large #pot.

Add @spaghetti{200%g} and cook for ~{12%minutes}.

Drain and toss with @olive oil{2%tbsp} and @parmesan{50%g}.
```

Which one would you rather edit at 6 PM while juggling kids and groceries?

## The Five Freedoms of Plain Text

### 1. You Own Your Data (Actually)

With database apps, you own your recipes like you own your Netflix movies. You have access... until you don't.

Plain text files? They're yours. Forever. Open them in 2025 or 2055. Edit them in VS Code, Notepad, vim, or carved into stone tablets. Your recipes, your rules.

### 2. Version Control That Actually Works

My wife changed my carbonara recipe to use cream (sacrilege!). In a database app, the original is gone. With plain text and Git:

```bash
git diff carbonara.cook
- Add @beaten eggs{3} to pasta immediately
+ Add @heavy cream{1/2%cup} and @beaten eggs{3} to pasta
```

I can see exactly what changed, when, and by whom. I can revert it, branch it, or maintain both versions. Try doing that with a recipe locked in someone else's database.

### 3. Universal Compatibility

Watch what happens when I share a Cooklang recipe:

- Email it → They can read it
- Text message → Still readable
- Print it → Looks like a recipe
- Post on Reddit → Formatted correctly
- Import to any Cooklang tool → Full functionality

Now try emailing someone a recipe from your database-backed app. "Just download our app!" Yeah, good luck with that.

### 4. Scriptable Everything

Last week, I wanted to find all recipes I could make with what's in my pantry. With plain text:

```bash
grep -l "chicken\|rice\|tomato" *.cook |
  xargs -I {} grep -L "cream\|butter" {} |
  head -5
```

Five recipes, no dairy, using my available ingredients. Took 0.3 seconds.

With a database app? "This feature coming in Premium Plus! Only $9.99/month!"

### 5. Merge, Don't Overwrite

My family shares a recipe folder via Git. When wife and I both edit recipes:

```
Wife's changes:  Added "season to taste" to soup.cook
My changes:     Fixed typo in soup.cook
Git:           Merged both changes automatically
```

Database apps? "Conflict! Choose which version to keep." You lose one set of changes. Every. Single. Time.

## The Performance Myth

"But databases are faster!"

Really? Let's test that:

```bash
# Finding all 30-minute recipes in my 1,000+ recipe collection
time grep -l "cook_time: 30" *.cook
real    0m0.012s

# Same query in SQLite
time sqlite3 recipes.db "SELECT * FROM recipes WHERE cook_time = 30"
real    0m0.038s
```

Plain text with grep: 12 milliseconds
Optimized SQLite: 38 milliseconds

For most home cooks with fewer than 10,000 recipes, plain text is *faster*.

## The Real Cost of "Free" Cloud Storage

That recipe app that backs up to the cloud? Let's do the math:

- Average recipe: 2KB of text
- 1,000 recipes: 2MB total
- Cloud storage cost: "Free!"
- Hidden cost: Your data is their product

They're not storing your recipes out of kindness. They're mining them for data, showing you ads, or waiting to charge you when you're locked in.

My recipes in plain text:
- Storage: 2MB on my drive (aka free)
- Backup: Git/Dropbox/USB stick (actually free)
- Privacy: Complete
- Lock-in: Zero

## The Network Effect That Actually Matters

Database apps promise "social features." Share with friends! Discover new recipes! Rate and review!

You know what's more social? Texting a friend:

```
"Hey Sarah, here's that curry recipe:
github.com/dubadub/cookbook/curry.cook"
```

She clicks, sees the recipe, copies the text. No account, no app, no subscription.

The network effect that matters isn't how many users an app has. It's how many people can immediately use your recipes without installing anything.

## The 10-Year Test

Here's my challenge: Pick any recipe app with a database. Now imagine:

- The company goes under (happens weekly in tech)
- They pivot to B2B (goodbye consumer app)
- They get acquired (hello, subscription increase)
- They have a data breach (your email's now spam central)
- They change their terms (your recipes train their AI now)

Now imagine Cooklang text files:

- Company goes under? Files still work
- Pivot to B2B? Files still work
- Acquisition? Files still work
- Data breach? Files on your computer still work
- Terms change? What terms? They're text files

## The Unexpected Benefits

After two years with plain text recipes, unexpected benefits emerged:

**Recipe Development**: I keep variants in branches. `carbonara-classic.cook`, `carbonara-cream.cook`, `carbonara-vegan.cook`. Database apps force one canonical version.

**Meal Planning as Code**: My meal plan is a text file that references recipes:
```
Monday: @./italian/carbonara{}
Tuesday: @./asian/pad-thai{2}  # guests coming
Wednesday: @./soups/minestrone{} + @./breads/focaccia{}
```

## The Philosophical Difference

Database apps assume recipes are data to be structured, queried, and optimized.

Plain text assumes recipes are documents to be read, edited, and shared.

Which matches how you actually use recipes?

When I'm cooking, I don't need normalized data relations. I need to know what goes in the pot next. Plain text respects that recipes are instructions for humans first, data second.

## Making the Switch

If you're convinced, here's how to start:

1. **Export what you can** from your current app
2. **Start new recipes** in Cooklang
3. **Convert gradually** - no rush
4. **Use any text editor** - seriously, Notepad works
5. **Sync however you want** - Dropbox, Git, USB stick

Don't overthink it. It's just text files.

## The Counterarguments (And Why They're Wrong)

**"But I like pretty pictures!"**
Keep them. `carbonara.cook` and `carbonara.jpg` in the same folder. Every Cooklang viewer supports this.

**"Databases enable better search!"**
```bash
grep -i "tomato" *.cook  # Found 47 recipes in 0.02 seconds
```

**"What about scaling recipes?"**
Cooklang tools handle this. Or use any programming language. Or a calculator. You have options.

**"Cloud sync is convenient!"**
So is Dropbox. Or GitHub. Or Syncthing. Or email-to-self. Pick your poison.

## The Recipe Revolution

The revolution isn't building better recipe databases. It's recognizing that recipes don't need databases at all.

Every recipe app that has died took thousands of family recipes with it. Every plain text file from the 1980s still opens fine.

You know what's really modern? Text files that will outlive every startup, every platform, every database technology that comes and goes.

Your grandmother's handwritten recipe cards have survived longer than most recipe apps. There's a lesson there.

Welcome to plain text recipes. Your great-grandchildren will thank you.

-Alexey
