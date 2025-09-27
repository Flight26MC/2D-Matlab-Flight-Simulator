# 2D Flight Simulator in MATLAB v1.0

![Platform](https://img.shields.io/badge/Platform-MATLAB-orange)
![License](https://img.shields.io/badge/License-MIT-yellow)


## Introduction: Project Goal and Philosophy

This project is a modular software developed in the MATLAB environment to simulate the 2D flight dynamics of an aircraft. It was designed with a deeper purpose than simply mimicking flight: to create a modular, analysis-driven **"virtual laboratory" (sandbox)** for exploring the principles of **closed-loop control** in complex dynamic systems.

In line with this philosophy, the aircraft itself is abstracted as a 2D point-mass system rather than a photorealistic model. This intentional simplification shifts the focus from the aircraft itself to the behavior of the **PID (Proportional-Integral-Derivative) controlled autopilot** that attempts to command it. The core objective of the simulation is to explore the art and engineering of finding the perfect balance between the three fundamental control forces (`Kp`, `Ki`, `Kd`) through a data-driven approach.

This initial release (**v1.0**) includes the core simulation infrastructure and the **Light Training Aircraft** profile.

---

## Simulation Output

Below is the results panel from a successful autopilot configuration for the Light Training Aircraft, demonstrating a stable capture of the target altitude with minimal oscillation.

*(It is highly recommended to add screenshots of your best-running simulation results here.)*

**Manual Flight (Open-Loop) Example:**
<img width="988" height="613" alt="Manual Flight Example Results" src="https://github.com/user-attachments/assets/dd4d23b7-afc4-4478-a0e8-cbc2a442ab04" />

**Altitude Hold (Closed-Loop) Example:**
<img width="984" height="624" alt="Altitude Hold Example Results" src="https://github.com/user-attachments/assets/fa2b4296-5ed2-411e-8f85-142bfbc86e9d" />

---

## Development: "Project Architecture and Technical Details"

The project is structured using modular `.m` files, each adhering to the Single Responsibility Principle. This architecture enhances the code's readability, maintainability, and future extensibility.

### Module Responsibilities

- `ucus_simulasyon.m`: **Main Controller & Simulation Manager**
  - This is the main entry point of the program. It provides the user menu, sets up the simulation scenario, and triggers the simulation by calling MATLAB's `ode45` differential equation solver. It also handles post-processing and logging, passing the final data to the visualization module.

- `ucus_denklemleri.m`: **Dynamic Model & Control Logic**
  - This is the core function called by `ode45` at each time step. It contains the 2D point-mass Equations of Motion for the aircraft. It calculates aerodynamic forces (Lift, Drag), thrust, and gravity to return the derivatives of the state vector (`dydt`). For autopilot mode, it houses the closed-loop PID control logic.

- `initialize_parameters.m`: **Configuration & Parameter Management**
  - This module centralizes the definition of all simulation parameters. Aircraft physical properties (mass, wing area, etc.), aerodynamic coefficients, and autopilot PID gains (`Kp`, `Ki`, `Kd`) are configured here. This forms the basis for the project's flexibility and tunability.

- `plot_results.m`: **Data Visualization Module**
  - This module takes the processed time-series data from the simulation manager and presents it to the user in a meaningful dashboard. This panel is the primary feedback tool for analyzing the autopilot's performance (e.g., overshoot, settling time, oscillation) and making informed decisions for the next tuning iteration.

- `hesapla_isa_yogulugu.m` & `olay_fabrikasi.m`: **Utility & Safety Modules**
  - These helper functions, respectively, calculate the instantaneous air density based on the International Standard Atmosphere (ISA) model and create an event function to safely terminate the simulation if a condition like a ground crash is detected.

### Control Strategy in the Current Version (v1.0)

This initial version employs a deliberately simple control strategy: **"Power for Altitude."** The autopilot adjusts only the engine power (throttle) to correct for altitude errors. This approach serves as an ideal starting point for understanding PID control fundamentals but is planned to be replaced with more advanced strategies in future versions.

---

## Conclusion: Setup, Usage, and Future Plans

### Setup and Usage

1.  Download all `.m` files from this repository into a single folder on your computer.
2.  Open MATLAB and set this folder as the "Current Folder".
3.  Run the simulator by typing `ucus_simulasyon` in the MATLAB Command Window and pressing Enter.
4.  Select the desired flight scenario and initial conditions from the menu that appears.

### Roadmap

This project is under active development. Planned features and improvements for future versions include:

- [ ] **New Aircraft Profiles:**
    - [ ] Business Jet (Cessna Citation-like)
    - [ ] KAAN (MMU) 5th Generation Fighter Aircraft
- [ ] **Advanced Control Strategies:**
    - [ ] Transitioning to a "Pitch for Altitude, Power for Speed" control philosophy.
- [ ] **Graphical User Interface (GUI):**
    - [ ] Developing a more user-friendly interface using MATLAB App Designer.

### License

This project is licensed under the MIT License. See the `LICENSE` file for details.
