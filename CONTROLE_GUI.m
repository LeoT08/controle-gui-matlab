function fig = CONTROLE_GUI
%CONTROLE_GUI Interface grafica para os codigos das aulas de Sistemas de Controle.
%   Uma aba por tipo de controle. Cada aba chama a funcao da aula correspondente:
%     Ganho Otimo Escalar    -> aula1_ganho_escalar  (AULA.m)
%     Ganho Otimo Matricial  -> aula2_ganho_otimo    (AULA2.m)
%     LQR (Q = C'*Qy*C)      -> aula2_lqr            (AULA2_2.m)
%     LQR (Q direta)         -> aula3_lqr            (AULA3.m)
%     Transformadas          -> aula4_transformadas  (AULA4.m)
%     Discretizacao          -> aula5_discretizar    (AULA5.m)
%     Controlador Deadbeat   -> aula6_deadbeat       (AULA6.m / AULA6_2.m)
%
%   Matrizes sao digitadas na sintaxe do MATLAB, ex.: [0 1; 0 0]
%   Funcoes de transferencia usam a variavel s, ex.: 1/(10.5*s+1)

    fig = uifigure('Name', 'Sistemas de Controle - Aulas', ...
                   'Position', [60 60 1150 700]);
    raiz = uigridlayout(fig, [1 1]);
    abas = uitabgroup(raiz);
    metodos = {'zoh', 'foh', 'tustin', 'impulse', 'matched'};

    %% ---------------- Aba 1: Ganho Otimo Escalar (AULA.m) ----------------
    h1 = montarAba(abas, 'Ganho Ótimo Escalar', 'Baseado em AULA.m  (F = a + b·k, S = 1 + L·k²)', ...
        {'a:',         'num',  -1; ...
         'b:',         'num',  1; ...
         'L (vetor):', 'text', '[1 2 3]'}, ...
        'Custo J(k) para cada L', 'Polos de malha fechada (plano s)');
    h1.btn.ButtonPushedFcn = @(~, ~) rodar(@calcEscalar, 'Calculando (cálculo simbólico)...');

    %% -------------- Aba 2: Ganho Otimo Matricial (AULA2.m) ---------------
    h2 = montarAba(abas, 'Ganho Ótimo Matricial', 'Baseado em AULA2.m  (K = -diag(k), S = I + L·K''K)', ...
        {'A (n x n):',   'text', '[0 1; 0 0]'; ...
         'B (n x m):',   'text', '[0 0; 1 1]'; ...
         'x0 (n x 1):',  'text', '[1; 0]'; ...
         'L:',           'num',  10; ...
         'Tempo final:', 'num',  30}, ...
        'Resposta livre x(t) a partir de x0', 'Polos de malha fechada (plano s)');
    h2.btn.ButtonPushedFcn = @(~, ~) rodar(@calcMatricial, 'Calculando (cálculo simbólico)...');

    %% ---------------- Aba 3: LQR com Q = C'*Qy*C (AULA2_2.m) ---------------
    h3 = montarAba(abas, 'LQR (Q = C''·Qy·C)', 'Baseado em AULA2_2.m', ...
        {'A (n x n):',  'text', '[0 1; 0 -1]'; ...
         'B (n x m):',  'text', '[0; 1]'; ...
         'C (p x n):',  'text', '[1 0]'; ...
         'Qy (p x p):', 'text', '100'; ...
         'R (m x m):',  'text', '1'}, ...
        'Degrau na referência (u = -K·x + N·r)', 'Polos de malha fechada (plano s)');
    h3.btn.ButtonPushedFcn = @(~, ~) rodar(@calcLQRsaida, 'Calculando...');

    %% ------------------- Aba 4: LQR com Q direta (AULA3.m) -------------------
    h4 = montarAba(abas, 'LQR (Q direta)', 'Baseado em AULA3.m', ...
        {'A (n x n):', 'text', '[0 1; 0 -1]'; ...
         'B (n x m):', 'text', '[0; 1]'; ...
         'C (p x n):', 'text', '[1 0]'; ...
         'Q (n x n):', 'text', '[100 0; 0 100]'; ...
         'R (m x m):', 'text', '5'}, ...
        'Degrau na referência (u = -K·x + N·r)', 'Polos de malha fechada (plano s)');
    h4.btn.ButtonPushedFcn = @(~, ~) rodar(@calcLQRdireta, 'Calculando...');

    %% ------------------ Aba 5: Transformadas (AULA4.m) ------------------
    h5 = montarAba(abas, 'Transformadas Laplace / Z', 'Baseado em AULA4.m', ...
        {'f(t):',        'text', 'heaviside(t)'; ...
         'Tempo final:', 'num',  10}, ...
        'f(t), ilaplace(F(s)) e iztrans(F(z))', 'Polos de F(s) (plano s)');
    h5.btn.ButtonPushedFcn = @(~, ~) rodar(@calcTransformadas, 'Calculando (cálculo simbólico)...');

    %% ------------------- Aba 6: Discretizacao (AULA5.m) -------------------
    h6 = montarAba(abas, 'Discretização', 'Baseado em AULA5.m', ...
        {'G(s):',    'text', '1/(s+1)'; ...
         'T:',       'num',  0.5; ...
         'Método:',  'drop', {metodos, 'tustin'}}, ...
        'step(G(s)) × degrau de G(z)', 'Polos e zeros de G(z) (plano z)');
    h6.btn.ButtonPushedFcn = @(~, ~) rodar(@calcDiscretizacao, 'Calculando...');

    %% ------------- Aba 7: Controlador Deadbeat (AULA6.m / AULA6_2.m) -------------
    h7 = montarAba(abas, 'Controlador Deadbeat (z^-N)', 'Baseado em AULA6.m (N = 3) e AULA6_2.m (N = 5)', ...
        {'G(s):',          'text', '1/(10.5*s+1)'; ...
         'T:',             'num',  1; ...
         'Atraso N:',      'num',  3; ...
         'Método:',        'drop', {metodos, 'zoh'}}, ...
        'Planta e malha fechada com D(z)', 'D(z) e malha fechada (plano z)');
    h7.btn.ButtonPushedFcn = @(~, ~) rodar(@calcDeadbeat, 'Calculando...');

    %% =============================== Callbacks ===============================
    function rodar(fn, msg)
        dlg = uiprogressdlg(fig, 'Title', 'Aguarde', 'Message', msg, 'Indeterminate', 'on');
        try
            fn();
        catch err
            close(dlg);
            uialert(fig, err.message, 'Erro');
            return
        end
        close(dlg);
    end

    function calcEscalar
        a = h1.campos{1}.Value;
        b = h1.campos{2}.Value;
        Lvec = lerMatriz(h1.campos{3}, 'L');

        [res, Jf] = aula1_ganho_escalar(a, b, Lvec);

        linhas = {sprintf('F = %g + %g·k,   S = 1 + L·k²', a, b), ''};
        for i = 1:numel(res)
            linhas{end + 1} = sprintf('L = %g', res(i).L); %#ok<AGROW>
            linhas{end + 1} = ['  raízes de dJ/dk:  ' mat2str(res(i).raizes.', 5)]; %#ok<AGROW>
            linhas{end + 1} = ['  d²J/dk² nelas:    ' mat2str(res(i).d2J.', 5)]; %#ok<AGROW>
            if isnan(res(i).k)
                linhas{end + 1} = '  nenhuma raiz é mínimo estabilizante'; %#ok<AGROW>
            else
                linhas{end + 1} = sprintf('  k ótimo = %.4f   J = %.4f   polo = %.4f', ...
                                          res(i).k, res(i).J, res(i).polo); %#ok<AGROW>
            end
            linhas{end + 1} = ''; %#ok<AGROW>
        end
        mostrar(h1.txt, linhas);

        % curva J(k), so na regiao estavel (a + b*k < 0)
        ax = limpar(h1.axC);
        kot = [res.k];
        kval = kot(~isnan(kot));
        if isempty(kval)
            kval = -a/b;
        end
        kk = linspace(min(kval) - 2, max(kval) + 2, 800);
        estavel = (a + b*kk) < 0;
        for i = 1:numel(res)
            Jv = Jf(kk, res(i).L) .* ones(size(kk));
            Jv(~estavel | Jv < 0) = NaN;
            plot(ax, kk, Jv, 'LineWidth', 1.5, 'DisplayName', sprintf('L = %g', res(i).L));
        end
        plot(ax, kot, [res.J], 'ko', 'MarkerFaceColor', 'k', 'DisplayName', 'mínimos');
        Jmax = max([res.J]);
        if isfinite(Jmax) && Jmax > 0
            ylim(ax, [0, 3*Jmax]);
        end
        xlabel(ax, 'k'); ylabel(ax, 'J');
        legend(ax, 'Location', 'best');

        plotPolos(h1.axP, {[res.polo]}, {'polo a + b·k'}, false);
    end

    function calcMatricial
        A  = lerMatriz(h2.campos{1}, 'A');
        B  = lerMatriz(h2.campos{2}, 'B');
        x0 = lerMatriz(h2.campos{3}, 'x0');
        L  = h2.campos{4}.Value;
        tf_ = h2.campos{5}.Value;

        [k, J, polos, Kn] = aula2_ganho_otimo(A, B, x0, L);

        linhas = {sprintf('L = %g', L), ''};
        for i = 1:numel(k)
            linhas{end + 1} = sprintf('k%d = %.4f', i, k(i)); %#ok<AGROW>
        end
        linhas = [linhas, {'', sprintf('J = %.4f', J), '', 'K:'}, texto(Kn), ...
                  {'', 'Polos de malha fechada eig(A + B*K):'}, texto(polos)];
        mostrar(h2.txt, linhas);

        n = size(A, 1);
        sys = ss(A + B*Kn, zeros(n, 1), eye(n), zeros(n, 1));
        [y, t] = initial(sys, x0(:), tf_);
        ax = limpar(h2.axC);
        for i = 1:n
            plot(ax, t, y(:, i), 'LineWidth', 1.5, 'DisplayName', sprintf('x%d', i));
        end
        xlabel(ax, 't (s)'); legend(ax, 'Location', 'best');

        plotPolos(h2.axP, {polos}, {'eig(A + B·K)'}, false);
    end

    function calcLQRsaida
        A  = lerMatriz(h3.campos{1}, 'A');
        B  = lerMatriz(h3.campos{2}, 'B');
        C  = lerMatriz(h3.campos{3}, 'C');
        Qy = lerMatriz(h3.campos{4}, 'Qy');
        R  = lerMatriz(h3.campos{5}, 'R');

        [K, polos, Kplace, aviso] = aula2_lqr(A, B, C, Qy, R);

        linhas = [{'Q = C''*Qy*C', '', 'K (lqr):'}, texto(K), ...
                  {'', 'Polos de malha fechada eig(A - B*K):'}, texto(polos), ...
                  {'', 'K (place com os mesmos polos):'}];
        if isempty(Kplace)
            linhas{end + 1} = ['  place não pôde ser usado: ' aviso];
        else
            linhas = [linhas, texto(Kplace)];
        end
        Nr = respostaLQR(h3.axC, A, B, C, K);
        linhas = [linhas, {'', 'Pré-compensador N (ganho estático unitário):'}, texto(Nr)];
        mostrar(h3.txt, linhas);

        plotPolos(h3.axP, {polos}, {'eig(A - B·K)'}, false);
    end

    function calcLQRdireta
        A = lerMatriz(h4.campos{1}, 'A');
        B = lerMatriz(h4.campos{2}, 'B');
        C = lerMatriz(h4.campos{3}, 'C');
        Q = lerMatriz(h4.campos{4}, 'Q');
        R = lerMatriz(h4.campos{5}, 'R');

        [K, polos] = aula3_lqr(A, B, Q, R);

        Nr = respostaLQR(h4.axC, A, B, C, K);
        linhas = [{'K (lqr):'}, texto(K), ...
                  {'', 'Polos de malha fechada eig(A - B*K):'}, texto(polos), ...
                  {'', 'Pré-compensador N (ganho estático unitário):'}, texto(Nr)];
        mostrar(h4.txt, linhas);

        plotPolos(h4.axP, {polos}, {'eig(A - B·K)'}, false);
    end

    function calcTransformadas
        r = aula4_transformadas(h5.campos{1}.Value);
        tmax = h5.campos{2}.Value;

        linhas = {['f(t)                = ' char(r.f)], ...
                  ['F(s) = laplace(f)   = ' char(r.Fs)], ...
                  ['F(z) = ztrans(f)    = ' char(r.Fz)], ...
                  ['ilaplace(F(s))      = ' char(r.Ft)], ...
                  ['iztrans(F(z))       = ' char(r.Fd)], ...
                  '', ['Polos de F(s): ' mat2str(r.polosS.', 5)], ...
                      ['Polos de F(z): ' mat2str(r.polosZ.', 5)]};
        mostrar(h5.txt, linhas);

        tt = linspace(0, tmax, 400);
        nn = 0:floor(tmax);
        ax = limpar(h5.axC);
        plot(ax, tt, avaliar(r.f, r.t, tt), 'LineWidth', 2, 'DisplayName', 'f(t)');
        plot(ax, tt, avaliar(r.Ft, r.t, tt), '--', 'LineWidth', 1.5, 'DisplayName', 'ilaplace(F(s))');
        stem(ax, nn, avaliar(r.Fd, r.n, nn), 'filled', 'DisplayName', 'iztrans(F(z)) [n]');
        xlabel(ax, 't  /  n'); legend(ax, 'Location', 'best');

        plotPolos(h5.axP, {r.polosS}, {'polos de F(s)'}, false);
    end

    function calcDiscretizacao
        Gs = lerTF(h6.campos{1});
        T = h6.campos{2}.Value;
        metodo = h6.campos{3}.Value;

        Gz = aula5_discretizar(Gs, T, metodo);

        linhas = [{'G(s):'}, texto(Gs), {'', sprintf('G(z) = c2d(G(s), %g, ''%s''):', T, metodo)}, ...
                  texto(Gz), {'', ['Polos de G(s): ' mat2str(pole(Gs).', 5)], ...
                  ['Polos de G(z): ' mat2str(pole(Gz).', 5)], ...
                  ['Zeros de G(z): ' mat2str(zero(Gz).', 5)]}];
        mostrar(h6.txt, linhas);

        [y, t] = step(Gs);
        [yd, td] = step(Gz, t(end));
        ax = limpar(h6.axC);
        plot(ax, t, y, 'LineWidth', 1.5, 'DisplayName', 'G(s) contínuo');
        stairs(ax, td, yd, 'LineWidth', 1.5, 'DisplayName', sprintf('G(z), T = %g', T));
        xlabel(ax, 't (s)'); legend(ax, 'Location', 'best');

        plotPolos(h6.axP, {pole(Gz), zero(Gz)}, {'polos G(z)', 'zeros G(z)'}, true);
    end

    function calcDeadbeat
        Gs = lerTF(h7.campos{1});
        T = h7.campos{2}.Value;
        N = h7.campos{3}.Value;
        metodo = h7.campos{4}.Value;

        [Gz, Dz, MF, aviso] = aula6_deadbeat(Gs, T, N, metodo);

        linhas = [{sprintf('G(z) = c2d(G(s), %g, ''%s''):', T, metodo)}, texto(Gz), ...
                  {'', sprintf('D(z) = minreal( z^-%d / (G(z)·(1 - z^-%d)) ):', N, N)}, texto(Dz), ...
                  {'', 'Malha fechada D(z)G(z) / (1 + D(z)G(z)):'}, texto(MF)];
        if ~isempty(aviso)
            linhas = [linhas, {'', ['AVISO: ' aviso]}];
        end
        mostrar(h7.txt, linhas);

        [y, t] = step(Gs);
        tfim = max(t(end), (N + 10)*T);
        [y, t] = step(Gs, tfim);
        [yd, td] = step(Gz, tfim);
        [ym, tm] = step(MF, tfim);
        ax = limpar(h7.axC);
        plot(ax, t, y, 'LineWidth', 1.5, 'DisplayName', 'G(s) contínuo');
        stairs(ax, td, yd, 'LineWidth', 1.5, 'DisplayName', 'G(z) malha aberta');
        stairs(ax, tm, ym, 'LineWidth', 2, 'DisplayName', sprintf('malha fechada (z^{-%d})', N));
        xlabel(ax, 't (s)'); legend(ax, 'Location', 'best');

        plotPolos(h7.axP, {pole(Dz), zero(Dz), pole(MF)}, ...
                  {'polos D(z)', 'zeros D(z)', 'polos malha fechada'}, true);
    end
end

%% =========================== Funcoes auxiliares ===========================
function h = montarAba(abas, titulo, origem, campos, tituloCurva, tituloPolos)
% Cria uma aba padrao: entradas + resultados a esquerda, curva e polos a direita.
    tab = uitab(abas, 'Title', titulo);
    g = uigridlayout(tab, [1 2]);
    g.ColumnWidth = {360, '1x'};

    nc = size(campos, 1);
    esq = uigridlayout(g, [nc + 4, 2]);
    esq.ColumnWidth = {110, '1x'};
    esq.RowHeight = [{22}, repmat({22}, 1, nc), {30, '1x', 30}];
    esq.Layout.Row = 1; esq.Layout.Column = 1;

    lb = uilabel(esq, 'Text', origem, 'FontAngle', 'italic');
    lb.Layout.Row = 1; lb.Layout.Column = [1 2];

    h.campos = cell(1, nc);
    for i = 1:nc
        rot = uilabel(esq, 'Text', campos{i, 1});
        rot.Layout.Row = i + 1; rot.Layout.Column = 1;
        switch campos{i, 2}
            case 'text'
                c = uieditfield(esq, 'text', 'Value', campos{i, 3});
            case 'num'
                c = uieditfield(esq, 'numeric', 'Value', campos{i, 3});
            case 'drop'
                c = uidropdown(esq, 'Items', campos{i, 3}{1}, 'Value', campos{i, 3}{2});
        end
        c.Layout.Row = i + 1; c.Layout.Column = 2;
        h.campos{i} = c;
    end

    h.btn = uibutton(esq, 'Text', 'Calcular', 'FontWeight', 'bold');
    h.btn.Layout.Row = nc + 2; h.btn.Layout.Column = [1 2];

    txt = uitextarea(esq, 'Editable', 'off', 'FontName', 'Consolas');
    txt.Layout.Row = nc + 3; txt.Layout.Column = [1 2];
    h.txt = txt;

    bc = uibutton(esq, 'Text', 'Copiar resultados', 'ButtonPushedFcn', @(~, ~) copiar(txt));
    bc.Layout.Row = nc + 4; bc.Layout.Column = [1 2];

    dir = uigridlayout(g, [2 1]);
    dir.Layout.Row = 1; dir.Layout.Column = 2;
    h.axC = uiaxes(dir);
    h.axC.Layout.Row = 1;
    title(h.axC, tituloCurva); grid(h.axC, 'on');
    h.axP = uiaxes(dir);
    h.axP.Layout.Row = 2;
    title(h.axP, tituloPolos); grid(h.axP, 'on');
end

function ax = limpar(ax)
% Limpa os graficos mantendo titulo e grade.
    cla(ax);
    legend(ax, 'off');
    ylim(ax, 'auto'); xlim(ax, 'auto');
    hold(ax, 'on');
end

function plotPolos(ax, grupos, nomes, discreto)
% Mapa de polos/zeros. Se discreto, desenha o circulo unitario.
    cla(ax);
    legend(ax, 'off');
    hold(ax, 'on');
    if discreto
        th = linspace(0, 2*pi, 200);
        plot(ax, cos(th), sin(th), 'k:', 'DisplayName', 'círculo unitário');
        xlabel(ax, 'Re(z)'); ylabel(ax, 'Im(z)');
    else
        xlabel(ax, 'Re(s)'); ylabel(ax, 'Im(s)');
    end
    marcas = {'x', 'o', 's', 'd'};
    for g = 1:numel(grupos)
        p = grupos{g};
        p = p(isfinite(p));
        if isempty(p)
            continue
        end
        plot(ax, real(p), imag(p), marcas{g}, 'MarkerSize', 10, 'LineWidth', 1.8, ...
             'DisplayName', nomes{g});
    end
    axis(ax, 'equal');
    legend(ax, 'Location', 'best');
end

function Nr = respostaLQR(ax, A, B, C, K)
% Degrau na referencia com u = -K*x + N*r, N escolhido para ganho estatico unitario
% (no AULA3.slx isso equivale a u = K1*(r - x1) - K2*x2).
    if size(C, 2) ~= size(A, 1)
        error('C deve ter %d colunas (mesmo numero de estados de A).', size(A, 1));
    end
    m = size(B, 2);
    p = size(C, 1);
    Acl = A - B*K;
    Nr = eye(m);
    if p == m
        G0 = C*(-Acl\B);
        if rcond(G0) > 1e-12
            Nr = inv(G0);
        end
    end
    sys = ss(Acl, B*Nr, C, zeros(p, m));
    [y, t] = step(sys);

    ax = limpar(ax);
    for i = 1:p
        for j = 1:m
            if m == 1
                nome = sprintf('y%d', i);
            else
                nome = sprintf('y%d (degrau em r%d)', i, j);
            end
            plot(ax, t, y(:, i, j), 'LineWidth', 1.5, 'DisplayName', nome);
        end
    end
    xlabel(ax, 't (s)'); legend(ax, 'Location', 'best');
end

function y = avaliar(expr, var, vals)
% Avalia uma expressao simbolica em varios pontos (para graficos).
    y = double(subs(expr, var, vals));
    if isscalar(y)
        y = y*ones(size(vals));
    end
    y(~isfinite(y)) = NaN;
end

function M = lerMatriz(campo, nome)
% Le uma matriz numerica digitada em um campo de texto.
    [M, ok] = str2num(campo.Value); %#ok<ST2NM>
    if ~ok || isempty(M) || ~isnumeric(M)
        error('"%s" não é uma matriz válida: %s\nUse a sintaxe do MATLAB, ex.: [0 1; 0 0]', ...
              nome, campo.Value);
    end
end

function G = lerTF(campo)
% Le uma funcao de transferencia escrita em s, ex.: 1/(10.5*s+1)
    s = tf('s'); %#ok<NASGU> usada pelo eval
    try
        G = eval(campo.Value);
    catch
        error('G(s) inválida: %s\nUse a variável s, ex.: 1/(10.5*s+1)', campo.Value);
    end
    if isnumeric(G)
        G = tf(G);
    end
    if ~isa(G, 'tf')
        error('G(s) deve ser uma função de transferência em s.');
    end
end

function linhas = texto(M)
% Converte matriz / funcao de transferencia em linhas de texto (como o disp).
    s = evalc('disp(M)');
    linhas = strsplit(s, newline);
    linhas = linhas(~cellfun(@(x) isempty(strtrim(x)), linhas));
    linhas = cellfun(@(x) ['  ' x], linhas, 'UniformOutput', false);
end

function mostrar(txt, linhas)
    txt.Value = linhas(:);
end

function copiar(txt)
    try
        clipboard('copy', strjoin(txt.Value, newline));
    catch
        uialert(ancestor(txt, 'figure'), ...
                'Não foi possível copiar (área de transferência indisponível). Selecione o texto e use Ctrl+C.', ...
                'Copiar');
    end
end

%% ==================================================================
%%  Funcoes de calculo de cada aula (mesma sequencia dos scripts do professor)
%% ==================================================================

function [res, Jf] = aula1_ganho_escalar(a, b, Lvec)
%AULA1_GANHO_ESCALAR Ganho otimo escalar por Lyapunov (AULA.m generalizada).
%   [res, Jf] = aula1_ganho_escalar(a, b, Lvec)
%
%   Mesma sequencia da AULA.m:
%     F = a + b*k,  S = 1 + L*k^2,  F*p + p*F + S = 0  ->  J = p(k)
%     dJ/dk (numden) -> raizes com roots(sym2poly(NUM)) para cada L
%     d2J/dk2 avaliada nas raizes
%   Na AULA.m: a = -1, b = 1 (F = k - 1), L = 1, 2, 3.
%
%   res(i) tem os campos L, raizes, d2J, k (raiz de minimo estabilizante),
%   J e polo (a + b*k).  Jf(k, L) e o custo J numerico (para graficos).

    if ~isscalar(a) || ~isscalar(b) || ~isreal(a) || ~isreal(b)
        error('a e b devem ser escalares reais.');
    end
    if b == 0
        error('b = 0: o ganho k nao influencia o sistema.');
    end
    if isempty(Lvec) || ~isreal(Lvec) || any(~isfinite(Lvec(:)))
        error('L deve ser um vetor de numeros reais, ex.: [1 2 3].');
    end

    syms p k L

    F = a + b*k;                    % na AULA.m: F = k - 1
    S = 1 + L*k^2;
    f = F*p + p*F + S;
    P = solve(f, p);
    J = P;

    dJdk = simplify( diff(J, k) );
    [num, ~] = numden(dJdk);
    dJ2dk2 = simplify( diff(dJdk, k) );

    Jf = matlabFunction(J, 'Vars', [k L]);

    res = struct('L', {}, 'raizes', {}, 'd2J', {}, 'k', {}, 'J', {}, 'polo', {});
    for i = 1:numel(Lvec)
        Li = Lvec(i);
        NUM = subs(num, {L}, {Li});
        if isempty(symvar(NUM))
            error('Para L = %g, dJ/dk nao depende de k.', Li);
        end
        raizes = roots( sym2poly(NUM) );

        d2 = zeros(size(raizes));
        for j = 1:numel(raizes)
            d2(j) = double( subs(dJ2dk2, {L, k}, {Li, raizes(j)}) );
        end

        % minimo: raiz real, d2J/dk2 > 0 e sistema estavel (a + b*k < 0)
        ok = abs(imag(raizes)) < 1e-9 & real(d2) > 0 & (a + b*real(raizes)) < 0;
        if any(ok)
            kr = real(raizes(ok));
            Jr = Jf(kr, Li);
            [Jot, idx] = min(Jr);
            kot = kr(idx);
        else
            kot = NaN;
            Jot = NaN;
        end

        res(i).L = Li;
        res(i).raizes = raizes;
        res(i).d2J = d2;
        res(i).k = kot;
        res(i).J = Jot;
        res(i).polo = a + b*kot;
    end
end

function [k, J, polos, Kn] = aula2_ganho_otimo(A, B, x0, L)
%AULA2_GANHO_OTIMO Ganho otimo diagonal pelo metodo de Lyapunov (AULA2.m generalizada).
%   [k, J, polos, Kn] = aula2_ganho_otimo(A, B, x0, L)
%
%   Mesma sequencia da AULA2.m:
%     K = -diag(k1..kr),  F = A + B*K,  S = I + K'*K*L
%     F'*P + P*F + S = 0  ->  P(k),  J = x0'*P*x0
%     dJ/dki = 0  (numeradores via numden)  ->  k
%   Kn e a matriz K numerica (F = A + B*Kn).
%
%   Exemplo (valores da aula, L = 10):
%     [k, J] = aula2_ganho_otimo([0 1; 0 0], [0 0; 1 1], [1; 0], 10)
%     % k = [0.1440 0.3709]

    % ---- Validacao das entradas ----
    [n, nA] = size(A);
    if n ~= nA
        error('A deve ser quadrada (n x n). Recebido: %dx%d.', n, nA);
    end
    if size(B, 1) ~= n
        error('B deve ter %d linhas (mesmo numero de estados de A). Recebido: %dx%d.', ...
              n, size(B, 1), size(B, 2));
    end
    m = size(B, 2);
    x0 = x0(:);
    if numel(x0) ~= n
        error('x0 deve ter %d elementos. Recebido: %d.', n, numel(x0));
    end
    if ~isscalar(L) || ~isreal(L) || ~isfinite(L) || L < 0
        error('L deve ser um escalar real, finito e >= 0.');
    end

    % ---- Variaveis simbolicas (como na AULA2.m) ----
    r = min(m, n);
    ks = sym('k', [1 r]);              % k1, k2, ...
    Ls = sym('L');

    K = sym(zeros(m, n));              % caso 2x2: K = [-k1 0; 0 -k2]
    for i = 1:r
        K(i, i) = -ks(i);
    end

    % P simetrica: p1_1, p1_2, ..., uma incognita por elemento do triangulo superior
    P = sym(zeros(n));
    pvars = sym([]);
    for i = 1:n
        for j = i:n
            p = sym(sprintf('p%d_%d', i, j));
            P(i, j) = p;
            P(j, i) = p;
            pvars(end + 1) = p; %#ok<AGROW>
        end
    end

    F = A + B*K;
    S = eye(n) + K.'*K*Ls;
    f = F.'*P + P*F + S;

    % ---- Resolve a equacao de Lyapunov para P ----
    solP = solve(f(:), pvars);
    vals = sym(zeros(size(pvars)));
    if isstruct(solP)
        for i = 1:numel(pvars)
            v = solP.(char(pvars(i)));
            if isempty(v)
                error('Nao foi possivel resolver a equacao de Lyapunov para P.');
            end
            vals(i) = v(1);
        end
    elseif ~isempty(solP)
        vals = solP(1);                 % uma unica incognita (n = 1)
    else
        error('Nao foi possivel resolver a equacao de Lyapunov para P.');
    end
    P_ = subs(P, pvars, vals);
    Jsym = x0.'*P_*x0;

    % ---- dJ/dki = 0 ----
    NUM = sym(zeros(1, r));
    for i = 1:r
        dJdki = simplify(diff(Jsym, ks(i)));
        [num_i, ~] = numden(dJdki);
        NUM(i) = subs(num_i, {Ls}, {L});
    end

    solK = solve(NUM, ks, 'Real', true);
    cand = solucoesParaMatriz(solK, ks);

    % ---- Escolhe a solucao estabilizante de menor custo ----
    Jfun = subs(Jsym, Ls, L);
    [k, J] = escolher(cand, A, B, m, n, r, Jfun, ks);
    if isempty(k)
        % solve nao achou solucao utilizavel: tenta numericamente varias vezes
        cand = [];
        for t = 1:20
            cand = [cand; solucoesParaMatriz(vpasolve(NUM, ks, 'Random', true), ks)]; %#ok<AGROW>
        end
        [k, J] = escolher(cand, A, B, m, n, r, Jfun, ks);
    end
    if isempty(k)
        error(['Nenhuma solucao real de dJ/dk = 0 estabiliza o sistema (A + B*K). ' ...
               'Verifique A, B e L.']);
    end

    Kn = montarK(k, m, n, r);
    polos = eig(A + B*Kn);
end

function [k, J] = escolher(cand, A, B, m, n, r, Jfun, ks)
% Entre as solucoes candidatas, fica com a estabilizante de menor J.
    k = [];
    J = inf;
    for s = 1:size(cand, 1)
        kc = cand(s, :);
        if any(~isfinite(kc)) || any(abs(imag(kc)) > 1e-9)
            continue
        end
        kc = real(kc);
        if any(real(eig(A + B*montarK(kc, m, n, r))) >= 0)
            continue                    % nao estabiliza
        end
        Jc = double(subs(Jfun, ks, kc));
        if isfinite(Jc) && Jc < J
            J = Jc;
            k = kc;
        end
    end
end

function Kn = montarK(k, m, n, r)
    Kn = zeros(m, n);
    for i = 1:r
        Kn(i, i) = -k(i);
    end
end

function cand = solucoesParaMatriz(sol, ks)
% Converte a saida de solve/vpasolve em uma matriz numerica (nsol x r).
% Solucoes com parametros livres (nao numericas) sao descartadas.
    r = numel(ks);
    cand = [];
    try
        if isstruct(sol)
            cols = cell(1, r);
            for i = 1:r
                cols{i} = double(sol.(char(ks(i))));
                cols{i} = cols{i}(:);
            end
            if ~any(cellfun(@isempty, cols))
                cand = [cols{:}];
            end
        else
            cand = double(sol(:));      % r = 1
        end
    catch
        cand = [];
    end
end

function [K, polos, Kplace, avisoPlace] = aula2_lqr(A, B, C, Qy, R)
%AULA2_LQR Projeto LQR com peso na saida (AULA2_2.m generalizada).
%   [K, polos, Kplace, avisoPlace] = aula2_lqr(A, B, C, Qy, R)
%
%   Q = C'*Qy*C,  K = lqr(A,B,Q,R),  polos = eig(A-B*K),  Kplace = place(A,B,polos)
%
%   Exemplo (valores da aula):
%     [K, polos, Kplace] = aula2_lqr([0 1; 0 -1], [0; 1], [1 0], 100, 1)

    Q = C'*Qy*C;
    K = lqr(A, B, Q, R);
    polos = eig(A - B*K);

    Kplace = [];
    avisoPlace = '';
    try
        Kplace = place(A, B, polos);
    catch err
        % place falha, por exemplo, com polos repetidos acima de rank(B)
        avisoPlace = err.message;
    end
end

function [K, polos] = aula3_lqr(A, B, Q, R)
%AULA3_LQR Projeto LQR com matriz Q completa (AULA3.m generalizada).
%   [K, polos] = aula3_lqr(A, B, Q, R)
%
%   K = lqr(A,B,Q,R),  polos = eig(A - B*K)
%
%   Exemplo (valores da aula, mesmo ganho do AULA3.slx = 4.4721):
%     K = aula3_lqr([0 1; 0 -1], [0; 1], [100 0; 0 100], 5)

    K = lqr(A, B, Q, R);
    polos = eig(A - B*K);
end

function r = aula4_transformadas(fexpr)
%AULA4_TRANSFORMADAS Transformadas de Laplace e Z e inversas (AULA4.m generalizada).
%   r = aula4_transformadas('heaviside(t)')
%
%   Mesma sequencia da AULA4.m:
%     Fs = laplace(f),  Fz = ztrans(f),  Ft = ilaplace(Fs),  Fd = iztrans(Fz)
%   r tem os campos f, Fs, Fz, Ft, Fd, polosS, polosZ e as variaveis t, n, s, z.

    syms s t z n

    if ischar(fexpr) || isstring(fexpr)
        f = str2sym(fexpr);
    else
        f = sym(fexpr);
    end

    Fs = laplace(f);
    Fz = ztrans(f);

    Ft = ilaplace(Fs);
    Fd = iztrans(Fz);

    r.f = f;
    r.Fs = Fs;
    r.Fz = Fz;
    r.Ft = Ft;
    r.Fd = Fd;
    r.polosS = polosRacional(Fs);
    r.polosZ = polosRacional(Fz);
    r.t = t;
    r.n = n;
    r.s = s;
    r.z = z;
end

function p = polosRacional(F)
% Polos de uma funcao racional (raizes do denominador). [] se nao for racional.
    try
        [~, den] = numden(simplify(F));
        p = roots(sym2poly(den));
    catch
        p = [];
    end
end

function Gz = aula5_discretizar(Gs, T, metodo)
%AULA5_DISCRETIZAR Discretizacao de G(s) (AULA5.m generalizada).
%   Gz = aula5_discretizar(Gs, T, metodo)
%
%   Gz = c2d(Gs, T, metodo).  Na AULA5.m: Gs = 1/(s+1), T = 0.5, 'tustin'.

    if nargin < 3
        metodo = 'tustin';
    end
    if ~isscalar(T) || ~isreal(T) || T <= 0
        error('O periodo de amostragem T deve ser um numero positivo.');
    end

    Gz = c2d(Gs, T, metodo);
end

function [Gz, Dz, MF, aviso] = aula6_deadbeat(Gs, T, N, metodo)
%AULA6_DEADBEAT Controlador discreto para malha fechada z^-N (AULA6.m / AULA6_2.m).
%   [Gz, Dz, MF, aviso] = aula6_deadbeat(Gs, T, N, metodo)
%
%   Mesma sequencia da AULA6.m:
%     Gz = c2d(Gs,T,'zoh'),  Tz = z^(-N),  Dz = Tz/(Gz*(1-Tz)),  Dz = minreal(Dz)
%   AULA6.m usa N = 3 e AULA6_2.m usa N = 5 (Gs = 1/(10.5s+1), T = 1).
%   MF = minreal(feedback(Dz*Gz, 1)) e a malha fechada resultante (deve ser z^-N).

    if nargin < 4
        metodo = 'zoh';
    end
    if ~isscalar(T) || ~isreal(T) || T <= 0
        error('O periodo de amostragem T deve ser um numero positivo.');
    end
    if ~isscalar(N) || N < 1 || N ~= round(N)
        error('O atraso N deve ser um inteiro >= 1.');
    end

    z = tf('z', T);

    Gz = c2d(Gs, T, metodo);
    Tz = z^(-N);

    Dz = Tz/(Gz*(1 - Tz));
    Dz = minreal(Dz);

    MF = minreal(feedback(Dz*Gz, 1));

    aviso = '';
    if ~isproper(Dz)
        aviso = sprintf(['D(z) nao e causal (mais zeros que polos). ' ...
                         'Aumente N para pelo menos o atraso da planta discreta.']);
    end
end
