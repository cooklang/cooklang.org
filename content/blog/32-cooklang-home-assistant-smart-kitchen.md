---
title: "Cooklang + Home Assistant: Smart Kitchen Meal Planning & Recipes"
date: 2026-02-28
weight: 60
summary: "Turn Home Assistant into a smart kitchen hub by integrating CookCLI — display today's recipe, trigger shopping lists, track expiring pantry items, and fire smart timers from your recipes."
description: "Integrate recipe management and meal planning into Home Assistant. Display recipes, generate shopping lists, and run cooking timers from your HA dashboard."
---

Home Assistant controls your lights, thermostat, and door locks. It knows when you wake up and when you leave the house. So why doesn't it know what's for dinner?

With [CookCLI](/cli/) running on your local network, the answer is a few lines of YAML away. This post shows how to pull your recipes into a Home Assistant dashboard, generate shopping lists from HA automations, fire smart timers from recipe step data, and surface expiring pantry items without leaving the HA UI.

This is a companion to the [Raspberry Pi kitchen display post](/blog/17-raspberry-pi-kitchen-display/), which covers the hardware setup and getting CookCLI running as a service. Read that first if you're starting from scratch. This post assumes CookCLI is already running on your network — either on a Pi or any other machine — and focuses entirely on the Home Assistant side.

Fair warning: some of what follows requires a bit of custom scripting. This is for the tinkerer audience. If you love Home Assistant's YAML editor, you'll feel at home.

## The Setup

CookCLI's server runs at `http://kitchen.local:9080` (or whatever hostname and port you've configured). It exposes:

- A web UI for browsing recipes
- A REST-accessible JSON format via `cook recipe --format json`
- A shopping list generator via `cook shopping-list --format json`
- A pantry tracker via `cook pantry expiring --format json`

Home Assistant can talk to all of this through REST sensors, `command_line` sensors, `shell_command` services, and iframe panels. No custom integration, no HACS dependency — just built-in HA capabilities wired to CookCLI's outputs.

The full stack: your `.cook` recipe files on a shared volume, CookCLI serving them, Home Assistant reading from CookCLI's outputs and driving smart devices based on that data.

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
  echo '{"name": "No recipe planned", "servings": 0, "ingredients": []}'
  exit 0
fi
cook recipe "/home/pi/recipes/${RECIPE}" --format json
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
      value_template: "{{ value_json.name }}"
      json_attributes:
        - servings
        - ingredients
        - cookware
      scan_interval: 3600
      command_timeout: 15
```

This polls the Pi over SSH once per hour (3600 seconds). The sensor's state becomes the recipe name. The attributes hold the full structured data: ingredient list, cookware, servings count.

To display it on your dashboard, add a Markdown card:

```yaml
type: markdown
title: "Tonight's Dinner"
content: >
  ## {{ states('sensor.today_s_recipe') }}

  **Servings:** {{ state_attr('sensor.today_s_recipe', 'servings') }}

  **Ingredients:**
  {% for ingredient in state_attr('sensor.today_s_recipe', 'ingredients') %}
  - {{ ingredient.quantity }} {{ ingredient.units }} {{ ingredient.name }}
  {% endfor %}
```

The result is a live recipe card on your dashboard, driven by whatever you've put in `today.txt`. Change the file, wait for the next poll (or trigger a manual refresh), and the card updates.

## Shopping List Integration

`cook shopping-list --format json` outputs a structured list of ingredients across multiple recipes. With a `shell_command` in Home Assistant, you can trigger this from the HA UI — or from an automation.

Add to `configuration.yaml`:

```yaml
shell_command:
  generate_shopping_list: >
    ssh pi@kitchen.local
    "cook shopping-list /home/pi/recipes/menu/*.cook --format json
    > /tmp/shopping-list.json"
```

Then add a button to your dashboard that calls this service:

```yaml
type: button
name: "Generate Shopping List"
icon: mdi:cart-outline
tap_action:
  action: call-service
  service: shell_command.generate_shopping_list
```

Tap the button before heading to the store and the JSON file gets written to `/tmp/shopping-list.json` on the Pi.

To surface the list in Home Assistant itself, add another `command_line` sensor that reads the generated file:

```yaml
command_line:
  - sensor:
      name: "Shopping List Items"
      command: "ssh pi@kitchen.local cat /tmp/shopping-list.json"
      value_template: "{{ value_json | length }}"
      json_attributes_path: "$"
      scan_interval: 600
```

Home Assistant also has a built-in todo list integration. With a bit of scripting, you can pipe the JSON output into HA's REST API to populate the native shopping list. This requires the [Long-Lived Access Token](https://developers.home-assistant.io/docs/auth_api/#long-lived-access-token) and a script on the Pi side, but it means your Cooklang-generated shopping list lands in the same place you'd normally check things off.

## Smart Timers from Recipe Data

This is where the integration gets interesting. Cooklang recipes encode timer data directly — `~{25%minutes}` marks a 25-minute step. When you pull a recipe as JSON, those timer values are structured data you can act on.

The pattern: parse the recipe JSON, extract timer values, and fire a Home Assistant automation that starts a timer, shows a countdown on your kitchen display, and announces completion on a smart speaker.

First, add a `command_line` sensor that extracts timers from today's recipe:

```yaml
command_line:
  - sensor:
      name: "Recipe Timers"
      command: >
        ssh pi@kitchen.local
        "cook recipe $(cat /home/pi/recipes/menu/today.txt) --format json
        | python3 -c \"
        import json,sys
        data=json.load(sys.stdin)
        timers=[s for s in data.get('steps',[]) if s.get('type')=='timer']
        print(json.dumps(timers))
        \""
      value_template: "{{ value_json | length }} timers"
      json_attributes_path: "$"
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
      - service: timer.start
        target:
          entity_id: timer.kitchen_recipe_timer
        data:
          duration: "{{ duration_minutes * 60 }}"
      - service: media_player.play_media
        target:
          entity_id: media_player.kitchen_speaker
        data:
          media_content_type: music
          media_content_id: "Timer started for {{ duration_minutes }} minutes"
          announce: true
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
      - service: notify.kitchen_speaker
        data:
          message: "Kitchen timer is done!"
      - service: light.turn_on
        target:
          entity_id: light.kitchen_light
        data:
          flash: short
```

Flashing the kitchen lights when a timer finishes is genuinely useful if you walk away from the kitchen with noise-canceling headphones on. The recipe data drives the timer value; HA handles the notification.

## Pantry Alerts on the Dashboard

`cook pantry expiring --format json` returns a list of items that will expire within the next seven days. Wire this to a `command_line` sensor and you get pantry alerts on your HA dashboard without any manual checking.

```yaml
command_line:
  - sensor:
      name: "Expiring Pantry Items"
      command: "ssh pi@kitchen.local cook pantry expiring --format json"
      value_template: "{{ value_json | length }}"
      json_attributes_path: "$"
      scan_interval: 86400
      command_timeout: 10
```

The sensor state is the count of expiring items. Zero is good. Above zero means something needs attention.

Add a conditional card that only appears when the count is nonzero:

```yaml
type: conditional
conditions:
  - entity: sensor.expiring_pantry_items
    state_not: "0"
card:
  type: markdown
  title: "Use These Soon"
  content: >
    {% set items = state_attr('sensor.expiring_pantry_items', 'items') %}
    {% for item in items %}
    - **{{ item.name }}** — expires {{ item.expires }}
    {% endfor %}
```

The card disappears when the pantry is clear and reappears when something is about to expire. Clean dashboard behavior with no manual intervention.

Pair this with an automation that sends a notification to your phone when the count goes above zero:

```yaml
automation:
  - alias: "Pantry Expiry Alert"
    trigger:
      - platform: numeric_state
        entity_id: sensor.expiring_pantry_items
        above: 0
    condition:
      - condition: time
        after: "08:00:00"
        before: "10:00:00"
    action:
      - service: notify.mobile_app_your_phone
        data:
          title: "Pantry reminder"
          message: >
            {{ states('sensor.expiring_pantry_items') }} item(s) expiring soon.
            Check the kitchen dashboard.
```

This fires once per day during the morning window when the count crosses zero. You won't get spammed — the condition keeps it to the 8–10 AM window.

## Meal Planning Display

If you use Cooklang's `.menu` format for weekly meal plans, you can display the full week on an HA dashboard panel. A script on the Pi parses the menu file and outputs structured JSON:

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

**Voice commands via Assist.** Home Assistant's built-in voice assistant (Assist) can call scripts and services. Set up an intent that calls `shell_command.generate_shopping_list` when you say "generate my shopping list." Requires a bit of intent configuration, but the infrastructure is already there.

**Recipe suggestions based on pantry.** Run `cook pantry recipes --format json` on a schedule. Feed the output to a sensor. Display the "can make now" list on your dashboard — a live view of what you can cook without going to the store. Combine this with an automation that pushes the list to your phone every Friday afternoon when you're figuring out the weekend.

## An Honest Note

The integrations in this post range from trivial (the iframe card) to genuinely involved (the pantry sensor with notifications). The SSH-based command approach works well on a local network but requires passwordless SSH configured between HA and the Pi, and error handling in the shell scripts if you want them to degrade gracefully.

This is not plug-and-play. If you're comfortable with HA's YAML configuration, shell scripting, and SSH key management, none of it is difficult. If you're new to Home Assistant, start with the iframe card and the Webpage panel — that alone is useful — and add complexity incrementally.

The data model is what makes this work: Cooklang recipes are structured text, and `cook` can output that structure as JSON. Once the data is JSON, Home Assistant can consume it like any other sensor value. The tools do exactly what they're supposed to do, and the integration is mostly plumbing.

## Get Started

Start with CookCLI running on your network — the [Raspberry Pi kitchen display guide](/blog/17-raspberry-pi-kitchen-display/) covers that end-to-end. Then add the iframe card to your HA dashboard as a first step. From there, add sensors and automations one at a time as you find the ones that actually improve your workflow.

The [CookCLI documentation](/cli/) covers all the commands referenced here. The [getting-started guide](/docs/getting-started/) is the right place if you're new to Cooklang format.

[CookCLI documentation →](/cli/) | [Cooklang spec →](/docs/spec/) | [Raspberry Pi kitchen display →](/blog/17-raspberry-pi-kitchen-display/)

-Alex
