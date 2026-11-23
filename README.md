# CONTROLE_GUI

A MATLAB graphical interface for the control-systems design methods taught in class. The original lesson scripts (`AULA*.m`) have every value hardcoded: system matrices, cost weights, sampling period, plant and desired delay. To try a new case you had to edit the code and copy results by hand. `CONTROLE_GUI` puts all of these methods in a single window, with one tab per control method. You type the parameters, click **Calcular** (Calculate), and get the numerical results, the response curves and the pole maps.

Each tab uses **the same MATLAB functions, in the same order, as the original scripts**. Only the hardcoded values were replaced by inputs. With the same inputs, the interface reproduces the results from class.

## Quick start

1. Download [`ProjetoFafa_final/CONTROLE_GUI.m`](ProjetoFafa_final/CONTROLE_GUI.m). The whole interface is in this one file.
2. Open it in MATLAB (R2020a or newer) or upload it to [MATLAB Online](https://matlab.mathworks.com).
3. In the Command Window, run:

   ```matlab
   CONTROLE_GUI
   ```

Every field opens filled with the values used in class. Click **Calcular** to reproduce the original results.

### Requirements

| Toolbox | Used by |
|---|---|
| Symbolic Math Toolbox | Ganho Ótimo Escalar, Ganho Ótimo Matricial, Transformadas Laplace / Z |
| Control System Toolbox | both LQR tabs, Discretização, Controlador Deadbeat, time responses |

Run `ver` in MATLAB to see which toolboxes are installed.

## Tabs

Every tab has the same layout. On the left are the inputs, the **Calcular** button and a text area with the results. On the right are a response curve (top) and a pole/zero map (bottom), in the s-plane or in the z-plane with the unit circle.

| Tab | Method | Based on | Curve | Poles |
|---|---|---|---|---|
| Ganho Ótimo Escalar | Scalar optimal gain via Lyapunov (`F = a + b·k`, `S = 1 + L·k²`) | `AULA.m` | Cost J(k) for each L, with the minimum marked | a + b·k |
| Ganho Ótimo Matricial | Diagonal optimal gain via Lyapunov (`Fᵀ P + P F + S = 0`, `J = x0ᵀ P x0`) | `AULA2.m` | Free response x(t) from x0 | eig(A + B·K) |
| LQR (Q = C'·Qy·C) | LQR with output weighting, checked with `place` | `AULA2_2.m` | Reference step response | eig(A − B·K) |
| LQR (Q direta) | LQR with a full Q matrix | `AULA3.m` | Reference step response | eig(A − B·K) |
| Transformadas Laplace / Z | `laplace`, `ztrans` and their inverses | `AULA4.m` | f(t), ilaplace and iztrans samples | Poles of F(s) |
| Discretização | `c2d` discretization (zoh, foh, tustin, impulse, matched) | `AULA5.m` | Continuous step vs. discrete step | Poles/zeros of G(z) |
| Controlador Deadbeat (z^-N) | Direct design `D(z) = T(z) / (G(z)(1 − T(z)))`, `T(z) = z^-N` | `AULA6.m` (N = 3), `AULA6_2.m` (N = 5) | Plant and closed loop | D(z) and closed loop |

### Inputs

| Input | Syntax | Example |
|---|---|---|
| Matrix | MATLAB syntax | `[0 1; 0 0]` |
| Column vector | entries separated by `;` | `[1; 0]` |
| List of values | entries separated by spaces | `[1 2 3]` |
| Transfer function | expression in `s` | `1/(10.5*s+1)` |
| Time function | symbolic expression in `t` | `heaviside(t)` |

## Expected results (default inputs)

| Tab | Result | Reference in the original material |
|---|---|---|
| Ganho Ótimo Escalar | k = −0.4142, −0.2247, −0.1547 (L = 1, 2, 3) | comments at the end of `AULA.m` |
| Ganho Ótimo Matricial | k1 = 0.1440, k2 = 0.3709, J = 3.6437 (L = 10) | comments in `AULA2.m` and gains in `AULA2.slx` |
| LQR (Q = C'·Qy·C) | K = [10.0000 3.5826], poles −2.2913 ± 2.1794i | `AULA2_2.m` (`lqr` = `place`) |
| LQR (Q direta) | K = [4.4721 4.4721] | gains in `AULA3.slx` |

## Repository layout

| Branch | Contents |
|---|---|
| `main` (default) | Only the interface: `ProjetoFafa_final/CONTROLE_GUI.m`. This is all you need to run it. |
| `scripts-originais` | The interface plus the original lesson scripts (`AULA*.m`) and Simulink models (`AULA2.slx`, `AULA3.slx`), kept unchanged as reference. |

`git clone` fetches `main` by default. To get the original scripts as well:

```bash
git clone -b scripts-originais <repository-url>
```

`CONTROLE_GUI.m` is organized in four parts:
1. The main function builds the window and the tabs.
2. Callbacks (`calc*`) read the inputs, call a calculation function and display the results.
3. Helper functions handle layout (`montarAba`), input parsing (`lerMatriz`, `lerTF`) and plotting (`plotPolos`, `respostaLQR`).
4. One calculation function per lesson (`aula1_ganho_escalar` … `aula6_deadbeat`) mirrors the original script line by line.

The UI does no math itself, so each calculation function can be compared directly with the script it came from.

## Notes

- The interface labels and messages are in Portuguese, as in the original coursework.
- The original scripts plot the discrete step response with `dstep(Gz, T)`, which cannot draw into an app's axes. The interface uses `step(Gz)` with `stairs` instead, which plots the same discrete step response.
- The full written documentation (ABNT-formatted `.docx`) is not part of this repository.
