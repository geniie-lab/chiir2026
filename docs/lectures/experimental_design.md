---
hide:
    - toc
---

# Experimental Design 101

!!! info "Variables"

    - **Independent Variables (IVs)**: Factors that experimenters intentionally manipulate in experiments
        - LLMs, Ranking Models, Prompts, etc.
    - **Dependent Variables (DVs)**: Variables that measure the effect of IVs
        - Number of queries, query length, retrieval effectivness, accuracy of relevance judgements, etc.
    - Other Variables: confounding variable, moderating variable, intervening variable, ...
        - See Chapter 5 of [Kelly (2009)](references.md)

!!! example "Within Subject and Between Subject"

    - **Within-Subject Design**: Each participant contributes measurements across all experimental conditions.
    - **Between-Subject Design**: Each participant is exposed to one condition only.

!!! question "What does this mean in model search behaviour?"

    When applying human experimental‑design concepts to computational models, it is more accurate to focus on whether the model’s behavior is stateful (context‑dependent) or stateless (independent across trials). The analogy to within‑/between‑subject designs is helpful but not literal.

    - **Stateful or Context‑Persistent Evaluation**: When previous search logs or dialogue history are included in the model’s input, the model’s outputs can be influenced by earlier turns.
        - This is analogous to a within‑subject design because earlier “conditions” may affect later behavior through carryover effects.
    - **Stateless or Context‑Reset Evaluation**: When each model call begins with a fresh context (no past logs, no accumulated history), each response is independent of previous interactions.
        - This is analogous to a between‑subject design because no carryover effects are possible and each inference is isolated.

    :bulb: These are analogies rather than strict equivalences. The model is not a human subject, and repeated calls do not change the model’s underlying parameters.