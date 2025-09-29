---
title: "About"
date: 2024-01-01
layout: "single"
menu:
  main:
    name: "About"
    weight: 50
---

# My Story — Crafting Cooklang

During the pandemic, I was living in a tiny village on the Irish east coast. With quarantine restrictions, we couldn’t go further than 5 km from our house. Online shopping became the only option, and it revealed an unexpected frustration: without wandering through all aisles, I either forgot essentials or ended up with a dozen things I didn’t need. After juggling sticky-note meal plans that quickly grew repetitive, I thought: “It’s time to automate this… and never solve it twice.”

So I began writing recipes in plain text—tagging ingredients with `@`:

```cooklang
Poke holes in @potato{2}.  

Add @salt and @ground black pepper{} to taste.
```

That simple markup—both human-friendly and machine-readable—became the heart of Cooklang.

Next came the power tools: a parser, then a CLI, that turn your `.cook` files into shopping lists, organized by department with one command:

```bash
$ cook shopping-list Monday.cook Tuesday.cook
```

Shopping became faster, cooking became smoother.

But it's not just about lists—it's about **ownership and flexibility**. Because Cooklang is just text, you can version control it, tweak it, and use it forever. There's no subscription, no lock-down. Your recipes are yours.

I practice what I preach—my own recipes live in a [public GitHub repository](https://github.com/dubadub/cookbook), where anyone can see how I organize meals, automate shopping, and continuously refine my cooking workflow.

What started as developer convenience turned into something joyful—meal planning is no longer a chore, it's a creative act. Cooklang emerged from necessity, yes—but now fuels creativity and clarity in the kitchen.

## Support Cooklang

☕ **Like Cooklang? Buy me a coffee.**

Cooklang is a labor of love that I maintain in my spare time. If it's helped make your cooking or shopping easier, you can support its development by [buying me a coffee](https://www.buymeacoffee.com/dubadub)—it keeps the project running and fuels new ideas.

## Stay Updated

Get the latest Cooklang news and updates delivered to your inbox once a month.

{{< newsletter-form >}}

---

*— Alex*
