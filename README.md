# 💼 Fintech Coding Challenge (Rohith Radhakrishnan): Configurable Investment Flow

Welcome to our technical challenge! This challenge is designed to simulate a real-world problem in our fintech platform. 
We are building a white-labeled investment platform for private markets, where each customer (platform) can define their own investment onboarding process.

This is not a simple CRUD app — it's an opportunity to show off your architecture, reasoning, and UX decisions using **Rails + Hotwire (Turbo + Stimulus)**.

---

## 🚀 Your Task

Build a **configurable investment flow engine** where each platform can define a custom sequence of steps for users to complete before submitting an investment.

### 🧩 Example Use Case

Platform A may ask:
1. Investment amount
2. Accept terms
3. Confirm

Platform B may ask:
1. Investment amount
2. Enter referral code
3. Agree to risk disclaimer
4. Confirm

Your app should dynamically render and validate these steps for each platform.

---

## 🛠 Requirements

### 1. Platform and Step Configuration

Each `Platform` should have a set of ordered `Steps`, each with:
- `title` (string)
- `component_type` (`amount_input`, `checkbox`, `disclaimer`, `text_input`)
- Optional `config` (e.g. min/max amount, label text, etc.)

Platform configuration can be stored in:
- A seed file or YAML
- OR simple DB models (`Platform`, `Step`)

```yaml
platforms:
  muench-crowd:
    steps:
      - type: amount_input
        title: "How much would you like to invest?"
        config: { min: 250, max: 10000 }

      - type: checkbox
        title: "Do you accept the terms?"
        config: { label: "I agree to the terms and conditions." }

      - type: disclaimer
        title: "Please confirm"
        config: { text: "This is a speculative investment. Capital is at risk." }
```

### 2. Dynamic Investment Flow

- Allow the user to choose a platform (or simulate with a dropdown)
- Dynamically render its investment flow step by step
- Use Turbo Frames to navigate between steps without full reloads
- Use Stimulus for inline validation and dynamic behavior
- Persist the form progress (in memory, Redis, or DB)
- Final step submits the investment (you can mock this)

### 3. 🧪 What We'll Evaluate

| Area                 | What We’re Looking For                              |
| -------------------- | --------------------------------------------------- |
| ✅ Architecture       | Can you model a dynamic flow engine cleanly?        |
| ✅ Turbo/Stimulus     | Did you use Hotwire idiomatically and effectively?  |
| ✅ Code Quality       | Is your code readable, organized, and maintainable? |
| ✅ UX & Feedback      | Is the user experience smooth, clear, and reactive? |
| ✅ Reasoning & Design | Did you handle config options and edge cases well?  |

### 4. ⚙️ Tech Stack
This challenge should be built using:

- Ruby on Rails 7-8
- Hotwire (Turbo Frames, Turbo Streams)
- Stimulus.js
- Redis (optional, for state storage)
- Bootstrap or Tailwind (if you like)

You are free to use Sidekiq, Redis, or any testing framework you're comfortable with.

### 5. 📝 Bonus Ideas (Optional)
If you have time and want to impress:

- Support "go back" and "edit previous step" behavior
- Add real-time validation (e.g. live range check on investment amount)
- Allow platform configs to be imported from YAML in the admin
- Add test coverage for at least one component

### 🧑‍💻 Submission Instructions

1. Fork or clone this repository (or start your own public GitHub repo).
2. Commit your changes to the main branch (or a feature branch).
3. Push your solution and send us the link to the repo.
4. Please include a short NOTES.md file describing your thinking, trade-offs, or anything unfinished.

### ⏱ Timebox

We recommend spending no more than 4–8 hours on this challenge.
This is not about completeness — it's about how you approach the problem.

### 🙌 Good luck!

We’re looking forward to seeing how you think and build. If you have any questions, feel free to reach out. 
-> e.mueller@portagon.com

