<img width="500" height="121" alt="image" src="https://github.com/user-attachments/assets/dbab9374-189a-4088-85fe-3787c0b97703" />



Carry-Ripple Adder:

A 32-bit carry-ripple adder is implemented by cascading eight stages, each using two levels of logic.
The critical path delay is approximately 32 times the delay of a single full-adder stage.
Each two-level logic stage consists of two gates: one AND gate and one OR gate.

Results:
Critical path delay ≈ 4.38 ns ≈ 32 × (delay of a full adder) ≈ 32 × 14ns

Total area = 154.5 µm²

Carry-Lookahead Adder:

Critical path delay ≈ 2.01 ns

Total area = 546.1 µm²


Hierarchical Carry-Lookahead Adder

Each 4-bit carry-lookahead adder introduces a delay of 4 gate levels. Therefore, the total delay for a 32-bit adder would be 4×8=32 gate levels.
Critical path delay ≈ 3.71 ns

Total area = 358 µm²


Multilevel Carry-Lookahead Adder:

A 32-bit carry-lookahead adder is implemented as shown in the figure below.

<img width="624" height="386" alt="image" src="https://github.com/user-attachments/assets/7741cb25-32dc-44d9-b894-2cfb084aae32" />

The total delay is approximately:

Two gate delays for the Sum and Propagate/Generate (SPG) blocks (half adders), and
Two gate delays (one AND gate and one OR gate) for each level of carry-lookahead (CLA) logic.

This results in a total delay of:
2+2+2+2=8 gate delays (I doubt that! -- will explain later)

Results:
Critical path delay ≈ 1.57 ns ≈ (SPG + 4BIT_CLA + 4BIT_CLA) * 2 + 2BIT_CLA

Total area = 467.1 µm²
