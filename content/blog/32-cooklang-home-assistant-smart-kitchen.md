---
title: "Cooklang + Home Assistant: Smart Kitchen Meal Planning & Recipes"
date: 2026-02-28
weight: 60
summary: "Turn Home Assistant into a smart kitchen hub by integrating CookCLI — display today's recipe, trigger shopping lists, track expiring pantry items, and fire smart timers from your recipes."
description: "Integrate recipe management and meal planning into Home Assistant. Display recipes, generate shopping lists, and run cooking timers from your HA dashboard."
categories: ["Self-Hosting and Integrations"]
---

Home Assistant controls your lights, thermostat, and door locks. It knows when you wake up and when you leave the house. So why doesn't it know what's for dinner?

With [CookCLI](/cli/) running on your local network, the answer is a few lines of YAML away. This post shows how to pull your recipes into a Home Assistant dashboard, generate shopping lists from HA automations, fire smart timers from recipe step data, and surface expiring pantry items without leaving the HA UI.

This is a companion to the [Raspberry Pi kitchen display post](/blog/17-raspberry-pi-kitchen-display/), which covers the hardware setup and getting CookCLI running as a service. Read that first if you're starting from scratch. This post assumes CookCLI is already running on your network — either on a Pi or any other machine — and focuses entirely on the Home Assistant side.

Fair warning: some of what follows requires a bit of custom scripting. This is for the tinkerer audience. If you love Home Assistant's YAML editor, you'll feel at home.

## The Setup

CookCLI's server runs at `http://kitchen.local:9080` (or whatever hostname and port you've configured). It gives you:

- A web UI for browsing recipes, with a shopping list and pantry page
- A JSON API under `/api/` (the full list is at `/api-docs` on your server)
- On the command line, JSON output from `cook recipe -f json`, `cook shopping-list -f json` and `cook pantry -f json expiring`

There are two ways to wire this into Home Assistant:

1. **The [CookCLI integration](https://github.com/cooklang/homeassistant-cookcli)** from HACS. It talks to the server's API over HTTP, so it works when Home Assistant runs in a container or on HA OS, where you can't set up SSH. It gives you pantry sensors, a meal plan calendar, the shopping list as to-do lists, and actions for automations. Start here.
2. **Plain HA YAML** — `command_line` sensors and `shell_command` services that SSH into the machine running CookCLI. More flexible, but it needs a Home Assistant install where you can put an SSH key, which rules out most container setups.

The sections below use the integration where it covers the job, and YAML for the rest.

The full stack: your `.cook` recipe files on a shared volume, CookCLI serving them, Home Assistant reading from CookCLI's outputs and driving smart devices based on that data.

## Installing the Integration

In HACS, open the three-dot menu → **Custom repositories**, add `https://github.com/cooklang/homeassistant-cookcli` as an **Integration**, install **CookCLI**, and restart Home Assistant. Then go to **Settings → Devices & Services → Add Integration → CookCLI** and enter your server's URL, e.g. `http://kitchen.local:9080`.

You get these entities:

| Entity | What it is |
|---|---|
| `todo.cookcli_shopping_list` | The recipes on CookCLI's shopping list |
| `todo.cookcli_shopping_ingredients` | The ingredients to buy for them — scaled, with pantry stock subtracted |
| `calendar.cookcli_meal_plan` | Your active `.menu` file as calendar events |
| `sensor.cookcli_pantry_expiring` | Pantry items expiring within 7 days |
| `sensor.cookcli_pantry_depleted` | Pantry items running low |
| `sensor.cookcli_recipes` | Recipe count |

## Embedding the Recipe Server

The simplest integration is an iframe panel. Add CookCLI's web UI directly to your Home Assistant dashboard as a Webpage card:

```yaml
type: iframe
url: http://kitchen.local:9080
aspect_ratio: 75%
```

Drop this into any dashboard view and your entire recipe collection — browsable, searchable, scalable — is available without leaving Home Assistant. On a wall-mounted tablet running the HA dashboard, this effectively becomes the kitchen display from the Raspberry Pi post, embedded in your smart home UI rather than running standalone.

This works immediately with no configuration beyond knowing your CookCLI server's address. It's not "integrated" in the data sense, but it gets your recipes visible in the HA dashboard in under a minute.

## Recipe Dashboard Card with REST Sensor

For a real data integration, use HA's REST sensor to pull structured recipe data from CookCLI. The idea: pick a recipe for the day, run `cook recipe --format json` on it, and surface the result as a sensor state in Home Assistant.

This requires a small wrapper script on the machine running CookCLI. Create `/usr/local/bin/today-recipe.sh`:

```bash
#!/bin/bash
# Read today's recipe from a menu file and output JSON
RECIPE=$(cat /home/pi/recipes/menu/today.txt 2>/dev/null)
if [ -z "$RECIPE" ]; then
  echo '{"metadata": {"map": {"title": "No recipe planned"}}, "ingredients": [], "cookware": []}'
  exit 0
fi
cook recipe "/home/pi/recipes/${RECIPE}" -f json
```

Make it executable:

```bash
chmod +x /usr/local/bin/today-recipe.sh
```

Then configure a `command_line` sensor in Home Assistant's `configuration.yaml`:

```yaml
command_line:
  - sensor:
      name: "Today's Recipe"
      command: "ssh pi@kitchen.local /usr/local/bin/today-recipe.sh"
      value_template: "{{ value_json.metadata.map.title | default('Untitled') }}"
      json_attributes:
        - metadata
        - ingredients
        - cookware
      scan_interval: 3600
      command_timeout: 15
```

This polls the Pi over SSH once per hour (3600 seconds). The sensor's state becomes the recipe's title from its frontmatter. The attributes hold the full structured data: metadata (servings, tags, and so on), ingredient list, and cookware.

To display it on your dashboard, add a Markdown card:

```yaml
type: markdown
title: "Tonight's Dinner"
content: >
  ## {{ states('sensor.today_s_recipe') }}

  **Servings:** {{ state_attr('sensor.today_s_recipe', 'metadata').map.servings }}

  **Ingredients:**
  {% for ingredient in state_attr('sensor.today_s_recipe', 'ingredients') %}
  {%- set q = ingredient.quantity %}
  - {% if q and q.value.type == 'number' and q.value.value.type == 'regular' %}{{ q.value.value.value }} {{ q.unit or '' }} {% endif %}{{ ingredient.name }}
  {% endfor %}
```

Quantities in the JSON are structured rather than pre-formatted, which is why the template digs into `q.value.value.value`; it prints numbers as decimals (`1/2` shows as `0.5`) and leaves out ranges like `2-3`, showing just the ingredient name.

The result is a live recipe card on your dashboard, driven by whatever you've put in `today.txt`. Change the file, wait for the next poll (or trigger a manual refresh), and the card updates.

## Shopping List Integration

CookCLI keeps one shopping list: you add recipes and menus to it from the web UI, and it works out the ingredients — combined across recipes, scaled, with what's in your pantry taken off. The integration puts that list in Home Assistant two ways.

**As its own to-do list.** `todo.cookcli_shopping_ingredients` shows the ingredients to buy, like `pasta (400 g)`. Ticking one off in Home Assistant ticks it off in CookCLI, and the other way round, so the HA app on your phone works as the shopping list in the store. Add it to a dashboard like any to-do list:

```yaml
type: todo-list
entity: todo.cookcli_shopping_ingredients
```

**Copied into Home Assistant's Shopping List.** If you already keep groceries in HA's own Shopping List (or any other to-do list), the `cookcli.export_shopping_list` action copies the ingredients across. A button on the kitchen dashboard:

```yaml
type: button
name: "Send to shopping list"
icon: mdi:cart-arrow-right
tap_action:
  action: perform-action
  perform_action: cookcli.export_shopping_list
  data:
    entity_id: todo.shopping_list
```

It leaves out ingredients you've already ticked off in CookCLI, and ones already on the target list and not yet bought, so pressing it twice doesn't add everything twice. Set `include_quantities: false` if you'd rather have `pasta` than `pasta (400 g)`.

To fill the list from an automation — say, every Saturday morning from the recipes you've planned — use `cookcli.add_recipe_to_shopping_list`:

```yaml
action: cookcli.add_recipe_to_shopping_list
data:
  recipe: "Neapolitan Pizza.cook"
  scale: 2
```

No SSH, no scripts on the Pi, and it works the same when Home Assistant runs in a container.

## Smart Timers from Recipe Data

This is where the integration gets interesting. Cooklang recipes encode timer data directly — `~{25%minutes}` marks a 25-minute step. When you pull a recipe as JSON, those timer values are structured data you can act on.

The pattern: parse the recipe JSON, extract timer values, and fire a Home Assistant automation that starts a timer, shows a countdown on your kitchen display, and announces completion on a smart speaker.

First, add a `command_line` sensor that extracts timers from today's recipe. The recipe JSON has a top-level `timers` array; each entry has a `name` and a `quantity` (value and unit, such as `25` `minutes`):

```yaml
command_line:
  - sensor:
      name: "Recipe Timers"
      command: >
        ssh pi@kitchen.local
        "cook recipe \"/home/pi/recipes/\$(cat /home/pi/recipes/menu/today.txt)\" -f json
        | python3 -c 'import json,sys; print(json.dumps({\"timers\": json.load(sys.stdin)[\"timers\"]}))'"
      value_template: "{{ value_json.timers | length }} timers"
      json_attributes:
        - timers
      scan_interval: 3600
```

Then create a script in Home Assistant that starts a timer and triggers announcements:

```yaml
script:
  start_recipe_timer:
    alias: "Start Recipe Timer"
    fields:
      duration_minutes:
        description: "Timer duration in minutes"
        example: 25
    sequence:
      - action: timer.start
        target:
          entity_id: timer.kitchen_recipe_timer
        data:
          duration: "{{ duration_minutes * 60 }}"
      - action: tts.speak
        target:
          entity_id: tts.home_assistant_cloud
        data:
          media_player_entity_id: media_player.kitchen_speaker
          message: "Timer started for {{ duration_minutes }} minutes"
```

Add the timer entity to `configuration.yaml`:

```yaml
timer:
  kitchen_recipe_timer:
    name: "Kitchen Timer"
    restore: true
```

When the timer finishes, fire an automation:

```yaml
automation:
  - alias: "Kitchen Timer Finished"
    trigger:
      - platform: event
        event_type: timer.finished
        event_data:
          entity_id: timer.kitchen_recipe_timer
    action:
      - action: tts.speak
        target:
          entity_id: tts.home_assistant_cloud
        data:
          media_player_entity_id: media_player.kitchen_speaker
          message: "Kitchen timer is done!"
      - action: light.turn_on
        target:
          entity_id: light.kitchen_light
        data:
          flash: short
```

Swap `tts.home_assistant_cloud` for whichever text-to-speech entity you have (Piper, Google Translate, and so on).

Flashing the kitchen lights when a timer finishes is genuinely useful if you walk away from the kitchen with noise-canceling headphones on. The recipe data drives the timer value; HA handles the notification.

## Pantry Alerts on the Dashboard

The integration's `sensor.cookcli_pantry_expiring` counts the pantry items that expire within the next seven days, and lists them in its `items` attribute. Zero is good. Above zero means something needs attention.

If you're on the YAML route instead, the command-line equivalent is below. Note that `--format` belongs to `cook pantry` itself, so it goes before `expiring`:

```yaml
command_line:
  - sensor:
      name: "Expiring Pantry Items"
      command: "ssh pi@kitchen.local cook pantry -f json expiring"
      value_template: "{{ value_json['items'] | length }}"
      json_attributes:
        - items
      scan_interval: 86400
      command_timeout: 10
```

The CLI's items carry `expire_date`, where the integration's carry `expire`; the card below uses the integration's names.

Add a conditional card that only appears when the count is nonzero:

```yaml
type: conditional
conditions:
  - entity: sensor.cookcli_pantry_expiring
    state_not: "0"
card:
  type: markdown
  title: "Use These Soon"
  content: >
    {% set items = state_attr('sensor.cookcli_pantry_expiring', 'items') %}
    {% for item in items %}
    - **{{ item.name }}** — expires {{ item.expire }}
    {% endfor %}
```

The card disappears when the pantry is clear and reappears when something is about to expire. Clean dashboard behavior with no manual intervention.

Pair this with an automation that sends a notification to your phone each morning when something is expiring:

```yaml
automation:
  - alias: "Pantry Expiry Alert"
    trigger:
      - platform: time
        at: "08:30:00"
    condition:
      - condition: numeric_state
        entity_id: sensor.cookcli_pantry_expiring
        above: 0
    action:
      - action: notify.mobile_app_your_phone
        data:
          title: "Pantry reminder"
          message: >
            {{ states('sensor.cookcli_pantry_expiring') }} item(s) expiring soon.
            Check the kitchen dashboard.
```

This runs once a day at 8:30 and only notifies when there's something to use up, so you get at most one reminder a day.

## Meal Planning Display

If you use Cooklang's `.menu` format for weekly meal plans, the integration's `calendar.cookcli_meal_plan` already shows them: set the active menu file when you add the integration, and give each section a date, like `== Monday (2026-03-09) ==`. Add a calendar card and the week's meals show up at their meal times.

For a custom layout, a script on the Pi parses the menu file and outputs structured JSON:

```bash
#!/bin/bash
# /usr/local/bin/weekly-menu.sh
python3 << 'EOF'
import json, re
from pathlib import Path

menu_file = Path("/home/pi/recipes/menu/this-week.menu")
if not menu_file.exists():
    print(json.dumps([]))
    exit()

days = []
current_day = None
for line in menu_file.read_text().splitlines():
    day_match = re.match(r"==(.+)==", line.strip())
    if day_match:
        current_day = {"day": day_match.group(1), "meals": []}
        days.append(current_day)
    elif line.strip() and current_day:
        current_day["meals"].append(line.strip())

print(json.dumps(days))
EOF
```

Wire it to a `command_line` sensor with a daily scan interval, then build a Markdown card to display the week. The result is a weekly menu on your dashboard — same data that drives your shopping list, now visible on the wall-mounted tablet in the kitchen.

## Going Further

A few directions worth exploring once the basics are working.

**NFC tags on pantry items.** HA's mobile app supports NFC tag scanning. Stick a tag on a pantry item, tap your phone, trigger an automation that looks up the item in your pantry config and shows what recipes use it. Low-tech data input for the pantry.

**Voice commands via Assist.** Home Assistant's built-in voice assistant (Assist) can call scripts and services. Set up a sentence trigger that calls `cookcli.export_shopping_list` when you say "send my recipes to the shopping list." Requires a bit of intent configuration, but the infrastructure is already there.

**Recipe suggestions based on pantry.** Run `cook pantry -f json recipes` on a schedule. Feed the output to a sensor. Display the "can make now" list on your dashboard — a live view of what you can cook without going to the store. Combine this with an automation that pushes the list to your phone every Friday afternoon when you're figuring out the weekend.

## An Honest Note

The integrations in this post range from trivial (the iframe card, the HACS integration) to genuinely involved (timers from recipe data). The SSH-based command approach works well on a local network but requires passwordless SSH configured between HA and the Pi — which you can't do on HA OS or most container installs — and error handling in the shell scripts if you want them to degrade gracefully.

If you're new to Home Assistant, start with the iframe card and the HACS integration — that alone covers the shopping list, pantry, and meal plan — and add YAML incrementally for the rest.

One limitation: if you've turned on sign-in for `cook server`, the integration can read but not change anything yet (adding recipes, ticking items off). API tokens for that are [planned](https://github.com/cooklang/cookcli/issues/763).

The data model is what makes this work: Cooklang recipes are structured text, and `cook` can output that structure as JSON. Once the data is JSON, Home Assistant can consume it like any other sensor value. The tools do exactly what they're supposed to do, and the integration is mostly plumbing.

## Get Started

Start with CookCLI running on your network — the [Raspberry Pi kitchen display guide](/blog/17-raspberry-pi-kitchen-display/) covers that end-to-end. Then add the iframe card to your HA dashboard as a first step. From there, add sensors and automations one at a time as you find the ones that actually improve your workflow.

The [CookCLI documentation](/cli/) covers all the commands referenced here. The [getting-started guide](/docs/getting-started/) is the right place if you're new to Cooklang format.

[CookCLI documentation →](/cli/) | [Cooklang spec →](/docs/spec/) | [Raspberry Pi kitchen display →](/blog/17-raspberry-pi-kitchen-display/)

-Alex
