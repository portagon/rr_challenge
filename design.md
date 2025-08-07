## Overview
The `Platforms::Base` class acts as a parent for platform-specific workflows, each describing a set of ordered steps. Each step consists of:

- type: The kind of input or UI control (e.g., :amount_input, :text_input)
- title: A descriptive label shown to the user
- config: A hash for additional custom settings or validation rules

### Key Components
- Step class
Encapsulates individual steps with type, title, and config.

- Platform subclassing
Define new platform workflows by subclassing Platforms::Base.

- Step management
Add steps via the .step(type, title, config = {}) class method.

- StepEnumerator
Provides navigation helpers (next, previous, current, last?) by managing the current step index.

- Workflow title
Set or inherit a human-readable workflow title via .title.

### Usage
Defining a Workflow for a Platform
Create a new platform subclass with steps, for example:

```ruby
module Platforms
  class Platform1 < Base
    title "Platform 1 Investment"
    step :amount_input, "Enter amount", min: 30
    step :text_input, "Enter reason", required: true
  end
end
```
Navigating Steps in Controller
Each platform instance can be used to manage current steps for a user session.

Initialize a workflow instance at stored step index

```ruby
workflow = Platforms::Platform1.new
step_enum = workflow.call(session["wizard"]["Platforms::Platform1"]["step_index"])
```
Get current step data for rendering
```
current_step = step_enum.current
```
Move to next step after saving input
```
step_enum.next
```
Initialize session structure if needed
```
session["wizard"] ||= {}
session["wizard"]["Platforms::Platform1"] ||= {
  "step_index" => 0,
  "answers" => {},
  "finished" => false
}
```
Session Storage Structure
User progress and inputs are stored in the session as:
```
{
  "wizard": {
    "Platforms::Platform1": {
      "step_index": 0,
      "answers": {
        "0": "user_input_value"
      },
     "finished": false
    }
  }
}
```
- step_index: Integer tracking the current or last visited step index.
- answers: Hash mapping step indices (as strings) to user inputs.
- finished: Boolean indicating whether the workflow is complete.

### Benefits of This Design
- Dynamic & Flexible
Easily add or modify steps in Ruby with full programming power.

- Inheritance Friendly
Subclasses inherit and extend base steps without duplication.

- Step Navigation
Navigate forwards and backwards smoothly with built-in enumerator.

- Clean Separation
Step definitions are cleanly separated from UI and session logic.
